---@class UGCPass_Task_Item1_UIBP_C:UUserWidget
---@field Button UNewButton
---@field Highlight UImage
---@field RedDot UImage
---@field SelectedGroupNameText UTextBlock
---@field SelectedProgressText UTextBlock
---@field Switcher UWidgetSwitcher
---@field UnSelectedGroupNameText UTextBlock
---@field UnSelectedProgressText UTextBlock
--Edit Below--
local UGCPass_Task_Item1_UIBP = { bInitDoOnce = false } 

function UGCPass_Task_Item1_UIBP:Construct()
	
end

function UGCPass_Task_Item1_UIBP:Destruct()

end

function UGCPass_Task_Item1_UIBP:Init(TabName)
    self.UnSelectedGroupNameText:SetText(TabName)
    self.SelectedGroupNameText:SetText(TabName)

end

function UGCPass_Task_Item1_UIBP:RefreshProgress(FinishedNum, MaxNum, bShowRedDot)
    self.UnSelectedProgressText:SetText(string.format("(%d/%d)", FinishedNum, MaxNum))
    self.SelectedProgressText:SetText(string.format("(%d/%d)", FinishedNum, MaxNum))

    self.RedDot:SetVisibility(bShowRedDot and ESlateVisibility.HitTestInvisible or ESlateVisibility.Collapsed)
end

function UGCPass_Task_Item1_UIBP:Select()
    self.Switcher:SetActiveWidgetIndex(0)
    self.Highlight:SetVisibility(ESlateVisibility.HitTestInvisible)
end

function UGCPass_Task_Item1_UIBP:Deselect()
    self.Switcher:SetActiveWidgetIndex(1)
    self.Highlight:SetVisibility(ESlateVisibility.Collapsed)
end

return UGCPass_Task_Item1_UIBP