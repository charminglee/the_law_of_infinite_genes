---@class GeneSkillNode_C:UAEUserWidget
---@field Arrow UImage
---@field Frame UButton
---@field Icon UImage
---@field Level UTextBlock
---@field LevelPanel UCanvasPanel
---@field LockBg UImage
---@field LockImg UImage
---@field PressedFrame UImage
---@field PressedImg UImage
--Edit Below--
local GeneSkillNode = { 
    bInitDoOnce = false,
    parent = nil,
    index = 0,
	branchId = 0,
	nodeId = 0
} 

function GeneSkillNode:Construct()
	self:LuaInit();
end

function GeneSkillNode:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	GeneManager.SkillNode = self;
	self.Frame.OnClicked:Add(self.FrameClicked, self);
end

function GeneSkillNode:LoadNode()
    return self.parent:LoadBranch()[self.index + 1]
end

function GeneSkillNode:SelectedNode()
    return GeneManager.Config.SkillData[self.branchId][self.index + 1]
end

function GeneSkillNode:SetLocked(locked)
	self.LockImg:SetVisibility(locked and ESlateVisibility.Collapsed or ESlateVisibility.Visible);
	self.LockBg:SetVisibility(locked and ESlateVisibility.Collapsed or ESlateVisibility.Visible);
	self.LevelPanel:SetVisibility(locked and ESlateVisibility.Collapsed or ESlateVisibility.Visible);
end

function GeneSkillNode:Refresh()
 	self:SetLocked(self:LoadNode().Unlocked);
	self.Level:SetText(self:LoadNode().Lv);
	self.Icon:SetBrushFromTexture(UGCObjectUtility.LoadObject(self:LoadNode().IconPath));
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
    self.parent:SelectTab(self.nodeId);
end

return GeneSkillNode