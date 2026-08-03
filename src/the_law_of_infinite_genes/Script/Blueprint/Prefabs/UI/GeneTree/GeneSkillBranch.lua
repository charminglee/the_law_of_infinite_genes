---@class GeneSkillBranch_C:UAEUserWidget
---@field Name UTextBlock
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

function GeneSkillBranch:DataList()
    return GeneTreeCfg.SkillData[self.index]
end

function GeneSkillBranch:Reload()
	self.ReuseList2:Reload(#self:DataList());
end

function GeneSkillBranch:Refresh()
    self.Name:SetText(GeneTreeCfg.BranchText[self.index])
end

function GeneSkillBranch:ReuseList2Update(item, index)
	if item.parent == nil then
		item.parent = self;
	end
    item.index = index;
    item.branchId = self.index;
    item.nodeId = item:Data().Id;
	self.parent.tabButtons[item.nodeId] = item;
	if item.nodeId == self.parent.selectedTabID then
        item:Select();
    else
        item:Deselect();
    end
	item:Refresh();
end

return GeneSkillBranch