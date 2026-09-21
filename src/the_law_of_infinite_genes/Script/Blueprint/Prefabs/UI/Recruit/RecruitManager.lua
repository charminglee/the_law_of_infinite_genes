---@class RecruitManager
RecruitManager = RecruitManager or {
    MainUI = nil,
    TeamHUD = nil,
    Rooms = {},
    SelectedRoomIndex = nil,
    CurrentRoom = nil,
    Page = "Default",
    InvitationUI = nil,
    RoomConfigUI = nil,
    SwitchModeUI = nil,
    JoinRequestCallback = nil,
    InviteRequestCallback = nil,
    ModeConfigByID = {},
    ModeIDsByMapKey = {},
    MapConfigs = {},
    bModeConfigLoaded = false,
    SelectedModeID = nil,
    AllowRestock = true,
    bIsMatching = false,
}
local POPUP_PATHS = {
    Invitation = "Asset/Blueprint/Prefabs/UI/Recruit/InvitationList.InvitationList_C",
    RoomConfig = "Asset/Blueprint/Prefabs/UI/Recruit/RoomConfig.RoomConfig_C",
    SwitchMode = "Asset/Blueprint/Prefabs/UI/Recruit/SwitchMode.SwitchMode_C",
}

local LOBBY_MODE_ID = 1001
local GAME_MODE_CONFIG_PATH = "Asset/Data/Table/UGCGameModeConfig.UGCGameModeConfig"
local GAME_MODE_DETAIL_PATH = "Asset/Data/Table/UGCGameModeDetail.UGCGameModeDetail"
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

function RecruitManager:RegisterMainUI(MainUI)
    self.MainUI = MainUI
end

function RecruitManager:RegisterTeamHUD(TeamHUD)
    self.TeamHUD = TeamHUD
    local PlayerController = UGCGameSystem.GetLocalPlayerController()
    self.bIsMatching = PlayerController and PlayerController.LobbyInfo
            and PlayerController.LobbyInfo.bIsMatching == true or false
end

function RecruitManager:UnregisterTeamHUD(TeamHUD)
    if self.TeamHUD == TeamHUD then
        self.TeamHUD = nil
    end
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

function RecruitManager:NotifyChanged()
    if self.MainUI then
        self.MainUI:RefreshUI()
    end
    if self.TeamHUD then
        self.TeamHUD:RefreshModeInfo(self:GetSelectedModeID())
        self.TeamHUD:RefreshTeamState()
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

    self.ModeConfigByID = {}
    self.ModeIDsByMapKey = {}
    self.MapConfigs = {}

    local ModeRowsByID = {}
    local ModeRows = UGCGameSystem.GetTableData(UGCGameSystem.GetUGCResourcesFullPath(GAME_MODE_CONFIG_PATH)) or {}
    for _, ModeRow in pairs(ModeRows) do
        local ModeID = tonumber(ModeRow.ModeID)
        if ModeID then
            ModeRowsByID[ModeID] = ModeRow
        end
    end

    local DetailRows = UGCGameSystem.GetTableData(UGCGameSystem.GetUGCResourcesFullPath(GAME_MODE_DETAIL_PATH)) or {}
    for _, Detail in pairs(DetailRows) do
        local MapConfigsByKey = {}
        for _, RawModeID in ipairs(Detail.ModeIDs or {}) do
            local ModeID = tonumber(RawModeID)
            local ModeRow = ModeRowsByID[ModeID]
            if ModeID ~= LOBBY_MODE_ID and ModeRow then
                local MapName = ModeRow.ModeName
                local MapKey = tostring(Detail.ID) .. ":" .. tostring(MapName)
                local Config = CopyTable(Detail)
                Config.ModeID = ModeID
                Config.DetailID = Detail.ID
                Config.MapKey = MapKey
                Config.ModeName = MapName
                Config.Difficulty = ModeRow.Difficulty
                Config.UnlockDesc = ModeRow.UnlockDesc
                self.ModeConfigByID[ModeID] = Config
                self.ModeIDsByMapKey[MapKey] = self.ModeIDsByMapKey[MapKey] or {}
                table.insert(self.ModeIDsByMapKey[MapKey], ModeID)
                if not MapConfigsByKey[MapKey] then
                    MapConfigsByKey[MapKey] = CopyTable(Config)
                end
            end
        end
        if not Detail.Hide then
            for MapKey, MapConfig in pairs(MapConfigsByKey) do
                MapConfig.ModeIDs = self.ModeIDsByMapKey[MapKey]
                table.insert(self.MapConfigs, MapConfig)
            end
        end
    end
    table.sort(self.MapConfigs, function(Left, Right)
        return tonumber(Left.ModeID) < tonumber(Right.ModeID)
    end)
    self.bModeConfigLoaded = true
end

function RecruitManager:GetMapConfigs()
    self:LoadModeConfig()
    local Result = {}
    for _, MapConfig in ipairs(self.MapConfigs) do
        table.insert(Result, CopyTable(MapConfig))
    end
    return Result
end

