---@class PlayerAttrManager_C:BaseManager_C
--Edit Below--
local PlayerAttrManager = {
    _cardBonus = {},
}


local _GAS_BACKED = nil


function PlayerAttrManager:ReceiveBeginPlay()
    PlayerAttrManager.SuperClass.ReceiveBeginPlay(self)
    _GAS_BACKED = {
        [Attribute.AttackPowerBoost]         = true,
        [Attribute.NormalMonsterDamageBoost] = true,
        [Attribute.EliteMonsterDamageBoost]  = true,
        [Attribute.BossDamageBoost]          = true,
        [Attribute.CritChance]               = true,
        [Attribute.CritDamageBoost]          = true,
        [Attribute.DefenseBoost]             = true,
        [Attribute.HealthStealRatio]         = true,
        [Attribute.DamageDecreacePct]        = true,
        [Attribute.BreakDefenceRatio]        = true,
    }
    Lib.EventSystem.Listen(ServerEvent.OnCardEquipAfter,   self.OnCardEquipAfter,   self)
    Lib.EventSystem.Listen(ServerEvent.OnCardUnequipAfter, self.OnCardUnequipAfter, self)
    Lib.EventSystem.Listen(ServerEvent.OnCardSellAfter,    self.OnCardSellAfter,    self)
end


function PlayerAttrManager:OnCardEquipAfter(uid, fromSlot, toSlot, card)
    if uid ~= self.owner.UID then
        return
    end
    self:_ApplyCardDelta(card, 1)
end


function PlayerAttrManager:OnCardUnequipAfter(uid, fromSlot, toSlot, card)
    if uid ~= self.owner.UID then
        return
    end
    self:_ApplyCardDelta(card, -1)
end


function PlayerAttrManager:OnCardSellAfter(uid, from, slot, card, refund)
    if uid ~= self.owner.UID or from ~= "equipped" then
        return
    end
    self:_ApplyCardDelta(card, -1)
end


--===========================  内部  ===========================--


---计算单张卡牌提供的加成。
local function _CardBonusOf(card)
    local id, star = card[1], card[2]
    local bonus = Card.Cards[id].bonus[star]
    local contrib = {}
    for _, entry in pairs(bonus) do
        local prop = entry.property
        local val = entry.value
        if _GAS_BACKED[prop] then
            contrib[prop] = (contrib[prop] or 0) + val
        end
    end
    if Lib.Table.IsEmpty(contrib) then
        return nil
    end
    return contrib
end


---按符号叠加一份卡牌加成到_cardBonus并应用到玩家。
function PlayerAttrManager:_ApplyCardDelta(card, sign)
    local contrib = _CardBonusOf(card)
    if not contrib then
        return
    end
    for attr, val in pairs(contrib) do
        local newVal = (self._cardBonus[attr] or 0) + sign * val
        self._cardBonus[attr] = newVal
        UGCAttributeSystem.SetGameAttributeValue(self.owner, attr, newVal)
    end
end


---【服务端】获取属性当前值。
---@param attr Attribute @Attribute枚举值
---@return number @当前值
function PlayerAttrManager:Get(attr)
    return UGCAttributeSystem.GetGameAttributeValue(self.owner, attr)
end


return PlayerAttrManager
