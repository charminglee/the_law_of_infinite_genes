---@class StoreResultantPanel_C:UUserWidget
---@field bg UImage
---@field border UImage
---@field Button_49 UButton
---@field CountText UTextBlock
---@field DecreaseButton UButton
---@field ExpandableArea_7 UExpandableArea
---@field ExpandableArea_8 UExpandableArea
---@field ExpandableArea_9 UExpandableArea
---@field ExpandableArea_10 UExpandableArea
---@field ExpandableArea_11 UExpandableArea
---@field Image_0 UImage
---@field Image_1 UImage
---@field Image_46 UImage
---@field Increase100Button UButton
---@field Increase10Button UButton
---@field IncreaseButton UButton
---@field Item UImage
---@field quality UImage
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