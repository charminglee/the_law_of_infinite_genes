---@class ACHVCategoryList_C:UUserWidget
---@field ReuseList2 ReuseList2_C
--Edit Below--
local ACHVCategoryList = {
	bInitDoOnce = false,
	tabButtons = {},
	selectedTabID = 0,
} 

function ACHVCategoryList:Construct()
	self:LuaInit();
end

function ACHVCategoryList:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	ACHVManager.CategoryListUI = self;
	self.ReuseList2.OnUpdateItem:Add(self.ReuseList2Update, self);
end

function ACHVCategoryList:Reload()
	self.ReuseList2:Reload(#ACHVManager.Config.CategoryNameLabel);
end


function ACHVCategoryList:ReuseList2Update(item, index)
	if item.parent == nil then
		item.parent = self;
	end
	item.index = index;
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
	ACHVManager.TitleListUI:Reload();
end

return ACHVCategoryList