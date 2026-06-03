---@class HomeMain_C:UserWidgetLayout
---@field HomeToolBar ReuseList2_C
--Edit Below--
local HomeMain = {
	bInitDoOnce = false,
	ToolBarButtonLabel = {'商城', '抽奖', '排行榜', '仓库', '组队'},
	selectIndex = 0,
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
	self:Listen();
	self:RefreshHomeToolBar();
	HomeManager:RegisterMainUI(self);
end

function HomeMain:Listen()
	self.HomeToolBar.OnUpdateItem:Add(self.HomeToolBarUpdate, self);
end

function HomeMain:RefreshHomeToolBar()
	ugcprint('Refresh button :'..tostring(#self.ToolBarButtonLabel));
	self.HomeToolBar:Reload(#self.ToolBarButtonLabel);
end

function HomeMain:HomeToolBarUpdate(Item, Index)
	if Item.Parent == nil then
		Item.Parent = self;
		Item.Index = Index;
	end
	ugcprint('label is :'..tostring(self.ToolBarButtonLabel[Index+1]));
	Item:SetText(self.ToolBarButtonLabel[Index+1]);
end

return HomeMain