function RecruitManager:GetModeConfig(ModeID)
    self:LoadModeConfig()
    return self.ModeConfigByID[tonumber(ModeID)]
end

function RecruitManager:GetMapConfigByModeID(ModeID)
    local ModeConfig = self:GetModeConfig(ModeID)
    if not ModeConfig then
        return nil
    end
    for _, MapConfig in ipairs(self.MapConfigs) do
        if MapConfig.MapKey == ModeConfig.MapKey then
            return MapConfig
        end
    end
    return nil
end

function RecruitManager:GetDifficultyConfigs(ModeID)
    self:LoadModeConfig()
    local Config = self.ModeConfigByID[tonumber(ModeID)]
    local Result = {}
    if Config then
        for _, DifficultyModeID in ipairs(self.ModeIDsByMapKey[Config.MapKey] or {}) do
            table.insert(Result, self.ModeConfigByID[DifficultyModeID])
        end
    end
    return Result
end

function RecruitManager:IsModeLocked(ModeID)
    local PlayerState = UGCGameSystem.GetLocalPlayerState()
    for _, UnlockedModeID in ipairs(PlayerState.GameCompletionRecord or {}) do
        if tonumber(UnlockedModeID) == tonumber(ModeID) then
            return false
        end
    end
    ---  默认先全部解锁
    return false
end

function RecruitManager:GetSelectedModeID()
    if self.CurrentRoom and self.CurrentRoom.Config then
        local RoomModeID = tonumber(self.CurrentRoom.Config.ModeID)
        if RoomModeID and RoomModeID ~= LOBBY_MODE_ID then
            return RoomModeID
        end
    end
    local SelectedModeID = tonumber(self.SelectedModeID)
    if SelectedModeID and SelectedModeID ~= LOBBY_MODE_ID then
        return SelectedModeID
    end
    local PlayerController = UGCGameSystem.GetLocalPlayerController()
    SelectedModeID = PlayerController and PlayerController.LobbyInfo
            and tonumber(PlayerController.LobbyInfo.SelectedModeID) or nil
    if SelectedModeID and SelectedModeID ~= LOBBY_MODE_ID then
        return SelectedModeID
    end
    local Maps = self:GetMapConfigs()
    return Maps[1] and Maps[1].ModeID or nil
end

function RecruitManager:SetSelectedModeID(ModeID)
    self:LoadModeConfig()
    ModeID = tonumber(ModeID)
    if not ModeID or ModeID == LOBBY_MODE_ID or not self.ModeConfigByID[ModeID] then
        return false
    end
    self.SelectedModeID = ModeID
    if self.CurrentRoom and self.CurrentRoom.Config then
        local ModeConfig = self.ModeConfigByID[ModeID]
        local MapConfig = self:GetMapConfigByModeID(ModeID)
        self.CurrentRoom.Config.ModeID = ModeID
        self.CurrentRoom.Config.Difficulty = ModeConfig.Difficulty
        self.CurrentRoom.Config.MapName = MapConfig.ModeName
        self.CurrentRoom.Config.Description = MapConfig.ModeDesc
        self.CurrentRoom.Config.MapImage = MapConfig.ModePost
    end
    local PlayerController = UGCGameSystem.GetLocalPlayerController()
    if PlayerController then
        UnrealNetwork.CallUnrealRPC(
            PlayerController,
            PlayerController,
            "RPC_Server_SetLobbySelectedModeID",
            ModeID
        )
    end
    self:NotifyChanged()
    return true
end

function RecruitManager:IsMatching()
    return self.bIsMatching == true
end

function RecruitManager:SetMatchingState(bIsMatching)
    self.bIsMatching = bIsMatching == true
    if self.TeamHUD then
        self.TeamHUD:SetMatchingState(self.bIsMatching)
    end
end

function RecruitManager:OnMatchResponse(bSucceeded)
    self:SetMatchingState(bSucceeded)
    local PlayerController = UGCGameSystem.GetLocalPlayerController()
    if PlayerController and PlayerController.bIsTeamLeader then
        UnrealNetwork.CallUnrealRPC(
            PlayerController,
            PlayerController,
            "RPC_Server_SetLobbybIsMatching",
            bSucceeded
        )
    end
end

function RecruitManager:CancelMatch()
    if not self:IsMatching() or not UGCMultiMode.RequestCancelMatch() then
        return false
    end
    self:SetMatchingState(false)
    local PlayerController = UGCGameSystem.GetLocalPlayerController()
    if PlayerController and PlayerController.bIsTeamLeader then
        UnrealNetwork.CallUnrealRPC(
            PlayerController,
            PlayerController,
            "RPC_Server_SetLobbybIsMatching",
            false
        )
    end
    return true
end

