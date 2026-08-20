---@class UGCPlayerController_C:BP_UGCPlayerController_C
---@field GunsComponent GunsComponent_C
---@field KenlComposeComponent KenlComposeComponent_C
---@field AppraisalComponent ppraisalComponent_C
---@field ReinfComponent ReinfComponent_C
---@field PureComponent PureComponent_C
---@field FortifyComponent FortifyComponent_C
---@field RecruitComponent RecruitComponent_C
---@field ComposeComponent ComposeComponent_C
---@field RaidInstanceComponent RaidInstanceComponent_C
---@field PassComponent PassComponent_C
---@field GeneComponent GeneComponent_C
---@field GlobalEventComponent GlobalEventComponent_C
---@field GachaComponent GachaComponent_C
---@field FightComponent FightComponent_C
---@field ACHVComponent CHVComponent_C
---@field StoreComponent StoreComponent_C
---@field HomeComponent HomeComponent_C
---@field RankingListComponent RankingListComponent_C
---@field ShopV2Component ShopV2Component_C
---@field LotteryComponent LotteryComponent_C
--Edit Below--
local UGCPlayerController = {}

local Delegate = require("common.Delegate")
local GameFlow = UGCGameSystem.UGCRequire("Script.Blueprint.GameFlow.GameFlow")

UGCPlayerController.GamePartReady = false
UGCPlayerController.bIsTeamLeader = false
UGCPlayerController.LobbyTeammatePlayerKeys = {}
UGCPlayerController.LobbyInfo = GameFlow.StateFactory.NewLobbyInfo()
UGCPlayerController.OnLobbyTeammatePlayerKeysUpdate = Delegate.New()

---声明允许客户端请求的服务端 RPC 白名单。
function UGCPlayerController:GetAvailableServerRPCs()
    return "RPC_Server_EnterSpectating", "RPC_Server_SetLobbybIsMatching",
        "RPC_Server_RequestRespawn", "RPC_Server_SetLobbyReadyStatus",
        "RPC_Server_SetLobbySelectedModeID", "RPC_Server_SetFillTeammate",
        "RPC_Server_LikeOther"
end

---声明 Controller 负责复制的队长、队伍成员和大厅快照字段。
function UGCPlayerController:GetReplicatedProperties()
    return { "bIsTeamLeader", "Lazy" }, { "LobbyInfo", "Lazy" },
        { "LobbyTeammatePlayerKeys", "Lazy" }
end

---初始化非复制客户端状态和服务端权威大厅状态。
function UGCPlayerController:InitializeRuntimeState()
    self.GamePartReady = false
    GameFlow.Lobby.InitializeRuntimeState(self)
end

---Controller 生命周期入口，按服务端/客户端及大厅/战斗分派初始化。
function UGCPlayerController:ReceiveBeginPlay()
    UGCPlayerController.SuperClass.ReceiveBeginPlay(self)
    self:InitializeRuntimeState()

    if UGCGameSystem.IsServer() then
        if UGCGameData.IsLobbyMode(UGCMultiMode.GetModeID()) then
            self:HandleBeginPlayInServerForLobby()
        else
            self:HandleBeginPlayInServerForFighting()
        end
        return
    end

    LocalPlayerController = self ---@type UGCPlayerController_C
    if UGCGameData.IsLobbyMode(UGCMultiMode.GetModeID()) then
        self:HandleBeginPlayInClientForLobby()
    else
        self:HandleBeginPlayInClientForFighting()
    end
end

---Controller 销毁时清理客户端全局引用。
function UGCPlayerController:ReceiveEndPlay()
    UGCPlayerController.SuperClass.ReceiveEndPlay(self)
    if not UGCGameSystem.IsServer() and LocalPlayerController == self then
        LocalPlayerController = nil
    end
end

---服务端大厅职责：绑定队伍进入和退出事件。
function UGCPlayerController:HandleBeginPlayInServerForLobby()
    GameFlow.Lobby.BindServerEvents(self)
end

---服务端战斗侧初始化预留入口。
function UGCPlayerController:HandleBeginPlayInServerForFighting()
end

---客户端大厅侧初始化：进入大厅 UI 流程并等待组件就绪。
function UGCPlayerController:HandleBeginPlayInClientForLobby()
    GameFlow.ClientBootstrap.InitializeLobby(self)
end

---客户端战斗侧初始化：打开战斗界面并等待组件就绪。
function UGCPlayerController:HandleBeginPlayInClientForFighting()
    GameFlow.ClientBootstrap.InitializeFighting(self)
end

---创建时序检查，等待 GamePart 与 GameState 同时可用。
function UGCPlayerController:WaitForGamePartReady()
    GameFlow.ClientBootstrap.WaitForGamePartReady(self)
end

---服务端刷新当前玩家的大厅队友 PlayerKey。
function UGCPlayerController:RefreshLobbyTeammates()
    GameFlow.Lobby.RefreshTeammates(self)
end

