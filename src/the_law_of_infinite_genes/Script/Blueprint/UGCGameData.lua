---静态配置兼容门面。旧调用保持不变，具体查询交给 GameConfigRepository。
UGCGameData = UGCGameData or {}

local GameFlow = UGCGameSystem.UGCRequire("Script.Blueprint.GameFlow.GameFlow")

UGCGameData.ModeID = GameFlow.Types.ModeID
UGCGameData.ModeName = GameFlow.Types.ModeName
UGCGameData.AliveState = GameFlow.Types.AliveState

---清空配置仓库缓存。
function UGCGameData.ClearCache()
    GameFlow.Config.ClearCache()
end

---获取指定玩家等级的成长配置。
function UGCGameData.GetLevelConfig(Level)
    return GameFlow.Config.GetLevelConfig(Level)
end

---获取全局等级配置。
function UGCGameData.GetGlobalLevelConfig()
    return GameFlow.Config.GetGlobalLevelConfig()
end

---获取指定模式的完整配置行。
function UGCGameData.GetGameModeConfig(ModeID)
    return GameFlow.Config.GetGameModeConfig(ModeID)
end

---根据模式配置创建独立的复活资源快照。
function UGCGameData.GetRespawnConfig(ModeID)
    return GameFlow.Config.GetRespawnConfig(ModeID)
end

---获取指定模式的显示名称。
function UGCGameData.GetGameModeName(ModeID)
    return GameFlow.Config.GetGameModeName(ModeID)
end

---获取指定模式使用的关卡流程 ActorManager 路径。
function UGCGameData.GetGameModeActorMgrConfig(ModeID)
    return GameFlow.Config.GetGameModeActorMgrConfig(ModeID)
end

---获取完成指定模式后可解锁的模式 ID。
function UGCGameData.GetUnlockModeID(ModeID)
    return GameFlow.Config.GetUnlockModeID(ModeID)
end

---获取指定模式、关卡阶段结束后的商店掉落组 ID。
function UGCGameData.GetShopAfterLevelDropGroupID(ModeID, CurrentStage)
    return GameFlow.Config.GetShopAfterLevelDropGroupID(ModeID, CurrentStage)
end

---获取指定模式结算时奖励的经验数量。
function UGCGameData.GetSettlementExpCount(ModeID)
    return GameFlow.Config.GetSettlementExpCount(ModeID)
end

---获取指定模式结算时奖励的天赋点数量。
function UGCGameData.GetSettlementTalentCount(ModeID)
    return GameFlow.Config.GetSettlementTalentCount(ModeID)
end

---判断给定 ModeID 是否为大厅模式。
function UGCGameData.IsLobbyMode(ModeID)
    return tonumber(ModeID) == GameFlow.Types.ModeID.Lobby
end

return UGCGameData
