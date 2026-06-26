---@class PlayerDataManager_C:BaseManager_C
--Edit Below--
local PlayerDataManager = {
    _data = {},
    _isLoaded = false,
    _tick = 0,
    _card = {},
}


function PlayerDataManager:GetReplicatedProperties()
    return {"_data", "Lazy"}, {"_card", "Lazy"}
end


function PlayerDataManager:OnRep__data()
    self._isLoaded = true
end


function PlayerDataManager:OnRep__card()
end


function PlayerDataManager:ReceiveBeginPlay()
    PlayerDataManager.SuperClass.ReceiveBeginPlay(self)
    self:_Load()
    self:ResetCardData()
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

    local data = UGCPlayerStateSystem.GetPlayerArchiveData(self.owner.UID)
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
    return UGCPlayerStateSystem.SavePlayerArchiveData(self.owner.UID, self._data)
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
    local old = coin[id]
    local new = math.max(0, value)
    coin[id] = new
    if sync ~= false then
        self:Sync()
    end
    Lib.EventSystem.Emit(ServerEvent.OnCoinChangeAfter, Lib.EventSystem.EmitType.Both, id, old, new)
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
    local old = coin[id]
    local new = math.max(0, old + value)
    coin[id] = new
    if sync ~= false then
        self:Sync()
    end
    Lib.EventSystem.Emit(ServerEvent.OnCoinChangeAfter, Lib.EventSystem.EmitType.Both, id, old, new)
end


--===========================  卡牌  ===========================--


-- 卡牌按grade分组的id缓存，首次刷新商店时构建
local cardsByGrade = nil
local function _BuildCardsByGrade()
    if cardsByGrade ~= nil then
        return cardsByGrade
    end
    cardsByGrade = {}
    for cardId, info in pairs(Card.Cards) do
        local list = cardsByGrade[info.grade]
        if list == nil then
            list = {}
            cardsByGrade[info.grade] = list
        end
        table.insert(list, cardId)
    end
    return cardsByGrade
end


---【服务端】重置卡牌数据。
function PlayerDataManager:ResetCardData()
    if not self:HasAuthority() then
        return
    end
    self._card = {
        shopLevel = 1,
        store = table.pack(
            nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil
        ),
        shop = table.pack(
            nil, nil, nil, nil, nil, nil
        ),
        equipped = table.pack(
            nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil
        ),
        refreshCount = 0,
    }
    UnrealNetwork.RepLazyProperty(self, "_card")
end


---【双端】判断是否拥有指定卡牌。
---@param card table 卡牌，结构为{cardId, star}
---@return boolean 是否拥有指定卡牌
function PlayerDataManager:HasCard(card)
    for i = 1, self._card.store.n do
        local c = self._card.store[i]
        if c and c[1] == card[1] and c[2] == card[2] then
            return true
        end
    end
    for i = 1, self._card.equipped.n do
        local c = self._card.equipped[i]
        if c and c[1] == card[1] and c[2] == card[2] then
            return true
        end
    end
    return false
end


function PlayerDataManager:_FindEmptySlot(list)
    for i = 1, list.n do
        if list[i] == nil then
            return i
        end
    end
    return nil
end


---【服务端】装备卡牌。
---@param fromSlot number 仓库槽位索引 1-20
---@param toSlot? number 卡牌槽位索引 1-12，默认为第一个空槽位
---@param sync? boolean 是否立即同步数据，默认为true
function PlayerDataManager:EquipCard(fromSlot, toSlot, sync)
    if not self:HasAuthority() or not self._isLoaded then
        return
    end

    local store = self._card.store
    local equipped = self._card.equipped
    local card = store[fromSlot]
    if card == nil then
        return
    end

    if toSlot == nil then
        toSlot = self:_FindEmptySlot(equipped)
        if toSlot == nil then
            -- 卡牌槽位已满
            return
        end
    end

    equipped[toSlot] = card
    store[fromSlot] = nil

    if sync ~= false then
        UnrealNetwork.RepLazyProperty(self, "_card")
    end
    Lib.EventSystem.Emit(ServerEvent.OnCardEquipAfter, Lib.EventSystem.EmitType.Both, fromSlot, toSlot, card)
end


---【服务端】卸下卡牌。
---@param fromSlot number 卡牌槽位索引 1-12
---@param toSlot? number 仓库槽位索引 1-20，默认为第一个空槽位
---@param sync? boolean 是否立即同步数据，默认为true
function PlayerDataManager:UnequipCard(fromSlot, toSlot, sync)
    if not self:HasAuthority() or not self._isLoaded then
        return
    end

    local store = self._card.store
    local equipped = self._card.equipped
    local card = equipped[fromSlot]
    if card == nil then
        return
    end

    if toSlot == nil then
        toSlot = self:_FindEmptySlot(store)
        if toSlot == nil then
            -- 仓库已满
            return
        end
    end

    store[toSlot] = card
    equipped[fromSlot] = nil

    if sync ~= false then
        UnrealNetwork.RepLazyProperty(self, "_card")
    end
    Lib.EventSystem.Emit(ServerEvent.OnCardUnequipAfter, Lib.EventSystem.EmitType.Both, fromSlot, toSlot, card)
