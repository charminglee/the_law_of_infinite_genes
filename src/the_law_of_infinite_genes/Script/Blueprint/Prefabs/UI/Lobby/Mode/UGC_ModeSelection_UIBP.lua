---@class UGC_ModeSelection_UIBP_C:UUserWidget
---@field Button_Confirm UButton
---@field Button_DifficultySelect UButton
---@field CanvasPanel_Difficulty UCanvasPanel
---@field CanvasPanel_SelectDifficulty UCanvasPanel
---@field ModeItem UGC_ReuseList2_C
---@field NewButton_Close UButton
---@field TextBlock_Difficult UTextBlock
---@field UGC_ReuseList2_Difficulty UGC_ReuseList2_C
---@field WidgetSwitcher_Arrow UWidgetSwitcher
--Edit Below--
local UGC_ModeSelection_UIBP = {}

---把局部更新合并到页面视图快照中。
---@param Target table
---@param Source table|nil
---@return table
local function Merge(Target, Source)
    for Key, Value in pairs(Source or {}) do
        Target[Key] = Value
    end
    return Target
end

---初始化页面视图状态并绑定按钮、复用列表事件。
function UGC_ModeSelection_UIBP:Construct()
    self.ViewData = {}
    self.NewButton_Close.OnClicked:Add(self.OnCloseClicked, self)
    self.Button_Confirm.OnClicked:Add(self.OnChooseClicked, self)
    self.Button_DifficultySelect.OnClicked:Add(self.OnDifficultySelectClicked, self)
    self.ModeItem.OnAfterNewItem:Add(self.OnModeItemReload, self)
    self.UGC_ReuseList2_Difficulty.OnAfterNewItem:Add(self.OnDifficultyItemReload, self)
end

---打开页面时以当前已选模式初始化焦点。
---@param Data table|nil
function UGC_ModeSelection_UIBP:OnOpen(Data)
    self.ViewData = {
        FocusedMode = LobbyModel:GetCurrentSelectedModeID(),
    }
    Merge(self.ViewData, Data)
    self:ToggleDifficulty(false)
end

---关闭页面时同步关闭附属难度提示。
function UGC_ModeSelection_UIBP:OnClose()
    LobbyUtils.CloseWidget(LobbyWidgetType.LWT_ModeDifficultyTip)
end

---合并页面数据并刷新模式列表和难度列表。
---@param Data table|nil
function UGC_ModeSelection_UIBP:OnUpdate(Data)
    self.ViewData = Merge(self.ViewData or {}, Data)
    if not LobbyModel:GetModeConfig(self.ViewData.FocusedMode) then
        self.ViewData.FocusedMode = LobbyModel:GetCurrentSelectedModeID()
    end
    self:UpdateModeList()
    self:UpdateDifficultyList()
end

