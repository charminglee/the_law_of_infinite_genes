---复制状态工厂。所有可变 Table 都通过这里创建，避免 Actor 实例共享同一份默认值。
local ReplicatedStateFactory = {}

local GameTypes = UGCGameSystem.UGCRequire("Script.Blueprint.GameFlow.Shared.GameTypes")

---创建独立的大厅快照。
---@param Source table|nil
---@return table
function ReplicatedStateFactory.NewLobbyInfo(Source)
    Source = Source or {}
    return {
        SelectedModeID = tonumber(Source.SelectedModeID) or GameTypes.ModeID.DefaultGameplay,
        bFillTeammate = Source.bFillTeammate == true,
        bTeamComplete = Source.bTeamComplete ~= false,
        bIsMatching = Source.bIsMatching == true,
    }
end

---创建独立的单关统计记录。
---@return table
function ReplicatedStateFactory.NewLevelRecord()
    return {
        LevelDamage = 0,
        LevelMonsterKill = 0,
        LevelMonsterKillByType = { Monster = 0, EliteMonster = 0, Boss = 0 },
        LevelPlayerExp = 0,
        LevelTime = 0,
        LevelCriticalHit = 0,
    }
end

---创建独立的整局统计数据。
---@return table
function ReplicatedStateFactory.NewGameRecordData()
    return {
        LevelInfo = {},
        TotalDamage = 0,
        TotalMonsterKill = 0,
        TotalMonsterKillByType = { Monster = 0, EliteMonster = 0, Boss = 0 },
        PlayerExp = 0,
        GameTime = 0,
        TotalCriticalHit = 0,
        CurrentStage = 1,
        LikeNum = 0,
        Likes = {},
        ReceivedLikes = {},
    }
end

---创建独立的结算状态快照。
---@return table
function ReplicatedStateFactory.NewSettleParams()
    return {
        bIsSettled = false,
        bIsFinished = true,
        bUnlockedNewMode = false,
    }
end

---根据模式配置创建独立的复活资源快照。
---@param Config table|nil
---@return table
function ReplicatedStateFactory.NewRespawnConfig(Config)
    Config = Config or {}
    local FreeCount = tonumber(Config.FreeReviveCount) or 0
    local PaidCount = tonumber(Config.PaidReviveCount) or 0
    local PriceConfig = Config.Price or {}
    return {
        TotalFreeReviveCount = FreeCount,
        CurrentFreeReviveCount = FreeCount,
        TotalPaidReviveCount = PaidCount,
        CurrentPaidReviveCount = PaidCount,
        CurrencyID = tonumber(PriceConfig[1]) or 0,
        Price = tonumber(PriceConfig[2]) or 0,
    }
end

return ReplicatedStateFactory
