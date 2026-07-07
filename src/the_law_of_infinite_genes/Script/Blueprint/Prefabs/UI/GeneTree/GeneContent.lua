---@class GeneContent_C:UAEUserWidget
---@field ExpandableArea_0 UExpandableArea
---@field GeneInfoBar GeneInfoBar_C
---@field ReuseList2 ReuseList2_C
--Edit Below--
local GeneContent = { 
    bInitDoOnce = false,
    tabButtons = {}
} 

function GeneContent:Construct()
	self:LuaInit();
end

function GeneContent:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
    GeneManager.Content = self;
    self.ReuseList2.OnUpdateItem:Add(self.ReuseList2Update, self);
end

function GeneContent:Reload()
	self.ReuseList2:Reload(5);
end

function GeneContent:ReuseList2Update(item, index)
	if item.parent == nil then
		item.parent = self;
	end
	item.index = index;
	self.tabButtons[index] = item;
    GeneManager.SkillBranch:Reload();
	item:Refresh();
end

return GeneContent