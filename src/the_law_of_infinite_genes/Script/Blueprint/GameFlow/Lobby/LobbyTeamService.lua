---大厅队伍服务。统一维护队长身份、队员列表、准备状态和大厅共享快照。
local LobbyTeamService = {}

local UGCGameData = UGCGameSystem.UGCRequire("Script.Blueprint.UGCGameData")
local ReplicatedStateFactory = UGCGameSystem.UGCRequire(
    "Script.Blueprint.GameFlow.Shared.ReplicatedStateFactory"
)

---获取 Controller 对应的 PlayerState。
---@param Controller UGCPlayerController_C
---@return UGCPlayerState_C|nil
local function GetPlayerState(Controller)
    return UGCGameSystem.GetPlayerStateByPlayerController(Controller)
end

---统计集合型 Map 中的有效键数量。
---@param Map table|nil
---@return number
local function CountKeys(Map)
    local Count = 0
    for _ in pairs(Map or {}) do
        Count = Count + 1
    end
    return Count
end

---创建 Controller 独立的服务端大厅运行状态。
---@param Controller UGCPlayerController_C
function LobbyTeamService.InitializeRuntimeState(Controller)
    if not UGCGameSystem.IsServer() then
        return
    end
    Controller.bIsTeamLeader = false
    Controller.LobbyTeammatePlayerKeys = {}
    Controller.LobbyInfo = ReplicatedStateFactory.NewLobbyInfo(Controller.LobbyInfo)
end

---绑定大厅玩家进入、退出事件。
---@param Controller UGCPlayerController_C
function LobbyTeamService.BindServerEvents(Controller)
    UGCGenericMessageSystem.ListenGlobalMessage(
        Controller,
        UGCGenericMessageSystem.Messages.UGC.Player.PlayerEnter,
        Controller,
        Controller.InitInServer
    )
    UGCGenericMessageSystem.ListenGlobalMessage(
        Controller,
        UGCGenericMessageSystem.Messages.UGC.Player.PlayerExit,
        Controller,
        Controller.OnPlayerExit
    )
end

---刷新并复制当前玩家的大厅队友 PlayerKey。
---@param Controller UGCPlayerController_C
function LobbyTeamService.RefreshTeammates(Controller)
    if not UGCGameSystem.IsServer() then
        return
    end

    if Lib.IsPIE() then
        Controller.LobbyTeammatePlayerKeys = UGCTeamSystem.GetPlayerKeysByTeamID(Controller.TeamID, true) or {}
    else
        Controller.LobbyTeammatePlayerKeys =
            UGCTeamSystem.GetLobbyTeammatePlayerKeysByPlayerKey(Controller.PlayerKey) or {}
    end
    UnrealNetwork.RepLazyProperty(Controller, "LobbyTeammatePlayerKeys")
end

---玩家进入时初始化队长身份、准备状态和大厅快照。
---@param Controller UGCPlayerController_C
---@param MessageOrPlayerKey any
---@param PlayerKey number|nil
function LobbyTeamService.OnPlayerEnter(Controller, MessageOrPlayerKey, PlayerKey)
    if not UGCGameSystem.IsServer() then
        return
    end

    PlayerKey = PlayerKey or MessageOrPlayerKey
    LobbyTeamService.RefreshTeammates(Controller)

    if PlayerKey == Controller.PlayerKey then
        Controller.bIsTeamLeader = Lib.IsPIE() and PlayerKey == 10001
            or UGCTeamSystem.GetIsLeaderOrNotByPlayerKey(PlayerKey)
        UnrealNetwork.RepLazyProperty(Controller, "bIsTeamLeader")

        local PlayerState = GetPlayerState(Controller)
        if PlayerState then
            PlayerState:SetIsLobbyTeamLeader(Controller.bIsTeamLeader)
            PlayerState:SetLobbyReadyStatus(Controller.bIsTeamLeader)
        end
    end

    if not Controller.bIsTeamLeader then
        return
    end
    if not Lib.IsPIE() then
        local PlayerKeys = UGCTeamSystem.GetLobbyTeammatePlayerKeysByPlayerKey(Controller.PlayerKey) or {}
        local UID = UGCGameSystem.GetUIDByPlayerController(Controller)
        local UIDs = UGCTeamSystem.GetLobbyTeammateUIDsByUID(UID) or {}
        Controller.LobbyInfo.bTeamComplete = #PlayerKeys == #UIDs
    end
    local JoinedController = UGCGameSystem.GetPlayerControllerByPlayerKey(PlayerKey)
    if JoinedController then
        LobbyTeamService.SetLobbyInfo(JoinedController, Controller.LobbyInfo)
    end
    UnrealNetwork.RepLazyProperty(Controller, "LobbyInfo")
end

---队员退出时把队伍标记为不完整并同步大厅快照。
---@param Controller UGCPlayerController_C
---@param MessageOrPlayerKey any
---@param PlayerKey number|nil
function LobbyTeamService.OnPlayerExit(Controller, MessageOrPlayerKey, PlayerKey)
    if not UGCGameSystem.IsServer() then
        return
    end

    PlayerKey = PlayerKey or MessageOrPlayerKey
    for _, TeammatePlayerKey in ipairs(Controller.LobbyTeammatePlayerKeys or {}) do
        if TeammatePlayerKey == PlayerKey then
            Controller.LobbyInfo.bTeamComplete = false
            UnrealNetwork.RepLazyProperty(Controller, "LobbyInfo")
            return
        end
    end
end

---将独立的大厅快照写入指定 Controller 并复制。
---@param Controller UGCPlayerController_C
---@param LobbyInfo table|nil
function LobbyTeamService.SetLobbyInfo(Controller, LobbyInfo)
    if not UGCGameSystem.IsServer() then
        return
    end
    Controller.LobbyInfo = ReplicatedStateFactory.NewLobbyInfo(LobbyInfo)
    UnrealNetwork.RepLazyProperty(Controller, "LobbyInfo")