function RecruitManager:BuildDefaultRoomConfig()
    local SelectedModeID = self:GetSelectedModeID()
    local Maps = self:GetMapConfigs()
    local Mode = self:GetModeConfig(SelectedModeID) or Maps[1]
    local Map = self:GetMapConfigByModeID(SelectedModeID) or Maps[1]
    return {
        ModeID = Mode and Mode.ModeID or nil,
        MapName = Map and Map.ModeName or "",
        Description = Map and Map.ModeDesc or "",
        MapImage = Map and Map.ModePost or nil,
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
    self.SelectedModeID = tonumber(Room.Config.ModeID)
    self.AllowRestock = Room.Config.AllowRestock == true
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
    self.SelectedModeID = tonumber(Room.Config.ModeID)
    self.AllowRestock = Room.Config.AllowRestock == true
    self.Page = "Exist"
    self:RefreshLobbyMembers()
    self:NotifyChanged()
end

function RecruitManager:ClearCurrentRoom(bRemoveFromList)
    if bRemoveFromList then
        for Index = #self.Rooms, 1, -1 do
            if self.Rooms[Index] == self.CurrentRoom then
                table.remove(self.Rooms, Index)
                break
            end
        end
    end
    self.CurrentRoom = nil
    self.SelectedRoomIndex = nil
    self.Page = "Default"
end

function RecruitManager:ExitCurrentRoom()
    UGCTeamSystem.QuitLobbyTeam()
    self:ClearCurrentRoom(false)
    self:NotifyChanged()
end

function RecruitManager:DisbandCurrentRoom()
    UGCTeamSystem.QuitLobbyTeam()
    self:ClearCurrentRoom(true)
    self:NotifyChanged()
end

function RecruitManager:GetAllowRestock()
    if self.CurrentRoom then
        return self.CurrentRoom.Config.AllowRestock == true
    end
    return self.AllowRestock == true
end

function RecruitManager:SetAllowRestock(bAllowRestock)
    local bNewValue = bAllowRestock == true
    if self:GetAllowRestock() == bNewValue then
        return
    end
    self.AllowRestock = bNewValue
    if self.CurrentRoom then
        self.CurrentRoom.Config.AllowRestock = bNewValue
    end
    self:NotifyChanged()
end

function RecruitManager:StartGame()
    local Room = self.CurrentRoom
    local PlayerController = UGCGameSystem.GetLocalPlayerController()
    local GameState = UGCGameSystem.GameState
    local ModeID = self:GetSelectedModeID()
    local bAllowRestock = Room and Room.Config.AllowRestock == true or self:GetAllowRestock()
    local ModeSetting = UGCMultiMode.GetModeSetting(ModeID)
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
    --if self:IsModeLocked(Room.Config.ModeID) then
    --    UGCWidgetManagerSystem.ShowTipsUI("该模式尚未解锁")
    --    return
    --end
    UnrealNetwork.CallUnrealRPC(
        PlayerController,
        PlayerController,
        "RPC_Server_SetLobbySelectedModeID",
        ModeID
    )
    UnrealNetwork.CallUnrealRPC(
        PlayerController,
        PlayerController,
        "RPC_Server_SetFillTeammate",
        bAllowRestock
    )
    ugcprint("[Recruit] RequestMatch ModeID=" .. tostring(ModeID))
    UGCMultiMode.RequestMatch(ModeID, self.OnMatchResponse, self, bAllowRestock)
end

function RecruitManager:SaveRoomConfig(Config)
    if not self.CurrentRoom then
        return
    end
    self.CurrentRoom.Config = CopyTable(Config)
    self.SelectedModeID = tonumber(Config.ModeID)
    self.AllowRestock = Config.AllowRestock == true
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
        self.InvitationUI:OnClose()
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

function RecruitManager:OpenSwitchMode()
    if not self.SwitchModeUI then
        self.SwitchModeUI = CreatePopup(POPUP_PATHS.SwitchMode)
    end
    if self.SwitchModeUI then
        self.SwitchModeUI:SetVisibility(ESlateVisibility.Visible)
        self.SwitchModeUI:OnOpen()
        self.SwitchModeUI:OnUpdate()
    end
end

function RecruitManager:CloseSwitchMode()
    if self.SwitchModeUI then
        self.SwitchModeUI:SetVisibility(ESlateVisibility.Collapsed)
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

function RecruitManager:OnLobbyMembersChanged()
    self:RefreshLobbyMembers()
    local PlayerState = UGCGameSystem.GetLocalPlayerState()
    if self.CurrentRoom and #self.CurrentRoom.Members <= 1 and not PlayerState.bIsLobbyTeamLeader then
        self:ClearCurrentRoom(true)
    end
    self:NotifyChanged()
end

function RecruitManager:GetTeamState()
    local PlayerController = UGCGameSystem.GetLocalPlayerController()
    local PlayerState = UGCGameSystem.GetLocalPlayerState()
    local Room = self.CurrentRoom
    local Members = Room and Room.Members or {}
    return {
        Room = Room,
        Members = Members,
        bHasTeam = Room ~= nil,
        bLeader = PlayerState.bIsLobbyTeamLeader == true,
        bReady = PlayerState.bIsReadyInLobby == true,
        bTeamComplete = PlayerController.LobbyInfo.bTeamComplete == true,
        bAllowRestock = self:GetAllowRestock(),
    }
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
