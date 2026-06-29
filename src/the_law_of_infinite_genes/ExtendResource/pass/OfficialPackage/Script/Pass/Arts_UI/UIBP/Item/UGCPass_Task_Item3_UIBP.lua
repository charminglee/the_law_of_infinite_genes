---@class UGCPass_Task_Item3_UIBP_C:UUserWidget
---@field Button UNewButton
---@field Highlight UImage
---@field LockedWeekText UTextBlock
---@field ProgressText UTextBlock
---@field RedDot UImage
---@field Switcher UWidgetSwitcher
---@field UnLockedWeekText UTextBlock
---@field Normal FSlateColor
---@field Selected FSlateColor
--Edit Below--

local Delegate = require("common.Delegate")

local UGCPass_Task_Item3_UIBP = { 
    bInitDoOnce = false,
    OnWeekTabClicked = Delegate.New()
} 

function UGCPass_Task_Item3_UIBP:Construct()
	self.Button.OnClicked:Add(self.OnClick, self)
end

function UGCPass_Task_Item3_UIBP:Destruct()
    self.Button.OnClicked:Remove(self.OnClick, self)
end

function UGCPass_Task_Item3_UIBP:Refresh(Week, FinishedNum, MaxNum, bShowRedDot, bLocked)
    self.Week = Week

    self.UnLockedWeekText:SetText("第" .. Week .. "周")
    self.LockedWeekText:SetText("第" .. Week .. "周")

    self.ProgressText:SetText(string.format("(%d/%d)", FinishedNum, MaxNum))

    self.RedDot:SetVisibility(bShowRedDot and ESlateVisibility.HitTestInvisible or ESlateVisibility.Collapsed)

    self.Switcher:SetActiveWidgetIndex(bLocked and 1 or 0)
end

function UGCPass_Task_Item3_UIBP:OnClick()
    PassManager:SelectWeekTab(self.Week)
end

function UGCPass_Task_Item3_UIBP:Select()
    self.Highlight:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.UnLockedWeekText:SetColorRGBStr("311300")
    self.ProgressText:SetColorRGBStr("311300")
    self.LockedWeekText:SetColorRGBStr("311300")
end

function UGCPass_Task_Item3_UIBP:Deselect()
    self.Highlight:SetVisibility(ESlateVisibility.Collapsed)
    self.UnLockedWeekText:SetColorRGBStr("fffefd")
    self.LockedWeekText:SetColorRGBStr("fffefd")
    self.ProgressText:SetColorRGBStr("fffefd")
end

return UGCPass_Task_Item3_UIBP