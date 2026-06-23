---@class PlayerDataManager_C:BaseManager_C
--Edit Below--
local PlayerDataManager = {
    _data = {},
    _isLoaded = false,
    _uid = 0,
    _tick = 0,
}


function PlayerDataManager:GetReplicatedProperties()
    return {
        {"_data", "Lazy"}
    }
end


function PlayerDataManager:OnRep__data()
end


function PlayerDataManager:ReceiveBeginPlay()
    PlayerDataManager.SuperClass.ReceiveBeginPlay(self)
    self._uid = UGCGameSystem.GetUIDByPlayerState(self.owner)
    self:_Load()
end


function PlayerDataManager:ReceiveTick(DeltaTime)
    PlayerDataManager.SuperClass.ReceiveTick(self, DeltaTime)
    self._tick = self._tick + 1
    if self._tick >= Config.Common.AutoSaveInterval then
        self._tick = 0
        self:Save()
    end
end


function PlayerDataManager:ReceiveEndPlay()
    PlayerDataManager.SuperClass.ReceiveEndPlay(self)
    self:Save()
end


function PlayerDataManager:_BuildDefaultData()
    return {
        coin = {
            [ItemId.Coin_0] = 0,
            [ItemId.Coin_1] = 0,
            [ItemId.Coin_2] = 0,
            [ItemId.Coin_3] = 0,
            [ItemId.Coin_4] = 0,
        },
        card = {},
        stat = {
            [Statistics.NormalMonsterKillCount] = 0,
            [Statistics.EliteMonsterKillCount] = 0,
            [Statistics.BossKillCount] = 0,
            [Statistics.NormalMonsterKillCountHealthAboveHalf] = 0,
            [Statistics.EliteMonsterKillCountHealthAboveHalf] = 0,
            [Statistics.HasPerfectBossFight] = 0,
        },
        title = {
            equipped = nil,
            unlocked = {},
        },
        custom = {},
    }
end


function PlayerDataManager:_MergeDefaults(data)
    local defaults = self:_BuildDefaultData()
    for k, v in pairs(defaults) do
        if data[k] == nil then
            data[k] = v
        elseif type(v) == "table" then
            for kk, vv in pairs(v) do
                if data[k][kk] == nil then
                    data[k][kk] = vv
                end
            end
        end
    end
end


function PlayerDataManager:_Load()
    if not self:HasAuthority() then
        return
    end

    local data = UGCPlayerStateSystem.GetPlayerArchiveData(self._uid)
    if data == nil then
        data = self:_BuildDefaultData()
    else
        self:_MergeDefaults(data)
    end

    self._data = data
    self._isLoaded = true
    UnrealNetwork.RepLazyProperty(self, "_data")
end


---【双端】获取某个一级字段的值。
---@param key string 字段名
---@return any 数据值
function PlayerDataManager:Get(key)
    return self._data[key]
end


---【服务端】设置某个一级字段的值。
---@param key string 字段名
---@param value any 字段值
---@param sync? boolean 是否立即同步数据，默认为true
function PlayerDataManager:Set(key, value, sync)
    if not self:HasAuthority() or not self._isLoaded then
        return
    end
    self._data[key] = value
    if sync ~= false then
        self:Sync()
    end
end


---【服务端】立即保存所有数据。
---@return boolean 是否成功
function PlayerDataManager:Save()
    if not self:HasAuthority() or not self._isLoaded then
        return false
    end
    return UGCPlayerStateSystem.SavePlayerArchiveData(self._uid, self._data)
end


---【服务端】将数据同步到客户端。
function PlayerDataManager:Sync()
    if not self:HasAuthority() or not self._isLoaded then
        return
    end
    UnrealNetwork.RepLazyProperty(self, "_data")
end


---【双端】获取自定义数据。
---@param key string 数据键
---@return any 数据值
function PlayerDataManager:GetCustomData(key)
    return (self._data.custom or {})[key]
end


---【服务端】存储自定义数据。
---@param key string 数据键
---@param value any 数据值
---@param sync? boolean 是否立即同步数据，默认为true
function PlayerDataManager:SaveCustomData(key, value, sync)
    if not self:HasAuthority() or not self._isLoaded then
        return
    end
    self._data.custom[key] = value
    if sync ~= false then
        self:Sync()
    end
end


--===========================  货币  ===========================--


---【双端】获取指定货币的数量。
---@param id number 货币ID
---@return number 货币数量
function PlayerDataManager:GetCoin(id)
    return (self._data.coin or {})[id] or -1
end


