---管理玩家所有需要存档的数据，绑定于 PlayerState ，双端可见。
---@class PlayerDataManager_C:BaseManager_C
--Edit Below--
local PlayerDataManager = {
    _isLoaded = false,
    _tick = 0,

    ---@type {
    ---    coin: table<ItemId, number>, 
    ---    stat: table<Statistics, number>, 
    ---    title: {equipped: Title?, unlocked: Title[]}, 
    ---    inv: table<number, ntable<InvItem>>,
    ---    geneTree: {skillPoint: number, nodes: table<number, GeneNode>},
    ---}
    _data = nil,

    ---@type {
    ---    shopLevel: number, 
    ---    store: ntable<Card>, 
    ---    shop: ntable<Card>, 
    ---    equipped: ntable<Card>, 
    ---    refreshCount: number,
    ---}
    _card = nil,
}


function PlayerDataManager:GetReplicatedProperties()
    return {"_data", "Lazy"}, {"_card", "Lazy"}
end


function PlayerDataManager:OnRep__data()
    self._isLoaded = true
end


function PlayerDataManager:OnRep__card()
    Lib.EventSystem.Dispatch(Event.OnRepCardData)
end


function PlayerDataManager:ReceiveBeginPlay()
    PlayerDataManager.SuperClass.ReceiveBeginPlay(self)
    self:_LoadData()
    self:ResetCardData()
    
    if UGCGameSystem.IsUGCPIE() then
        for k, v in pairs(Config.Debug.Coin) do
            self:SetCoin(k, v, false)
        end
        self:SyncData()
    end
end


function PlayerDataManager:ReceiveTick(deltaTime)
    PlayerDataManager.SuperClass.ReceiveTick(self, deltaTime)
    self._tick = self._tick + deltaTime
    if self._tick >= Config.Common.AutoSaveInterval then
        self._tick = 0
        self:Save()
    end
end


function PlayerDataManager:ReceiveEndPlay()
    PlayerDataManager.SuperClass.ReceiveEndPlay(self)
    self:Save()
end


-- region: 通用 ==================================================


function PlayerDataManager:_BuildDefaultData()
    local data = {
        coin = {
            [ItemId.Coin_0] = 0,
            [ItemId.Coin_1] = 0,
            [ItemId.Coin_2] = 0,
            [ItemId.Coin_3] = 0,
            [ItemId.Coin_4] = 0,
        },
        stat = {},
        title = {
            equipped = nil,
            unlocked = {},
        },
        geneTree = {
            skillPoint = 0,
            nodes = {},
        },
    }
    for _, v in pairs(Statistics) do
        data.stat[v] = 0
    end
    for _, branch in pairs(GeneTreeCfg.SkillData) do
        for __, node in pairs(branch) do
            data.geneTree.nodes[node.Id] = {level = 0, isUnlocked = false, nodeId = node.Id}
        end
    end
    return data
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


function PlayerDataManager:_LoadData()
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
    self:SyncData()
end


---【双端】获取某个一级字段的值。
---@param key string @字段名
---@return any @数据值
function PlayerDataManager:GetData(key)
    return self._data[key]
end


---【服务端】设置某个一级字段的值。
---@param key string @字段名
---@param value any @字段值
---@param sync? boolean @是否立即同步数据，默认为 true
function PlayerDataManager:SetData(key, value, sync)
    if not self:HasAuthority() or not self._isLoaded then
        return
    end
    self._data[key] = value
    if sync ~= false then
        self:SyncData()
    end
end


---【服务端】立即保存所有存档数据。
---@return boolean @是否成功
function PlayerDataManager:Save()
    if not self:HasAuthority() or not self._isLoaded then
        return false
    end
    return UGCPlayerStateSystem.SavePlayerArchiveData(self.owner.UID, self._data)
end


---【服务端】将存档数据同步到客户端。
function PlayerDataManager:SyncData()
    if not self:HasAuthority() or not self._isLoaded then
        return
    end
    UnrealNetwork.RepLazyProperty(self, "_data")
end


