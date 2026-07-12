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
	tick = 0,
    parent = nil,
    index = 0,
	branchId = 0,
	nodeId = 0,
	pressAndHoldDelay = 1,
	tips = {
		UnlockedSuccessfully = '解锁成功',
		NeedToPressAndHold = '需长按1秒解锁技能',
		GeneMustBeHighestLevel = '基因需要进化至最高等级'
	}
} 

function GeneSkillNode:Construct()
	self:LuaInit();
end

function GeneSkillNode:Tick(MyGeometry, InDeltaTime)
	self.tick = self.tick + 1;
	self.delay = self.tick * InDeltaTime;
end

function GeneSkillNode:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	GeneManager.SkillNode = self;
	self.Frame.OnPressed:Add(self.FramePressed, self);
	self.Frame.OnClicked:Add(self.FrameClicked, self);
end

function GeneSkillNode:LoadNode()
    return self.parent:LoadBranch()[self.index + 1]
end

function GeneSkillNode:PreviousNode()
	if self.index == 0 then
		return nil
	end
	return GeneManager.Config.SkillData[self.branchId][self.index]
end

function GeneSkillNode:SelectedNode()
    return GeneManager.Config.SkillData[self.branchId][self.index + 1]
end

function GeneSkillNode:CheckUnlockCondition()
	local pn = self:PreviousNode();
	if pn == nil then return true end
	if pn.Lv < #pn.ConditionText - 1 then
		return false
	end
	return true
end

function GeneSkillNode:SetLocked(locked)
	self.LockImg:SetVisibility(locked and ESlateVisibility.Collapsed or ESlateVisibility.Visible);
	self.LockBg:SetVisibility(locked and ESlateVisibility.Collapsed or ESlateVisibility.Visible);
	self.LevelPanel:SetVisibility(locked and ESlateVisibility.Collapsed or ESlateVisibility.HitTestInvisible);
end

function GeneSkillNode:Refresh()
 	self:SetLocked(self:LoadNode().Unlocked);
	self.Level:SetText(self:LoadNode().Lv);
	self.Icon:SetBrushFromTexture(UGCObjectUtility.LoadObject(self:LoadNode().IconPath));
	if self.index == #self.parent:LoadBranch() - 1 then
		self.Arrow:SetVisibility(ESlateVisibility.Collapsed);
	end
end

function GeneSkillNode:Select()
    self.PressedFrame:SetVisibility(ESlateVisibility.HitTestInvisible);
    self.PressedImg:SetVisibility(ESlateVisibility.Visible);
end

function GeneSkillNode:Deselect()
	self.PressedFrame:SetVisibility(ESlateVisibility.Collapsed);
	self.PressedImg:SetVisibility(ESlateVisibility.Collapsed);
end

function GeneSkillNode:FramePressed()
	self.tick = 0;
	self.delay = 0;
end

function GeneSkillNode:FrameClicked()
	local tip;
	if self.delay >= self.pressAndHoldDelay then
		if self:SelectedNode().Unlocked then return end
		if self:CheckUnlockCondition() then
			self:SelectedNode().Unlocked = true;
			self.parent:Reload();
			tip = self.tips.UnlockedSuccessfully;
		else
			tip = self:PreviousNode().SkillText .. self.tips.GeneMustBeHighestLevel;
		end
	else
		self.parent:SelectTab(self.nodeId);
		if self:SelectedNode().Unlocked then return end
		tip = self.tips.NeedToPressAndHold;
	end
	UGCWidgetManagerSystem.ShowTipsUI(tip);
end

return GeneSkillNode