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
    self._uid = tonumber(self.owner.PlayerUID)
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
        },
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


---获取某个一级字段的值。
---@param key string 字段名
---@return any 数据值
function PlayerDataManager:Get(key)
    return self._data[key]
end


---设置某个一级字段的值。
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


---立即保存所有数据。
---@return boolean 是否成功
function PlayerDataManager:Save()
    if not self:HasAuthority() or not self._isLoaded then
        return false
    end
    return UGCPlayerStateSystem.SavePlayerArchiveData(self._uid, self._data)
end


---将数据同步到客户端。
function PlayerDataManager:Sync()
    if not self:HasAuthority() or not self._isLoaded then
        return
    end
    UnrealNetwork.RepLazyProperty(self, "_data")
end


--===========================  货币  ===========================--


---获取指定货币的数量。
---@param id number 货币ID
---@return number 货币数量
function PlayerDataManager:GetCoin(id)
    return (self._data.coin or {})[id] or -1
end


---设置指定货币的数量。
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


---增加指定货币的数量，支持负值扣除。
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


---判断是否拥有指定卡牌。
---@param id number 卡牌ID
---@return boolean 是否拥有指定卡牌
function PlayerDataManager:HasCard(id)
    return self._data.card and self._data.card[id] ~= nil
end


---添加卡牌。
---@param id number 卡牌ID
---@param sync? boolean 是否立即同步数据，默认为true
function PlayerDataManager:AddCard(id, sync)
    if not self:HasAuthority() or not self._isLoaded then
        return
    end
    self._data.card[id] = 1
    if sync ~= false then
        self:Sync()
    end
end


---移除卡牌。
---@param id number 卡牌ID
---@param sync? boolean 是否立即同步数据，默认为true
function PlayerDataManager:RemoveCard(id, sync)
    if not self:HasAuthority() or not self._isLoaded then
        return
    end
    self._data.card[id] = nil
    if sync ~= false then
        self:Sync()
    end
end


--===========================  统计  ===========================--


---获取指定统计数据。
---@param name string 统计数据名称，请使用Statistics枚举值
---@return number 数据值
function PlayerDataManager:GetStat(name)
    return (self._data.stat or {})[name] or -1
end


---累加指定统计数据。
---@param name string 统计数据名称，请使用Statistics枚举值
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


return PlayerDataManager