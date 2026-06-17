---@class ACHVCategoryList_C:UUserWidget
---@field ReuseList2 ReuseList2_C
--Edit Below--
local ACHVCategoryList = {
	bInitDoOnce = false,
	tabButtons = {},
	selectedTabID = 0,
    nameLabel = {'财富称号', '充值称号', '赛季称号'},
} 

function ACHVCategoryList:Construct()
	self:LuaInit();
end

function ACHVCategoryList:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	self.ReuseList2.OnUpdateItem:Add(self.ReuseList2Update, self);
	self.ReuseList2:Reload(#self.nameLabel);
end

-- function ACHVCategoryList:Tick(MyGeometry, InDeltaTime)

-- end

-- function ACHVCategoryList:Destruct()

-- end

function ACHVCategoryList:ReuseList2Update(item, index)
	if item.parent == nil then
		item.parent = self;
		item.index = index;
	end
	if index == self.selectedTabID then
        item:Select();
    else
        item:Deselect();
    end
	self.tabButtons[index] = item;
	item:Refresh();
end

function ACHVCategoryList:SelectTab(index)
    if index == self.selectedTabID then
        return;
    end
    self.tabButtons[index]:Select();
    self.tabButtons[self.selectedTabID]:Deselect();
    self.selectedTabID = index;
end

return ACHVCategoryList