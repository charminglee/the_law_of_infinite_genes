---@class StoreTabButton_C:UUserWidget
---@field Button_0 UButton
---@field checked UImage
---@field TextBlock_0 UTextBlock
--Edit Below--
local StoreTabButton = {bInitDoOnce = false, Index=nil} 

function StoreTabButton:Construct()
	self:LuaInit();
end

function StoreTabButton:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	self:Listen();
end

function StoreTabButton:Listen()
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);
end

function StoreTabButton:Button_0_Clicked()
    StoreManager.TabSelectIndex = self.Index;
    return nil;
end

---@param text string
function StoreTabButton:SetText(text)
	self.TextBlock_0:SetText(text);
end

---@param Visible number
function StoreTabButton:SetSelectedVisible(Visible)
	self.checked:SetVisibility(Visible);
end

return StoreTabButton