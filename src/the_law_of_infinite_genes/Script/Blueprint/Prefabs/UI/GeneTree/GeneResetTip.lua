---@class GeneResetTip_C:UAEUserWidget
---@field Bg UImage
---@field No UButton
---@field Yes UButton
--Edit Below--
local GeneResetTip = { 
    bInitDoOnce = false,
    parent = nil 
} 

function GeneResetTip:Construct()
	self:LuaInit();
end

function GeneResetTip:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
    self.Yes.OnClicked:Add(self.YesClicked, self);
    self.No.OnClicked:Add(self.NoClicked, self);
end

function GeneResetTip:Open()
	self:SetVisibility(ESlateVisibility.Visible);
	self:SetVisibleAnim(true);
end

function GeneResetTip:Close()
    UGCTimerUtility.CreateUETimer(
        function() self:SetVisibility(ESlateVisibility.Collapsed) end, 
        GeneManager.Config.AnimDur.Out, 
        false
    );
    self:SetVisibleAnim(false);
end

function GeneResetTip:SetVisibleAnim(isVisible)
    local startScale, endScale, dur
    if isVisible then
        startScale = 0
        endScale   = 1
		dur = GeneManager.Config.AnimDur.Reset
    else
        startScale = 1
        endScale   = 0
		dur = GeneManager.Config.AnimDur.Reset
    end
    TweenManager.FloatAnim(
		function(Object, value) self:SetRenderScale(KismetMathLibrary.MakeVector2D(value, 1)) end,
        startScale, endScale, dur
    );
end

function GeneResetTip:YesClicked()
    self:Close();
    self.parent:Execute();
end

function GeneResetTip:NoClicked()
    self:Close();
end

return GeneResetTip