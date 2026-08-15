---@class UGCPlayerState_C:BP_UGCPlayerState_C
---@field ItemDataManager ItemDataManager_C
---@field PlayerDataManager PlayerDataManager_C
--Edit Below--
local UGCPlayerState = {}

local Delegate = require("common.Delegate")
local UGCGameData = UGCGameSystem.UGCRequire("Script.Blueprint.UGCGameData")
local GameFlow = UGCGameSystem.UGCRequire("Script.Blueprint.GameFlow.GameFlow")

UGCPlayerState.PlayerLevelChangedDelegate = Delegate.New()
UGCPlayerState.PlayerExpChangedDelegate = Delegate.New()
UGCPlayerState.PlayerGameGameRecordDataDelegate = Delegate.New()
UGCPlayerState.ReadyStateUpdateDelegate = Delegate.New()
UGCPlayerState.OnlineStateUpdateDelegate = Delegate.New()

UGCPlayerState.RespawnConfig = {}
UGCPlayerState.GameRecordData = GameFlow.StateFactory.NewGameRecordData()
UGCPlayerState.GameCompletionRecord = {}
UGCPlayerState.SettleParams = GameFlow.StateFactory.NewSettleParams()
UGCPlayerState.IsModeUnLock = false
UGCPlayerState.AliveState = UGCGameData.AliveState.Alive
UGCPlayerState.bIsReadyInLobby = false
UGCPlayerState.bIsPlayerInPortalDoor = false
UGCPlayerState.bIsOnline = true
UGCPlayerState.bIsLobbyTeamLeader = false

---声明玩家存档、战斗统计和大厅状态等复制字段。
function UGCPlayerState:GetReplicatedProperties()
    return { "RespawnConfig", "Lazy" }, { "GameRecordData", "Lazy" },
        { "GameCompletionRecord", "Lazy" }, { "bIsReadyInLobby", "Lazy" },
        { "SettleParams", "Lazy" }, { "bIsPlayerInPortalDoor", "Lazy" },
        { "IsModeUnLock", "Lazy" }, { "AliveState", "Lazy" },
        { "bIsOnline", "Lazy" }, { "bIsLobbyTeamLeader", "Lazy" },
        { "GameStartTime", "Lazy" }
end

---声明 PlayerState 不直接接收客户端 Lua RPC。
function UGCPlayerState:GetAvailableServerRPCs()
    return
end

---只在服务端创建每个玩家独立的可变复制状态。
function UGCPlayerState:InitializeRuntimeState()
    if not UGCGameSystem.IsServer() then
        return
    end
    self.RespawnConfig = {}
    self.GameRecordData = GameFlow.StateFactory.NewGameRecordData()
    self.GameCompletionRecord = {}
    self.SettleParams = GameFlow.StateFactory.NewSettleParams()
    self.IsModeUnLock = false
    self.AliveState = UGCGameData.AliveState.Alive
    self.bIsReadyInLobby = false
    self.bIsPlayerInPortalDoor = false
    self.bIsOnline = true
    self.bIsLobbyTeamLeader = false
end

---PlayerState 生命周期入口，按运行端初始化权威数据或本地战斗展示。
function UGCPlayerState:ReceiveBeginPlay()
    UGCPlayerState.SuperClass.ReceiveBeginPlay(self)
    if UGCGameSystem.IsServer() then
        self:InitializeRuntimeState()
        if UGCActorComponentUtility.GetOwner(self) then
            self:HandleBeginPlayInServer()
        end
        return
    end

    if self == UGCGameSystem.GetLocalPlayerState() then
        LocalPlayerState = self ---@type UGCPlayerState_C
    end
    if not UGCGameData.IsLobbyMode(UGCMultiMode.GetModeID()) then
        self:HandleBeginPlayInClientForFighting()
    end
end

---PlayerState 销毁时结算游戏时长或清理本地引用。
function UGCPlayerState:ReceiveEndPlay()
    UGCPlayerState.SuperClass.ReceiveEndPlay(self)
    if UGCGameSystem.IsServer() then
        self:UpdateGameTime()
    elseif self == UGCGameSystem.GetLocalPlayerState() then
        LocalPlayerState = nil
    end
end

