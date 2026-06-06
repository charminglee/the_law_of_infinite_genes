---@class StoreBackpackTabButton_C:UUserWidget
---@field Button_0 UButton
---@field Image_0 UImage
---@field selected UCanvasPanel
---@field TextBlock_0 UTextBlock
--Edit Below--
local StoreBackpackTabButton = { bInitDoOnce = false, Index=nil} 

function StoreBackpackTabButton:Construct()
	self:LuaInit();
end

function StoreBackpackTabButton:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	self:Listen();
end

function StoreBackpackTabButton:Listen()
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);
end

function StoreBackpackTabButton:Button_0_Clicked()
    StoreManager.StoreBackpackTabSelectIndex = self.Index;
    return nil
end

function StoreBackpackTabButton:SetText(text)
    self.TextBlock_0:SetText(text);
end

function StoreBackpackTabButton:SetSelectedVisible(Visible)
    self.selected:SetVisibility(Visible);
end
return StoreBackpackTabButton