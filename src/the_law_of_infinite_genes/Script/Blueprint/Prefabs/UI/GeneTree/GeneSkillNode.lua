---@class GeneSkillNode_C:UAEUserWidget
---@field Arrow UImage
---@field Frame UButton
---@field Icon UImage
---@field LockBg UImage
---@field LockImg UImage
---@field PressedFrame UImage
---@field PressedImg UImage
--Edit Below--
local GeneSkillNode = { 
    bInitDoOnce = false,
    parent = nil,
    index = 0
} 

function GeneSkillNode:Construct()
	self:LuaInit();
end

function GeneSkillNode:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	self.Frame.OnClicked:Add(self.FrameClicked, self);
end

function GeneSkillNode:Refresh()
	if self.index % 3 == 2 then
		self.Arrow:SetVisibility(ESlateVisibility.Collapsed);
	end
end

function GeneSkillNode:Select()
    self.PressedFrame:SetVisibility(ESlateVisibility.Visible);
    self.PressedImg:SetVisibility(ESlateVisibility.Visible);
end

function GeneSkillNode:Deselect()
	self.PressedFrame:SetVisibility(ESlateVisibility.Collapsed);
	self.PressedImg:SetVisibility(ESlateVisibility.Collapsed);
end

function GeneSkillNode:FrameClicked()
    self.parent:SelectTab(self.index);
end

return GeneSkillNode