---【服务端】将卡牌数据同步到客户端。
function PlayerDataManager:SyncCardData()
    if not self:HasAuthority() then
        return
    end
    UnrealNetwork.RepLazyProperty(self, "_card")
end


---【服务端】将所有数据同步到客户端。
function PlayerDataManager:SyncAll()
    self:SyncData()
    self:SyncCardData()
end


-- endregion


-- region: 基因树 ==================================================


---【双端】获取基因树指定节点。
---@param nodeId number @节点ID（技能ID）
---@return GeneNode? @节点数据，结构为 { level: number, isUnlocked: boolean, nodeId: number }
function PlayerDataManager:GetGeneTreeNode(nodeId)
    if not self._isLoaded then
        return nil
    end
    return Lib.Table.Copy(self._data.geneTree.nodes[nodeId])
end


---【双端】升级基因树指定节点，并扣除相应的技能点。
---@param nodeId number @节点ID（技能ID）
---@param level number @要升的等级，默认为 1
---@param sync? boolean @是否立即同步数据，默认为 true
function PlayerDataManager:LevelUpGeneTreeNode(nodeId, level, sync)
    if not self._isLoaded then
        return
    end
    level = level or 1
    local geneTree = self._data.geneTree
    local node = geneTree.nodes[nodeId]
    if not node or not node.isUnlocked or geneTree.skillPoint < level then
        return
    end
    node.level = node.level + level
    geneTree.skillPoint = geneTree.skillPoint - level
    if sync ~= false then
        self:SyncData()
    end
end


---【服务端】重置基因树，并返还所消耗的所有技能点。
function PlayerDataManager:ResetGeneTree()
    if not self:HasAuthority() or not self._isLoaded then
        return
    end
    local geneTree = self._data.geneTree
    local skillPoint = 0
    for _, node in pairs(geneTree.nodes) do
        if node.isUnlocked then
            skillPoint = skillPoint + node.level
        end
        node.level = 0
        node.isUnlocked = false
    end
    geneTree.skillPoint = skillPoint
    self:SyncData()
end


---【双端】获取当前剩余的基因树技能点。
---@return number @技能点
function PlayerDataManager:GetGeneTreeSkillPoint()
    return (self._data.geneTree or {}).skillPoint or 0
end


---【服务端】设置基因树技能点。
---@param value number @技能点
---@param sync? boolean @是否立即同步数据，默认为 true
function PlayerDataManager:SetGeneTreeSkillPoint(value, sync)
    if not self:HasAuthority() or not self._isLoaded then
        return
    end
    self._data.geneTree.skillPoint = value
    if sync ~= false then
        self:SyncData()
    end
end


---【服务端】增加/扣除基因树技能点。
---@param delta? number @技能点增量，默认为 1
---@param sync? boolean @是否立即同步数据，默认为 true
function PlayerDataManager:AddGeneTreeSkillPoint(delta, sync)
    if not self:HasAuthority() or not self._isLoaded then
        return
    end
    delta = delta or 1
    self._data.geneTree.skillPoint = self._data.geneTree.skillPoint + delta
    if sync ~= false then
        self:SyncData()
    end
end


-- region: 货币 ==================================================


---【双端】获取指定货币的数量。
---@param id number @货币ID
---@return number @货币数量
function PlayerDataManager:GetCoin(id)
    return (self._data.coin or {})[id] or -1
end


---【服务端】设置指定货币的数量。
---@param id number @货币ID
---@param value number @数量
---@param sync? boolean @是否立即同步数据，默认为 true
---@return boolean @是否成功
function PlayerDataManager:SetCoin(id, value, sync)
    local coin = self._data.coin
    if not self:HasAuthority() or not self._isLoaded or coin[id] == nil or coin[id] == value then
        return false
    end
    if value < 0 then
        return false
    end
    local old = coin[id]
    coin[id] = value
    if sync ~= false then
        self:SyncData()
    end
    Lib.EventSystem.Broadcast(Event.OnCoinChangeAfter, self.owner.UID, id, old, value)
    return true
end


