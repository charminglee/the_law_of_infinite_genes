---全灭服务。维护死亡玩家集合、复活机会倒计时以及失败结算。
local TeamWipeService = {}

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

---初始化服务端全灭运行状态。
---@param GameState UGCGameState_C
function TeamWipeService.Initialize(GameState)
    if not UGCGameSystem.IsServer() then
        return
    end
    GameState.CurrentRespawnChanceCountDown = 0
    GameState.DeadPlayerKeys = {}
    GameState.RespawnChanceCountDownTimer = nil
    GameState.RespawnChanceCountDownStartTime = nil
end

---重置死亡集合和复活机会倒计时。
---@param GameState UGCGameState_C
function TeamWipeService.Reset(GameState)
    if not UGCGameSystem.IsServer() then
        return
    end
    GameState.DeadPlayerKeys = {}
    TeamWipeService.ClearCountdown(GameState, 0)
end

---启动唯一的全灭复活机会倒计时。
---@param GameState UGCGameState_C
function TeamWipeService.StartCountdown(GameState)
    if not UGCGameSystem.IsServer()
        or GameState.RespawnChanceCountDownTimer
        or (tonumber(GameState.CurrentRespawnChanceCountDown) or 0) > 0 then
        return
    end
    GameState.RespawnChanceCountDownStartTime = UGCGameSystem.GetServerTimeSec()
    TeamWipeService.TickCountdown(GameState)
end

---移除倒计时 Timer，并把指定剩余值同步给客户端。
---@param GameState UGCGameState_C
---@param ReplicatedValue number
function TeamWipeService.ClearCountdown(GameState, ReplicatedValue)
    if not UGCGameSystem.IsServer() then
        return
    end
    if GameState.RespawnChanceCountDownTimer then
        UGCTimerUtility.RemoveLuaTimer(GameState.RespawnChanceCountDownTimer)
        GameState.RespawnChanceCountDownTimer = nil
    end
    GameState.CurrentRespawnChanceCountDown = tonumber(ReplicatedValue) or 0
    UnrealNetwork.RepLazyProperty(GameState, "CurrentRespawnChanceCountDown")
end

---停止全灭倒计时，以 -1 表示本次倒计时被取消。
---@param GameState UGCGameState_C
function TeamWipeService.StopCountdown(GameState)
    TeamWipeService.ClearCountdown(GameState, -1)
end

---计算并同步倒计时；归零时触发失败结算。
---@param GameState UGCGameState_C
function TeamWipeService.TickCountdown(GameState)
    if not UGCGameSystem.IsServer() or not GameState.RespawnChanceCountDownStartTime then
        return
    end

    local Elapsed = UGCGameSystem.GetServerTimeSec() - GameState.RespawnChanceCountDownStartTime
    GameState.CurrentRespawnChanceCountDown = math.max(0, GameState.RespawnChanceCountDown - Elapsed)
    UnrealNetwork.RepLazyProperty(GameState, "CurrentRespawnChanceCountDown")

    if GameState.CurrentRespawnChanceCountDown > 0 then
        GameState.RespawnChanceCountDownTimer = UGCTimerUtility.CreateLuaTimer(1, function()
            GameState.RespawnChanceCountDownTimer = nil
            TeamWipeService.TickCountdown(GameState)
        end, false)
        return
    end

    GameState.RespawnChanceCountDownTimer = nil
    if #(GameState.PlayerArray or {}) > 0 then
        UGCLevelFlowSystem.GameSettle(false)
    end
end

---记录死亡玩家；全员死亡后启动复活机会倒计时。
---@param GameState UGCGameState_C
---@param PlayerKey number
function TeamWipeService.OnPlayerDead(GameState, PlayerKey)
    if not UGCGameSystem.IsServer() or PlayerKey == nil then
        return
    end
    GameState.DeadPlayerKeys = GameState.DeadPlayerKeys or {}
    if GameState.DeadPlayerKeys[PlayerKey] then
        return
    end
    GameState.DeadPlayerKeys[PlayerKey] = true
    local PlayerCount = #(GameState.PlayerArray or {})
    if PlayerCount > 0 and CountKeys(GameState.DeadPlayerKeys) >= PlayerCount then
        TeamWipeService.StartCountdown(GameState)
    end
end

---移除已复活玩家；只要有人存活就取消全灭倒计时。
---@param GameState UGCGameState_C
---@param PlayerKey number
function TeamWipeService.OnPlayerAlive(GameState, PlayerKey)
    if not UGCGameSystem.IsServer()
        or PlayerKey == nil
        or not GameState.DeadPlayerKeys
        or not GameState.DeadPlayerKeys[PlayerKey] then
        return
    end
    GameState.DeadPlayerKeys[PlayerKey] = nil
    if CountKeys(GameState.DeadPlayerKeys) < #(GameState.PlayerArray or {}) then
        TeamWipeService.StopCountdown(GameState)
    end
end

---GameState 销毁时只清理本地 Timer，不再发起复制。
---@param GameState UGCGameState_C
function TeamWipeService.Shutdown(GameState)
    if GameState.RespawnChanceCountDownTimer then
        UGCTimerUtility.RemoveLuaTimer(GameState.RespawnChanceCountDownTimer)
        GameState.RespawnChanceCountDownTimer = nil
    end
end

return TeamWipeService
