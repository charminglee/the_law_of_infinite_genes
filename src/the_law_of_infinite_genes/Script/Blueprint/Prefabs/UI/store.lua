---@class store_C:UUserWidget
---@field articleList ReuseList2_C
---@field bg_01 UImage
---@field bg_02 UImage
---@field dialog dialog_C
---@field equipmentSlot equipmentSlot_C
---@field forge forge_C
---@field Image_97 UImage
---@field LeftTabList ReuseList2_C
---@field storeTab storeTab_C
---@field storeTopBar storeTopBar_C
---@field WidgetSwitcher_0 UWidgetSwitcher
--Edit Below--
local store = { bInitDoOnce = false, LobbyUIControl=nil, selected=0, leftTabLabel={'物品','强化','合成'}} 


function store:Construct()
	self:LuaInit();
end

function store:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	self.storeTopBar.paternal = self
	self:ListenEvent();
	self:InitUI();
end

function store:ListenEvent()
	self.articleList.OnUpdateItem:Add(self.UpdateArticleList, self);
	self.LeftTabList.OnUpdateItem:Add(self.UpdateLeftTabList, self);
end

function store:UpdateArticleList(item, index)
	ugcprint('index is'..tostring(index))
	item.paternal = self;
	item.idx = index;
end

function store:UpdateEquipmentSlot(item, index)
end

function store:UpdateLeftTabList(item, index)
	if item.paternal == nil then
		item.paternal = self;
		item.idx = index;
	end
	if index == self.selected then
		item:switchSelected(ESlateVisibility.Visible, 20, 20, 10, -10);
	else
		item:switchSelected(ESlateVisibility.Collapsed, 10, 10, 5, -5);
	end
	item.TextBlock_0:SetText(self.leftTabLabel[index+1])

end

function store:changeSelected(idx)
	self.selected = idx;
	self.LeftTabList:Reload(6)
end

function store:InitUI()
	self.articleList:Reload(100);
	self.LeftTabList:Reload(#self.leftTabLabel)
end

function store:ReloadUI()

end

function store:changePanel(idx)
	self.WidgetSwitcher_0:SetActiveWidgetIndex(idx)
end
return store