---玩家进入时初始化队长身份、准备状态和大厅快照。
---@param MessageOrPlayerKey any
---@param PlayerKey number|nil
function UGCPlayerController:InitInServer(MessageOrPlayerKey, PlayerKey)
    GameFlow.Lobby.OnPlayerEnter(self, MessageOrPlayerKey, PlayerKey)
end

---玩家退出时把队伍标记为不完整并同步大厅快照。
---@param MessageOrPlayerKey any
---@param PlayerKey number|nil
function UGCPlayerController:OnPlayerExit(MessageOrPlayerKey, PlayerKey)
    GameFlow.Lobby.OnPlayerExit(self, MessageOrPlayerKey, PlayerKey)
end

---GamePart 与 GameState 就绪后恢复生存 UI 和结算 UI。
function UGCPlayerController:RecieveGamePartReady()
    GameFlow.ClientPresenter.OnGamePartReady(self)
end

---服务端处理玩家进入观战状态请求。
function UGCPlayerController:RPC_Server_EnterSpectating()
    if UGCGameSystem.IsServer() then
        UGCGameSystem.EnterSpectating(self)
    end
end

---客户端请求修改大厅准备状态。
---@param bIsReady boolean
function UGCPlayerController:SetLobbyReadyStatus(bIsReady)
    UnrealNetwork.CallUnrealRPC(self, self, "RPC_Server_SetLobbyReadyStatus", bIsReady == true)
end

---服务端将队长大厅快照复制到当前 Controller。
---@param LobbyInfo table|nil
function UGCPlayerController:SetLobbyInfo(LobbyInfo)
    GameFlow.Lobby.SetLobbyInfo(self, LobbyInfo)
end

---服务端队长把当前大厅快照同步给自己和所有队友。
function UGCPlayerController:BroadcastLobbyInfo()
    GameFlow.Lobby.BroadcastLobbyInfo(self)
end

---服务端处理玩家准备状态请求。
---@param bIsReady boolean
function UGCPlayerController:RPC_Server_SetLobbyReadyStatus(bIsReady)
    GameFlow.Lobby.SetReady(self, bIsReady)
end

---服务端执行救援或重新生成玩家。
---@return boolean
function UGCPlayerController:RPC_Server_RespawnPlayer()
    return GameFlow.Respawn.ExecuteRespawn(self)
end

---客户端根据当前模式打开复活界面。
function UGCPlayerController:OpenRespawnUI()
    GameFlow.ClientPresenter.OpenRespawnUI()
end

---服务端校验复活次数或货币，成功后执行复活并扣除资源。
---@param bFreeRespawn boolean
function UGCPlayerController:RPC_Server_RequestRespawn(bFreeRespawn)
    GameFlow.Respawn.RequestRespawn(self, bFreeRespawn)
end

---队长切换模式后，将所有非队长成员重置为未准备。
function UGCPlayerController:ResetTeammateReadyStates()
    GameFlow.Lobby.ResetTeammateReadyStates(self)
end

---服务端校验队长权限、解锁状态及人数后更新所选模式。
---@param ModeID number|string
function UGCPlayerController:RPC_Server_SetLobbySelectedModeID(ModeID)
    GameFlow.Lobby.SetSelectedMode(self, ModeID)
end

---服务端队长更新自动填充队友选项并广播大厅快照。
---@param bFillTeammate boolean
function UGCPlayerController:RPC_Server_SetFillTeammate(bFillTeammate)
    GameFlow.Lobby.SetFillTeammate(self, bFillTeammate)
end

---服务端队长更新匹配状态并广播大厅快照。
---@param bIsMatching boolean
function UGCPlayerController:RPC_Server_SetLobbybIsMatching(bIsMatching)
    GameFlow.Lobby.SetMatching(self, bIsMatching)
end

---服务端记录一次不可重复的玩家点赞。
---@param OtherPlayerKey number
function UGCPlayerController:RPC_Server_LikeOther(OtherPlayerKey)
    GameFlow.Record.LikeOther(self, OtherPlayerKey)
end

---客户端根据 PlayerState 结算快照打开战斗结果界面。
function UGCPlayerController:OnGameSettle()
    GameFlow.ClientPresenter.OpenBattleResult(self)
end

---客户端收到队伍成员列表后广播本地更新委托。
function UGCPlayerController:OnRep_LobbyTeammatePlayerKeys()
    GameFlow.ClientPresenter.OnLobbyTeammatesReplicated(self)
end

---客户端收到大厅快照后交给 LobbyModel 统一应用。
function UGCPlayerController:OnRep_LobbyInfo()
    GameFlow.ClientPresenter.OnLobbyInfoReplicated(self)
end

---Pawn 状态上报入口：把权威状态写入所属 PlayerState。
---@param State number
function UGCPlayerController:ChangeState(State)
    if not UGCGameSystem.IsServer() then
        return
    end
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerController(self)
    if PlayerState then
        GameFlow.Respawn.SetAliveState(PlayerState, State)
    end
end

---保留给蓝图调用的一次性 Lua 初始化入口。
function UGCPlayerController:LuaInit()
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true
end

return UGCPlayerController
