---玩家存档服务。负责读取归档、恢复基础成长数据以及维护模式解锁记录。
local PlayerArchiveService = {}

local GameTypes = UGCGameSystem.UGCRequire("Script.Blueprint.GameFlow.Shared.GameTypes")

---读取所属玩家归档并刷新运行时 CustomData。
---@param PlayerState UGCPlayerState_C
function PlayerArchiveService.RefreshCustomData(PlayerState)
    if not UGCGameSystem.IsServer() then
        return
    end
    local UID = UGCGameSystem.GetUIDByPlayerState(PlayerState)
    PlayerState.CustomData = UGCPlayerStateSystem.GetPlayerArchiveData(UID) or {}
end

---所属玩家进入时恢复等级、经验和模式解锁记录。
---@param PlayerState UGCPlayerState_C
---@param MessageOrPlayerKey any
---@param PlayerKey number|nil
function PlayerArchiveService.OnPlayerEnter(PlayerState, MessageOrPlayerKey, PlayerKey)
    if not UGCGameSystem.IsServer() then
        return
    end

    PlayerKey = PlayerKey or MessageOrPlayerKey
    if UGCGameSystem.GetPlayerKeyByPlayerState(PlayerState) ~= PlayerKey then
        return
    end

    PlayerArchiveService.SetOnlineState(PlayerState, true)
    local UID = UGCGameSystem.GetUIDByPlayerState(PlayerState)
    local Data = UGCPlayerStateSystem.GetPlayerArchiveData(UID) or {}
    Data.UGCPlayerLevel = math.max(tonumber(Data.UGCPlayerLevel) or 1, 1)
    Data.PlayerExp = tonumber(Data.PlayerExp) or 0
    PlayerState.CustomData = Data
    PlayerState.PlayerExp = Data.PlayerExp
    PlayerState.UGCPlayerLevel = Data.UGCPlayerLevel
    PlayerArchiveService.InitializeCompletionRecord(PlayerState)
end

---设置并复制玩家在线状态。
---@param PlayerState UGCPlayerState_C
---@param bIsOnline boolean
function PlayerArchiveService.SetOnlineState(PlayerState, bIsOnline)
    if not UGCGameSystem.IsServer() then
        return
    end
    PlayerState.bIsOnline = bIsOnline == true
    UnrealNetwork.RepLazyProperty(PlayerState, "bIsOnline")
end

---合并必解锁模式与玩家存档，并保存、复制最终解锁列表。
---@param PlayerState UGCPlayerState_C
function PlayerArchiveService.InitializeCompletionRecord(PlayerState)
    if not UGCGameSystem.IsServer() then
        return
    end

    local UID = UGCGameSystem.GetUIDByPlayerState(PlayerState)
    local PlayerData = UGCPlayerStateSystem.GetPlayerArchiveData(UID) or {}
    PlayerData.GameCompletionRecord = PlayerData.GameCompletionRecord or {}

    local Existing = {}
    for _, ModeID in ipairs(PlayerData.GameCompletionRecord) do
        Existing[tonumber(ModeID)] = true
    end
    local RequiredModes = { GameTypes.ModeID.Lobby, GameTypes.ModeID.DefaultGameplay }
    for _, ModeID in ipairs(RequiredModes) do
        if not Existing[ModeID] then
            table.insert(PlayerData.GameCompletionRecord, ModeID)
        end
    end

    PlayerState.GameCompletionRecord = PlayerData.GameCompletionRecord
    UnrealNetwork.RepLazyProperty(PlayerState, "GameCompletionRecord")
    UGCPlayerStateSystem.SavePlayerArchiveData(UID, PlayerData)
end

return PlayerArchiveService
