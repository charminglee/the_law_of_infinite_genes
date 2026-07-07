---@class GeneSkillBranch_C:UAEUserWidget
---@field ReuseList2 ReuseList2_C
--Edit Below--
local GeneSkillBranch = { 
    bInitDoOnce = false,
    parent = nil,
    index = 0,
    tabButtons = {},
	selectedTabID = 0,
} 

function GeneSkillBranch:Construct()
	self:LuaInit();
end

function GeneSkillBranch:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
    GeneManager.SkillBranch = self;
    self.ReuseList2.OnUpdateItem:Add(self.ReuseList2Update, self);
end

function GeneSkillBranch:Reload()
	self.ReuseList2:Reload(3);
end

function GeneSkillBranch:Refresh()
    
end

function GeneSkillBranch:ReuseList2Update(item, index)
	if item.parent == nil then
		item.parent = self;
	end
	item.index = index;
	self.tabButtons[index] = item;
	if index == self.selectedTabID then
        item:Select();
    else
        item:Deselect();
    end
	item:Refresh();
end

function GeneSkillBranch:SelectTab(index)
    if index == self.selectedTabID then
        return;
    end
    self.tabButtons[index]:Select();
    self.tabButtons[self.selectedTabID]:Deselect();
    self.selectedTabID = index;
	self:Reload();
end

return GeneSkillBranch