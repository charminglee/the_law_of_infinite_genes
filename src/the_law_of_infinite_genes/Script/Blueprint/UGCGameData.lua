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

---获取指定怪物的详情配置。
function UGCGameData.GetMonsterConfig(MonsterID)
    return GameFlow.Config.GetMonsterConfig(MonsterID)
end

---获取指定装备的随机词缀配置。
function UGCGameData.GetEquippmentAffixConfig(EquipmentID)
    return GameFlow.Config.GetEquippmentAffixConfig(EquipmentID)
end

---获取全部词缀详情配置。
function UGCGameData.GetAffixDetailsAllConfig()
    return GameFlow.Config.GetAffixDetailsAllConfig()
end

---获取指定词缀的详情配置。
function UGCGameData.GetAffixDetailsConfig(AffixID)
    return GameFlow.Config.GetAffixDetailsConfig(AffixID)
end

---获取指定技能的详情配置。
function UGCGameData.GetSkillDetailsConfig(SkillID)
    return GameFlow.Config.GetSkillDetailsConfig(SkillID)
end

---获取全部物品与词缀映射配置。
function UGCGameData.GetItemMapAffixIDAllConfig()
    return GameFlow.Config.GetItemMapAffixIDAllConfig()
end

---获取指定物品的词缀映射配置。
function UGCGameData.GetItemMapAffixIDConfig(ItemID)
    return GameFlow.Config.GetItemMapAffixIDConfig(ItemID)
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

---把游戏属性类型映射为界面显示名称。
function UGCGameData.GetAttributeName(GameAttributeType)
    return GameFlow.Config.GetAttributeName(GameAttributeType)
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
