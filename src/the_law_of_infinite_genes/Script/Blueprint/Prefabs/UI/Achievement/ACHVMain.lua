---@class ACHVMain_C:UUserWidget
---@field ACHVLeftContent CHVLeftContent_C
---@field ACHVRightContent CHVRightContent_C
---@field Bg UImage
---@field BgInner UImage
---@field BlurredBg UImage
--Edit Below--
local ACHVMain = { 
	bInitDoOnce = false,
	animDur = {
		openUI = 0.2,
		closeUI = 0.2
	}
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
end

-- function ACHVMain:Tick(MyGeometry, InDeltaTime)

-- end

-- function ACHVMain:Destruct()

-- end

function ACHVMain:Open()
	self:SetVisibility(ESlateVisibility.Visible);
    self:SetVisibleAnim(true);
end

function ACHVMain:Close()
	UGCTimerUtility.CreateUETimer(
        function() self:SetVisibility(ESlateVisibility.Collapsed) end, 
        self.animDur.closeUI, 
        false
    )
    self:SetVisibleAnim(false);
end

function ACHVMain:SetVisibleAnim(isVisible)
    local startColor, endColor, dur
    if isVisible then
        startColor = KismetMathLibrary.MakeColor(1,1,1,0)
        endColor   = KismetMathLibrary.MakeColor(1,1,1,1)
		dur = self.animDur.openUI
    else
        startColor = KismetMathLibrary.MakeColor(1,1,1,1)
        endColor   = KismetMathLibrary.MakeColor(1,1,1,0)
		dur = self.animDur.closeUI
    end
    TweenManager.ColorAnim(
		function(value) self:SetColorAndOpacity(value) end,
        startColor, endColor, dur
    )
end

return ACHVMain