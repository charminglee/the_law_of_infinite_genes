---@class StoreStrengthenPanel_C:UUserWidget
---@field Button_0 UButton
---@field Button_1 UButton
---@field Image_5 UImage
---@field Image_24 UImage
---@field Image_60 UImage
---@field Image_105 UImage
---@field Image_173 UImage
---@field Image_175 UImage
---@field Image_176 UImage
---@field Image_177 UImage
---@field m1_item UImage
---@field m1_quality UImage
---@field m2_border UImage
---@field m2_item UImage
---@field m2_quality UImage
---@field preview_border UImage
---@field preview_item UImage
---@field preview_quality UImage
---@field ProgressBar_0 UProgressBar
---@field ReuseList2 ReuseList2_C
---@field ReuseList2_C_0 ReuseList2_C
---@field StrengthenChoseList ReuseList2_C
--Edit Below--
local StoreStrengthenPanel = {
     bInitDoOnce = false,
     StoreStrengthenChoseItemIndex = 0,
    } 
function StoreStrengthenPanel:Construct()
    self:LuaInit();
end
function StoreStrengthenPanel:LuaInit()
	if self.bInitDoOnce then
		return;
    end
    self:Listen();
    self.StrengthenChoseList:Reload(6);
end
function StoreStrengthenPanel:Listen()
    self.StrengthenChoseList.OnUpdateItem:Add(self.StrengthenChoseListUpdate, self);
end
function StoreStrengthenPanel:Tick(MyGeometry, InDeltaTime)
    if self.StoreStrengthenChoseItemIndex ~= StoreManager.StoreStrengthenChoseItemIndex then
        self.StoreStrengthenChoseItemIndex = StoreManager.StoreStrengthenChoseItemIndex;
        self.StrengthenChoseList:Reload(6);
    end
end
function StoreStrengthenPanel:StrengthenChoseListUpdate(Item, Index)
    Item.Index = Index;
    if self.StoreStrengthenChoseItemIndex == Index then
        Item:SetSelectedVisible(ESlateVisibility.Visible);
    else
        Item:SetSelectedVisible(ESlateVisibility.Collapsed);
    end
end
return StoreStrengthenPanel