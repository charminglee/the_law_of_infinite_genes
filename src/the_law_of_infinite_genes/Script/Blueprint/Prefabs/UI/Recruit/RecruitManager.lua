---@class RecruitManager
RecruitManager = RecruitManager or {
    MainUI = nil,
    ComponentClass = nil,
    Rooms = {},
    SelectedRoomIndex = nil,
    CurrentRoom = nil,
    Page = "Default",
    InvitationUI = nil,
    RoomConfigUI = nil,
    JoinRequestCallback = nil,
    InviteRequestCallback = nil,
    ModeConfigByID = {},
    ModeIDsByDetailID = {},
    ModeGroups = {},
    bModeConfigLoaded = false,
}

local POPUP_PATHS = {
    Invitation = "Asset/Blueprint/Prefabs/UI/Recruit/InvitationList.InvitationList_C",
    RoomConfig = "Asset/Blueprint/Prefabs/UI/Recruit/RoomConfig.RoomConfig_C",
}

local GAME_MODE_CONFIG_PATH = "Asset/Data/Table/UGCGameModeConfig.UGCGameModeConfig"
local GAME_MODE_DETAIL_PATH = "Asset/Data/Table/UGCGameModeDetail.UGCGameModeDetail"
local LOBBY_MODE_ID = 1001

local function CopyTable(Source)
    local Result = {}
    for Key, Value in pairs(Source or {}) do
        Result[Key] = Value
    end
    return Result
end

local function CreatePopup(Path)
    local PlayerController = UGCGameSystem.GetLocalPlayerController()
    local WidgetClass = UE.LoadClass(UGCGameSystem.GetUGCResourcesFullPath(Path))
    if not PlayerController or not WidgetClass then
        return nil
    end
    local Widget = UserWidget.NewWidgetObjectBP(PlayerController, WidgetClass)
    Widget:AddToViewport(12001)
    return Widget
end

function RecruitManager:RegisterComponentClass(Component)
    self.ComponentClass = Component
end

function RecruitManager:RegisterMainUI(MainUI)
    self.MainUI = MainUI
end

function RecruitManager:UnregisterMainUI(MainUI)
    if self.MainUI == MainUI then
        self.MainUI = nil
    end
end

function RecruitManager:OpenMainUI()
    if not self.MainUI then
        return
    end
    self.MainUI:SetVisibility(ESlateVisibility.Visible)
    self:RefreshLobbyMembers()
    self:NotifyChanged()
end

function RecruitManager:CloseMainUI()
    if self.MainUI then
        self.MainUI:SetVisibility(ESlateVisibility.Collapsed)
    end
    self:CloseInvitation()
    self:CloseRoomConfig()
end

function RecruitManager:GetMainUI()
    return self.MainUI
end

function RecruitManager:NotifyChanged()
    if self.MainUI then
        self.MainUI:RefreshUI()
    end
end

function RecruitManager:RegisterRequestCallbacks(JoinCallback, InviteCallback)
    self.JoinRequestCallback = JoinCallback
    self.InviteRequestCallback = InviteCallback
end

function RecruitManager:GetRooms()
    return self.Rooms
end

function RecruitManager:GetSelectedRoom()
    return self.SelectedRoomIndex and self.Rooms[self.SelectedRoomIndex] or self.CurrentRoom
end

function RecruitManager:SelectRoom(Index)
    if not self.Rooms[Index] then
        return
    end
    self.SelectedRoomIndex = Index
    self.Page = "Exist"
    self:NotifyChanged()
end

function RecruitManager:ShowDefaultRoom()
    self.SelectedRoomIndex = nil
    self.Page = self.CurrentRoom and "Exist" or "Default"
    self:NotifyChanged()
end

function RecruitManager:ShowCreateRoom()
    self.SelectedRoomIndex = nil
    self.Page = "Create"
    self:NotifyChanged()
end

