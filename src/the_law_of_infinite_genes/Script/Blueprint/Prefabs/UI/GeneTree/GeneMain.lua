---@class GeneMain_C:UAEUserWidget
---@field Bg UImage
---@field BgInner UImage
---@field Button_0 UButton
---@field Exit UButton
--Edit Below--
local GeneMain = { bInitDoOnce = false } 

function GeneMain:Construct()
	self:LuaInit();
end

function GeneMain:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
    GeneManager:RegisterMainUI(self);
    self.Exit.OnClicked:Add(self.Close, self);
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
    )
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
		function(value) self:SetColorAndOpacity(value) end,
        startColor, endColor, dur
    )
end

return GeneMain