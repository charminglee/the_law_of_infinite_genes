---@class HomeMain_C:UserWidgetLayout
---@field HomeToolBar HomeToolBar_C
---@field HomeUserInfo HomeUserInfo_C
---@field LobbyTeamHUD LobbyTeamHUD_C
--Edit Below--
local HomeMain = { bInitDoOnce = false }

function HomeMain:Construct()
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true
    self.ViewData = {}
    self.HomeToolBar.parent = self
    HomeManager:RegisterMainUI(self)

    LobbyEvent.OnModeSelected:Add(self.OnModeSelected, self)
    LobbyEvent.OnDifficultySelected:Add(self.OnDifficultySelected, self)
    LobbyEvent.OnMatchStarted:Add(self.OnMatchStateChanged, self)
    LobbyEvent.OnMatchCanceled:Add(self.OnMatchCanceled, self)

end

function HomeMain:Destruct()
    LobbyEvent.OnModeSelected:Remove(self.OnModeSelected, self)
    LobbyEvent.OnDifficultySelected:Remove(self.OnDifficultySelected, self)
    LobbyEvent.OnMatchStarted:Remove(self.OnMatchStateChanged, self)
    LobbyEvent.OnMatchCanceled:Remove(self.OnMatchCanceled, self)

    self:UnbindTeamEvents()
end

function HomeMain:OnOpen(Data)
    self.ViewData = {
        ModeID = LobbyModel:GetCurrentSelectedModeID(),
        Difficulty = LobbyModel:GetCurrentSelectedDifficulty(),
        bIsMatching = LobbyModel:IsMatching(),
    }
    self:MergeViewData(Data)

    local PlayerController = UGCGameSystem.GetLocalPlayerController()
    self:BindTeamEvents()
    if PlayerController.OnReconnected and not self.bReconnectBound then
        PlayerController.OnReconnected:Add(self.OnPlayerReconnected, self)
        self.bReconnectBound = true
    end
end

function HomeMain:OnClose()
    local PlayerController = UGCGameSystem.GetLocalPlayerController()
    self:UnbindTeamEvents()
    if PlayerController.OnReconnected and self.bReconnectBound then
        PlayerController.OnReconnected:Remove(self.OnPlayerReconnected, self)
        self.bReconnectBound = false
    end
end

function HomeMain:BindTeamEvents()
    if self.bTeamEventsBound then
        return
    end
    local PlayerController = UGCGameSystem.GetLocalPlayerController()
    local PlayerState = UGCGameSystem.GetLocalPlayerState()
    PlayerController.OnLobbyTeammatePlayerKeysUpdate:Add(self.OnTeamStateChanged, self)
    PlayerState.ReadyStateUpdateDelegate:Add(self.OnTeamStateChanged, self)
    self.bTeamEventsBound = true
end

function HomeMain:UnbindTeamEvents()
    if not self.bTeamEventsBound then
        return
    end
    local PlayerController = UGCGameSystem.GetLocalPlayerController()
    local PlayerState = UGCGameSystem.GetLocalPlayerState()
    PlayerController.OnLobbyTeammatePlayerKeysUpdate:Remove(self.OnTeamStateChanged, self)
    PlayerState.ReadyStateUpdateDelegate:Remove(self.OnTeamStateChanged, self)
    self.bTeamEventsBound = false
end

function HomeMain:MergeViewData(Data)
    for Key, Value in pairs(Data or {}) do
        self.ViewData[Key] = Value
    end
end

function HomeMain:OnUpdate(Data)
    self:MergeViewData(Data)
    self.LobbyTeamHUD:OnUpdate(self.ViewData)
end

function HomeMain:OnModeSelected(ModeID)
    if self.bIsOpened then
        self:OnUpdate({
            ModeID = ModeID,
            Difficulty = LobbyModel:GetCurrentSelectedDifficulty(),
        })
    end
end

function HomeMain:OnDifficultySelected(Difficulty)
    if self.bIsOpened then
        self:OnUpdate({ Difficulty = Difficulty })
    end
end

function HomeMain:OnMatchStateChanged(bIsMatching)
    if self.bIsOpened then
        self:OnUpdate({ bIsMatching = bIsMatching == true })
    end
end

function HomeMain:OnMatchCanceled()
    self:OnMatchStateChanged(false)
end

function HomeMain:OnTeamStateChanged()
    if self.bIsOpened then
        self.LobbyTeamHUD:RefreshTeamState()
    end
end

function HomeMain:OnPlayerReconnected()
    if self.bIsOpened then
        self:OnUpdate({
            ModeID = LobbyModel:GetCurrentSelectedModeID(),
            Difficulty = LobbyModel:GetCurrentSelectedDifficulty(),
            bIsMatching = LobbyModel:IsMatching(),
        })
    end
end

return HomeMain
