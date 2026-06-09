---@class StoreRefinedPanel_C:UUserWidget
---@field Button_0 UButton
---@field Button_1 UButton
---@field Image_5 UImage
---@field Image_24 UImage
---@field Image_60 UImage
---@field Image_105 UImage
---@field Image_173 UImage
---@field Image_176 UImage
---@field lock_border UImage
---@field lock_item UImage
---@field lock_quality UImage
---@field m1_item UImage
---@field m1_quality UImage
---@field m2_border UImage
---@field m2_item UImage
---@field m2_quality UImage
---@field preview_border UImage
---@field preview_item UImage
---@field preview_quality UImage
---@field RefinedChoseList ReuseList2_C
---@field RefinedList ReuseList2_C
--Edit Below--
local StoreRefinedPanel = { 
    bInitDoOnce = false ,
    StoreRefinedChoseItemIndex = 0,
    } 
function StoreRefinedPanel:Construct()
    self:LuaInit();
end
function StoreRefinedPanel:LuaInit()
	if self.bInitDoOnce then
		return;
    end
    self:Listen();
    self.RefinedChoseList:Reload(6);
    self.RefinedList:Reload(5);
end
function StoreRefinedPanel:Listen()
    self.RefinedChoseList.OnUpdateItem:Add(self.RefinedChoseListUpdate, self);
    self.RefinedList.OnUpdateItem:Add(self.RefinedListUpdate, self);
end
function StoreRefinedPanel:Tick(MyGeometry, InDeltaTime)
    if self.StoreRefinedChoseItemIndex ~= StoreManager.StoreRefinedChoseItemIndex then
        self.StoreRefinedChoseItemIndex = StoreManager.StoreRefinedChoseItemIndex;
        self.RefinedChoseList:Reload(6);
    end
end
function StoreRefinedPanel:RefinedChoseListUpdate(Item, Index)
    Item.Index = Index;
    if self.StoreRefinedChoseItemIndex == Index then
        Item:SetSelectedVisible(ESlateVisibility.Visible);
    else
        Item:SetSelectedVisible(ESlateVisibility.Collapsed);
    end
end
function StoreRefinedPanel:RefinedListUpdate(Item, Index)
end
return StoreRefinedPanel