function RecruitManager:LoadModeConfig()
    if self.bModeConfigLoaded then
        return
    end

    local EnabledModeIDs = {}
    local MultiModeConfigs = GameFrontendHUD:UGCGetMultiModeConfig()
    for Index = 1, MultiModeConfigs:Num() do
        local Config = json.decode(MultiModeConfigs:Get(Index))
        local ModeID = Config and tonumber(Config.ModeID)
        if ModeID and ModeID ~= LOBBY_MODE_ID then
            EnabledModeIDs[ModeID] = true
        end
    end

    local ModeRowsByID = {}
    local ModeRows = UGCGameSystem.GetTableData(UGCGameSystem.GetUGCResourcesFullPath(GAME_MODE_CONFIG_PATH)) or {}
    for _, ModeRow in pairs(ModeRows) do
        ModeRowsByID[tonumber(ModeRow.ModeID)] = ModeRow
    end

    local DetailRows = UGCGameSystem.GetTableData(UGCGameSystem.GetUGCResourcesFullPath(GAME_MODE_DETAIL_PATH)) or {}
    for _, Detail in pairs(DetailRows) do
        local DetailModeIDs = {}
        for _, RawModeID in ipairs(Detail.ModeIDs or {}) do
            local ModeID = tonumber(RawModeID)
            local ModeRow = ModeRowsByID[ModeID]
            if EnabledModeIDs[ModeID] and ModeRow then
                self.ModeConfigByID[ModeID] = {
                    ModeID = ModeID,
                    DetailID = Detail.ID,
                    ModeName = Detail.ModeName,
                    ModeDesc = Detail.ModeDesc,
                    ModeBanner = Detail.ModeBanner,
                    ModePost = Detail.ModePost,
                    Difficulty = ModeRow.Difficulty,
                    UnlockDesc = ModeRow.UnlockDesc,
                }
                table.insert(DetailModeIDs, ModeID)
            end
        end
        self.ModeIDsByDetailID[Detail.ID] = DetailModeIDs
        if not Detail.Hide and DetailModeIDs[1] then
            table.insert(self.ModeGroups, self.ModeConfigByID[DetailModeIDs[1]])
        end
    end
    table.sort(self.ModeGroups, function(A, B)
        return A.DetailID < B.DetailID
    end)
    self.bModeConfigLoaded = true
end

function RecruitManager:GetModeGroups()
    self:LoadModeConfig()
    local Result = {}
    for _, Config in ipairs(self.ModeGroups) do
        table.insert(Result, Config)
    end
    return Result
end

function RecruitManager:GetDifficultyConfigs(ModeID)
    self:LoadModeConfig()
    local Config = self.ModeConfigByID[tonumber(ModeID)]
    local Result = {}
    if Config then
        for _, DifficultyModeID in ipairs(self.ModeIDsByDetailID[Config.DetailID]) do
            table.insert(Result, self.ModeConfigByID[DifficultyModeID])
        end
    end
    return Result
end

function RecruitManager:GetModeConfig(ModeID)
    self:LoadModeConfig()
    return self.ModeConfigByID[tonumber(ModeID)]
end

function RecruitManager:IsModeLocked(ModeID)
    local PlayerState = UGCGameSystem.GetLocalPlayerState()
    for _, UnlockedModeID in ipairs(PlayerState.GameCompletionRecord or {}) do
        if tonumber(UnlockedModeID) == tonumber(ModeID) then
            return false
        end
    end
    return true
end

function RecruitManager:BuildDefaultRoomConfig()
    local PlayerController = UGCGameSystem.GetLocalPlayerController()
    local SelectedModeID = PlayerController.LobbyInfo and PlayerController.LobbyInfo.SelectedModeID
    local Mode = self:GetModeConfig(SelectedModeID) or self:GetModeGroups()[1]
    return {
        ModeID = Mode and Mode.ModeID or nil,
        MapName = Mode and Mode.ModeName or "",
        Description = Mode and Mode.ModeDesc or "",
        MapImage = Mode and Mode.ModePost or nil,
        Difficulty = Mode and Mode.Difficulty or "",
        AllowRestock = true,
        AllowServe = true,
        DropItems = {},
    }
end

function RecruitManager:CreateRoom(Config)
    local Room = {
        RoomName = self:GetLocalPlayerName() .. "的队伍",
        Config = CopyTable(Config),
        Members = self:GetLobbyMembers(),
        MaxMembers = 4,
    }
    table.insert(self.Rooms, 1, Room)
    self.CurrentRoom = Room
    self.SelectedRoomIndex = 1
    self.Page = "Exist"
    self:NotifyChanged()
end

function RecruitManager:JoinSelectedRoom()
    local Room = self.SelectedRoomIndex and self.Rooms[self.SelectedRoomIndex]
    if not Room then
        return
    end
    if self.JoinRequestCallback then
        self.JoinRequestCallback(Room)
    end
    self.CurrentRoom = Room
    self.Page = "Exist"
    self:RefreshLobbyMembers()
    self:NotifyChanged()
end

function RecruitManager:LeaveCurrentRoom()
    self.CurrentRoom = nil
    self.SelectedRoomIndex = nil
    self.Page = "Default"
    self:NotifyChanged()
end

function RecruitManager:SetReady(bReady)
    local PlayerController = UGCGameSystem.GetLocalPlayerController()
    if PlayerController then
        PlayerController:SetLobbyReadyStatus(bReady == true)
    end
    self:RefreshLobbyMembers()
    self:NotifyChanged()
end

