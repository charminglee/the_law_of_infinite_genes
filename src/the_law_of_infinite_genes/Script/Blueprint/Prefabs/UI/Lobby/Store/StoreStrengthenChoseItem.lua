---@class StoreStrengthenChoseItem_C:UUserWidget
---@field bg UImage
---@field Button_0 UButton
---@field Image_3 UImage
---@field Image_46 UImage
---@field quality UImage
---@field selected UImage
--Edit Below--
local StoreStrengthenChoseItem = { bInitDoOnce = false, Index=nil } 

function StoreStrengthenChoseItem:Construct()
	self:LuaInit();
end

function StoreStrengthenChoseItem:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	self:Listen();
end

function StoreStrengthenChoseItem:Listen()
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);
end

function StoreStrengthenChoseItem:Button_0_Clicked()
    StoreManager.StoreStrengthenChoseItemIndex = self.Index;
end

function StoreStrengthenChoseItem:SetSelectedVisible(Visible)
    self.selected:SetVisibility(Visible);
end
return StoreStrengthenChoseItem