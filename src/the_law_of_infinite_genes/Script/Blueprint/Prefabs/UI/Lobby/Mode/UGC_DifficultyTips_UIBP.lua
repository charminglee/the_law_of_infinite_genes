---@class UGC_DifficultyTips_UIBP_C:UUserWidget
---@field Button_Close UButton
---@field CanvasPanel_DifficultTips UCanvasPanel
---@field ScrollBox_Conditions UScrollBox
---@field TextBlock_Conditions UTextBlock
---@field TextBlock_Difficult UTextBlock
--Edit Below--
local UGC_DifficultyTips_UIBP = {}

---绑定提示面板关闭按钮。
function UGC_DifficultyTips_UIBP:Construct()
    self.Button_Close.OnClicked:Add(self.OnCloseClicked, self)
end

---销毁时解除按钮监听，避免残留 Widget 引用。
function UGC_DifficultyTips_UIBP:Destruct()
    self.Button_Close.OnClicked:Remove(self.OnCloseClicked, self)
end

---刷新模式名称、解锁条件以及提示面板位置。
---@param Data table
function UGC_DifficultyTips_UIBP:OnUpdate(Data)
    self.Data = Data or {}
    local ModeConfig = self.Data.ModeConfig
    if not ModeConfig then
        return
    end
    self.TextBlock_Difficult:SetText(ModeConfig.ModeName or "")
    self.TextBlock_Conditions:SetText(ModeConfig.UnlockDesc or "")
    self:UpdatePosition()
end

---根据父条目几何信息，把提示面板放置在其左侧或右侧。
function UGC_DifficultyTips_UIBP:UpdatePosition()
    if not self.Data or not self.Data.ParentGeometry then
        return
    end

    local ParentGeometry = self.Data.ParentGeometry
    local ViewportGeometry = WidgetLayoutLibrary.GetViewportWidgetGeometry(self)
    if not ViewportGeometry then
        return
    end

    local ParentSize = SlateBlueprintLibrary.GetLocalSize(ParentGeometry)
    local AbsolutePosition = UGCWidgetManagerSystem.GetAbsolutePosition(ParentGeometry)
    local Pos = UGCWidgetManagerSystem.AbsoluteToLocal(ViewportGeometry, AbsolutePosition)
    local ViewportScale = UGCWidgetManagerSystem.GetViewportScale(self)
    local TipWidth = 227.0
    local MinPadding = 8

    if self.Data.bIsLeft then
        Pos.X = Pos.X - TipWidth * ViewportScale - MinPadding
    else
        Pos.X = Pos.X + ParentSize.X * ViewportScale + MinPadding
    end
    self.CanvasPanel_DifficultTips.Slot:SetPosition(Pos)
end

---关闭当前难度提示面板。
function UGC_DifficultyTips_UIBP:OnCloseClicked()
    LobbyUtils.CloseWidget(LobbyWidgetType.LWT_ModeDifficultyTip)
end

return UGC_DifficultyTips_UIBP
