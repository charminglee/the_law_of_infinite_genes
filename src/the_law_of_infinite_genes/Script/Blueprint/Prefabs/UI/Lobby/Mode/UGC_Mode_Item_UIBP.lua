---@class UGC_Mode_Item_UIBP_C:UUserWidget
---@field CanvasPanel_Selected UCanvasPanel
---@field ImageEx_GameMode UImage
---@field NewButton_Select UButton
---@field ScrollBox_ModeIntro UScrollBox
---@field TextBlock_ModeIntro UTextBlock
---@field TextBlock_ModeName UTextBlock
--Edit Below--
local UGC_Mode_Item_UIBP = {}

---绑定模式条目的点击事件。
function UGC_Mode_Item_UIBP:Construct()
    self.NewButton_Select.OnClicked:Add(self.OnSelectClicked, self)
end

---刷新模式名称、简介、图片以及焦点选中框。
---@param Data table
function UGC_Mode_Item_UIBP:OnUpdate(Data)
    self.Data = Data or {}
    local ModeConfig = self.Data.ModeConfig
    if not ModeConfig then
        self.CanvasPanel_Selected:SetVisibility(ESlateVisibility.Collapsed)
        return
    end

    self.TextBlock_ModeName:SetText(LobbyUtils.GetTrimmedString(ModeConfig.ModeName, 6))
    self.TextBlock_ModeIntro:SetText(LobbyUtils.GetTrimmedString(ModeConfig.ModeDesc, 12))
    self.ImageEx_GameMode:SetBrushFromTexture(ModeConfig.ModePost)

    local FocusedConfig = LobbyModel:GetModeConfig(self.Data.FocusedMode)
    local bSelected = FocusedConfig and FocusedConfig.DetailID == ModeConfig.DetailID
    self.CanvasPanel_Selected:SetVisibility(bSelected and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
end

---校验队伍人数后，把当前模式设置为模式选择页焦点。
function UGC_Mode_Item_UIBP:OnSelectClicked()
    if not self.Data or not self.Data.ModeID then
        return
    end

    local ModeSetting = UGCMultiMode.GetModeSetting(self.Data.ModeID)
    local PC = UGCGameSystem.GetLocalPlayerController()
    if not ModeSetting or not PC then
        return
    end
    local MaxPlayers = tonumber(ModeSetting.TeamPlayers) or 0
    if MaxPlayers <= 0 or #(PC.LobbyTeammatePlayerKeys or {}) > MaxPlayers then
        UGCWidgetManagerSystem.ShowTipsUI("当前人数大于模式最大人数")
        return
    end
    if self.Data.OnModeFocusedCallback then
        self.Data.OnModeFocusedCallback(self.Data.ModeID)
    end
end

return UGC_Mode_Item_UIBP
