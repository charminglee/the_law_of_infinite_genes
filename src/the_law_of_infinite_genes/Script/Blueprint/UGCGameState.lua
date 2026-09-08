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
UGCGameSystem.UGCRequire("Script.Common.GameFlowCfg")
UGCGameSystem.UGCRequire("Script.Common.TweenManager")
UGCGameSystem.UGCRequire("Script.Common.TimingListUtils")
UGCGameSystem.UGCRequire("Script.Common.RichText")
UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.UGCItem.UGCItemManager")
UGCGameSystem.UGCRequire("Script.Blueprint.UGCGameData")
UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Broadcast.BroadcastManager")

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

UGCGameState.score = 0
UGCGameState.remainingMobCount = 0
UGCGameState.difficulty = nil

function UGCGameState:GetReplicatedProperties()
    return
    { "CurrentRespawnChanceCountDown", "Lazy" },
    "score"
end

---GameState 生命周期入口：初始化全局运行状态并绑定关卡事件。
function UGCGameState:ReceiveBeginPlay()
    UGCGameState.SuperClass.ReceiveBeginPlay(self)
    self.bIsOpenShovelingAbility = true
    self.difficulty = UGCGameData.GetGameModeConfig(UGCMultiMode.GetModeID()).Difficulty
    self:InitializeRuntimeState()
    self:Listen()

    if not UGCGameSystem.IsServer() then
        self:SetUIWidget()
    end
end

---GameState 销毁时清理全灭倒计时。
function UGCGameState:ReceiveEndPlay()
    UGCGameState.SuperClass.ReceiveEndPlay(self)
    GameFlow.TeamWipe.Shutdown(self)
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
    self:_ResetScore()
    return GameFlow.Session.Start(self)
end

---服务端结束当前战斗并恢复等待状态。
---@return boolean
function UGCGameState:EndGame()
    return GameFlow.Session.Finish(self)
end

---【服务端】增加分数。
---@param score number 分数
function UGCGameState:AddScore(score)
    if not Lib.IsServer() then
        return
    end
    local oldScore = self.score
    self.score = self.score + score
    Lib.EventSystem.Broadcast(Event.OnGameScoreChanged, oldScore, self.score)
end

---【双端】获取当前分数。
---@return number @分数
function UGCGameState:GetScore()
    return self.score
end

function UGCGameState:_ResetScore()
    if not Lib.IsServer() then
        return
    end
    local oldScore = self.score
    self.score = 0
    Lib.EventSystem.Broadcast(Event.OnGameScoreChanged, oldScore, self.score)
end

---【双端】获取当前回合数（关卡数）。
function UGCGameState:GetWaveIndex()
    return self.MobSpawnerManager.waveIndex
end

function UGCGameState:_AddRemainMobCount(delta)
    delta = delta or 1
    local oldCount = self.remainingMobCount
    local newCount = math.max(0, oldCount + delta)
    if newCount == oldCount then
        return
    end
    self.remainingMobCount = newCount
    Lib.EventSystem.Dispatch(Event.OnRemainingMobCountChanged, oldCount, newCount)
end

---【双端】获取剩余怪物数。
---@return number @剩余怪物数
function UGCGameState:GetRemainingMobCount()
    return self.remainingMobCount
end

---按波次在关键点曲线上线性插值取倍率；曲线两端之外按最近的关键点取值。
---@param curve {Wave:number, Multiplier:number}[] @按 Wave 严格递增排列的关键点
---@param waveIndex number @波次编号，从 1 开始
---@return number @倍率
local function _EvaluateMobMultiplier(curve, waveIndex)
    if type(curve) ~= "table" or #curve == 0 then
        return 1
    end
    if waveIndex <= curve[1].Wave then
        return curve[1].Multiplier
    end
    for i = 2, #curve do
        local prevPoint = curve[i - 1]
        local currPoint = curve[i]
        if waveIndex <= currPoint.Wave then
            local waveSpan = currPoint.Wave - prevPoint.Wave
            if waveSpan <= 0 then
                return currPoint.Multiplier
            end
            local alpha = (waveIndex - prevPoint.Wave) / waveSpan
            return prevPoint.Multiplier + (currPoint.Multiplier - prevPoint.Multiplier) * alpha
        end
    end
    return curve[#curve].Multiplier
end


---【双端】获取指定波次的怪物攻击力倍率。
---@param waveIndex number? @波次编号，默认为当前波次
---@return number @攻击力倍率
function UGCGameState:GetMonsterAttackMultiplier(waveIndex)
    waveIndex = waveIndex or self:GetWaveIndex()
    return _EvaluateMobMultiplier(GameFlowCfg.MobMultiplier.Attack, waveIndex)
end

---【双端】获取指定波次的怪物防御力倍率。
---@param waveIndex number? @波次编号，默认为当前波次
---@return number @防御力倍率
function UGCGameState:GetMonsterDefenseMultiplier(waveIndex)
    waveIndex = waveIndex or self:GetWaveIndex()
    return _EvaluateMobMultiplier(GameFlowCfg.MobMultiplier.Defense, waveIndex)
end

---【双端】获取指定波次的怪物血量倍率。
---@param waveIndex number? @波次编号，默认为当前波次
---@return number @血量倍率
function UGCGameState:GetMonsterHealthMultiplier(waveIndex)
    waveIndex = waveIndex or self:GetWaveIndex()
    return _EvaluateMobMultiplier(GameFlowCfg.MobMultiplier.Health, waveIndex)
end

---多播同步玩家当前装备的称号缓存。
---@param UID number|string
---@param ID number
function UGCGameState:MulticastRPC_EquippedTitle(UID, ID)
    ACHVManager.CacheEquippedTitle = ID
end

return UGCGameState












