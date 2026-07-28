---管理玩家属性数据，绑定于PlayerPawn，仅服务端可见。
---@class AttrManager_C:BaseManager_C
--Edit Below--
local AttrManager = {
    ---@type table<Attribute, number>
    _attrCache = nil,
    ---@type table<Attribute, number>
    _base = nil,
    ---@type table<Attribute, number>
    _final = nil,
}


---@type table<Attribute, boolean>
local _GAS_BACKED = nil
---@type table<Attribute, {min: number, max: number}>
local _ATTR_MIN_MAX = nil
---@type table<Attribute, Attribute>
local _PCT_MAP = nil


function AttrManager:ReceiveBeginPlay()
    AttrManager.SuperClass.ReceiveBeginPlay(self)

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

    if not self._base then
        self._base = {}
        for k, _ in pairs(_GAS_BACKED) do
            local attr = k
            if k == Attribute._HealthMax then
                attr = Attribute.HealthMax
            end
            local v = UGCAttributeSystem.GetGameAttributeValue(self.owner, attr)
            self._base[k] = v
        end
    end
    if not self._attrCache then
        self._attrCache = Lib.Table.Copy(self._base)
    end
    if not self._final then
        self._final = {}
        self:_UpdateFinal()
    end

    if self:HasAuthority() then 
        Lib.EventSystem.Listen(Event.OnResetCardData, self.OnResetCardData, self)
        Lib.EventSystem.Listen(Event.OnCardEquipAfter, self.OnCardEquipAfter, self)
        Lib.EventSystem.Listen(Event.OnCardUnequipAfter, self.OnCardUnequipAfter, self)
        Lib.EventSystem.Listen(Event.OnCardSellAfter, self.OnCardSellAfter, self)
    end
end


function AttrManager:ReceiveEndPlay()
    self._attrCache = nil
    self._final = nil
    Lib.EventSystem.UnlistenByOwner(self)
end


function AttrManager:OnResetCardData(uid)
    if uid ~= self.owner.UID then
        return
    end
    self:_RebuildFromEquipped()
end


function AttrManager:OnCardEquipAfter(uid, fromSlot, toSlot, card)
    if uid ~= self.owner.UID then
        return
    end
    self:_RebuildFromEquipped()
end


function AttrManager:OnCardUnequipAfter(uid, fromSlot, toSlot, card)
    if uid ~= self.owner.UID then
        return
    end
    self:_RebuildFromEquipped()
end


function AttrManager:OnCardSellAfter(uid, from, slot, card, refund)
    if uid ~= self.owner.UID or from ~= "equipped" then
        return
    end
    self:_RebuildFromEquipped()
end


---计算单张卡牌提供的加成。
local function _CardBonusOf(card)
    local id, star = card[1], card[2]
    local bonus = Card.Cards[id].bonus[star]
    local result = {}
    for _, entry in pairs(bonus) do
        local prop = entry.property
        local val = entry.value
        -- 无后坐力的特殊处理
        if prop == Attribute.Recoilless then
            prop = Attribute.RecoilPct
            val = -1.0
        end
        -- 最大血量的特殊处理
        if prop == Attribute.HealthMax then
            prop = Attribute._HealthMax
        end
        if _GAS_BACKED[prop] then
            result[prop] = (result[prop] or 0) + val
        end
    end
    if Lib.Table.IsEmpty(result) then
        return nil
    end
    return result
end


function AttrManager:_UpdateFinal()
    for base, pct in pairs(_PCT_MAP) do
        local baseVal = self._attrCache[base]
        local pctVal = self._attrCache[pct]
        local finalVal = baseVal * (1 + pctVal)
        local range = _ATTR_MIN_MAX[base]
        finalVal = Lib.Math.Clamp(finalVal, range.min, range.max)
        self._final[base] = finalVal
    end
end


function AttrManager:_UpdateHealthMax()
    local val = self._final[Attribute._HealthMax]
    UGCAttributeSystem.SetGameAttributeValue(self.owner, Attribute.HealthMax, val)
end


---从已装备卡牌列表重算全部卡牌加成并同步属性。
function AttrManager:_RebuildFromEquipped()
    if not self:HasAuthority() then
        return false
    end

    local ps = UGCGameSystem.GetPlayerStateByPlayerPawn(self.owner)
    local pdm = ps.PlayerDataManager
    local equipped = pdm:GetAllEquippedCards()
    local slotCount = pdm:GetUnlockedCardSlotCount()
    self._attrCache = Lib.Table.Copy(self._base)
    for slot = 1, slotCount do
        local bonus = _CardBonusOf(equipped[slot])
        if bonus ~= nil then
            for attr, value in pairs(bonus) do
                self._attrCache[attr] = (self._attrCache[attr] or 0) + value
            end
        end
    end

    for attr, value in pairs(self._attrCache) do
        local range = _ATTR_MIN_MAX[attr]
        value = Lib.Math.Clamp(value, range.min, range.max)
        self._attrCache[attr] = value
        UGCAttributeSystem.SetGameAttributeValue(self.owner, attr, value)
    end

    self:_UpdateFinal()
    self:_UpdateHealthMax()
    return true
end


---【服务端】获取属性值。
---@param attr Attribute @Attribute枚举值
---@param includePct boolean? @是否包含百分比加成，默认为true
---@return number @属性值
function AttrManager:GetAttr(attr, includePct)
    if attr == Attribute.HealthMax then
        attr = Attribute._HealthMax
    end
    if includePct == nil then
        includePct = true
    end

    if includePct and self._final[attr] ~= nil then 
        return self._final[attr]
    else
        return self._attrCache[attr]
    end
end


return AttrManager
