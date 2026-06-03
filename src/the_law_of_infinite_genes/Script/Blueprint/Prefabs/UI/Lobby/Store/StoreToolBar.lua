---@class StoreToolBar_C:UUserWidget
---@field background UImage
---@field Button_1 UButton
---@field Image_0 UImage
--Edit Below--
local StoreToolBar = {
	bInitDoOnce = false,
	parent = nil,
	} 


function StoreToolBar:Construct()
	self:LuaInit();
end

function StoreToolBar:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	self.Button_1.OnClicked:Add(self.Button_1_OnClicked, self);
end

function StoreToolBar:Button_1_OnClicked()
	self.parent:SwitchLobby();
	return nil;
end

return StoreToolBar