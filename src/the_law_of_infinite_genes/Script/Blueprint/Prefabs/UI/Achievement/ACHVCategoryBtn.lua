---@class ACHVCategoryBtn_C:UUserWidget
---@field AnimImg UImage
---@field Btn UButton
---@field Name UTextBlock
---@field PressedImg UImage
--Edit Below--
local ACHVCategoryBtn = { 
	bInitDoOnce = false,
    parent = nil,
    index = 0,
} 

function ACHVCategoryBtn:Construct()
	self:LuaInit();
end

function ACHVCategoryBtn:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	self.Btn.OnClicked:Add(self.OnButtonClicked, self);
end

function ACHVCategoryBtn:Refresh()
    self.Name:SetText(ACHVManager.Config.CategoryNameLabel[self.index]);
end

function ACHVCategoryBtn:Select()
    self.PressedImg:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
	self:SelectAnim(true);
end

function ACHVCategoryBtn:Deselect()
	self.PressedImg:SetVisibility(ESlateVisibility.Collapsed);
	self:SelectAnim(false);
end

function ACHVCategoryBtn:SelectAnim(isVisible)
    local startVec, endVec, dur
    if isVisible then
        startVec = KismetMathLibrary.MakeVector2D(0, 1)
        endVec   = KismetMathLibrary.MakeVector2D(1, 1)
		dur = ACHVManager.Config.AnimDur.In
    else
        startVec = KismetMathLibrary.MakeVector2D(1, 1)
        endVec   = KismetMathLibrary.MakeVector2D(0, 1)
		dur = ACHVManager.Config.AnimDur.Out
    end
    TweenManager.VectorAnim(
		function(Object, value) self.AnimImg:SetRenderScale(KismetMathLibrary.MakeVector2D(value.x, value.y)) end,
        startVec, endVec, dur
    )
end

function ACHVCategoryBtn:OnButtonClicked()
    self.parent:SelectTab(self.index);
end

return ACHVCategoryBtn