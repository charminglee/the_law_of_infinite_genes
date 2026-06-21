---@class ACHVMain_C:UUserWidget
---@field ACHVLeftContent CHVLeftContent_C
---@field ACHVRightContent CHVRightContent_C
---@field Bg UImage
---@field BgInner UImage
---@field Exit UButton
--Edit Below--
local ACHVMain = { 
	bInitDoOnce = false,
} 

function ACHVMain:Construct()
	self:LuaInit();
end

function ACHVMain:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
    ACHVManager:RegisterMainUI(self);
    ACHVManager.CategoryListUI:Reload();
    ACHVManager.TitleListUI:Reload();
    self.Exit.OnClicked:Add(self.Close, self);
end

function ACHVMain:Open()
	self:SetVisibility(ESlateVisibility.Visible);
    self:SetVisibleAnim(true);
end

function ACHVMain:Close()
	UGCTimerUtility.CreateUETimer(
        function() self:SetVisibility(ESlateVisibility.Collapsed) end, 
        ACHVManager.Config.AnimDur.Out, 
        false
    )
    self:SetVisibleAnim(false);
end

function ACHVMain:SetVisibleAnim(isVisible)
    local startColor, endColor, dur
    if isVisible then
        startColor = KismetMathLibrary.MakeColor(1,1,1,0)
        endColor   = KismetMathLibrary.MakeColor(1,1,1,1)
		dur = ACHVManager.Config.AnimDur.In
    else
        startColor = KismetMathLibrary.MakeColor(1,1,1,1)
        endColor   = KismetMathLibrary.MakeColor(1,1,1,0)
		dur = ACHVManager.Config.AnimDur.Out
    end
    TweenManager.ColorAnim(
		function(value) self:SetColorAndOpacity(value) end,
        startColor, endColor, dur
    )
end

return ACHVMain