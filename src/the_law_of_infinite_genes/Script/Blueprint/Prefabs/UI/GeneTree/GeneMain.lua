---@class GeneMain_C:UAEUserWidget
---@field Degrade UButton
---@field Exit UButton
---@field ExitBtn UButton
---@field GeneContent GeneContent_C
---@field GeneReset GeneReset_C
---@field Upgrade UButton
--Edit Below--
local GeneMain = { 
    bInitDoOnce = false,
	tips = {
		NeedToUnlock = '需要先解锁基因'
	}
} 

function GeneMain:Construct()
	self:LuaInit();
end

function GeneMain:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
    GeneManager:RegisterMainUI(self);
    GeneManager.Content:Reload();
    self.Exit.OnClicked:Add(self.Close, self);
    self.ExitBtn.OnClicked:Add(self.Close, self);
    self.Degrade.OnClicked:Add(self.DegradeClicked, self);
    self.Upgrade.OnClicked:Add(self.UpgradeClicked, self);
end

function GeneMain:Open()
	self:SetVisibility(ESlateVisibility.Visible);
	self:SetVisibleAnim(true);
end

function GeneMain:Close()
    UGCTimerUtility.CreateUETimer(
        function() self:SetVisibility(ESlateVisibility.Collapsed) end, 
        GeneManager.Config.AnimDur.Out, 
        false
    );
    self:SetVisibleAnim(false);
end

function GeneMain:SetVisibleAnim(isVisible)
    local startColor, endColor, dur
    if isVisible then
        startColor = KismetMathLibrary.MakeColor(1,1,1,0)
        endColor   = KismetMathLibrary.MakeColor(1,1,1,1)
		dur = GeneManager.Config.AnimDur.In
    else
        startColor = KismetMathLibrary.MakeColor(1,1,1,1)
        endColor   = KismetMathLibrary.MakeColor(1,1,1,0)
		dur = GeneManager.Config.AnimDur.Out
    end
    TweenManager.ColorAnim(
		function(Object, value) self:SetColorAndOpacity(value) end,
        startColor, endColor, dur
    );
end

function GeneMain:DegradeClicked()
    if not GeneManager.Content:SelectedTab():SelectedNode().Unlocked then
        UGCWidgetManagerSystem.ShowTipsUI(self.tips.NeedToUnlock)
    end
end

function GeneMain:UpgradeClicked()
    if not GeneManager.Content:SelectedTab():SelectedNode().Unlocked then
        UGCWidgetManagerSystem.ShowTipsUI(self.tips.NeedToUnlock)
    end
end

return GeneMain