function RecruitManager:StartGame()
    local Room = self.CurrentRoom
    if not Room then
        return
    end
    local PlayerController = UGCGameSystem.GetLocalPlayerController()
    local GameState = UGCGameSystem.GameState
    local ModeSetting = UGCMultiMode.GetModeSetting(Room.Config.ModeID)
    if not PlayerController or not GameState or not ModeSetting or not PlayerController.bIsTeamLeader then
        return
    end
    if not PlayerController.LobbyInfo or not PlayerController.LobbyInfo.bTeamComplete then
        UGCWidgetManagerSystem.ShowTipsUI("队伍有成员退出，请退出玩法重新进入")
        return
    end
    if #(PlayerController.LobbyTeammatePlayerKeys or {}) > tonumber(ModeSetting.TeamPlayers) then
        UGCWidgetManagerSystem.ShowTipsUI("当前人数大于模式最大人数")
        return
    end
    if not GameState:IsAllLobbyTeammateReady() then
        UGCWidgetManagerSystem.ShowTipsUI("有队友未准备，不能开始匹配")
        return
    end
    if self:IsModeLocked(Room.Config.ModeID) then
        UGCWidgetManagerSystem.ShowTipsUI("该模式尚未解锁")
        return
    end
    UnrealNetwork.CallUnrealRPC(
        PlayerController,
        PlayerController,
        "RPC_Server_SetLobbySelectedModeID",
        Room.Config.ModeID
    )
    UnrealNetwork.CallUnrealRPC(
        PlayerController,
        PlayerController,
        "RPC_Server_SetFillTeammate",
        Room.Config.AllowRestock == true
    )
    UGCMultiMode.RequestMatch(Room.Config.ModeID, nil, nil, Room.Config.AllowRestock == true)
end

function RecruitManager:SaveRoomConfig(Config)
    if not self.CurrentRoom then
        return
    end
    self.CurrentRoom.Config = CopyTable(Config)
    self:CloseRoomConfig()
    self:NotifyChanged()
end

function RecruitManager:OpenInvitation()
    if not self.InvitationUI then
        self.InvitationUI = CreatePopup(POPUP_PATHS.Invitation)
    end
    if self.InvitationUI then
        self.InvitationUI:SetVisibility(ESlateVisibility.Visible)
        self.InvitationUI:OnOpen({
            Players = self:GetGlobalPlayers(),
            FilterPlayers = function(Players)
                return self:FilterGlobalPlayers(Players)
            end,
            OnInvite = function(Player)
                if self.InviteRequestCallback then
                    self.InviteRequestCallback(Player)
                end
            end,
        })
    end
end

function RecruitManager:CloseInvitation()
    if self.InvitationUI then
        self.InvitationUI:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function RecruitManager:OpenRoomConfig()
    if not self.CurrentRoom then
        return
    end
    if not self.RoomConfigUI then
        self.RoomConfigUI = CreatePopup(POPUP_PATHS.RoomConfig)
    end
    if self.RoomConfigUI then
        self.RoomConfigUI:SetVisibility(ESlateVisibility.Visible)
        self.RoomConfigUI:OnOpen({
            Config = CopyTable(self.CurrentRoom.Config),
            OnSave = function(Config)
                self:SaveRoomConfig(Config)
            end,
            OnCancel = function()
                self:CloseRoomConfig()
            end,
        })
    end
end

function RecruitManager:CloseRoomConfig()
    if self.RoomConfigUI then
        self.RoomConfigUI:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function RecruitManager:GetLocalPlayerName()
    local PlayerState = UGCGameSystem.GetLocalPlayerState()
    return PlayerState and tostring(PlayerState.PlayerName) or "玩家"
end

function RecruitManager:GetLobbyMembers()
    local PlayerController = UGCGameSystem.GetLocalPlayerController()
    local Keys = PlayerController and PlayerController.LobbyTeammatePlayerKeys or {}
    local Members = {}
    for _, PlayerKey in ipairs(Keys) do
        local PlayerState = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey)
        if PlayerState then
            table.insert(Members, {
                PlayerKey = PlayerKey,
                Name = tostring(PlayerState.PlayerName),
                bReady = PlayerState.bIsReadyInLobby == true,
                bLeader = PlayerState.bIsLobbyTeamLeader == true,
            })
        end
    end
    return Members
end

function RecruitManager:RefreshLobbyMembers()
    if self.CurrentRoom then
        self.CurrentRoom.Members = self:GetLobbyMembers()
    end
end

function RecruitManager:GetGlobalPlayers()
    local GlobalActor = UGCGamePartSystem.PlayerListManager.GetGlobalActor()
    return self:FilterGlobalPlayers(GlobalActor and GlobalActor:GetPlayerListData() or {})
end

function RecruitManager:FilterGlobalPlayers(Players)
    local ExcludedUIDs = {}
    for _, Member in ipairs(self:GetLobbyMembers()) do
        ExcludedUIDs[UGCGameSystem.GetUIDByPlayerKey(Member.PlayerKey)] = true
    end
    local Result = {}
    for _, Player in ipairs(Players) do
        if not ExcludedUIDs[Player.UID] then
            table.insert(Result, Player)
        end
    end
    return Result
end

return RecruitManager