---服务端初始化计时、全局消息监听、复活配置和战斗统计。
function UGCPlayerState:HandleBeginPlayInServer()
    if not UGCGameSystem.IsServer() then
        return
    end

    GameFlow.Record.StartSession(self)
    local Messages = UGCGenericMessageSystem.Messages.UGC
    UGCGenericMessageSystem.ListenGlobalMessage(self, Messages.PlayerPawn.PawnSpawn, self, self.OnPawnSpawn)
    UGCGenericMessageSystem.ListenGlobalMessage(self, Messages.PlayerPawn.PawnRespawn, self, self.OnPawnRespawn)
    UGCGenericMessageSystem.ListenGlobalMessage(self, Messages.LevelFlow.LevelBegin, self, self.UpdateCurrentStage)

    local Owner = UGCActorComponentUtility.GetOwner(self)
    UGCGenericMessageSystem.ListenGlobalMessage(self, Messages.Player.PlayerEnter, Owner, function(...)
        self:OnPlayerEnter(...)
    end)
    UGCGenericMessageSystem.ListenGlobalMessage(self, Messages.Player.PlayerLost, Owner, function(...)
        self:OnPlayerLost(...)
    end)
    UGCGenericMessageSystem.ListenGlobalMessage(self, Messages.Player.PlayerReconnect, Owner, function(...)
        self:OnPlayerReconnect(...)
    end)

    self.OnLevelChanged = Delegate.New()
    GameFlow.Respawn.InitializeConfig(self, UGCMultiMode.GetModeID())
    self:InitGameGameRecordData()
end

---组装结算界面需要的玩家展示与战绩快照。
---@return table
function UGCPlayerState:BuildResultPlayerData()
    return GameFlow.ClientPresenter.BuildResultPlayerData(self)
end

---客户端战斗侧首次注册结算玩家数据。
function UGCPlayerState:HandleBeginPlayInClientForFighting()
    GameFlow.ClientPresenter.RegisterResultPlayerState(self)
end

---所属 Pawn 生成时刷新该玩家的存档快照。
---@param MessageOrPlayerKey any
---@param PlayerKey number|nil
function UGCPlayerState:OnPawnSpawn(MessageOrPlayerKey, PlayerKey)
    PlayerKey = PlayerKey or MessageOrPlayerKey
    if PlayerKey == nil or UGCGameSystem.GetPlayerKeyByPlayerState(self) == PlayerKey then
        self:OnSpawnOrRespawn()
    end
end

---所属 Pawn 复活时刷新该玩家的存档快照。
---@param MessageOrPlayerKey any
---@param PlayerKey number|nil
function UGCPlayerState:OnPawnRespawn(MessageOrPlayerKey, PlayerKey)
    PlayerKey = PlayerKey or MessageOrPlayerKey
    if PlayerKey == nil or UGCGameSystem.GetPlayerKeyByPlayerState(self) == PlayerKey then
        self:OnSpawnOrRespawn()
    end
end

---服务端读取所属玩家的归档数据并写入运行时 CustomData。
function UGCPlayerState:OnSpawnOrRespawn()
    GameFlow.Archive.RefreshCustomData(self)
end

---所属玩家进入时恢复等级、经验和模式解锁记录。
---@param MessageOrPlayerKey any
---@param PlayerKey number|nil
function UGCPlayerState:OnPlayerEnter(MessageOrPlayerKey, PlayerKey)
    GameFlow.Archive.OnPlayerEnter(self, MessageOrPlayerKey, PlayerKey)
end

---所属玩家掉线时同步离线状态。
---@param MessageOrPlayerKey any
---@param PlayerKey number|nil
function UGCPlayerState:OnPlayerLost(MessageOrPlayerKey, PlayerKey)
    PlayerKey = PlayerKey or MessageOrPlayerKey
    if UGCGameSystem.GetPlayerKeyByPlayerState(self) == PlayerKey then
        self:SetOnlineState(false)
    end
end

---所属玩家重连时同步在线状态。
---@param MessageOrPlayerKey any
---@param PlayerKey number|nil
function UGCPlayerState:OnPlayerReconnect(MessageOrPlayerKey, PlayerKey)
    PlayerKey = PlayerKey or MessageOrPlayerKey
    if UGCGameSystem.GetPlayerKeyByPlayerState(self) == PlayerKey then
        self:SetOnlineState(true)
    end
