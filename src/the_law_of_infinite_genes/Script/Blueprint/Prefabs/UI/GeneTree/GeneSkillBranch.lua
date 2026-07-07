---@class GeneSkillBranch_C:UAEUserWidget
---@field ReuseList2 ReuseList2_C
--Edit Below--
local GeneSkillBranch = { 
    bInitDoOnce = false,
    parent = nil,
    index = 0
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
    local tabIndex = 3 * self.index + index;
	item.index = tabIndex;
	self.parent.tabButtons[tabIndex] = item;
	if tabIndex == self.parent.selectedTabID then
        item:Select();
    else
        item:Deselect();
    end
	item:Refresh();
end

function GeneSkillBranch:SelectTab(index)
    if index == self.parent.selectedTabID then
        return;
    end
    self.parent.tabButtons[index]:Select();
    self.parent.tabButtons[self.parent.selectedTabID]:Deselect();
    self.parent.selectedTabID = index;
	self:Reload();
end

return GeneSkillBranch