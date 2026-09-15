---@class LobbyTeamHUD_C:UAEUserWidget
---@field Button_0 UButton
---@field Button_Disband UButton
---@field Button_ExitTeam UButton
---@field Button_OpenRecruit UButton
---@field Button_Prepare UButton
---@field Button_Prepare_Cancel UButton
---@field Button_Start UButton
---@field Button_Start_Cancel UButton
---@field CanvasPanel_Tip UCanvasPanel
---@field CheckBox_AllowRestock UCheckBox
---@field CircularThrobber_0 UCircularThrobber
---@field Image_2 UImage
---@field Image_3 UImage
---@field Image_4 UImage
---@field Image_7 UImage
---@field Image_8 UImage
---@field TeamList TeamList_C
---@field TextBlock_Time UTextBlock
--Edit Below--
local LobbyTeamHUD = { bInitDoOnce = false }
function LobbyTeamHUD:Construct()
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true
    RecruitManager:RegisterTeamHUD(self)
    self.Button_0.OnClicked:Add(self.OnSwitchModeClicked, self)
    self.Button_Disband.OnClicked:Add(self.OnDisbandClicked, self)
    self.Button_ExitTeam.OnClicked:Add(self.OnExitTeamClicked, self)
    self.Button_OpenRecruit.OnClicked:Add(self.OnOpenRecruitClicked, self)
    self.Button_Prepare.OnClicked:Add(self.OnPrepareClicked, self)
    self.Button_Prepare_Cancel.OnClicked:Add(self.OnCancelPrepareClicked, self)
    self.Button_Start.OnClicked:Add(self.OnStartClicked, self)
    self.Button_Start_Cancel.OnClicked:Add(self.OnCancelMatchClicked, self)
    self.CheckBox_AllowRestock.OnCheckStateChanged:Add(self.OnFillTeammateChanged, self)
end
function LobbyTeamHUD:Destruct()
    self:StopMatchingTimer()
    RecruitManager:UnregisterTeamHUD(self)
    self.Button_0.OnClicked:Remove(self.OnSwitchModeClicked, self)
    self.Button_Disband.OnClicked:Remove(self.OnDisbandClicked, self)
    self.Button_ExitTeam.OnClicked:Remove(self.OnExitTeamClicked, self)
    self.Button_OpenRecruit.OnClicked:Remove(self.OnOpenRecruitClicked, self)
    self.Button_Prepare.OnClicked:Remove(self.OnPrepareClicked, self)
    self.Button_Prepare_Cancel.OnClicked:Remove(self.OnCancelPrepareClicked, self)
    self.Button_Start.OnClicked:Remove(self.OnStartClicked, self)
    self.Button_Start_Cancel.OnClicked:Remove(self.OnCancelMatchClicked, self)
    self.CheckBox_AllowRestock.OnCheckStateChanged:Remove(self.OnFillTeammateChanged, self)
end
function LobbyTeamHUD:OnUpdate(Data)
    self.ViewData = Data
    self:SetMatchingState(Data.bIsMatching == true)