end

---服务端设置并复制玩家在线状态。
---@param bIsOnline boolean
function UGCPlayerState:SetOnlineState(bIsOnline)
    GameFlow.Archive.SetOnlineState(self, bIsOnline)
end

---等待关卡流就绪后，为每个关卡创建独立统计记录。
function UGCPlayerState:InitGameGameRecordData()
    GameFlow.Record.InitializeLevelRecords(self)
end

---合并必解锁模式与玩家存档，并保存、复制最终解锁列表。
function UGCPlayerState:InitGameCompletionRecord()
    GameFlow.Archive.InitializeCompletionRecord(self)
end

---服务端更新当前关卡阶段并复制战斗统计。
---@param MessageOrStage any
---@param CurrentStage number|nil
function UGCPlayerState:UpdateCurrentStage(MessageOrStage, CurrentStage)
    GameFlow.Record.UpdateCurrentStage(self, MessageOrStage, CurrentStage)
end

---服务端设置并复制玩家大厅准备状态。
---@param bIsReady boolean
function UGCPlayerState:SetLobbyReadyStatus(bIsReady)
    if UGCGameSystem.IsServer() then
        self.bIsReadyInLobby = bIsReady == true
        UnrealNetwork.RepLazyProperty(self, "bIsReadyInLobby")
    end
end

---服务端设置并复制玩家大厅队长身份。
---@param bIsTeamLeader boolean
function UGCPlayerState:SetIsLobbyTeamLeader(bIsTeamLeader)
    if UGCGameSystem.IsServer() then
        self.bIsLobbyTeamLeader = bIsTeamLeader == true
        UnrealNetwork.RepLazyProperty(self, "bIsLobbyTeamLeader")
    end
end

---唯一的生存状态写入口，并通知 GameState 维护全灭状态。
---@param State number
---@return boolean
function UGCPlayerState:SetAliveState(State)
    return GameFlow.Respawn.SetAliveState(self, State)
end

---服务端扣除一次免费复活次数，最小值限制为零。
function UGCPlayerState:ReduceFreeRespawnCount()
    GameFlow.Respawn.ReduceFreeCount(self)
end

---服务端扣除一次付费复活次数，最小值限制为零。
function UGCPlayerState:ReducePaidRespawnCount()
    GameFlow.Respawn.ReducePaidCount(self)
end

---客户端收到战绩复制后刷新结算缓存与结果界面。
function UGCPlayerState:OnRep_GameRecordData()
    GameFlow.ClientPresenter.OnGameRecordDataReplicated(self)
end

---客户端收到解锁记录后刷新大厅难度锁定状态。
function UGCPlayerState:OnRep_GameCompletionRecord()
    GameFlow.ClientPresenter.OnGameCompletionRecordReplicated(self)
end

---客户端收到准备状态后广播委托并刷新大厅操作区。
function UGCPlayerState:OnRep_bIsReadyInLobby()
    GameFlow.ClientPresenter.OnLobbyReadyReplicated(self)
end

---客户端收到队长身份后广播委托并刷新大厅操作区。
function UGCPlayerState:OnRep_bIsLobbyTeamLeader()
    GameFlow.ClientPresenter.OnLobbyLeaderReplicated(self)
end

---客户端收到在线状态后广播在线状态更新委托。
function UGCPlayerState:OnRep_bIsOnline()
    GameFlow.ClientPresenter.OnOnlineStateReplicated(self)
end

---服务端根据开始时间更新并复制累计游戏时长。
function UGCPlayerState:UpdateGameTime()
    GameFlow.Record.UpdateGameTime(self)
end

---服务端完成玩家结算，并统一处理解锁、存档和复制。
---@param IsFinish boolean|nil
---@return boolean
function UGCPlayerState:Settle(IsFinish)
    return GameFlow.Settlement.Settle(self, IsFinish)
end

---客户端收到结算参数后打开结算界面。
function UGCPlayerState:OnRep_SettleParams()
    GameFlow.ClientPresenter.OnSettleParamsReplicated(self)
end

---客户端收到生存状态后切换复活界面。
function UGCPlayerState:OnRep_AliveState()
    GameFlow.ClientPresenter.OnAliveStateReplicated(self)
end

return UGCPlayerState
