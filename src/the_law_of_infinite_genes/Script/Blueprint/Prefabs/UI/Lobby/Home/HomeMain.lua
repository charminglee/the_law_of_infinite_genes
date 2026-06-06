---@class HomeMain_C:UserWidgetLayout
---@field Button_46 UButton
---@field HomeToolBar HomeToolBar_C
---@field HomeUserInfo HomeUserInfo_C
--Edit Below--
local HomeMain = {
	bInitDoOnce = false,
} 

function HomeMain:Construct()
	self:LuaInit();
end

function HomeMain:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
    self.HomeToolBar.parent = self;
	HomeManager:RegisterMainUI(self);
end

return HomeMain