end


---【服务端】购买卡牌。
---@param fromSlot number 商店槽位索引 1-6
---@param toSlot? number 仓库槽位索引 1-20，默认为第一个空槽位
---@param sync? boolean 是否立即同步数据，默认为true
function PlayerDataManager:PurchaseCard(fromSlot, toSlot, sync)
    if not self:HasAuthority() or not self._isLoaded then
        return
    end

    local shop = self._card.shop
    local card = shop[fromSlot]
    if card == nil then
        return
    end

    local store = self._card.store
    if toSlot == nil then
        toSlot = self:_FindEmptySlot(store)
        if toSlot == nil then
            -- 仓库已满
            return  
        end
    end

    local info = Card.Cards[card[1]]
    local cost = Card.Grade[info.grade].cost
    if self:GetCoin(ItemId.Coin_0) < cost then
        -- 资源点不足
        return  
    end
    self:AddCoin(ItemId.Coin_0, -cost)

    store[toSlot] = card
    shop[fromSlot] = nil

    if sync ~= false then
        UnrealNetwork.RepLazyProperty(self, "_card")
    end
    Lib.EventSystem.Emit(ServerEvent.OnCardPurchaseAfter, Lib.EventSystem.EmitType.Both, fromSlot, toSlot, card, cost)
end


function PlayerDataManager:_SellCard(from, slot, sync)
    if not self:HasAuthority() or not self._isLoaded then
        return
    end
    local list = self._card[from]
    local card = list[slot]
    if card == nil then
        return
    end
    local info = Card.Cards[card[1]]
    local refund = math.floor(Card.Grade[info.grade].cost * Card.Common.SellRefundRatio)
    self:AddCoin(ItemId.Coin_0, refund)
    list[slot] = nil
    if sync ~= false then
        UnrealNetwork.RepLazyProperty(self, "_card")
    end
    Lib.EventSystem.Emit(ServerEvent.OnCardSellAfter, Lib.EventSystem.EmitType.Both, from, slot, card, refund)
end


---【服务端】出售仓库卡牌。
---@param slot number 仓库槽位索引 1-20
---@param sync? boolean 是否立即同步数据，默认为true
function PlayerDataManager:SellCardFromStore(slot, sync)
    self:_SellCard("store", slot, sync)
end


---【服务端】出售装备中的卡牌。
---@param slot number 卡牌槽位索引 1-12
---@param sync? boolean 是否立即同步数据，默认为true
function PlayerDataManager:SellCardFromEquipped(slot, sync)
    self:_SellCard("equipped", slot, sync)
end


---【服务端】刷新卡牌商店。
---@param useCoin? boolean 是否使用资源点刷新，默认为true
---@param isFirstRefresh? boolean 是否为首次刷新，若为首次刷新，则刷新价格为首次价格；默认为false
function PlayerDataManager:RefreshCardShop(useCoin, isFirstRefresh)
    if not self:HasAuthority() or not self._isLoaded then
        return
    end

    if isFirstRefresh then
        self._card.refreshCount = 0
    end
    local cost = Card.Common.RefreshBaseCost + Card.Common.RefreshStepCost * self._card.refreshCount
    if useCoin ~= false and self:GetCoin(ItemId.Coin_0) < cost then
        -- 资源点不足
        return  
    end
    self:AddCoin(ItemId.Coin_0, -cost)

    local weights = Card.StoreWeight[self._card.shopLevel]
    local byGrade = _BuildCardsByGrade()
    local shop = self._card.shop
    for i = 1, shop.n do
        -- 随机挑选一种费用
        local grade = 1
        local r = math.random()
        local acc = 0
        for g = 1, 5 do
            acc = acc + weights[g]
            if r <= acc then
                grade = g
                break
            end
        end
        -- 随机挑选该费用下的一张卡牌
        local pool = byGrade[grade]
        local cardId = pool[math.random(1, #pool)]
        shop[i] = {cardId, 1}
    end

    self._card.refreshCount = self._card.refreshCount + 1

    UnrealNetwork.RepLazyProperty(self, "_card")
    Lib.EventSystem.Emit(ServerEvent.OnCardShopRefreshAfter, Lib.EventSystem.EmitType.Both, shop)
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
    Lib.EventSystem.Emit(ServerEvent.OnTitleEquipAfter, Lib.EventSystem.EmitType.Both, title)
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
    Lib.EventSystem.Emit(ServerEvent.OnTitleUnlockAfter, Lib.EventSystem.EmitType.Both, title)
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