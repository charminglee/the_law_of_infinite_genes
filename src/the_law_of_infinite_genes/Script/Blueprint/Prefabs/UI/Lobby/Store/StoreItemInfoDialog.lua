---@class StoreItemInfoDialog_C:UUserWidget
---@field Button_0 UButton
---@field Button_1 UButton
---@field Image_0 UImage
--Edit Below--
local StoreItemInfoDialog = { bInitDoOnce = false } 

function StoreItemInfoDialog:Construct()
    self:LuaInit()
end

function StoreItemInfoDialog:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	self:Listen();
    StoreManager:RegisterItemInfoDialogUI(self);
end

function StoreItemInfoDialog:Listen()
    self.Button_0.OnClicked:Add(self.Exit, self);
    self.Button_1.OnClicked:Add(self.Exit, self);
end

function StoreItemInfoDialog:Exit()
    self:SetVisibility(ESlateVisibility.Collapsed);
end

return StoreItemInfoDialog