---GameFlow 统一入口。按首次访问惰性加载模块，避免服务端提前加载客户端表现层。
local GameFlow = {}

local ModulePaths = {
    Types = "Script.Blueprint.GameFlow.Shared.GameTypes",
    StateFactory = "Script.Blueprint.GameFlow.Shared.ReplicatedStateFactory",
    Config = "Script.Blueprint.GameFlow.Data.GameConfigRepository",
    Lobby = "Script.Blueprint.GameFlow.Lobby.LobbyTeamService",
    Session = "Script.Blueprint.GameFlow.Combat.GameSessionService",
    TeamWipe = "Script.Blueprint.GameFlow.Combat.TeamWipeService",
    Respawn = "Script.Blueprint.GameFlow.Player.PlayerRespawnService",
    Archive = "Script.Blueprint.GameFlow.Player.PlayerArchiveService",
    Record = "Script.Blueprint.GameFlow.Player.PlayerRecordService",
    Settlement = "Script.Blueprint.GameFlow.Player.PlayerSettlementService",
    ClientBootstrap = "Script.Blueprint.GameFlow.Client.GameClientBootstrap",
    ClientPresenter = "Script.Blueprint.GameFlow.Client.GameClientPresenter",
}

---首次访问模块时加载并缓存，后续访问直接返回同一模块实例。
---@param Target table
---@param Name string
---@return table|nil
local function LoadModule(Target, Name)
    local Path = ModulePaths[Name]
    if not Path then
        return nil
    end
    local Module = UGCGameSystem.UGCRequire(Path)
    rawset(Target, Name, Module)
    return Module
end

return setmetatable(GameFlow, { __index = LoadModule })