---【服务端】增加指定货币的数量，支持负值扣除。
---@param id number @货币ID
---@param delta? number @增加数量，默认为 1
---@param sync? boolean @是否立即同步数据，默认为 true
---@return boolean @是否成功
function PlayerDataManager:AddCoin(id, delta, sync)
    delta = delta or 1
    local coin = self._data.coin
    if not self:HasAuthority() or not self._isLoaded or coin[id] == nil then
        return false
    end
    local old = coin[id]
    local new = old + delta
    if new < 0 then
        return false
    end
    coin[id] = new
    if sync ~= false then
        self:SyncData()
    end
    Lib.EventSystem.Broadcast(Event.OnCoinChangeAfter, self.owner.UID, id, old, new)
    return true
end


-- endregion


-- region: 卡牌 ==================================================


local _cardsByGrade = nil


---卡牌按 grade 分组的 id 缓存，首次刷新商店时构建。
local function _BuildCardsByGrade()
    if _cardsByGrade ~= nil then
        return _cardsByGrade
    end
    _cardsByGrade = {}
    for cardId, info in pairs(CardCfg.Cards) do
        local list = _cardsByGrade[info.grade]
        if list == nil then
            list = {}
            _cardsByGrade[info.grade] = list
        end
        table.insert(list, cardId)
    end
    return _cardsByGrade
end


---【服务端】重置卡牌数据。
function PlayerDataManager:ResetCardData()
    if not self:HasAuthority() then
        return
    end
    self._card = {
        shopLevel = 1,
        store = {n = CardCfg.Common.StoreSlotCount},
        shop = {n = CardCfg.Common.ShopSlotCount},
        equipped = {n = CardCfg.Common.EquippedSlotCount},
        refreshCount = 0,
    }
    self:SyncCardData()
    Lib.EventSystem.Broadcast(Event.OnResetCardData, self.owner.UID)
end


---【双端】获取已解锁的卡牌穿戴槽数量。
---@return number @已解锁槽位数
function PlayerDataManager:GetUnlockedCardSlotCount()
    return math.min(CardCfg.Common.MaxCardSlotLevel, self._card.shopLevel)
end


---【服务端】提升卡牌槽位等级，每级解锁一个穿戴槽，最高 12 级。
function PlayerDataManager:LevelUpCardSlot()
    if not self:HasAuthority() or not self._isLoaded then
        return
    end

    local level = self:GetUnlockedCardSlotCount()
    if level >= CardCfg.Common.MaxCardSlotLevel then
        return
    end

    self._card.shopLevel = level + 1
    self:SyncCardData()
end


---【双端】获取玩家仓库中的所有卡牌。
---注意：遍历该表时，应使用长度遍历 for i = 1, table.n do ，而非 pairs() / ipairs() 。
---@return table<number, Card> @仓库中的所有卡牌，结构为：{ [index]: {cardId, star} }
function PlayerDataManager:GetAllStoreCards()
    return Lib.Table.DeepCopy(self._card.store)
end


---【双端】获取玩家卡牌商店中的所有卡牌。
---注意：遍历该表时，应使用长度遍历 for i = 1, table.n do ，而非 pairs() / ipairs() 。
---@return table<number, Card> @卡牌商店中的所有卡牌，结构为：{ [index]: {cardId, star} }
function PlayerDataManager:GetAllShopCards()
    return Lib.Table.DeepCopy(self._card.shop)
end


---【双端】获取玩家已装备的所有卡牌。
---注意：遍历该表时，应使用长度遍历 for i = 1, table.n do ，而非 pairs() / ipairs() 。
---@return table<number, Card> @已装备的所有卡牌，结构为：{ [index]: {cardId, star} }
function PlayerDataManager:GetAllEquippedCards()
    return Lib.Table.DeepCopy(self._card.equipped)
end


---【双端】获取玩家仓库中指定槽位的卡牌。
---@param slot number @仓库槽位索引 1-20
---@return Card? @指定槽位的卡牌，结构为 {cardId, star}
function PlayerDataManager:GetStoreCard(slot)
    return Lib.Table.Copy(self._card.store[slot])
end