end

---队长把当前大厅快照广播给自己和全部队友。
---@param Controller UGCPlayerController_C
function LobbyTeamService.BroadcastLobbyInfo(Controller)
    if not UGCGameSystem.IsServer() or not Controller.bIsTeamLeader then
        return
    end
    UnrealNetwork.RepLazyProperty(Controller, "LobbyInfo")

    for _, PlayerKey in ipairs(Controller.LobbyTeammatePlayerKeys or {}) do
        if PlayerKey ~= Controller.PlayerKey then
            local TeammateController = UGCGameSystem.GetPlayerControllerByPlayerKey(PlayerKey)
            if TeammateController then
                LobbyTeamService.SetLobbyInfo(TeammateController, Controller.LobbyInfo)
            end
        end
    end
end

---设置所属 PlayerState 的大厅准备状态。
---@param Controller UGCPlayerController_C
---@param bIsReady boolean
function LobbyTeamService.SetReady(Controller, bIsReady)
    if not UGCGameSystem.IsServer() then
        return
    end
    local PlayerState = GetPlayerState(Controller)
    if PlayerState then
        PlayerState:SetLobbyReadyStatus(bIsReady == true)
    end
end

---把所有非队长成员重置为未准备。
---@param Controller UGCPlayerController_C
function LobbyTeamService.ResetTeammateReadyStates(Controller)
    if not UGCGameSystem.IsServer() or not Controller.bIsTeamLeader then
        return
    end
    for _, PlayerKey in ipairs(Controller.LobbyTeammatePlayerKeys or {}) do
        if PlayerKey ~= Controller.PlayerKey then
            local TeammateController = UGCGameSystem.GetPlayerControllerByPlayerKey(PlayerKey)
            local PlayerState = TeammateController and GetPlayerState(TeammateController)
            if PlayerState then
                PlayerState:SetLobbyReadyStatus(false)
            end
        end
    end
end

---校验队长权限、模式解锁和人数限制后更新所选模式。
---@param Controller UGCPlayerController_C
---@param ModeID number|string
function LobbyTeamService.SetSelectedMode(Controller, ModeID)
    if not UGCGameSystem.IsServer() or not Controller.bIsTeamLeader then
        return
    end

    ModeID = tonumber(ModeID)
    local ModeSetting = ModeID and UGCMultiMode.GetModeSetting(ModeID)
    local PlayerState = GetPlayerState(Controller)
    if not ModeID or not UGCGameData.GetGameModeConfig(ModeID) or not ModeSetting or not PlayerState then
        return
    end

    local bUnlocked = false
    for _, UnlockedModeID in ipairs(PlayerState.GameCompletionRecord or {}) do
        if tonumber(UnlockedModeID) == ModeID then
            bUnlocked = true
            break
        end
    end
    local MaxPlayers = tonumber(ModeSetting.TeamPlayers) or 0
    if not bUnlocked or MaxPlayers <= 0 or #(Controller.LobbyTeammatePlayerKeys or {}) > MaxPlayers then
        return
    end

    if Controller.LobbyInfo.SelectedModeID ~= ModeID then
        Controller.LobbyInfo.SelectedModeID = ModeID
        LobbyTeamService.ResetTeammateReadyStates(Controller)
        LobbyTeamService.BroadcastLobbyInfo(Controller)
    end
end

---更新自动填充队友选项并广播大厅快照。
---@param Controller UGCPlayerController_C
---@param bFillTeammate boolean
function LobbyTeamService.SetFillTeammate(Controller, bFillTeammate)
    if not UGCGameSystem.IsServer() or not Controller.bIsTeamLeader then
        return
    end
    Controller.LobbyInfo.bFillTeammate = bFillTeammate == true
    LobbyTeamService.BroadcastLobbyInfo(Controller)
end

---更新匹配状态并广播大厅快照。
---@param Controller UGCPlayerController_C
---@param bIsMatching boolean
function LobbyTeamService.SetMatching(Controller, bIsMatching)
    if not UGCGameSystem.IsServer() or not Controller.bIsTeamLeader then
        return
    end
    Controller.LobbyInfo.bIsMatching = bIsMatching == true
    LobbyTeamService.BroadcastLobbyInfo(Controller)
end

---根据已同步的队员列表与 PlayerState 判断大厅成员是否全部准备。
---@param GameState UGCGameState_C
---@return boolean
function LobbyTeamService.IsAllTeammatesReady(GameState)
    local RequiredPlayerKeys = {}
    if Lib.IsPIE() then
        for _, PlayerState in ipairs(GameState.PlayerArray or {}) do
            RequiredPlayerKeys[UGCGameSystem.GetPlayerKeyByPlayerState(PlayerState)] = true
        end
    else
        local Controller = UGCGameSystem.GetLocalPlayerController()
        if not Controller then
            return false
        end
        for _, PlayerKey in ipairs(Controller.LobbyTeammatePlayerKeys or {}) do
            RequiredPlayerKeys[PlayerKey] = true
        end
    end

    if CountKeys(RequiredPlayerKeys) == 0 then
        return false
    end
    for _, PlayerState in ipairs(GameState.PlayerArray or {}) do
        local PlayerKey = UGCGameSystem.GetPlayerKeyByPlayerState(PlayerState)
        if RequiredPlayerKeys[PlayerKey] then
            if not PlayerState.bIsReadyInLobby then
                return false
            end
            RequiredPlayerKeys[PlayerKey] = nil
        end
    end
    return CountKeys(RequiredPlayerKeys) == 0
end

return LobbyTeamService
