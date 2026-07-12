---@class GeneInfoBar_C:UAEUserWidget
---@field Add UButton
---@field Highest UButton
---@field Info_0 UTextBlock
---@field Info_1 UTextBlock
---@field InfoPanel UCanvasPanel
---@field Lowest UButton
---@field Name UTextBlock
---@field PointText UTextBlock
---@field Reduce UButton
---@field SidebarBtn UButton
--Edit Below--
local GeneInfoBar = { bInitDoOnce = false } 

function GeneInfoBar:Construct()
	self:LuaInit();
end

function GeneInfoBar:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	GeneManager.InfoBar = self;
	self.point = 0
	self.SidebarBtn.OnClicked:Add(self.SidebarBtnClicked, self);
	self.Lowest.OnClicked:Add(self.LowestClicked, self);
	self.Reduce.OnClicked:Add(self.ReduceClicked, self);
	self.Add.OnClicked:Add(self.AddClicked, self);
	self.Highest.OnClicked:Add(self.HighestClicked, self);
end

function GeneInfoBar:Refresh()
	local selected = GeneManager.Content:SelectedTab():SelectedNode();
	self.Name:SetText(selected.SkillText);
	self.Info_0:SetText(selected.EffectText[selected.Lv + 1]);
	self.Info_1:SetText(selected.ConditionText[selected.Lv + 1]);
end

function GeneInfoBar:SidebarBtnClicked()
    GeneManager.Content:PlayAnim();
	self:Refresh();
end

function GeneInfoBar:LowestClicked()
	self.point = 1;
	self.PointText:SetText(self.point);
end

function GeneInfoBar:ReduceClicked()
	if self.point <= 1 then
		return
	end
	self.point = self.point - 1;
	self.PointText:SetText(self.point);
end

function GeneInfoBar:AddClicked()
	local selected = GeneManager.Content:SelectedTab():SelectedNode();
	if self.point >= #selected.ConditionText - selected.Lv then
		return
	end
	self.point = self.point + 1;
	self.PointText:SetText(self.point);
end

function GeneInfoBar:HighestClicked()
	local selected = GeneManager.Content:SelectedTab():SelectedNode();
	self.point = #selected.ConditionText - selected.Lv
	self.PointText:SetText(self.point);
end

return GeneInfoBar