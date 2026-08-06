---管理玩家属性数据，绑定于 PlayerPawn ，双端可见。
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


---@type table<Attribute, {min: number, max: number}>
local _ATTR_MIN_MAX = nil
---@type table<Attribute, Attribute>
local _PCT_MAP = nil


function AttrManager:ReceiveBeginPlay()
    AttrManager.SuperClass.ReceiveBeginPlay(self)

    if not _ATTR_MIN_MAX then
        _ATTR_MIN_MAX = {}
        for k, v in pairs(Attribute) do
            _ATTR_MIN_MAX[k] = {
                min = UGCAttributeSystem.GetGameAttributeValueMin(self.owner, v), 
                max = UGCAttributeSystem.GetGameAttributeValueMax(self.owner, v),
            }   
        end
    end
    _PCT_MAP = _PCT_MAP or {
        [Attribute.AttackPower] = Attribute.AttackPowerPct,
        [Attribute.Defence]     = Attribute.DefensePct,
        [Attribute._HealthMax]  = Attribute.HealthMaxPct,
    }

    if Lib.IsServer() then
        if not self._base then
            self._base = {}
            for k, v in pairs(Attribute) do
                if k ~= Attribute.HealthMax then
                    self._base[k] = UGCAttributeSystem.GetGameAttributeValue(self.owner, v)
                end
            end
        end
        if not self._attrCache then
            self._attrCache = Lib.Table.Copy(self._base)
        end
        if not self._final then
            self._final = {}
            self:_UpdateFinal()
        end

        Lib.EventSystem.Listen(Event.OnResetCardData, self.OnResetCardData, self)
        Lib.EventSystem.Listen(Event.OnCardEquipAfter, self.OnCardEquipAfter, self)
        Lib.EventSystem.Listen(Event.OnCardUnequipAfter, self.OnCardUnequipAfter, self)
        Lib.EventSystem.Listen(Event.OnCardSellAfter, self.OnCardSellAfter, self)
    end
end


function AttrManager:ReceiveEndPlay()
    AttrManager.SuperClass.ReceiveEndPlay(self)
    self._attrCache = nil
    self._base = nil
    self._final = nil
    if Lib.IsServer() then
        Lib.EventSystem.UnlistenByOwner(self)
    end
end


function AttrManager:OnResetCardData(uid)
    if uid ~= self.owner.UID then
        return
    end
    self:_RebuildAllAttr()
end


function AttrManager:OnCardEquipAfter(uid, fromSlot, toSlot, card)
    if uid ~= self.owner.UID then
        return
    end
    self:_RebuildAllAttr()
end


function AttrManager:OnCardUnequipAfter(uid, fromSlot, toSlot, card)
    if uid ~= self.owner.UID then
        return
    end
    self:_RebuildAllAttr()
end


function AttrManager:OnCardSellAfter(uid, from, slot, card, refund)
    if uid ~= self.owner.UID or from ~= "equipped" then
        return
    end
    self:_RebuildAllAttr()
end


---计算单张卡牌提供的加成。
local function _CardBonusOf(card)
    local id, star = card[1], card[2]
    local bonus = CardCfg.Cards[id].bonus[star]
    local result = {}
    for _, entry in pairs(bonus) do
        local prop = entry.property
        local val = entry.value
        if prop == Attribute.HealthMax then
            prop = Attribute._HealthMax
        end
        result[prop] = (result[prop] or 0) + val
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


---重算全部属性加成。
function AttrManager:_RebuildAllAttr()
    if not Lib.IsServer() then
        return false
    end

    local pdm = self.owner.PlayerState.PlayerDataManager
    local equipped = pdm:GetAllEquippedCards()
    local slotCount = pdm:GetUnlockedCardSlotCount()
    local attrTable = Lib.Table.Copy(self._base)
    for slot = 1, slotCount do
        local bonus = _CardBonusOf(equipped[slot])
        if bonus ~= nil then
            for attr, value in pairs(bonus) do
                attrTable[attr] = (attrTable[attr] or 0) + value
            end
        end
    end

    for attr, value in pairs(attrTable) do
        self:_SetAttr(attr, value)
    end
    self:_UpdateFinal()
    for attr, _ in pairs(attrTable) do
        self:_ApplyAttr(attr)
    end
    return true
end


---【双端】获取属性值。
---@param attr Attribute @Attribute 枚举值
---@param includePct boolean? @是否包含百分比加成，默认为 true
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


function AttrManager:_SetAttr(attr, value)
    if attr == Attribute.HealthMax then
        attr = Attribute._HealthMax
    end
    local range = _ATTR_MIN_MAX[attr]
    value = Lib.Math.Clamp(value, range.min, range.max)
    self._attrCache[attr] = value
    UGCAttributeSystem.SetGameAttributeValue(self.owner, attr, value)
end


function AttrManager:_ApplyAttr(attr)
    if attr == Attribute.HealthMax then
        attr = Attribute._HealthMax
    end
    local value = self._attrCache[attr]
    if attr == Attribute._HealthMax then
        local hm = self._final[Attribute._HealthMax]
        UGCAttributeSystem.SetGameAttributeValue(self.owner, Attribute.HealthMax, hm)
    elseif attr == Attribute.InfiniteAmmo then
        local weapon = UGCWeaponManagerSystem.GetCurrentWeapon(self.owner)
        UGCGunSystem.EnableClipInfiniteBullets(weapon, value == 1)
    end
end



---【服务端】设置属性值。
---@param attr Attribute @Attribute 枚举值
---@param value number @属性值
function AttrManager:SetAttr(attr, value)
    if not Lib.IsServer() then
        return
    end
    self:_SetAttr(attr, value)
    self:_UpdateFinal()
    self:_ApplyAttr(attr)
end


return AttrManager
