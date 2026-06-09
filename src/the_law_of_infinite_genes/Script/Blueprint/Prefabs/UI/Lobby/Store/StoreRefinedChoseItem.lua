---@class StoreRefinedChoseItem_C:UUserWidget
---@field bg UImage
---@field Button_0 UButton
---@field Image_3 UImage
---@field Image_46 UImage
---@field quality UImage
---@field selected UImage
--Edit Below--
local StoreRefinedChoseItem = { bInitDoOnce = false, Index=nil} 

function StoreRefinedChoseItem:Construct()
	self:LuaInit();
end 

function StoreRefinedChoseItem:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	self:Listen();
end

function StoreRefinedChoseItem:Listen()
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);
end

function StoreRefinedChoseItem:Button_0_Clicked()
    StoreManager.StoreRefinedChoseItemIndex = self.Index;
end

function StoreRefinedChoseItem:SetSelectedVisible(Visible)
    self.selected:SetVisibility(Visible);
end

return StoreRefinedChoseItem