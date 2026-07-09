---@class GeneInfoBar_C:UAEUserWidget
---@field Add UButton
---@field Highest UButton
---@field Info_0 UTextBlock
---@field Info_1 UTextBlock
---@field InfoPanel UCanvasPanel
---@field Lowest UButton
---@field Name UTextBlock
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
	self.SidebarBtn.OnClicked:Add(self.SidebarBtnClicked, self);
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

return GeneInfoBar