---@class HomeMain_C:UserWidgetLayout
---@field Button_CancelMatch UButton
---@field Button_CancelReady UButton
---@field Button_DifficultySelect UButton
---@field Button_Ready UButton
---@field Button_Show UButton
---@field CanvasPanel_Matching UCanvasPanel
---@field CanvasPanel_SelectDifficult UCanvasPanel
---@field Challenge UCanvasPanel
---@field FillTeammateCheckBox UCheckBox
---@field ImageEx_GameMode UImage
---@field NewButton_ModeSelect UButton
---@field TextBlock_Difficult UTextBlock
---@field TextBlock_MatchingTime UTextBlock
---@field TextBlock_ModeName UTextBlock
---@field UGC_ReuseList2_Difficulty UGC_ReuseList2_C
---@field WidgetSwitcher_Arrow UWidgetSwitcher
---@field WidgetSwitcher_Matching UWidgetSwitcher
--Edit Below--
local HomeMain = {}

local MATCH_SOUND_PATH = "/Game/UGC/Repository/CG032/PVPTemplate/Audio/WwiseEvent/Play_UGC_Mode_SkillPVP_UI_Countdown.Play_UGC_Mode_SkillPVP_UI_Countdown"

---把局部更新合并到大厅主页的视图快照中。
---@param Target table
---@param Source table|nil
---@return table
local function Merge(Target, Source)
    for Key, Value in pairs(Source or {}) do
        Target[Key] = Value
    end
    return Target
end

---Widget 构造入口，转入可重复调用的 Lua 初始化流程。
function HomeMain:Construct()
    self:LuaInit()
end

---一次性初始化内部状态、注册主页并绑定事件。
function HomeMain:LuaInit()
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true
    self.ViewData = {}
    self.HomeToolBar.parent = self
    HomeManager:RegisterMainUI(self)
    self:Listen()
end

-- 监听事件
function HomeMain:Listen()
    self.UGC_ReuseList2_Difficulty.OnAfterNewItem:Add(self.UGC_ReuseList2_Difficulty_OnAfterNewItem, self)
    self.NewButton_ModeSelect.OnClicked:Add(self.OnModeSelectClicked, self)
    self.Button_Show.OnClicked:Add(self.OnMatchClicked, self)
    self.Button_CancelMatch.OnClicked:Add(self.OnCancelMatchClicked, self)
    self.Button_Ready.OnClicked:Add(self.OnReadyClicked, self)
    self.Button_CancelReady.OnClicked:Add(self.OnCancelReadyClicked, self)
    self.Button_DifficultySelect.OnClicked:Add(self.OnDifficultySelectClicked, self)

    LobbyEvent.OnModeSelected:Add(self.OnModeSelected, self)
    LobbyEvent.OnDifficultySelected:Add(self.OnDifficultySelected, self)
    LobbyEvent.OnMatchStarted:Add(self.OnMatchStateChanged, self)
    LobbyEvent.OnMatchCanceled:Add(self.OnMatchCanceled, self)
end

-- 打开界面
function HomeMain:OnOpen(Data)
    self.ViewData = {
        ModeID = LobbyModel:GetCurrentSelectedModeID(),
        bIsMatching = LobbyModel:IsMatching(),
    }
    Merge(self.ViewData, Data)
    self:ToggleDifficulty(false)

    local PC = UGCGameSystem.GetLocalPlayerController()
    if PC and PC.OnReconnected and not self.bReconnectBound then
        PC.OnReconnected:Add(self.OnPlayerReconnected, self)
        self.bReconnectBound = true
    end
end

-- 关闭界面
function HomeMain:OnClose()
    self:StopMatchingTimer()
    if self.PlayerDataTimer then
        UGCTimerUtility.RemoveLuaTimer(self.PlayerDataTimer)
        self.PlayerDataTimer = nil
    end
    local PC = UGCGameSystem.GetLocalPlayerController()
    if PC and PC.OnReconnected and self.bReconnectBound then
        PC.OnReconnected:Remove(self.OnPlayerReconnected, self)
        self.bReconnectBound = false
    end
end

-- 刷新界面
function HomeMain:OnUpdate(Data)
    self.ViewData = Merge(self.ViewData or {}, Data)
    if self.ViewData.bIsMatching == nil then
        self.ViewData.bIsMatching = LobbyModel:IsMatching()
    end

    self:UpdateMode()
    self:UpdateMatch()
    self:UpdateDifficulty()
    self:UpdateLobbyActions()
    self:SchedulePlayerDataRefresh()
end

---模式选择事件处理：页面打开时刷新模式展示。
---@param ModeID number
function HomeMain:OnModeSelected(ModeID)
    if self.bIsOpened then
        self:OnUpdate({ ModeID = ModeID })
    end
end

---难度选择事件处理：同步模式 ID 与难度文本。
---@param Difficulty string|FText
function HomeMain:OnDifficultySelected(Difficulty)
    if self.bIsOpened then
        self:OnUpdate({
            ModeID = LobbyModel:GetCurrentSelectedModeID(),
            Difficulty = Difficulty,
        })
    end
