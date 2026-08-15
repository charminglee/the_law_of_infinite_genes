---数据表仓库。集中负责资源路径、表缓存和配置查询。
local GameConfigRepository = {}

local ReplicatedStateFactory = UGCGameSystem.UGCRequire(
    "Script.Blueprint.GameFlow.Shared.ReplicatedStateFactory"
)

local TablePaths = {
    Level = "Asset/Data/Level/UGCLevelConfig.UGCLevelConfig",
    GlobalLevel = "Asset/Data/Level/UGCLevelGlobal.UGCLevelGlobal",
    GameMode = "Asset/Data/Table/UGCGameModeConfig.UGCGameModeConfig"
}

local TableCache = {}

---把项目内资源相对路径转换为运行时完整路径。
---@param Path string
---@return string
local function GetFullPath(Path)
    return UGCGameSystem.GetUGCResourcesFullPath(Path)
end

---按逻辑名称读取并缓存整张数据表。
---@param Name string
---@return table
local function GetTable(Name)
    if TableCache[Name] == nil then
        TableCache[Name] = UGCGameSystem.GetTableData(GetFullPath(TablePaths[Name]))
    end
    return TableCache[Name] or {}
end

---读取指定数据表中的单行配置。
---@param Name string
---@param RowName any
---@return table|nil
local function GetRow(Name, RowName)
    return UGCGameSystem.GetTableDataByRowName(GetFullPath(TablePaths[Name]), tostring(RowName))
end

---按 ModeID 查找游戏模式配置行。
---@param ModeID number|string
---@return table|nil
local function FindGameModeConfig(ModeID)
    ModeID = tonumber(ModeID)
    for _, Config in pairs(GetTable("GameMode")) do
        if tonumber(Config.ModeID) == ModeID then
            return Config
        end
    end
    return nil
end

---清空数据表缓存，供热更或配置重载时调用。
function GameConfigRepository.ClearCache()
    TableCache = {}
end

---获取指定玩家等级的成长配置。
function GameConfigRepository.GetLevelConfig(Level)
    return GetRow("Level", Level)
end

---获取全局等级配置。
function GameConfigRepository.GetGlobalLevelConfig()
    return GetRow("GlobalLevel", "Global")
end

---获取指定模式的完整配置行。
function GameConfigRepository.GetGameModeConfig(ModeID)
    return FindGameModeConfig(ModeID)
end

---根据模式配置构造玩家独立的复活资源快照。
function GameConfigRepository.GetRespawnConfig(ModeID)
    return ReplicatedStateFactory.NewRespawnConfig(FindGameModeConfig(ModeID))
end

---获取指定模式的显示名称。
function GameConfigRepository.GetGameModeName(ModeID)
    local Config = FindGameModeConfig(ModeID)
    return Config and Config.ModeName or nil
end

---获取指定模式使用的关卡流程 ActorManager 资源路径。
function GameConfigRepository.GetGameModeActorMgrConfig(ModeID)
    local Config = FindGameModeConfig(ModeID)
    return Config and Config.GameModeActorMgr or nil
end

---获取完成指定模式后可解锁的模式 ID。
function GameConfigRepository.GetUnlockModeID(ModeID)
    local Config = FindGameModeConfig(ModeID)
    return Config and Config.UnlockMode or nil
end

---获取指定模式、关卡阶段结束后的商店掉落组 ID。
function GameConfigRepository.GetShopAfterLevelDropGroupID(ModeID, CurrentStage)
    local Config = FindGameModeConfig(ModeID)
    return Config and Config.ShopAfterLevel and Config.ShopAfterLevel[CurrentStage] or nil
end

---获取指定模式结算时奖励的经验数量。
function GameConfigRepository.GetSettlementExpCount(ModeID)
    local Config = FindGameModeConfig(ModeID)
    return Config and Config.SettlementExpCount or nil
end

---获取指定模式结算时奖励的天赋点数量。
function GameConfigRepository.GetSettlementTalentCount(ModeID)
    local Config = FindGameModeConfig(ModeID)
    return Config and Config.SettlementTalentCount or nil
end

return GameConfigRepository
