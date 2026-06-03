---@class lobby_C:UserWidgetLayout
---@field HomeToolBarButton HomeToolBarButton_C
--Edit Below--
local lobby = { bInitDoOnce = false } 

function lobby:Construct()
	self:LuaInit();
end

function lobby:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	ugcprint('初始化lobby界面！')
	self.IndexMain.parent = self;
	self.StoreMain.parent = self;
	self.bInitDoOnce = true;
	self.WidgetSwitcher_0:SetActiveWidget(0)
end

function lobby:switchActiveWidget(idx)
	ugcprint('change active');
	ugcprint('idx is:'..tostring(idx))
	self.WidgetSwitcher_0:SetActiveWidgetIndex(idx)
	ugcprint('数量：'..tostring(self.WidgetSwitcher_0:GetChildrenCount()))
	ugcprint('当前索引：'..tostring(self.WidgetSwitcher_0:GetActiveWidgetIndex()))
	
end

return lobby