end

---匹配状态事件处理：切换匹配面板和计时器。
---@param bIsMatching boolean
function HomeMain:OnMatchStateChanged(bIsMatching)
    if self.bIsOpened then
        self:OnUpdate({ bIsMatching = bIsMatching == true })
    end
end

---匹配取消事件处理：恢复非匹配界面。
function HomeMain:OnMatchCanceled()
    self:OnMatchStateChanged(false)
end

---静默重连后从模型重新获取大厅快照。
function HomeMain:OnPlayerReconnected()
    if self.bIsOpened then
        self:OnUpdate({
            ModeID = LobbyModel:GetCurrentSelectedModeID(),
            bIsMatching = LobbyModel:IsMatching(),
        })
    end
end

---刷新当前模式名称和横幅图片。
function HomeMain:UpdateMode()
    local ModeConfig = LobbyModel:GetModeConfig(self.ViewData.ModeID or LobbyModel:GetCurrentSelectedModeID())
    if not ModeConfig then
        return
    end
    self.TextBlock_ModeName:SetText(LobbyUtils.GetTrimmedString(ModeConfig.ModeName, 6))
    self.ImageEx_GameMode:SetBrushFromTexture(ModeConfig.ModeBanner, false)
end

---根据匹配状态切换主页区域并管理匹配计时器。
function HomeMain:UpdateMatch()
    if self.ViewData.bIsMatching then
        self.Challenge:SetVisibility(ESlateVisibility.Collapsed)
        self.CanvasPanel_Matching:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.WidgetSwitcher_Matching:SetVisibility(ESlateVisibility.Collapsed)
        self:StartMatchingTimer()
    else
        self.Challenge:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.CanvasPanel_Matching:SetVisibility(ESlateVisibility.Collapsed)
        self.WidgetSwitcher_Matching:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self:StopMatchingTimer()
    end
end