---【双端】获取玩家卡牌商店中指定槽位的卡牌。
---@param slot number @卡牌商店槽位索引 1-6
---@return Card? @指定槽位的卡牌，结构为 {cardId, star}
function PlayerDataManager:GetShopCard(slot)
    return Lib.Table.Copy(self._card.shop[slot])
end


---【双端】获取玩家已装备的指定槽位的卡牌。
---@param slot number @已装备槽位索引 1-12
---@return Card? @指定槽位的卡牌，结构为 {cardId, star}
function PlayerDataManager:GetEquippedCard(slot)
    return Lib.Table.Copy(self._card.equipped[slot])
end


---【双端】获取当前卡牌商店等级。
---@return number @卡牌商店等级
function PlayerDataManager:GetCardShopLevel()
    return self._card.shopLevel
end


---【双端】获取当前卡牌商店的刷新次数。
---@return number @卡牌商店刷新次数
function PlayerDataManager:GetCardShopRefreshCount()
    return self._card.refreshCount
end


---【双端】判断是否拥有指定卡牌。
---@param card Card @卡牌，结构为 {cardId, star}
---@return boolean @是否拥有指定卡牌
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


local function _FindEmptySlot(list, maxSlot)
    maxSlot = maxSlot or list.n
    for i = 1, math.min(list.n, maxSlot) do
        if list[i] == nil then
            return i
        end
    end
    return nil
end


---【服务端】装备卡牌。
---@param fromSlot number @仓库槽位索引 1-20
---@param toSlot? number @卡牌槽位索引 1-12 ，默认为第一个空槽位
---@param sync? boolean @是否立即同步数据，默认为 true
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

    local unlockedSlotCount = self:GetUnlockedCardSlotCount()
    if toSlot ~= nil and toSlot > unlockedSlotCount then
        -- 目标槽位未解锁
        return
    end

    if toSlot == nil then
        toSlot = _FindEmptySlot(equipped, unlockedSlotCount)
        if toSlot == nil then
            -- 卡牌槽位已满
            return
        end
    end

    equipped[toSlot] = card
    store[fromSlot] = nil

    if sync ~= false then
        self:SyncCardData()
    end
    Lib.EventSystem.Broadcast(Event.OnCardEquipAfter, self.owner.UID, fromSlot, toSlot, card)
end


---【服务端】卸下卡牌。
---@param fromSlot number @卡牌槽位索引 1-12
---@param toSlot? number @仓库槽位索引 1-20 ，默认为第一个空槽位
---@param sync? boolean @是否立即同步数据，默认为 true
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
        toSlot = _FindEmptySlot(store)
        if toSlot == nil then
            -- 仓库已满
            return
        end
    end

    store[toSlot] = card
    equipped[fromSlot] = nil

    if sync ~= false then
        self:SyncCardData()
    end
    Lib.EventSystem.Broadcast(Event.OnCardUnequipAfter, self.owner.UID, fromSlot, toSlot, card)
end


---【服务端】购买卡牌。
---@param fromSlot number @商店槽位索引 1-6
---@param toSlot? number @仓库槽位索引 1-20 ，默认为第一个空槽位
---@param sync? boolean @是否立即同步数据，默认为 true
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
        toSlot = _FindEmptySlot(store)
        if toSlot == nil then
            -- 仓库已满
            return  
        end
    end

    local info = CardCfg.Cards[card[1]]
    local cost = CardCfg.Grade[info.grade].cost
    if self:GetCoin(ItemId.Coin_0) < cost then
        -- 资源点不足
        return  
    end
    self:AddCoin(ItemId.Coin_0, -cost)

    store[toSlot] = card
    shop[fromSlot] = nil

    if sync ~= false then
        self:SyncCardData()
    end
    Lib.EventSystem.Broadcast(Event.OnCardPurchaseAfter, self.owner.UID, fromSlot, toSlot, card, cost)
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
    local info = CardCfg.Cards[card[1]]
    local refund = math.floor(CardCfg.Grade[info.grade].cost * CardCfg.Common.SellRefundRatio)
    self:AddCoin(ItemId.Coin_0, refund)
    list[slot] = nil
    if sync ~= false then
        self:SyncCardData()
    end
    Lib.EventSystem.Broadcast(Event.OnCardSellAfter, self.owner.UID, from, slot, card, refund)
