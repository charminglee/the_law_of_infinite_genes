---管理玩家背包/仓库中装备的自定义数据，绑定于 PlayerState ，双端可见。
---@class ItemDataManager_C:BaseManager_C
--Edit Below--
local ItemDataManager = {}


local function _IsEquipment(itemId)
    if type(itemId) ~= "number" then
        itemId = itemId.TypeSpecificID
    end
    local tags = UGCItemSystemV2.GetItemTagsV2(itemId)
    return Lib.Table.Contain(tags, GameplayTag.Item.Equipment)
end


local function _IsKenl(itemId)
    if type(itemId) ~= "number" then
        itemId = itemId.TypeSpecificID
    end
    local tags = UGCItemSystemV2.GetItemTagsV2(itemId)
    return Lib.Table.Contain(tags, GameplayTag.EquipmentSlot.Kenl)
end


local function _GetQuality(itemId)
    if type(itemId) ~= "number" then
        itemId = itemId.TypeSpecificID
    end
    return UGCItemSystemV2.GetItemQualityV2(itemId)
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
    local value = ItemCfg.AttrCurve(range.Min, range.Max)
    value = _RoundAttrValue(value, range.Min, range.Max)
    return value
end


---【双端】获取物品自定义数据。
---@param defineId ItemDefineID @物品的 ItemDefineID
---@return (EquipmentData|KenlData|table)? @自定义数据
function ItemDataManager:GetCustomData(defineId)
    local data = UGCItemSystemV2.LoadItemCustomData(defineId) or {}
    local defaults
    if _IsKenl(defineId) then
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
            Lib.ToTable(defineId), 
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
    if not _IsKenl(itemId) then
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


function ItemDataManager:_AddItem(itemId, count, customData)
    if type(itemId) ~= "number" then
        itemId = itemId.TypeSpecificID
    end
    count = count or 1
    local pc = UGCGameSystem.GetPlayerControllerByPlayerState(self.owner)
    if customData then
        local defineId = UGCItemSystemV2.GetItemDefineID(itemId)
        self:_SaveCustomData(defineId, customData)
        return UGCBackpackSystemV2.AddItemByDefineIDV2(pc, defineId, count) > 0
    else
        local res = UGCBackpackSystemV2.AddItemV2(pc, itemId, count)
        return res and res[0] > 0
    end
end


function ItemDataManager:_RemoveItem(itemId, count)
    count = count or 1
    local pc = UGCGameSystem.GetPlayerControllerByPlayerState(self.owner)
    if type(itemId) == "number" then
        return UGCBackpackSystemV2.RemoveItemV2(pc, itemId, count) > 0  
    else
        return UGCBackpackSystemV2.RemoveItemByDefineIDV2(pc, itemId, count) > 0
    end
end


function ItemDataManager:_GetItemCount(itemId)
    local pc = UGCGameSystem.GetPlayerControllerByPlayerState(self.owner)
    if type(itemId) == "number" then
        return UGCBackpackSystemV2.GetItemCountV2(pc, itemId)
    else
        return UGCBackpackSystemV2.GetItemCountByDefineIDV2(pc, itemId)
    end
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
    if not _IsKenl(itemId1) or not _IsKenl(itemId2) then
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

    self:_RemoveItem(defineId2)

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
    if not _IsKenl(itemId) then
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
---@param useAdvanced boolean? @是否使用宇宙晶石，默认为 false
---@return boolean @是否成功
function ItemDataManager:Reforge(defineId, useAdvanced)
    if not Lib.IsServer() then
        return false
    end
    local reforgeData = ItemCfg.Reforge.ReforgeMap[defineId.TypeSpecificID]
    if not reforgeData then
        return false
    end
    local result      = reforgeData.Result
    local requirement = reforgeData.Requirement
    local prob        = reforgeData.Prob

    for _, req in pairs(requirement) do
        if self:_GetItemCount(req.ItemId) < req.Value then
            return false
        end
    end

    if useAdvanced then
        if self:_GetItemCount(ItemId.Advanced_1) <= 0 then
            return false
        end
        prob = prob + ItemCfg.Reforge.AdvancedProbBoost
        self:_RemoveItem(ItemId.Advanced_1)
    end
    for _, req in pairs(requirement) do
        self:_RemoveItem(req.ItemId, req.Value)
    end

    if Lib.Math.Chance(prob) then
        self:_AddItem(result, 1, self:GetCustomData(defineId))
        self:_RemoveItem(defineId)
        return true
    else
        return false
    end
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


---【双端】获取装备基础词条明细，包含最终值、初始值和强化值。
---@param defineId ItemDefineID @装备的 ItemDefineID
---@param level number? @指定的强化等级；不传 level 时使用装备当前强化等级；传入 level 可用于 UI 预览指定等级
---@return BaseAttrEntryDetail[]? @词条明细，格式 { property: Attribute, finalValue: number, initialValue: number, strengthenValue: number } ；获取失败返回 nil
function ItemDataManager:GetBaseAttrEntryDetail(defineId, level)
    if not _IsEquipment(defineId) then
        ugcprint('返回nil')
        return nil
    end

    local itemId = defineId.TypeSpecificID
    local quality = _GetQuality(itemId)
    local name = UGCItemSystemV2.GetItemNameV2(itemId)
    local factor = ItemCfg.EquipmentAttribute[name].Factor[quality]
    local base = ItemCfg.EquipmentAttribute[name].Base
    if not level then
        level = self:GetStrengthenLevel(defineId)
    end

    local result = {}
    for _, entry in pairs(base) do
        local initialValue = entry.value * factor
        local strengthenValue = initialValue * ItemCfg.Strengthen.StrengthenCurve(entry.property, level, quality)
        table.insert(result, {
            property = entry.property,
            initialValue = initialValue,
            strengthenValue = strengthenValue,
            finalValue = initialValue + strengthenValue,
        })
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