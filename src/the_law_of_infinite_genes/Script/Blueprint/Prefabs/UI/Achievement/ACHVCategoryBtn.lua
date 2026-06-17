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
	animDur = {
		select = 0.2,
		deselect = 0.2
	}
} 


function ACHVCategoryBtn:Construct()
	self:LuaInit();
end


-- function ACHVCategoryBtn:Tick(MyGeometry, InDeltaTime)

-- end

-- function ACHVCategoryBtn:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
function ACHVCategoryBtn:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	self.Btn.OnClicked:Add(self.OnButtonClicked, self);
end

function ACHVCategoryBtn:Refresh()
    self.Name:SetText(self.parent.nameLabel[self.index + 1]);
end

function ACHVCategoryBtn:Select()
    self.PressedImg:SetVisibility(ESlateVisibility.Visible);
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
		dur = self.animDur.select
    else
        startVec = KismetMathLibrary.MakeVector2D(1, 1)
        endVec   = KismetMathLibrary.MakeVector2D(0, 1)
		dur = self.animDur.deselect
    end
    TweenManager.VectorAnim(
		function(value) self.AnimImg:SetRenderScale(KismetMathLibrary.MakeVector2D(value.x, value.y)) end,
        startVec, endVec, dur
    )
end

function ACHVCategoryBtn:OnButtonClicked()
    self.parent:SelectTab(self.index);
end

return ACHVCategoryBtn