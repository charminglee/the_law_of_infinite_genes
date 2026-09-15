---@class RecruitMain_C:UAEUserWidget
---@field Button_0 UButton
---@field CreateRoom CreateRoom_C
---@field DefaultRoom DefaultRoom_C
---@field ExistRoom ExistRoom_C
---@field RoomList RoomList_C
--Edit Below--
local RecruitMain = { bInitDoOnce = false }

function RecruitMain:Construct()
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true
    self.Button_0.OnClicked:Add(self.Exit, self)
    RecruitManager:RegisterMainUI(self)

    local PlayerController = UGCGameSystem.GetLocalPlayerController()
    local PlayerState = UGCGameSystem.GetLocalPlayerState()
    PlayerController.OnLobbyTeammatePlayerKeysUpdate:Add(self.OnLobbyChanged, self)
    PlayerState.ReadyStateUpdateDelegate:Add(self.OnReadyChanged, self)

    self.RoomList:Init(
        function(Index)
            RecruitManager:SelectRoom(Index)
        end,
        function()
            RecruitManager:ShowCreateRoom()
        end
    )
    self.DefaultRoom:Init(function()
        RecruitManager:ShowCreateRoom()
    end)
    self.CreateRoom:Init(
        function(Config)
            RecruitManager:CreateRoom(Config)
        end,
        function()
            RecruitManager:ShowDefaultRoom()
        end
    )
    self.ExistRoom:Init({
        OnJoin = function()
            RecruitManager:JoinSelectedRoom()
        end,
        OnStart = function()
            RecruitManager:StartGame()
        end,
        OnInvite = function()
            RecruitManager:OpenInvitation()
        end,
        OnConfig = function()
            RecruitManager:OpenRoomConfig()
        end,
    })
    self:RefreshUI()
end

function RecruitMain:Destruct()
    self.Button_0.OnClicked:Remove(self.Exit, self)
    local PlayerController = UGCGameSystem.GetLocalPlayerController()
    local PlayerState = UGCGameSystem.GetLocalPlayerState()
    PlayerController.OnLobbyTeammatePlayerKeysUpdate:Remove(self.OnLobbyChanged, self)
    PlayerState.ReadyStateUpdateDelegate:Remove(self.OnReadyChanged, self)
    RecruitManager:UnregisterMainUI(self)
end

function RecruitMain:OnLobbyChanged()
    RecruitManager:OnLobbyMembersChanged()
end

function RecruitMain:OnReadyChanged()
    RecruitManager:RefreshLobbyMembers()
    RecruitManager:NotifyChanged()
end

function RecruitMain:Exit()
    RecruitManager:CloseMainUI()
end

function RecruitMain:RefreshUI()
    local Page = RecruitManager.Page
    self.DefaultRoom:SetVisibility(Page == "Default" and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
    self.CreateRoom:SetVisibility(Page == "Create" and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
    self.ExistRoom:SetVisibility(Page == "Exist" and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)

    self.RoomList:Refresh(RecruitManager:GetRooms(), RecruitManager.SelectedRoomIndex, Page == "Exist")
    if Page == "Create" then
        self.CreateRoom:OnOpen(RecruitManager:BuildDefaultRoomConfig())
    elseif Page == "Exist" then
        local TeamState = RecruitManager:GetTeamState()
        local SelectedRoom = RecruitManager:GetSelectedRoom()
        self.ExistRoom:OnUpdate(SelectedRoom, TeamState.Room == SelectedRoom)
    end
end

return RecruitMain
