---@class PlayerAttrManager_C:BaseManager_C
--Edit Below--
local PlayerAttrManager = {
    ---@type table<Attribute, number>
    _attrCache = nil,
    ---@type table<Attribute, number>
    _final = nil,
}


---@type table<Attribute, boolean>
local _GAS_BACKED = nil
---@type table<Attribute, {min: number, max: number}>
local _ATTR_MIN_MAX = nil
---@type table<Attribute, Attribute>
local _PCT_MAP = nil


function PlayerAttrManager:ReceiveBeginPlay()
    PlayerAttrManager.SuperClass.ReceiveBeginPlay(self)
    _GAS_BACKED = _GAS_BACKED or {
        [Attribute.AttackPower]             = true,
        [Attribute.AttackPowerPct]          = true,
        [Attribute.DamagePct]               = true,
        [Attribute.NormalMonsterDamagePct]  = true,
        [Attribute.EliteMonsterDamagePct]   = true,
        [Attribute.BossDamagePct]           = true,
        [Attribute.CritChance]              = true,
        [Attribute.CritDamagePct]           = true,
        [Attribute.Defence]                 = true,
        [Attribute.DefensePct]              = true,
        [Attribute.HealthStealPct]          = true,
        [Attribute.CounterAttackPct]        = true,
        [Attribute.DamageDecreace]          = true,
        [Attribute.DamageDecreacePct]       = true,
        [Attribute.BreakDefencePct]         = true,
        [Attribute.SeckillChance]           = true,
        [Attribute.DodgeChance]             = true,
        [Attribute.RecoilPct]               = true,
        [Attribute.ReloadTime]              = true,
        [Attribute.ReloadTimePct]           = true,
        [Attribute.MoveSpeedScale]          = true,
        [Attribute.ShootSpeedScale]         = true,
        [Attribute.HealthMaxPct]            = true,
        [Attribute._HealthMax]              = true,
    }
    if not _ATTR_MIN_MAX then
        _ATTR_MIN_MAX = {}
        for k, _ in pairs(_GAS_BACKED) do
            _ATTR_MIN_MAX[k] = {
                min = UGCAttributeSystem.GetGameAttributeValueMin(self.owner, k), 
                max = UGCAttributeSystem.GetGameAttributeValueMax(self.owner, k),
            }   
        end
    end
    _PCT_MAP = _PCT_MAP or {
        [Attribute.AttackPower] = Attribute.AttackPowerPct,
        [Attribute.Defence]     = Attribute.DefensePct,
        [Attribute._HealthMax]  = Attribute.HealthMaxPct,
    }

    if not self._attrCache then
        self._attrCache = {}
        for k, _ in pairs(_GAS_BACKED) do
            local v
            if k == Attribute._HealthMax then
                v = UGCAttributeSystem.GetGameAttributeValue(self.owner, Attribute.HealthMax)
            else
                v = UGCAttributeSystem.GetGameAttributeValue(self.owner, k)
            end
            self._attrCache[k] = v
        end
    end
    if not self._final then
        self._final = {}
        self:_UpdateFinal()
    end

    if self:HasAuthority() then 
        Lib.EventSystem.Listen(ServerEvent.OnResetCardData, self.OnResetCardData, self)
        Lib.EventSystem.Listen(ServerEvent.OnCardEquipAfter, self.OnCardEquipAfter, self)
        Lib.EventSystem.Listen(ServerEvent.OnCardUnequipAfter, self.OnCardUnequipAfter, self)
        Lib.EventSystem.Listen(ServerEvent.OnCardSellAfter, self.OnCardSellAfter, self)
    end
end


function PlayerAttrManager:ReceiveEndPlay()
    Lib.EventSystem.UnlistenByOwner(self)
end


function PlayerAttrManager:OnResetCardData(uid)
    if uid ~= self.owner.UID then
        return
    end
    self:_ClearCardDelta()
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


---计算单张卡牌提供的加成。
local function _CardBonusOf(card)
    local id, star = card[1], card[2]
    local bonus = Card.Cards[id].bonus[star]
    local result = {}
    for _, entry in pairs(bonus) do
        local prop = entry.property
        local val = entry.value
        result[prop] = (result[prop] or 0) + val
    end
    if Lib.Table.IsEmpty(result) then
        return nil
    end
    return result
end


function PlayerAttrManager:_UpdateFinal()
    for base, pct in pairs(_PCT_MAP) do
        local baseVal = self._attrCache[base]
        local pctVal = self._attrCache[pct]
        local finalVal = baseVal * (1 + pctVal)
        self._final[base] = finalVal
    end
end


function PlayerAttrManager:_UpdateHealthMax()
    local val = self._final[Attribute._HealthMax]
    UGCAttributeSystem.SetGameAttributeValue(self.owner, Attribute.HealthMax, val)
end


function PlayerAttrManager:_ClearCardDelta()
    for attr, _ in pairs(_GAS_BACKED) do
        local baseVal = UGCAttributeSystem.GetGameAttributeValue(self.owner, attr)
        self._attrCache[attr] = baseVal
        if _PCT_MAP[attr] then
            local pctAttr = _PCT_MAP[attr]
            local pctVal = UGCAttributeSystem.GetGameAttributeValue(self.owner, pctAttr)
            self._attrCache[pctAttr] = pctVal
        end
    end
    self:_UpdateFinal()
    self:_UpdateHealthMax()
end


---按符号叠加一份卡牌加成到_attrCache并应用到玩家。
function PlayerAttrManager:_ApplyCardDelta(card, sign)
    if not self:HasAuthority() then
        return
    end
    local bonus = _CardBonusOf(card)
    if not bonus then
        return
    end

    for attr, val in pairs(bonus) do
        -- 无后坐力的特殊处理
        if attr == Attribute.Recoilless then
            attr = Attribute.RecoilPct
            val = -1.0
        end
        -- 最大血量的特殊处理
        if attr == Attribute.HealthMax then
            attr = Attribute._HealthMax
        end

        if _GAS_BACKED[attr] then
            local newVal = (self._attrCache[attr] or 0) + sign * val
            self._attrCache[attr] = newVal
            UGCAttributeSystem.SetGameAttributeValue(self.owner, attr, newVal)
        end
    end

    self:_UpdateFinal()
    self:_UpdateHealthMax()
end


---【服务端】获取属性值。
---@param attr Attribute @Attribute枚举值
---@param includePct boolean? @是否包含百分比加成，默认为true
---@return number @属性值
function PlayerAttrManager:Get(attr, includePct)
    if attr == Attribute.HealthMax then
        attr = Attribute._HealthMax
    end
    if includePct == nil then
        includePct = true
    end

    local val
    if includePct and self._final[attr] ~= nil then 
        val = self._final[attr]
    else
        val = self._attrCache[attr]
    end
    return Lib.Math.Clamp(val, _ATTR_MIN_MAX[attr].min, _ATTR_MIN_MAX[attr].max)
end


return PlayerAttrManager
