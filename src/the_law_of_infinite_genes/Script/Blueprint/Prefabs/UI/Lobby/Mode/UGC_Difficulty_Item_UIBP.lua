---@class UGC_Difficulty_Item_UIBP_C:UUserWidget
---@field CanvasPanel_Select UCanvasPanel
---@field Image_Lock UImage
---@field NewButton_Select UButton
---@field NewButton_Tips UButton
---@field SizeBox_difficultyItem USizeBox
---@field TextBlock_Difficulty UTextBlock
---@field WidgetSwitcher_Mode UWidgetSwitcher
--Edit Below--
local UGC_Difficulty_Item_UIBP = {}

local SELECTED_COLOR = { SpecifiedColor = { R = 0.040915, G = 0.042311, B = 0.052861, A = 1.0 }, ColorUseRule = 0 }
local NORMAL_COLOR = { SpecifiedColor = { R = 1.0, G = 1.0, B = 1.0, A = 1.0 }, ColorUseRule = 0 }
local LOCKED_COLOR = { SpecifiedColor = { R = 1.0, G = 1.0, B = 1.0, A = 0.4 }, ColorUseRule = 0 }

---绑定难度条目的提示与选择按钮事件。
function UGC_Difficulty_Item_UIBP:Construct()
    self.NewButton_Tips.OnClicked:Add(self.OnTipsClicked, self)
    self.NewButton_Select.OnClicked:Add(self.OnSelectClicked, self)
end

---根据难度配置刷新文本、选中态、锁定态和尺寸样式。
---@param Data table
function UGC_Difficulty_Item_UIBP:OnUpdate(Data)
    self.Data = Data or {}
    local ModeConfig = self.Data.ModeConfig
    if not ModeConfig then
        return
    end

    self.TextBlock_Difficulty:SetText(ModeConfig.Difficulty or "")
    local FocusedConfig = LobbyModel:GetModeConfig(self.Data.FocusedMode)
    local bSelected = FocusedConfig and FocusedConfig.ModeID == ModeConfig.ModeID
    self.TextBlock_Difficulty:SetColorAndOpacity(bSelected and SELECTED_COLOR or (self.Data.bIsLocked and LOCKED_COLOR or NORMAL_COLOR))

    self.Image_Lock:SetVisibility(self.Data.bIsLocked and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    self.WidgetSwitcher_Mode:SetActiveWidgetIndex(self.Data.bIsLocked and 0 or 1)

    local bLarge = self.Data.bIsBig == true
    self.SizeBox_difficultyItem:SetWidthOverride(bLarge and 195 or 165)
    self.SizeBox_difficultyItem:SetHeightOverride(bLarge and 34 or 51)
    self.TextBlock_Difficulty.Font.Size = bLarge and 11 or 13
end

---在当前条目旁打开难度解锁条件提示。
function UGC_Difficulty_Item_UIBP:OnTipsClicked()
    if not self.Data or not self.Data.ModeConfig then
        return
    end
    LobbyUtils.OpenAndUpdateWidget(LobbyWidgetType.LWT_ModeDifficultyTip, {
        ModeConfig = self.Data.ModeConfig,
        ParentGeometry = self:GetCachedGeometry(),
        bIsLeft = self.Data.bTipsIsLeft,
    })
end

---选择当前难度对应的 ModeID；锁定时只显示提示。
function UGC_Difficulty_Item_UIBP:OnSelectClicked()
    if not self.Data or not self.Data.ModeConfig or self.Data.bIsLocked then
        if self.Data and self.Data.bIsLocked then
            UGCWidgetManagerSystem.ShowTipsUI("该难度尚未解锁")
        end
        return
    end
    if self.Data.OnModeFocusedCallback then
        self.Data.OnModeFocusedCallback(self.Data.ModeConfig.ModeID)
    else
        LobbyModel:SelectMode(self.Data.ModeConfig.ModeID)
    end
end

return UGC_Difficulty_Item_UIBP
