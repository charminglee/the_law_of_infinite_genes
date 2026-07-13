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

function GeneSkillNode:Data()
    return GeneManager.Config.SkillData[self.branchId][self.index + 1]
end

function GeneSkillNode:PreviousData()
	if self.index == 0 then
		return nil
	end
	return GeneManager.Config.SkillData[self.branchId][self.index]
end

function GeneSkillNode:NextData()
	if self.index + 2 > #GeneManager.Content:SelectedBranchDataList() then
		return nil
	end
	return GeneManager.Config.SkillData[self.branchId][self.index + 2]
end

function GeneSkillNode:CheckUnlockCondition()
	local pn = self:PreviousData();
	if pn == nil then return true end
	if pn.Lv < #pn.ConditionText - 1 then
		return false
	end
	return true
end

function GeneSkillNode:SetLocked(unlocked)
	self.LockImg:SetVisibility(unlocked and ESlateVisibility.Collapsed or ESlateVisibility.Visible);
	self.LockBg:SetVisibility(unlocked and ESlateVisibility.Collapsed or ESlateVisibility.Visible);
	self.LevelPanel:SetVisibility(unlocked and ESlateVisibility.HitTestInvisible or ESlateVisibility.Collapsed);
end

function GeneSkillNode:Refresh()
 	self:SetLocked(self:Data().Unlocked);
	self.Level:SetText(self:Data().Lv);
	self.Icon:SetBrushFromTexture(UGCObjectUtility.LoadObject(self:Data().IconPath));
	if self.index == #self.parent:DataList() - 1 then
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
		if self:Data().Unlocked then return end
		if self:CheckUnlockCondition() then
			self:Data().Unlocked = true;
			self:Refresh();
			if self.nodeId == GeneManager.Content.selectedTabID and not GeneManager.Content.aniState then
				GeneManager.InfoBar:SidebarBtnClicked();
			end
			tip = self.tips.UnlockedSuccessfully;
		else
			tip = self:PreviousData().SkillText .. self.tips.GeneMustBeHighestLevel;
		end
	else
		GeneManager.Content:SelectTab(self.branchId, self.nodeId);
		if self:Data().Unlocked then 
			if not GeneManager.Content.aniState then
				GeneManager.InfoBar:SidebarBtnClicked()
			end
			return
		end
		tip = self.tips.NeedToPressAndHold;
	end
	UGCWidgetManagerSystem.ShowTipsUI(tip);
end

return GeneSkillNode