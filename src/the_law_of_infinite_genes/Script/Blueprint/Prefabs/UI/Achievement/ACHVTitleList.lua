---@class ACHVTitleList_C:UUserWidget
---@field ReuseList2 ReuseList2_C
--Edit Below--
local ACHVTitleList = { 
	bInitDoOnce = false,
	tabButtons = {},
	selectedTabID = 0,
} 

function ACHVTitleList:Construct()
    self:LuaInit();
end

function ACHVTitleList:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	ACHVManager.TitleListUI = self;
    self.ReuseList2.OnUpdateItem:Add(self.ReuseList2Update, self);
end

function ACHVTitleList:Reload()
	self.ReuseList2:Reload(#ACHVManager.Config.TitleNameLabel[ACHVManager.CategoryListUI.selectedTabID + 1]);
end

function ACHVTitleList:ReuseList2Update(item, index)
	if item.parent == nil then
		item.parent = self;
	end
	item.index = index;
	if index == self.selectedTabID then
        item:Select();
		ACHVManager.Preview:Refresh();
		ACHVManager.RightContent:Refresh();
    else
        item:Deselect();
    end
	self.tabButtons[index] = item;
	item:Refresh();
end


function ACHVTitleList:SelectTab(index)
    if index == self.selectedTabID then
        return;
    end
    self.tabButtons[index]:Select();
    self.tabButtons[self.selectedTabID]:Deselect();
    self.selectedTabID = index;
	ACHVManager.Preview:Refresh();
	ACHVManager.RightContent:Refresh();
end

return ACHVTitleList