end


---【服务端】出售仓库卡牌。
---@param slot number @仓库槽位索引 1-20
---@param sync? boolean @是否立即同步数据，默认为 true
function PlayerDataManager:SellCardFromStore(slot, sync)
    self:_SellCard("store", slot, sync)
end


---【服务端】出售装备中的卡牌。
---@param slot number @卡牌槽位索引 1-12
---@param sync? boolean @是否立即同步数据，默认为true
function PlayerDataManager:SellCardFromEquipped(slot, sync)
    self:_SellCard("equipped", slot, sync)
end


---【服务端】刷新卡牌商店。
---@param useCoin? boolean @是否消耗资源点，默认为 true
---@param isFirstRefresh? boolean @是否为首次刷新，若为首次刷新，则刷新价格为首次价格；默认为 false
function PlayerDataManager:RefreshCardShop(useCoin, isFirstRefresh)
    if not self:HasAuthority() or not self._isLoaded then
        return
    end
    if isFirstRefresh then
        self._card.refreshCount = 0
    end
    local cost = CardCfg.Common.RefreshBaseCost + CardCfg.Common.RefreshStepCost * self._card.refreshCount
    if useCoin ~= false and self:GetCoin(ItemId.Coin_0) < cost then
        -- 资源点不足
        return  
    end
    self:AddCoin(ItemId.Coin_0, -cost)

    local weights = CardCfg.StoreWeight[self._card.shopLevel]
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

    self:SyncCardData()
    Lib.EventSystem.Broadcast(Event.OnCardShopRefreshAfter, self.owner.UID, shop)
end


-- endregion


-- region: 统计 ==================================================


---【双端】获取指定统计数据的值。
---@param name Statistics @统计数据名称，请使用 Statistics 枚举值
---@return number @数据值
function PlayerDataManager:GetStat(name)
    return (self._data.stat or {})[name] or 0
end


---【服务端】累加指定统计数据。
---@param name Statistics @统计数据名称，请使用 Statistics 枚举值
---@param delta? number @增量，默认为 1
---@param sync? boolean @是否立即同步数据，默认为 true
function PlayerDataManager:AddStat(name, delta, sync)
    delta = delta or 1
    local stat = self._data.stat
    if not self:HasAuthority() or not self._isLoaded or stat[name] == nil then
        return
    end
    stat[name] = stat[name] + delta
    if sync ~= false then
        self:SyncData()
    end
end


-- endregion


-- region: 称号 ==================================================


---【双端】获取当前佩戴的称号。
---@return Title|nil @Title 枚举值，若无佩戴则返回 nil
function PlayerDataManager:GetEquippedTitle()
    if not self._isLoaded then
        return nil
    end
    return self._data.title.equipped
end


---【服务端】佩戴称号。
---@param title Title|nil @称号ID，请使用 Title 枚举值，卸下称号可传 nil
function PlayerDataManager:EquipTitle(title)
    if not self:HasAuthority() or not self._isLoaded then
        return
    end
    self._data.title.equipped = title
    self:SyncData()
    Lib.EventSystem.Broadcast(Event.OnTitleEquipAfter, self.owner.UID, title)
end


---【双端】获取所有已解锁的称号。
---@return Title[] @已解锁称号的列表
function PlayerDataManager:GetUnlockedTitles()
    if not self._isLoaded then
        return {}
    end
    return self._data.title.unlocked
end


---【服务端】解锁称号。
---@param title Title @称号ID，请使用 Title 枚举值
function PlayerDataManager:UnlockTitle(title) 
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
    self:SyncData()
    Lib.EventSystem.Broadcast(Event.OnTitleUnlockAfter, self.owner.UID, title)
end


---【双端】获取称号状态。 0 为未解锁， 1 为已解锁， 2 为已佩戴。
---@param title Title @称号ID，请使用 Title 枚举值
---@return number @称号状态
function PlayerDataManager:GetTitleState(title)
    if not self._isLoaded then
        return 0
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


-- endregion


return PlayerDataManager