---启动唯一的匹配耗时计时器。
function HomeMain:StartMatchingTimer()
    if self.MatchingTimer then
        return
    end
    self.TextBlock_MatchingTime:SetText("00:00")
    self.MatchingStartTime = os.time()
    self.MatchingTimer = UGCTimerUtility.CreateLuaTimer(1, function()
        UGCSoundManagerSystem.PlaySound2D(UE.LoadObject(MATCH_SOUND_PATH))
        local Elapsed = os.time() - self.MatchingStartTime
        self.TextBlock_MatchingTime:SetText(string.format("%02d:%02d", Elapsed // 60, Elapsed % 60))
    end, true)
end

---停止并清理匹配耗时计时器。
function HomeMain:StopMatchingTimer()
    if self.MatchingTimer then
        UGCTimerUtility.RemoveLuaTimer(self.MatchingTimer)
        self.MatchingTimer = nil
    end
end

---刷新当前难度文本和同模式难度列表。
function HomeMain:UpdateDifficulty()
    local ModeConfig = LobbyModel:GetModeConfig(self.ViewData.ModeID or LobbyModel:GetCurrentSelectedModeID())
    if not ModeConfig then
        return
    end
    self.TextBlock_Difficult:SetText(ModeConfig.Difficulty or "")
    self.DifficultyConfigs = LobbyModel:GetModeListWithSameDetailID(ModeConfig.ModeID)
    self.UGC_ReuseList2_Difficulty:Reload(#self.DifficultyConfigs)
end

---根据本地玩家的队长、准备及填充状态刷新操作区域。
function HomeMain:UpdateLobbyActions()
    local PC = UGCGameSystem.GetLocalPlayerController()
    local PlayerState = UGCGameSystem.GetLocalPlayerState()
    if not PC or not PlayerState then
        return
    end

    if PlayerState.bIsLobbyTeamLeader then
        self.WidgetSwitcher_Matching:SetActiveWidgetIndex(0)
    else
        self.WidgetSwitcher_Matching:SetActiveWidgetIndex(PlayerState.bIsReadyInLobby and 2 or 1)
    end
    self.FillTeammateCheckBox:SetIsChecked(PC.LobbyInfo and PC.LobbyInfo.bFillTeammate == true)
end

---合并短时间内的刷新请求，延迟读取尚未就绪的玩家数据。
function HomeMain:SchedulePlayerDataRefresh()
    if self.PlayerDataTimer then
        return
    end
    self.PlayerDataTimer = UGCTimerUtility.CreateLuaTimer(0.2, function()
        self.PlayerDataTimer = nil
        self:UpdatePlayerData()
    end, false)
end

---读取本地玩家账号与等级数据，生成主页玩家视图快照。
function HomeMain:UpdatePlayerData()
    local PlayerState = UGCGameSystem.GetLocalPlayerState()
    if not PlayerState then
        return
    end
    local PlayerKey = UGCPlayerStateSystem.GetPlayerKeyInt64(PlayerState)
    local AccountInfo = ScriptGameplayStatics.GetPlayerAccountInfo(UGCGameSystem.GameState, PlayerKey)
    local UGCGameData = UGCGameSystem.UGCRequire("Script.Blueprint.UGCGameData")
    local LevelConfig = UGCGameData.GetLevelConfig(PlayerState.UGCPlayerLevel)
    if not AccountInfo or not LevelConfig then
        return
    end

    local CurrentExp = tonumber(PlayerState.PlayerExp) or 0
    local TargetExp = tonumber(LevelConfig.Exp) or 0
    local ExpRatio = TargetExp > 0 and math.min(CurrentExp / TargetExp, 1) or 0
    self.PlayerViewData = {
        PlayerAccountInfo = AccountInfo:Copy(),
        Level = PlayerState.UGCPlayerLevel,
        NowExp = CurrentExp,
        TargetExp = TargetExp,
        ExpRatio = ExpRatio,
    }
end

-- 模式选择按钮
function HomeMain:OnModeSelectClicked()
    if LobbyModel:IsMatching() then
        UGCWidgetManagerSystem.ShowTipsUI("匹配中无法设置")
        return
    end
    local PC = UGCGameSystem.GetLocalPlayerController()
    if not PC or not PC.bIsTeamLeader then
        UGCWidgetManagerSystem.ShowTipsUI("只有队长才能选择模式")
        return
    end
    if not PC.LobbyInfo or not PC.LobbyInfo.bTeamComplete then
        UGCWidgetManagerSystem.ShowTipsUI("队伍有成员退出，请退出玩法重新进入")
        return
    end
    LobbyFlow:Go(LobbyFlowState.LFS_ModeSelect)
end

-- 刷新匹配按钮
function HomeMain:RefreshMatchButton(bIsLeader)
    self.WidgetSwitcher_Matching:SetActiveWidgetIndex(bIsLeader and 0 or 1)
end

-- 难度列表刷新
function HomeMain:UGC_ReuseList2_Difficulty_OnAfterNewItem(Widget, ZeroBasedIndex)
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
        bTipsIsLeft = false,
        FocusedMode = LobbyModel:GetCurrentSelectedModeID(),
        bIsBig = true,
    })
end

-- 开始匹配按钮
function HomeMain:OnMatchClicked()
    local PC = UGCGameSystem.GetLocalPlayerController()
    local GameState = UGCGameSystem.GameState
    local ModeSetting = UGCMultiMode.GetModeSetting(LobbyModel:GetCurrentSelectedModeID())
    if not PC or not GameState or not ModeSetting then
        return
    end
    if not PC.LobbyInfo or not PC.LobbyInfo.bTeamComplete then
        UGCWidgetManagerSystem.ShowTipsUI("队伍有成员退出，请退出玩法重新进入")
        return
    end
    local MaxPlayers = tonumber(ModeSetting.TeamPlayers) or 0
    if MaxPlayers <= 0 or #(PC.LobbyTeammatePlayerKeys or {}) > MaxPlayers then
        UGCWidgetManagerSystem.ShowTipsUI("当前人数大于模式最大人数")
        return
    end
    if PC.bIsTeamLeader and not GameState:IsAllLobbyTeammateReady() then
        UGCWidgetManagerSystem.ShowTipsUI("有队友未准备，不能开始匹配")
        return
    end

    self:ToggleDifficulty(false)

    LobbyModel:RequestMatch(self.FillTeammateCheckBox:IsChecked())
end

-- 取消匹配按钮
function HomeMain:OnCancelMatchClicked()
    LobbyModel:CancelMatch()
end

-- 准备按钮
function HomeMain:OnReadyClicked()
    local PC = UGCGameSystem.GetLocalPlayerController()
    if PC then
        PC:SetLobbyReadyStatus(true)
    end
end

-- 取消准备按钮
function HomeMain:OnCancelReadyClicked()
    local PC = UGCGameSystem.GetLocalPlayerController()
    if PC then
        PC:SetLobbyReadyStatus(false)
    end
end

-- 选择难度按钮
function HomeMain:OnDifficultySelectClicked()
    if LobbyModel:IsMatching() then
        UGCWidgetManagerSystem.ShowTipsUI("匹配中无法设置")
        return
    end
    local PC = UGCGameSystem.GetLocalPlayerController()
    if not PC or not PC.bIsTeamLeader then
        UGCWidgetManagerSystem.ShowTipsUI("只有队长才能选择难度")
        return
    end
    self:ToggleDifficulty()
end

-- 切换难度按钮
function HomeMain:ToggleDifficulty(bExpand)
    local bIsExpanded = self.CanvasPanel_SelectDifficult:GetVisibility() == ESlateVisibility.Visible
    if bExpand == nil then
        bExpand = not bIsExpanded
    end
    self.WidgetSwitcher_Arrow:SetActiveWidgetIndex(bExpand and 1 or 0)
    self.CanvasPanel_SelectDifficult:SetVisibility(bExpand and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    if not bExpand then
        LobbyUtils.CloseWidget(LobbyWidgetType.LWT_ModeDifficultyTip)
    end
end

return HomeMain