---重新获取所有可展示模式并刷新复用列表。
function UGC_ModeSelection_UIBP:UpdateModeList()
    self.DisplayModeIDs = LobbyModel:GetAllDisplayModeID()
    self.ModeItem:Reload(#self.DisplayModeIDs)
end

---兼容旧调用的模式列表刷新入口。
function UGC_ModeSelection_UIBP:UpdateMode()
    self:UpdateModeList()
end

---刷新焦点模式对应的全部难度配置。
function UGC_ModeSelection_UIBP:UpdateDifficultyList()
    local FocusedConfig = LobbyModel:GetModeConfig(self.ViewData.FocusedMode)
    if not FocusedConfig then
        self.DifficultyConfigs = {}
        self.UGC_ReuseList2_Difficulty:Reload(0)
        return
    end

    self.TextBlock_Difficult:SetText(FocusedConfig.Difficulty or "")
    self.DifficultyConfigs = LobbyModel:GetModeListWithSameDetailID(FocusedConfig.ModeID)
    self.UGC_ReuseList2_Difficulty:Reload(#self.DifficultyConfigs)
end

---兼容旧调用的难度列表刷新入口。
function UGC_ModeSelection_UIBP:UpdateDifficulty()
    self:UpdateDifficultyList()
end

---关闭模式选择页并返回大厅主页。
function UGC_ModeSelection_UIBP:OnCloseClicked()
    LobbyFlow:Go(LobbyFlowState.LFS_Lobby)
end

---确认焦点模式；校验解锁状态后写入大厅模型。
function UGC_ModeSelection_UIBP:OnChooseClicked()
    local FocusedMode = self.ViewData and self.ViewData.FocusedMode
    if not FocusedMode then
        UGCWidgetManagerSystem.ShowTipsUI("请选择模式")
        return
    end
    if LobbyModel:IsModeLocked(FocusedMode) then
        UGCWidgetManagerSystem.ShowTipsUI("该模式尚未解锁")
        return
    end
    if LobbyModel:SelectMode(FocusedMode) then
        LobbyFlow:Go(LobbyFlowState.LFS_Lobby)
    end
end

---为复用列表中的模式条目组装展示数据和焦点回调。
---@param Widget UGC_Mode_Item_UIBP_C
---@param ZeroBasedIndex number
function UGC_ModeSelection_UIBP:OnModeItemReload(Widget, ZeroBasedIndex)
    local Index = ZeroBasedIndex + 1
    local ModeID = self.DisplayModeIDs and self.DisplayModeIDs[Index]
    local ModeConfig = LobbyModel:GetModeConfig(ModeID)
    if not ModeConfig then
        return
    end
    Widget:OnUpdate({
        Idx = Index,
        ModeID = ModeID,
        ModeConfig = ModeConfig,
        FocusedMode = self.ViewData.FocusedMode,
        OnModeFocusedCallback = function(NewModeID)
            self:OnModeFocused(NewModeID)
        end,
    })
end

---为复用列表中的难度条目组装展示数据和锁定状态。
---@param Widget UGC_Difficulty_Item_UIBP_C
---@param ZeroBasedIndex number
function UGC_ModeSelection_UIBP:OnDifficultyItemReload(Widget, ZeroBasedIndex)
    local Index = ZeroBasedIndex + 1
    local ModeConfig = self.DifficultyConfigs and self.DifficultyConfigs[Index]
    if not ModeConfig then
        return
    end
    Widget:OnUpdate({
        Idx = Index,
        Difficulty = ModeConfig.Difficulty,
        bIsLocked = LobbyModel:IsModeLocked(ModeConfig.ModeID),
        ModeConfig = ModeConfig,
        bTipsIsLeft = true,
        FocusedMode = self.ViewData.FocusedMode,
        OnModeFocusedCallback = function(NewModeID)
            self:OnModeFocused(NewModeID)
        end,
    })
end

---更新页面焦点 ModeID，并同步刷新两个列表。
---@param ModeID number
function UGC_ModeSelection_UIBP:OnModeFocused(ModeID)
    if not LobbyModel:GetModeConfig(ModeID) then
        return
    end
    self.ViewData.FocusedMode = ModeID
    LobbyUtils.CloseWidget(LobbyWidgetType.LWT_ModeDifficultyTip)
    self:UpdateModeList()
    self:UpdateDifficultyList()
end

---响应难度下拉按钮，切换列表展开状态。
function UGC_ModeSelection_UIBP:OnDifficultySelectClicked()
    self:ToggleDifficulty()
end

---设置或反转难度列表展开状态。
---@param bExpand boolean|nil
function UGC_ModeSelection_UIBP:ToggleDifficulty(bExpand)
    local bIsExpanded = self.CanvasPanel_SelectDifficulty:GetVisibility() == ESlateVisibility.Visible
    if bExpand == nil then
        bExpand = not bIsExpanded
    end
    self.WidgetSwitcher_Arrow:SetActiveWidgetIndex(bExpand and 0 or 1)
    self.CanvasPanel_SelectDifficulty:SetVisibility(bExpand and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
end

return UGC_ModeSelection_UIBP
