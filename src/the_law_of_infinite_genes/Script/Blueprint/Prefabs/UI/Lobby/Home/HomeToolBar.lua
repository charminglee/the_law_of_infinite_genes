---@class HomeToolBar_C:UUserWidget
---@field ReuseList2 ReuseList2_C
--Edit Below--
local HomeToolBar = { 
    bInitDoOnce = false, 
    parent=nil,  
    ToolBarButtonLabel = {'商城', '抽奖', '排行榜', '仓库', '组队'},
    selectIndex = 0,
    }

function HomeToolBar:Construct()
	self:LuaInit();
end

function HomeToolBar:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	self:Listen();
	self:RefreshHomeToolBar();
end

function HomeToolBar:Listen()
	self.ReuseList2.OnUpdateItem:Add(self.HomeToolBarUpdate, self);
end

function HomeToolBar:RefreshHomeToolBar()
	self.ReuseList2:Reload(#self.ToolBarButtonLabel);
end

function HomeToolBar:HomeToolBarUpdate(Item, Index)
	if Item.Parent == nil then
		Item.Parent = self;
		Item.Index = Index;
	end
	Item:SetText(self.ToolBarButtonLabel[Index+1]);
end


return HomeToolBar