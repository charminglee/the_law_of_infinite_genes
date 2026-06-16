---@class ACHVTitleList_C:UUserWidget
---@field ReuseList2 ReuseList2_C
--Edit Below--
local ACHVTitleList = { 
	bInitDoOnce = false,
	tabButtons = {},
	selectedTabID = 0,
	nameLabel = {'囊中羞涩', '略有盈余', '小富即安', '盆满钵满', '腰缠万贯', '富甲一方'},
} 

function ACHVTitleList:Construct()
    self:LuaInit();
end

function ACHVTitleList:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
    self.ReuseList2.OnUpdateItem:Add(self.ReuseList2Update, self);
	self.ReuseList2:Reload(#self.nameLabel);
end

-- function ACHVTitleList:Tick(MyGeometry, InDeltaTime)

-- end

-- function ACHVTitleList:Destruct()

-- end

function ACHVTitleList:ReuseList2Update(item, index)
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


function ACHVTitleList:SelectTab(index)
    if index == self.selectedTabID then
        return;
    end
    self.tabButtons[index]:Select();
    self.tabButtons[self.selectedTabID]:Deselect();
    self.selectedTabID = index;
end

return ACHVTitleList