end
function LobbyTeamHUD:RefreshTeamState()
    local TeamState = RecruitManager:GetTeamState()
    local bIsMatching = self.ViewData and self.ViewData.bIsMatching == true
    self.TeamList:SetMembers(TeamState.Members)
    self.TeamList:SetVisibility(TeamState.bHasTeam and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
    self.bUpdatingFillTeammate = true
    self.CheckBox_AllowRestock:SetIsChecked(TeamState.bAllowRestock)
    self.bUpdatingFillTeammate = false
    self.CheckBox_AllowRestock:SetVisibility(ESlateVisibility.Visible)
    self.CheckBox_AllowRestock:SetIsEnabled(TeamState.bLeader and not bIsMatching)
    self.Button_Start:SetVisibility(TeamState.bLeader and not bIsMatching and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    self.Button_Start_Cancel:SetVisibility(TeamState.bLeader and bIsMatching and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    self.Button_Prepare:SetVisibility(not TeamState.bLeader and not TeamState.bReady and not bIsMatching and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    self.Button_Prepare_Cancel:SetVisibility(not TeamState.bLeader and TeamState.bReady and not bIsMatching and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    self.Button_OpenRecruit:SetVisibility(not TeamState.bHasTeam and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    self.Button_OpenRecruit:SetIsEnabled(not bIsMatching)
    self.Button_Disband:SetVisibility(TeamState.bHasTeam and TeamState.bLeader and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    self.Button_Disband:SetIsEnabled(not bIsMatching)
    self.Button_ExitTeam:SetVisibility(TeamState.bHasTeam and not TeamState.bLeader and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    self.Button_ExitTeam:SetIsEnabled(not bIsMatching)
    self.Button_0:SetIsEnabled(TeamState.bLeader and not bIsMatching)
end
function LobbyTeamHUD:SetMatchingState(bIsMatching)
    self.CanvasPanel_Tip:SetVisibility(bIsMatching and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
    self.CircularThrobber_0:SetVisibility(bIsMatching and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
    if bIsMatching then
        self:StartMatchingTimer()
    else
        self:StopMatchingTimer()
    end
    self:RefreshTeamState()
end
function LobbyTeamHUD:StartMatchingTimer()
    if self.MatchingTimer then
        return
    end
    self.MatchingStartTime = os.time()
    self.TextBlock_Time:SetText("00:00")
    self.MatchingTimer = UGCTimerUtility.CreateLuaTimer(1, function()
        local Elapsed = os.time() - self.MatchingStartTime
        self.TextBlock_Time:SetText(string.format("%02d:%02d", Elapsed // 60, Elapsed % 60))
    end, true)
end
function LobbyTeamHUD:StopMatchingTimer()
    if self.MatchingTimer then
        UGCTimerUtility.RemoveLuaTimer(self.MatchingTimer)
        self.MatchingTimer = nil
    end
    self.TextBlock_Time:SetText("00:00")
end
function LobbyTeamHUD:OnStartClicked()
    local TeamState = RecruitManager:GetTeamState()
    local GameState = UGCGameSystem.GameState
    local ModeID = LobbyModel:GetCurrentSelectedModeID()
    local ModeSetting = UGCMultiMode.GetModeSetting(ModeID)
    if not GameState or not ModeSetting then
        return
    end
    if not TeamState.bTeamComplete then
        UGCWidgetManagerSystem.ShowTipsUI("队伍有成员退出，请退出玩法重新进入")
        return
    end
    local MaxPlayers = tonumber(ModeSetting.TeamPlayers) or 0
    if MaxPlayers <= 0 or #TeamState.Members > MaxPlayers then
        UGCWidgetManagerSystem.ShowTipsUI("当前人数大于模式最大人数")
        return
    end
    if not GameState:IsAllLobbyTeammateReady() then
        UGCWidgetManagerSystem.ShowTipsUI("有队友未准备，不能开始匹配")
        return
    end
    LobbyModel:RequestMatch(TeamState.bAllowRestock)
end
function LobbyTeamHUD:OnCancelMatchClicked()
    LobbyModel:CancelMatch()
end
function LobbyTeamHUD:OnFillTeammateChanged(bFillTeammate)
    if self.bUpdatingFillTeammate then
        return
    end
    RecruitManager:SetAllowRestock(bFillTeammate)
end
function LobbyTeamHUD:OnPrepareClicked()
    UGCGameSystem.GetLocalPlayerController():SetLobbyReadyStatus(true)
end
function LobbyTeamHUD:OnCancelPrepareClicked()
    UGCGameSystem.GetLocalPlayerController():SetLobbyReadyStatus(false)
end
function LobbyTeamHUD:OnOpenRecruitClicked()
    RecruitManager:OpenMainUI()
end
function LobbyTeamHUD:OnSwitchModeClicked()
    local TeamState = RecruitManager:GetTeamState()
    if not TeamState.bLeader then
        UGCWidgetManagerSystem.ShowTipsUI("只有队长才能选择模式")
        return
    end
    if not TeamState.bTeamComplete then
        UGCWidgetManagerSystem.ShowTipsUI("队伍有成员退出，请退出玩法重新进入")
        return
    end
    LobbyUtils.OpenAndUpdateWidget(LobbyWidgetType.LWT_SwitchMode, {
        ModeID = LobbyModel:GetCurrentSelectedModeID(),
    })
end
function LobbyTeamHUD:OnExitTeamClicked()
    RecruitManager:ExitCurrentRoom()
end
function LobbyTeamHUD:OnDisbandClicked()
    RecruitManager:DisbandCurrentRoom()
end
return LobbyTeamHUD
