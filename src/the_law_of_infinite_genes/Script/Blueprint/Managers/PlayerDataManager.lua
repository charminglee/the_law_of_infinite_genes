---管理玩家所有需要存档的数据，绑定于 PlayerState ，双端可见。
---@class PlayerDataManager_C:BaseManager_C
--Edit Below--
local PlayerDataManager = {
    _isLoaded = false,
    _t = 0,

    ---@type {
    ---    custom: table<string, any>,
    ---    coin: table<ItemId, number>, 
    ---    stat: table<Statistics, number>, 
    ---    title: {equipped: Title?, unlocked: Title[]}, 
    ---    inv: table<number, ntable<InvItem>>,
    ---    geneTree: {skillPoint: number, nodes: table<number, GeneNode>},
    ---    gun: {unlocked: table<number, boolean>},
    ---    seasonExp: number,
    ---    characterExp: number,
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
    return { "_data", "Lazy" }, { "_card", "Lazy" }
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
    
    if Lib.IsPIE() and Lib.IsServer() then
        for k, v in pairs(Config.Debug.Coin) do
            self:SetCoin(k, v, false)
        end
        self:SyncData()
    end
end


function PlayerDataManager:ReceiveTick(deltaTime)
    PlayerDataManager.SuperClass.ReceiveTick(self, deltaTime)

    self._t = self._t + deltaTime
    if self._t >= GameFlowCfg.AutoSaveInterval and Lib.IsServer() then
        self._t = 0
        self:Save()
    end
end


function PlayerDataManager:ReceiveEndPlay()
    PlayerDataManager.SuperClass.ReceiveEndPlay(self)
    if Lib.IsServer() then
        self:Save()
    end
end


local function _BuildDefaultData()
    local data = {
        custom = {},
        coin = {
            [ItemId.Coin_0] = 0,
            [ItemId.Coin_1] = 0,
            [ItemId.Coin_2] = 0,
            [ItemId.Coin_3] = 0,
            [ItemId.Coin_4] = 0,
            [ItemId.Coin_5] = 0,
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
        gun = {
            unlocked = {},
        },
        seasonExp = 0,
        characterExp = 0,
    }
    for _, v in pairs(Statistics) do
        data.stat[v] = 0
    end
    for _, branch in pairs(GeneTreeCfg.SkillData) do
        for __, node in pairs(branch) do
            data.geneTree.nodes[node.Id] = {
                level = 0,
                isUnlocked = false,
                nodeId = node.Id,
            }
        end
    end
    return data
end


local function _MergeDefaults(data)
    local defaults = _BuildDefaultData()
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
    if not Lib.IsServer() then
        return
    end

    local data = UGCPlayerStateSystem.GetPlayerArchiveData(self.owner.UID)
    if data then
        _MergeDefaults(data)
    else
        data = _BuildDefaultData()
    end

    self._data = data
    self._isLoaded = true
    self:SyncData()
end


-- region: 经验 ==================================================


---【双端】获取永久经验。
---@return number @永久经验
function PlayerDataManager:GetCharacterExp()
    if not self._isLoaded then
        return 0
    end
    return self._data.characterExp
end


---【服务端】增加永久经验。
---@param delta? number @增加的经验值，默认为 1
---@param sync? boolean @是否立即同步数据，默认为 true
---@return boolean @是否成功
function PlayerDataManager:AddCharacterExp(delta, sync)
    if not Lib.IsServer() or not self._isLoaded then
        return false
    end
    delta = delta or 1
    local old = self._data.characterExp
    local new = old + delta
    if new < 0 then
        return false
    end
    self._data.characterExp = new
    if sync ~= false then
        self:SyncData()
    end
    Lib.EventSystem.Broadcast_SinglePlayer(
        self.owner,
        Event.OnCharacterExpChangeAfter,
        self.owner.UID, old, new
    )
    return true
end


---【双端】获取赛季经验。
---@return number @赛季经验
function PlayerDataManager:GetSeasonExp()
    if not self._isLoaded then
        return 0
    end
    return self._data.seasonExp
end


---【服务端】增加赛季经验。
---@param delta? number @增加的经验值，默认为 1
---@param sync? boolean @是否立即同步数据，默认为 true
---@return boolean @是否成功
function PlayerDataManager:AddSeasonExp(delta, sync)
    if not Lib.IsServer() or not self._isLoaded then
        return false
    end
    delta = delta or 1
    local old = self._data.seasonExp
    local new = old + delta
    if new < 0 then
        return false
    end
    self._data.seasonExp = new
    if sync ~= false then
        self:SyncData()
    end
    Lib.EventSystem.Broadcast_SinglePlayer(
        self.owner,
        Event.OnSeasonExpChangeAfter,
        self.owner.UID, old, new
    )
    return true
end


-- endregion


-- region: 通用 ==================================================


---【双端】获取自定义数据。
---@param key string @数据名
---@return any @数据值
function PlayerDataManager:GetCustomData(key)
    if not self._isLoaded then
        return nil
    end
    return self._data.custom[key]
end


---【服务端】保存自定义数据。
---@param key string @数据名
---@param value any @数据值
---@param sync? boolean @是否立即同步数据，默认为 true
function PlayerDataManager:SaveCustomData(key, value, sync)
    if not Lib.IsServer() or not self._isLoaded then
        return
    end
    self._data.custom[key] = value
    if sync ~= false then
        self:SyncData()
    end
end


---【服务端】立即保存所有存档数据。
---@return boolean @是否成功
function PlayerDataManager:Save()
    if not Lib.IsServer() or not self._isLoaded then
        return false
    end
    return UGCPlayerStateSystem.SavePlayerArchiveData(self.owner.UID, self._data)
end


---【服务端】将存档数据同步到客户端。
function PlayerDataManager:SyncData()
    if not Lib.IsServer() or not self._isLoaded then
        return
    end
    UnrealNetwork.RepLazyProperty(self, "_data")
end


---【服务端】将卡牌数据同步到客户端。
function PlayerDataManager:SyncCardData()
    if not Lib.IsServer() then
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


-- region: 枪械 ==================================================


---【服务端】购买枪械。
---@param itemId number @枪械的物品ID
---@param count number @购买数量，默认为 1
---@return boolean @是否成功
function PlayerDataManager:PurchaseGun(itemId, count)
    if not Lib.IsServer() then
        return false
    end
    if ItemCfg.UnlockConditions[itemId] ~= nil and not self:IsGunUnlock(itemId) then
        return false
    end

    count = count or 1
    local unitPrice = ItemCfg.GunPrice[itemId]
    if unitPrice == nil then
        return false
    end
    local price = unitPrice * count
    if self:GetCoin(ItemId.Coin_3) < price then
        return false
    end
    if not self:AddCoin(ItemId.Coin_3, -price) then
        return false
    end

    local pc = UGCGameSystem.GetPlayerControllerByPlayerState(self.owner)
    local res = UGCBackpackSystemV2.AddItemV2(pc, itemId, count)
    return res and res[0] > 0
end


---【双端】判断指定枪械是否已解锁。
---@param itemId number @枪械的物品ID
---@return boolean @是否已解锁
function PlayerDataManager:IsGunUnlock(itemId)
    if not self._isLoaded then
        return false
    end
    return self._data.gun.unlocked[itemId] == true
end


---【双端】获取已解锁的枪械列表。
---@return number[]? @已解锁的枪械物品ID列表，获取失败或无已解锁枪械时返回 nil
function PlayerDataManager:GetUnlockedGuns()
    if not self._isLoaded then
        return nil
    end
    if Lib.Table.IsEmpty(self._data.gun.unlocked) then
        return nil
    end
    return Lib.Table.Keys(self._data.gun.unlocked)
end


---【服务端】解锁指定枪械。
---@param itemId number @枪械的物品ID
---@return boolean @是否成功
function PlayerDataManager:UnlockGun(itemId)
    if not Lib.IsServer() or not self._isLoaded then
        return false
    end
    if self:IsGunUnlock(itemId) then
        return false
    end

    local cond = ItemCfg.UnlockConditions[itemId]
    local needItemId = cond.ItemId
    local needCount = cond.Count
    if needItemId ~= 0 then
        if self:GetCoin(needItemId) < needCount then
            return false
        end
        if not self:AddCoin(needItemId, -needCount, false) then
            return false
        end
    end

    self._data.gun.unlocked[itemId] = true
    self:SyncData()

    Lib.EventSystem.Broadcast_SinglePlayer(self.owner, Event.OnGunUnlockAfter, self.owner.UID, itemId)

    return true
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
    if not Lib.IsServer() or not self._isLoaded then
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
    if not self._isLoaded then
        return 0
    end
    return self._data.geneTree.skillPoint
end


---【服务端】设置基因树技能点。
---@param value number @技能点
---@param sync? boolean @是否立即同步数据，默认为 true
function PlayerDataManager:SetGeneTreeSkillPoint(value, sync)
    if not Lib.IsServer() or not self._isLoaded then
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
    if not Lib.IsServer() or not self._isLoaded then
        return
    end
    delta = delta or 1
    self._data.geneTree.skillPoint = self._data.geneTree.skillPoint + delta
    if sync ~= false then
        self:SyncData()
    end
end


-- endregion


-- region: 货币 ==================================================


---【双端】获取指定货币的数量。
---@param id number @货币ID
---@return number @货币数量
function PlayerDataManager:GetCoin(id)
    if not self._isLoaded then
        return 0
    end
    return self._data.coin[id]
end


---【服务端】设置指定货币的数量。
---@param id number @货币ID
---@param value number @数量
---@param sync? boolean @是否立即同步数据，默认为 true
---@return boolean @是否成功
function PlayerDataManager:SetCoin(id, value, sync)
    if not Lib.IsServer() or not self._isLoaded then
        return false
    end
    local coin = self._data.coin
    if coin[id] == nil or coin[id] == value then
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
    Lib.EventSystem.Broadcast_SinglePlayer(
        self.owner, 
        Event.OnCoinChangeAfter, 
        self.owner.UID, id, old, value
    )
    return true
end


---【服务端】增加指定货币的数量，支持负值扣除。
---@param id number @货币ID
---@param delta? number @增加数量，默认为 1
---@param sync? boolean @是否立即同步数据，默认为 true
---@return boolean @是否成功
function PlayerDataManager:AddCoin(id, delta, sync)
    if not Lib.IsServer() or not self._isLoaded then
        return false
    end
    delta = delta or 1
    local coin = self._data.coin
    local old = coin[id]
    local new = old + delta
    if new < 0 then
        return false
    end
    coin[id] = new
    if sync ~= false then
        self:SyncData()
    end
    Lib.EventSystem.Broadcast_SinglePlayer(
        self.owner, 
        Event.OnCoinChangeAfter, 
        self.owner.UID, id, old, new
    )
    return true
end


-- endregion


-- region: 卡牌 ==================================================


function PlayerDataManager:_CardAutoUpgrade()
    if not Lib.IsServer() or not self._isLoaded then
        return
    end

    local upgradeCount = CardCfg.Common.CardUpgradeCount
    local maxStar = CardCfg.Common.MaxCardStar
    local cardList = Lib.Table.Concat(self._card.equipped, self._card.store)

    -- 连续合并可升星卡牌
    local changed = false
    local finish = false
    while not finish do
        finish = true
        local group = {}
        for i = 1, cardList.n do
            local card = cardList[i]
            local id = card and card[1]
            local star = card and card[2]
            if card and card[2] < maxStar then
                local byId = Lib.Table.SetDefault(group, id, {})
                local byStar = Lib.Table.SetDefault(byId, star, {})
                table.insert(byStar, i)
                -- 发现三张同名同星级卡牌
                if #byStar >= upgradeCount then
                    -- 第一张执行升星
                    local firstIndex = byStar[1]
                    local firstCard = cardList[firstIndex]
                    cardList[firstIndex] = { firstCard[1], firstCard[2] + 1 }
                    -- 丢弃后两张
                    for ii = 2, #byStar do
                        cardList[byStar[ii]] = nil
                    end
                    byId[star] = {}
                    finish = false
                    changed = true
                end
            end
        end
    end

    -- 应用变更
    if changed then
        local equippedSlotCount = CardCfg.Common.EquippedSlotCount
        for i = 1, cardList.n do
            local card = cardList[i]
            if i <= equippedSlotCount then
                self._card.equipped[i] = card
            else
                self._card.store[i - equippedSlotCount] = card
            end
        end

        self:SyncCardData()
        Lib.EventSystem.Broadcast_SinglePlayer(self.owner, Event.OnCardAutoUpgradeAfter, self.owner.UID)
    end
end


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
    if not Lib.IsServer() then
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
    Lib.EventSystem.Broadcast_SinglePlayer(self.owner, Event.OnResetCardData, self.owner.UID)
end


---【双端】获取已解锁的卡牌穿戴槽数量。
---@return number @已解锁槽位数
function PlayerDataManager:GetUnlockedCardSlotCount()
    return math.min(CardCfg.Common.MaxCardSlotLevel, self._card.shopLevel)
end


---【服务端】提升卡牌槽位等级，每级解锁一个穿戴槽，最高 12 级。
function PlayerDataManager:LevelUpCardSlot()
    if not Lib.IsServer() or not self._isLoaded then
        return
    end

    local level = self:GetUnlockedCardSlotCount()
    if level >= CardCfg.Common.MaxCardSlotLevel then
        return
    end

    self._card.shopLevel = level + 1
    self:SyncCardData()
    Lib.EventSystem.Broadcast_SinglePlayer(
        self.owner, 
        Event.OnCardShopLevelUpAfter, 
        self.owner.UID, level, self._card.shopLevel
    )
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
    if not Lib.IsServer() or not self._isLoaded then
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
    Lib.EventSystem.Broadcast_SinglePlayer(
        self.owner, 
        Event.OnCardEquipAfter, 
        self.owner.UID, fromSlot, toSlot, card
    )
end


---【服务端】卸下卡牌。
---@param fromSlot number @卡牌槽位索引 1-12
---@param toSlot? number @仓库槽位索引 1-20 ，默认为第一个空槽位
---@param sync? boolean @是否立即同步数据，默认为 true
function PlayerDataManager:UnequipCard(fromSlot, toSlot, sync)
    if not Lib.IsServer() or not self._isLoaded then
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
    Lib.EventSystem.Broadcast_SinglePlayer(
        self.owner, 
        Event.OnCardUnequipAfter, 
        self.owner.UID, fromSlot, toSlot, card
    )
end


---【服务端】购买卡牌。
---@param fromSlot number @商店槽位索引 1-6
---@param toSlot? number @仓库槽位索引 1-20 ，默认为第一个空槽位
---@param sync? boolean @是否立即同步数据，默认为 true
function PlayerDataManager:PurchaseCard(fromSlot, toSlot, sync)
    if not Lib.IsServer() or not self._isLoaded then
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
        ugcprint('资源点不足')
        return  
    end
    self:AddCoin(ItemId.Coin_0, -cost)

    store[toSlot] = card
    shop[fromSlot] = nil

    if sync ~= false then
        self:SyncCardData()
    end
    Lib.EventSystem.Broadcast_SinglePlayer(
        self.owner, 
        Event.OnCardPurchaseAfter, 
        self.owner.UID, fromSlot, toSlot, card, cost
    )

    self:_CardAutoUpgrade()
end


function PlayerDataManager:_SellCard(from, slot, sync)
    if not Lib.IsServer() or not self._isLoaded then
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
    Lib.EventSystem.Broadcast_SinglePlayer(
        self.owner, 
        Event.OnCardSellAfter, 
        self.owner.UID, from, slot, card, refund
    )
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
    if not Lib.IsServer() or not self._isLoaded then
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
    Lib.EventSystem.Broadcast_SinglePlayer(
        self.owner, 
        Event.OnCardShopRefreshAfter, 
        self.owner.UID, shop
    )
end


-- endregion


-- region: 统计 ==================================================


---【双端】获取指定统计数据的值。
---@param name Statistics @统计数据名称，请使用 Statistics 枚举值
---@return number @数据值
function PlayerDataManager:GetStat(name)
    if not self._isLoaded then
        return 0
    end
    return self._data.stat[name]
end


---【服务端】累加指定统计数据。
---@param name Statistics @统计数据名称，请使用 Statistics 枚举值
---@param delta? number @增量，默认为 1
---@param sync? boolean @是否立即同步数据，默认为 true
function PlayerDataManager:AddStat(name, delta, sync)
    if not Lib.IsServer() or not self._isLoaded then
        return
    end
    delta = delta or 1
    local stat = self._data.stat
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
    if not Lib.IsServer() or not self._isLoaded then
        return
    end
    self._data.title.equipped = title
    self:SyncData()
    Lib.EventSystem.Broadcast_SinglePlayer(self.owner, Event.OnTitleEquipAfter, self.owner.UID, title)
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
    if not Lib.IsServer() or not self._isLoaded then
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
    Lib.EventSystem.Broadcast_SinglePlayer(self.owner, Event.OnTitleUnlockAfter, self.owner.UID, title)
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