---【服务端】设置指定货币的数量。
---@param id number 货币ID
---@param value number 数量
---@param sync? boolean 是否立即同步数据，默认为true
function PlayerDataManager:SetCoin(id, value, sync)
    local coin = self._data.coin
    if not self:HasAuthority() or not self._isLoaded or coin[id] == nil or coin[id] == value then
        return
    end
    coin[id] = math.max(0, value)
    if sync ~= false then
        self:Sync()
    end
end


---【服务端】增加指定货币的数量，支持负值扣除。
---@param id number 货币ID
---@param value? number 增加数量，默认为1
---@param sync? boolean 是否立即同步数据，默认为true
function PlayerDataManager:AddCoin(id, value, sync)
    value = value or 1
    local coin = self._data.coin
    if not self:HasAuthority() or not self._isLoaded or coin[id] == nil then
        return
    end
    coin[id] = math.max(0, coin[id] + value)
    if sync ~= false then
        self:Sync()
    end
end


--===========================  卡牌  ===========================--


---【双端】判断是否拥有指定卡牌。
---@param card number 卡牌ID
---@return boolean 是否拥有指定卡牌
function PlayerDataManager:HasCard(card)
    if self._data.card == nil then
        return false
    end
    return self._data.card[card] ~= nil
end


---【服务端】添加卡牌。
---@param card number 卡牌ID
---@param sync? boolean 是否立即同步数据，默认为true
function PlayerDataManager:AddCard(card, sync)
    if not self:HasAuthority() or not self._isLoaded then
        return
    end
    self._data.card[card] = 1
    if sync ~= false then
        self:Sync()
    end
end


---【服务端】移除卡牌。
---@param card number 卡牌ID
---@param sync? boolean 是否立即同步数据，默认为true
function PlayerDataManager:RemoveCard(card, sync)
    if not self:HasAuthority() or not self._isLoaded then
        return
    end
    self._data.card[card] = nil
    if sync ~= false then
        self:Sync()
    end
end


--===========================  统计  ===========================--


---【双端】获取指定统计数据的值。
---@param name Statistics 统计数据名称，请使用Statistics枚举值
---@return number 数据值
function PlayerDataManager:GetStat(name)
    return (self._data.stat or {})[name] or -1
end


---【服务端】累加指定统计数据。
---@param name Statistics 统计数据名称，请使用Statistics枚举值
---@param value? number 增量，默认为1
---@param sync? boolean 是否立即同步数据，默认为true
function PlayerDataManager:AddStat(name, value, sync)
    value = value or 1
    local stat = self._data.stat
    if not self:HasAuthority() or not self._isLoaded or stat[name] == nil then
        return
    end
    stat[name] = stat[name] + value
    if sync ~= false then
        self:Sync()
    end
end


--===========================  称号  ===========================--


---【双端】获取当前佩戴的称号。
---@return Title | nil Title枚举值，若无佩戴则返回nil
function PlayerDataManager:GetEquippedTitle()
    if not self._isLoaded then
        return nil
    end
    return self._data.title.equipped
end


---【服务端】佩戴称号。
---@param title Title | nil 称号ID，请使用Title枚举值，卸下称号可传nil
---@param sync? boolean 是否立即同步数据，默认为true
function PlayerDataManager:EquipTitle(title, sync)
    if not self:HasAuthority() or not self._isLoaded then
        return
    end
    self._data.title.equipped = title
    if sync ~= false then
        self:Sync()
    end
end


---【双端】获取所有已解锁的称号。
---@return Title[] 已解锁称号的列表
function PlayerDataManager:GetUnlockedTitles()
    if not self._isLoaded then
        return {}
    end
    return self._data.title.unlocked
end


---【服务端】解锁称号。
---@param title Title 称号ID，请使用Title枚举值
---@param sync? boolean 是否立即同步数据，默认为true
function PlayerDataManager:UnlockTitle(title, sync) 
    if not self:HasAuthority() or not self._isLoaded then
        return
    end
    local unlocked = self._data.title.unlocked
    for _, i in pairs(unlocked) do
        if i == title then
            return
        end
    end
    table.insert(unlocked, title)
    if sync ~= false then
        self:Sync()
    end
end

---【双端】获取称号状态。0为未解锁，1为已解锁，2为已佩戴
---@param title Title 称号ID，请使用Title枚举值
---@return number 称号状态
function PlayerDataManager:GetTitleState(title)
    if not self._isLoaded then
        return nil
    end
    if title == self._data.title.equipped then 
        return 2 
    end
    for _, i in pairs(self._data.title.unlocked) do
        if i == title then 
            return 1 
        end
    end
    return 0
end

return PlayerDataManager