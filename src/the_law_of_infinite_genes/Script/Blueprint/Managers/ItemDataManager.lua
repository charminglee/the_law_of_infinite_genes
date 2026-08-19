---管理玩家背包/仓库中装备的自定义数据，绑定于 PlayerState ，双端可见。
---@class ItemDataManager_C:BaseManager_C
--Edit Below--
local ItemDataManager = {}


local function _GetQuality(itemId)
    if type(itemId) == "number" then
        return UGCItemSystemV2.GetItemQualityV2(itemId)
    else
        return UGCItemSystemV2.GetItemQualityV2(itemId.TypeSpecificID)
    end
end


local function _GetItemType(itemId)
    if type(itemId) == "number" then
        return UGCItemSystemV2.GetItemCustomizedTypeV2(itemId)
    else
        return UGCItemSystemV2.GetItemCustomizedTypeV2(itemId.TypeSpecificID)
    end
end


local function _MergeDefaults(data, defaults)
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


local function _RoundAttrValue(value, min, max)
    if max - min <= 1 then
        return Lib.Math.Round(value, 1)
    else
        return Lib.Math.Round(value, 0)
    end
end


local function _GenAttrValue(attr)
    local range = ItemCfg.AttributeEntryRange[attr]
    local value = ItemCfg.AttrCurve(range.min, range.max)
    value = _RoundAttrValue(value, range.min, range.max)
    return value
end


---【双端】获取物品自定义数据。
---@param defineId ItemDefineID @物品的 ItemDefineID
---@return (EquipmentData|KenlData|table)? @自定义数据
function ItemDataManager:GetCustomData(defineId)
    local data = UGCItemSystemV2.LoadItemCustomData(defineId) or {}
    local defaults
    if _GetItemType(defineId) == ItemCfg.ItemType.Kenl then
        defaults = {
            entries = {},
            isIdentified = false,
            refineNum = 0,
        }
    else
        defaults = {
            strengthenLevel = 0,
        }
    end
    _MergeDefaults(data, defaults)
    return data
end


function ItemDataManager:_SaveCustomData(defineId, data)
    local oldData = self:GetCustomData(defineId)
    if not oldData then
        return false
    end
    local newData = Lib.Table.DeepCopy(oldData)
    for k, v in pairs(data) do
        newData[k] = v
    end
    local success = UGCItemSystemV2.SaveItemCustomData(defineId, newData)
    if success then
        Lib.EventSystem.Broadcast_SinglePlayer(
            self.owner,
            Event.OnItemCustomDataUpdateAfter, 
            self.owner.UID, 
            defineId, 
            oldData,
            newData
        )
    end
    return success
end


---【服务端】鉴定核心。
---@param defineId ItemDefineID @核心的 ItemDefineID
---@return AttrEntry[]? @鉴定结果词条列表，鉴定失败时返回 nil
function ItemDataManager:Identify(defineId)
    if not Lib.IsServer() then
        return nil
    end
    local itemId = defineId.TypeSpecificID
    if _GetItemType(itemId) ~= ItemCfg.ItemType.Kenl then
        return nil
    end
    local data = self:GetCustomData(defineId)
    if not data or data.isIdentified then
        return nil
    end

    -- 扣除鉴定材料
    local pdm = self.owner.PlayerDataManager ---@type PlayerDataManager_C
    local cost = ItemCfg.Identify.Cost[itemId]
    if not pdm:AddCoin(ItemCfg.Identify.Material, -cost) then
        return nil
    end
    
    -- 生成随机词条
    local quality = _GetQuality(itemId)
    local entries = {}
    local attrs = Lib.Random.Pick(ItemCfg.AttributeEntryPool, quality + 1)
    for _, attr in pairs(attrs) do
        local value = _GenAttrValue(attr)
        table.insert(entries, { property=attr, value=value })
    end

    -- 词条数据存入核心
    data.entries = entries
    data.isIdentified = true
    if not self:_SaveCustomData(defineId, data) then
        return nil
    end

    return Lib.Table.DeepCopy(entries)
end


---【服务端】融合两个核心。
---@param defineId1 ItemDefineID @主核心的 ItemDefineID
---@param defineId2 ItemDefineID @另一核心的 ItemDefineID
---@return AttrEntry[]? @新词条列表，融合失败时返回 nil
function ItemDataManager:Fusion(defineId1, defineId2)
    if not Lib.IsServer() then
        return nil
    end
    local itemId1 = defineId1.TypeSpecificID
    local itemId2 = defineId2.TypeSpecificID
    if _GetItemType(itemId1) ~= ItemCfg.ItemType.Kenl or _GetItemType(itemId2) ~= ItemCfg.ItemType.Kenl then
        return nil
    end
    local data1 = self:GetCustomData(defineId1)
    local data2 = self:GetCustomData(defineId2)
    if not data1 or not data2 then
        return nil
    end

    local quality = _GetQuality(itemId1)
    local n = quality + 1
    local entries = Lib.Table.Concat(data1.entries, data2.entries) ---@type AttrEntry[]
    local result = Lib.Random.Pick(entries, n)
    data1.entries = result
    if not self:_SaveCustomData(defineId1, data1) then
        return nil
    end

    local pc = UGCGameSystem.GetPlayerControllerByPlayerState(self.owner)
    UGCBackpackSystemV2.RemoveItemByDefineIDV2(pc, defineId2, 1)

    return Lib.Table.DeepCopy(result)
