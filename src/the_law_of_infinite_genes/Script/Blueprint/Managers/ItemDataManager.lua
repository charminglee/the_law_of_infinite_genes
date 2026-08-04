---管理玩家背包/仓库中装备的自定义数据，绑定于 PlayerState，双端可见。
---@class ItemDataManager_C:BaseManager_C
--Edit Below--
local ItemDataManager = {}


local KENL_SLOT_NAME = "EquipmentSlot.Suit.Kenl"


function ItemDataManager:_MergeDefaults(data, defaults)
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


---【双端】获取物品自定义数据。
---@return (EquipmentData|KenlData|table)? @自定义数据
function ItemDataManager:GetCustomData(defineId)
    local data = UGCItemSystemV2.LoadItemCustomData(defineId)
    if not data then
        return nil
    else
        local itemType = UGCItemSystemV2.GetItemCustomizedTypeV2(defineId.TypeSpecificID)
        local defaults
        if itemType == "Kenl" then
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
        self:_MergeDefaults(data, defaults)
        return data
    end
end


function ItemDataManager:_SaveData(defineId, data)
    local oldData = self:GetCustomData(defineId)
    if not oldData then
        return false
    end
    for k, v in pairs(data) do
        oldData[k] = v
    end
    return UGCItemSystemV2.SaveItemCustomData(defineId, oldData)
end


---【服务端】鉴定核心。
---@param defineId ItemDefineID @核心的 ItemDefineID
---@return AttrEntry[]? @鉴定结果词条列表，鉴定失败时返回 nil
function ItemDataManager:Identify(defineId)
    if not self:HasAuthority() then
        return nil
    end
    local data = self:GetCustomData(defineId)
    if not data or data.isIdentified then
        return nil
    end

    -- 扣除鉴定材料
    local itemId = defineId.TypeSpecificID
    ---@type PlayerDataManager_C
    local pdm = self.owner.PlayerDataManager
    local cost = ItemCfg.IdentifyCost[itemId]
    if not pdm:AddCoin(ItemCfg.IdentifyMaterial, -cost) then
        return nil
    end
    
    -- 生成随机词条
    local quality = UGCItemSystemV2.GetItemQualityV2(itemId)
    local entries = {}
    local attrs = Lib.Random.Pick(ItemCfg.AttributeEntryPool, quality + 1)
    for _, attr in pairs(attrs) do
        local range = ItemCfg.AttributeEntryRange[attr]
        local value = math.random(range.min, range.max)
        if range.max - range.min <= 1 then
            value = Lib.Math.Round(value, 1)
        else
            value = Lib.Math.Round(value, 0)
        end
        table.insert(entries, { property=attr, value=value })
    end

    -- 词条数据存入核心
    data.entries = entries
    data.isIdentified = true
    if not self:_SaveData(defineId, data) then
        return nil
    end
    return entries
end


---【服务端】融合两个核心。
---@param defineId1 ItemDefineID @主核心的 ItemDefineID
---@param defineId2 ItemDefineID @另一核心的 ItemDefineID
function ItemDataManager:Fusion(defineId1, defineId2)
    if not self:HasAuthority() then
        return
    end
end


---【服务端】洗炼核心。
---@param defineId ItemDefineID @装备的 ItemDefineID
function ItemDataManager:Refine(defineId)
    if not self:HasAuthority() then
        return
    end
end
 

---【服务端】强化指定装备。
---@param defineId ItemDefineID @装备的 ItemDefineID
---@param level number @要强化的等级，默认为 1
---@return number @返回强化后的等级，强化失败时返回 -1
function ItemDataManager:Strengthen(defineId, level)
    if not self:HasAuthority() then
        return -1
    end
    level = level or 1
    local data = self:GetCustomData(defineId)
    if not data then
        return -1
    end
    data.strengthenLevel = (data.strengthenLevel or 0) + level
    self:_SaveData(defineId, data)
    return data.strengthenLevel
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