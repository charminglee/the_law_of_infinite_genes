---@class StoreResultantPanel_C:UUserWidget
---@field ExpandableArea_7 UExpandableArea
---@field ExpandableArea_8 UExpandableArea
---@field ExpandableArea_9 UExpandableArea
---@field ExpandableArea_10 UExpandableArea
---@field ExpandableArea_11 UExpandableArea
---@field Image_0 UImage
---@field StoreCollapseList StoreCollapseList_C
---@field StoreCollapseList_0 StoreCollapseList_C
---@field StoreCollapseList_1 StoreCollapseList_C
---@field StoreCollapseList_3 StoreCollapseList_C
---@field StoreCollapseList_4 StoreCollapseList_C
--Edit Below--
local StoreResultantPanel = { bInitDoOnce = false } 

function StoreResultantPanel:Construct()
    self:LuaInit();
    
end

function StoreResultantPanel:LuaInit()
	if self.bInitDoOnce then
		return;
    end
end

return StoreResultantPanel