end


---【服务端】洗炼核心。
---@param defineId ItemDefineID @核心的 ItemDefineID
---@param ... number @保留的词条索引
---@return AttrEntry[]? @洗炼后的词条列表，洗炼失败时返回 nil
function ItemDataManager:Refine(defineId, ...)
    if not Lib.IsServer() then
        return nil
    end
    local itemId = defineId.TypeSpecificID
    if _GetItemType(itemId) ~= ItemCfg.ItemType.Kenl then
        return nil
    end
    local data = self:GetCustomData(defineId)
    if not data or data.refineNum >= ItemCfg.Refine.Limit then
        return nil
    end

    local keep = {...}
    for i, entry in ipairs(data.entries) do
        if not Lib.Table.Contain(keep, i) then
            entry.value = _GenAttrValue(entry.property)
        end
    end
    data.refineNum = data.refineNum + 1

    if not self:_SaveCustomData(defineId, data) then
        return nil
    end

    return Lib.Table.DeepCopy(data.entries)
end


---【服务端】强化装备。
---@param defineId ItemDefineID @装备的 ItemDefineID
---@return boolean @是否成功
function ItemDataManager:Strengthen(defineId)
    if not Lib.IsServer() then
        return false
    end
    local data = self:GetCustomData(defineId)
    if not data then
        return false
    end

    local level = data.strengthenLevel + 1
    local quality = _GetQuality(defineId)
    local prob = ItemCfg.Strengthen.ProbCurve(level, quality)
    if Lib.Math.Chance(prob) then
        data.strengthenLevel = level
        return self:_SaveCustomData(defineId, data)
    else
        return false
    end
end


---【服务端】精炼装备。
---@param defineId ItemDefineID @装备的 ItemDefineID
---@return boolean @是否成功
function ItemDataManager:Reforge(defineId)
    if not Lib.IsServer() then
        return false
    end
    return true
end


---【双端】获取核心的词条列表。
---@param defineId ItemDefineID @核心的 ItemDefineID
---@return AttrEntry[]? @词条列表，若无数据则返回 nil
function ItemDataManager:GetKenlAttrEntries(defineId)
    local data = self:GetCustomData(defineId)
    if not data then
        return nil
    end
    return data.entries
end


---【双端】获取剩余洗炼次数。
---@param defineId ItemDefineID @核心的 ItemDefineID
---@return number @剩余洗炼次数
function ItemDataManager:GetRemainRefineNum(defineId)
    local data = self:GetCustomData(defineId)
    if not data then
        return 0
    end
    if not data.refineNum then
        return 0
    end
    return ItemCfg.Refine.Limit - data.refineNum
end


---【双端】获取强化等级。
---@param defineId ItemDefineID @装备的 ItemDefineID
---@return number @强化等级
function ItemDataManager:GetStrengthenLevel(defineId)
    local data = self:GetCustomData(defineId)
    if not data then
        return 0
    end
    return data.strengthenLevel or 0
end


---【双端】获取装备的基础词条列表。
---@param defineId ItemDefineID @装备的 ItemDefineID
---@return AttrEntry[]? @基础词条列表，若无数据则返回 nil
function ItemDataManager:GetBaseAttrEntries(defineId)
    local itemId = defineId.TypeSpecificID
    if _GetItemType(itemId) ~= ItemCfg.ItemType.Equipment then
        return nil
    end
    local quality = _GetQuality(itemId)
    local name = UGCItemSystemV2.GetItemNameV2(itemId)
    local factor = ItemCfg.EquipmentAttribute[name].Factor[quality]
    local level = self:GetStrengthenLevel(defineId)
    local base = ItemCfg.EquipmentAttribute[name].Base ---@type AttrEntry[]
    local result = Lib.Table.DeepCopy(base)
    for _, entry in pairs(result) do
        local value = entry.value * factor
        entry.value = value + value * ItemCfg.Strengthen.StrengthenCurve(entry.property, level, quality)
    end
    return result
end


--[[
function ItemDataManager:ReceiveBeginPlay()
    ItemDataManager.SuperClass.ReceiveBeginPlay(self)
end
--]]


--[[
function ItemDataManager:ReceiveTick(DeltaTime)
    ItemDataManager.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]


--[[
function ItemDataManager:ReceiveEndPlay()
    ItemDataManager.SuperClass.ReceiveEndPlay(self) 
end
--]]


return ItemDataManager