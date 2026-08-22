---@class UGCGameState_C:BP_UGCGameState_C
---@field GlobalEventComponent GlobalEventComponent_C
---@field SpecialEventManager SpecialEventManager_C
---@field MobSpawnerManager MobSpawnerManager_C
--Edit Below--
local UGCGameState = {}

UGCGameSystem.UGCRequire('Script.Common.ue_enum_custom')
UGCGameSystem.UGCRequire("Script.GameAttribute.game_attribute_type")
UGCGameSystem.UGCRequire("Script.Lib.Lib")
UGCGameSystem.UGCRequire("Script.Common.UGCLog")
UGCGameSystem.UGCRequire("Script.Common.Const")
UGCGameSystem.UGCRequire("Script.Common.Common")
UGCGameSystem.UGCRequire("Script.Common.Config")
UGCGameSystem.UGCRequire("Script.Common.CardCfg")
UGCGameSystem.UGCRequire("Script.Common.ItemCfg")
UGCGameSystem.UGCRequire("Script.Common.GeneTreeCfg")
UGCGameSystem.UGCRequire("Script.Common.TweenManager")
UGCGameSystem.UGCRequire("Script.Common.TimingListUtils")
UGCGameSystem.UGCRequire("Script.Common.RichText")
UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.UGCItem.UGCItemManager")
UGCGameSystem.UGCRequire("Script.Blueprint.UGCGameData")

local GameFlow = UGCGameSystem.UGCRequire("Script.Blueprint.GameFlow.GameFlow")

UGCGameState.DeadPlayerKeys = {}
UGCGameState.RespawnChanceCountDown = 10
UGCGameState.CurrentRespawnChanceCountDown = 0
UGCGameState.LevelStateEnum = {
    Waiting = -1,
    Game = 0,
    Victory = 1,
    Failure = 2,
}
UGCGameState.LevelState = UGCGameState.LevelStateEnum.Waiting

---GameState 生命周期入口：初始化全局运行状态并绑定关卡事件。
function UGCGameState:ReceiveBeginPlay()
    UGCGameState.SuperClass.ReceiveBeginPlay(self)
    self.bIsOpenShovelingAbility = true
    self:InitializeRuntimeState()
    self:Listen()

    if not UGCGameSystem.IsServer() then
        self:SetUIWidget()
    end
end

---GameState 销毁时清理全灭倒计时。
function UGCGameState:ReceiveEndPlay()
    GameFlow.TeamWipe.Shutdown(self)
    UGCGameState.SuperClass.ReceiveEndPlay(self)
end

---初始化每局独立的服务端权威状态；客户端不覆盖复制属性。
function UGCGameState:InitializeRuntimeState()
    GameFlow.Session.Initialize(self)
    GameFlow.TeamWipe.Initialize(self)
end

---监听关卡开始事件，用于重置每关战斗数据。
function UGCGameState:Listen()
    UGCGenericMessageSystem.ListenGlobalMessage(self, "UGC.LevelFlow.LevelBegin", self, self.ResetData)
end

---重置关卡会话、全灭状态和客户端临时界面。
function UGCGameState:ResetData()
    if UGCGameSystem.IsServer() then
        GameFlow.Session.ResetLevel(self)
        GameFlow.TeamWipe.Reset(self)
    else
        GameFlow.ClientPresenter.OnLevelReset()
    end
end

---根据已同步的队员列表与 PlayerState 判断大厅成员是否全部准备。
---@return boolean
function UGCGameState:IsAllLobbyTeammateReady()
    return GameFlow.Lobby.IsAllTeammatesReady(self)
end

---服务端在全员死亡时启动唯一的复活机会倒计时。
function UGCGameState:StartRespawnChanceCountDown()
    GameFlow.TeamWipe.StartCountdown(self)
end

---移除倒计时 Timer，并把指定剩余值同步给客户端。
---@param ReplicatedValue number
function UGCGameState:ClearRespawnCountdown(ReplicatedValue)
    GameFlow.TeamWipe.ClearCountdown(self, ReplicatedValue)
end

---服务端停止全灭倒计时。
function UGCGameState:StopRespawnChanceCountDown()
    GameFlow.TeamWipe.StopCountdown(self)
end

---服务端计算剩余复活时间；归零时触发失败结算。
function UGCGameState:CalCulateRespawnChanceCountDown()
    GameFlow.TeamWipe.TickCountdown(self)
end

---记录死亡玩家；全员死亡后启动复活机会倒计时。
---@param PlayerKey number
function UGCGameState:OnPlayerDead(PlayerKey)
    GameFlow.TeamWipe.OnPlayerDead(self, PlayerKey)
end

---移除已复活玩家；只要有人存活就取消全灭倒计时。
---@param PlayerKey number
function UGCGameState:OnPlayerAlive(PlayerKey)
    GameFlow.TeamWipe.OnPlayerAlive(self, PlayerKey)
end

---声明 GameState 不对客户端开放 Lua 服务端 RPC。
function UGCGameState:GetAvailableServerRPCs()
    return
end

---声明需要复制的全局复活倒计时字段。
function UGCGameState:GetReplicatedProperties()
    return { "CurrentRespawnChanceCountDown", "Lazy" }
end

---客户端收到倒计时复制后刷新复活界面。
function UGCGameState:OnRep_CurrentRespawnChanceCountDown()
    GameFlow.ClientPresenter.OnRespawnCountdownReplicated(self)
end

---客户端替换主界面布局并隐藏不需要的原生控件。
function UGCGameState:SetUIWidget()
    GameFlow.ClientPresenter.SetMainUIWidget()
end

---按项目布局调整原生设置、语音和聊天控件位置。
function UGCGameState:SetUIPosition()
    GameFlow.ClientPresenter.SetMainUIPosition()
end

---服务端从等待状态进入战斗，并启动第一波刷怪。
---@return boolean
function UGCGameState:StartGame()
    return GameFlow.Session.Start(self)
end

---服务端结束当前战斗并恢复等待状态。
---@return boolean
function UGCGameState:EndGame()
    return GameFlow.Session.Finish(self)
end

---多播同步玩家当前装备的称号缓存。
---@param UID number|string
---@param ID number
function UGCGameState:MulticastRPC_EquippedTitle(UID, ID)
    ACHVManager.CacheEquippedTitle = ID
end

return UGCGameState
