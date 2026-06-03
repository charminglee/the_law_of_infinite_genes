---@class StoreBackpackItem_C:UUserWidget
---@field Button_0 UButton
---@field number_label UTextBlock
---@field quality UImage
---@field selected UImage
---@field sticker UImage
--Edit Below--
local StoreBackpackItem = { bInitDoOnce = false, Index = nil} 

function StoreBackpackItem:Construct()
    self:LuaInit();
end

function StoreBackpackItem:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	self:Listen();
end

function StoreBackpackItem:Listen()
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);
end

function StoreBackpackItem:Button_0_Clicked()
    StoreManager.BackpackSelectIndex = self.Index;
end

function StoreBackpackItem:SetSelectedVisible(Visible)
    self.selected:SetVisibility(Visible);
end
return StoreBackpackItem