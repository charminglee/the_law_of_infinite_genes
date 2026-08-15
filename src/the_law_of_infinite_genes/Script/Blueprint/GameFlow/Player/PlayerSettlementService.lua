---玩家结算服务。统一处理结算幂等、游戏时长、模式解锁、存档和复制通知。
local PlayerSettlementService = {}

local UGCGameData = UGCGameSystem.UGCRequire("Script.Blueprint.UGCGameData")
local ReplicatedStateFactory = UGCGameSystem.UGCRequire(
    "Script.Blueprint.GameFlow.Shared.ReplicatedStateFactory"
)

---把配置中的单值或数组统一转换为去重后的 ModeID 数组。
---@param Value any
---@return table
local function NormalizeModeIDs(Value)
    local Result = {}
    local Existing = {}

    ---追加一个有效且未重复的模式 ID。
    ---@param ModeID any
    local function Append(ModeID)
        ModeID = tonumber(ModeID)
        if ModeID and not Existing[ModeID] then
            Existing[ModeID] = true
            table.insert(Result, ModeID)
        end
    end

    if type(Value) == "number" or type(Value) == "string" then
        Append(Value)
        return Result
    end

    local Values = Value
    if type(Values) ~= "table" and Values ~= nil and type(totable) == "function" then
        local bSucceeded, Converted = pcall(totable, Values)
        if bSucceeded then
            Values = Converted
        end
    end
    if type(Values) == "table" then
        for _, ModeID in pairs(Values) do
            Append(ModeID)
        end
    end
    return Result
end

---合并 PlayerState 与存档中的通关记录，并保持原有顺序。
---@param PlayerState UGCPlayerState_C
---@param PlayerData table
---@return table, table
local function MergeCompletionRecords(PlayerState, PlayerData)
    local Result = {}
    local Existing = {}

    ---把一组通关记录追加到合并结果中。
    ---@param Records table|nil
    local function AppendRecords(Records)
        for _, ModeID in ipairs(Records or {}) do
            ModeID = tonumber(ModeID)
            if ModeID and not Existing[ModeID] then
                Existing[ModeID] = true
                table.insert(Result, ModeID)
            end
        end
    end

    AppendRecords(PlayerState.GameCompletionRecord)
    AppendRecords(PlayerData.GameCompletionRecord)
    return Result, Existing
end

---解锁当前模式配置指定的后续模式，并保存、复制最新通关记录。
---@param PlayerState UGCPlayerState_C
---@return boolean
local function UnlockNextModes(PlayerState)
    local UID = UGCGameSystem.GetUIDByPlayerState(PlayerState)
    local PlayerData = UGCPlayerStateSystem.GetPlayerArchiveData(UID) or {}
    local CompletionRecord, Existing = MergeCompletionRecords(PlayerState, PlayerData)
    local UnlockModeIDs = NormalizeModeIDs(
        UGCGameData.GetUnlockModeID(UGCMultiMode.GetModeID())
    )

    local bUnlockedNewMode = false
    for _, ModeID in ipairs(UnlockModeIDs) do
        if not Existing[ModeID] then
            Existing[ModeID] = true
            bUnlockedNewMode = true
            table.insert(CompletionRecord, ModeID)
        end
    end

    PlayerState.GameCompletionRecord = CompletionRecord
    PlayerState.IsModeUnLock = bUnlockedNewMode
    PlayerData.GameCompletionRecord = CompletionRecord
    UnrealNetwork.RepLazyProperty(PlayerState, "GameCompletionRecord")
    UnrealNetwork.RepLazyProperty(PlayerState, "IsModeUnLock")
    UGCPlayerStateSystem.SavePlayerArchiveData(UID, PlayerData)
    return bUnlockedNewMode
end

---完成单个玩家结算；重复调用不会再次保存、解锁或发送复制。
---@param PlayerState UGCPlayerState_C
---@param IsFinish boolean|nil
---@return boolean
function PlayerSettlementService.Settle(PlayerState, IsFinish)
    if not UGCGameSystem.IsServer() or not PlayerState then
        return false
    end
    if PlayerState.SettleParams and PlayerState.SettleParams.bIsSettled then
        return false
    end

    local bIsFinished = IsFinish ~= false
    PlayerState:UpdateGameTime()
    local bUnlockedNewMode = false
    if bIsFinished then
        bUnlockedNewMode = UnlockNextModes(PlayerState)
    else
        PlayerState.IsModeUnLock = false
        UnrealNetwork.RepLazyProperty(PlayerState, "IsModeUnLock")
    end

    PlayerState.SettleParams = ReplicatedStateFactory.NewSettleParams()
    PlayerState.SettleParams.bIsSettled = true
    PlayerState.SettleParams.bIsFinished = bIsFinished
    PlayerState.SettleParams.bUnlockedNewMode = bUnlockedNewMode
    UnrealNetwork.RepLazyProperty(PlayerState, "SettleParams")
    return true
end

return PlayerSettlementService
