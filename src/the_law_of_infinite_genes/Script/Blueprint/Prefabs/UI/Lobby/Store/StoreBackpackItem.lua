---@class StoreBackpackItem_C:UUserWidget
---@field Button_1 UButton
---@field Image_0 UImage
---@field Image_1 UImage
---@field selected UImage
---@field TextBlock_0 UTextBlock
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
    self.Button_1.OnClicked:Add(self.Button_1_Clicked, self);
end

function StoreBackpackItem:Button_1_Clicked()
    if StoreManager.BackpackSelectIndex == self.Index then
        StoreManager:OpenStoreItemInfoDialog();
    end
    StoreManager.BackpackSelectIndex = self.Index;
end

function StoreBackpackItem:SetSelectedVisible(Visible)
    self.selected:SetVisibility(Visible);
end
return StoreBackpackItem