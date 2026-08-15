---游戏会话服务。维护等待、开始、结束和关卡阶段状态。
local GameSessionService = {}

---初始化服务端会话状态。
---@param GameState UGCGameState_C
function GameSessionService.Initialize(GameState)
    if not UGCGameSystem.IsServer() then
        return
    end
    GameState.LevelState = GameState.LevelStateEnum.Waiting
end

---重置新关卡的会话阶段；首次开局前仍保持 Waiting，避免抢先消费启动入口。
---@param GameState UGCGameState_C
function GameSessionService.ResetLevel(GameState)
    if UGCGameSystem.IsServer()
        and GameState.LevelState ~= GameState.LevelStateEnum.Waiting then
        GameState.LevelState = GameState.LevelStateEnum.Game
    end
end

---从等待状态进入战斗，并启动第一波刷怪。
---@param GameState UGCGameState_C
---@return boolean
function GameSessionService.Start(GameState)
    if not UGCGameSystem.IsServer()
        or GameState.LevelState ~= GameState.LevelStateEnum.Waiting then
        return false
    end
    GameState.LevelState = GameState.LevelStateEnum.Game
    if GameState.MobSpawnerManager then
        GameState.MobSpawnerManager:NextWave()
    end
    return true
end

---结束当前战斗并恢复等待状态。
---@param GameState UGCGameState_C
---@return boolean
function GameSessionService.Finish(GameState)
    if not UGCGameSystem.IsServer()
        or GameState.LevelState == GameState.LevelStateEnum.Waiting then
        return false
    end
    GameState.LevelState = GameState.LevelStateEnum.Waiting
    return true
end

return GameSessionService
