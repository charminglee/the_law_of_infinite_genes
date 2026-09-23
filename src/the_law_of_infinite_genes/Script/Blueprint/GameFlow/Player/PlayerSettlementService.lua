---玩家结算服务。统一处理结算幂等、游戏时长、模式解锁、存档和复制通知。
local PlayerSettlementService = {}

UGCGameSystem.UGCRequire("Script.Common.Const")
UGCGameSystem.UGCRequire("Script.Common.GameFlowCfg")
UGCGameSystem.UGCRequire("Script.Common.UGCLog")

local UGCGameData = UGCGameSystem.UGCRequire("Script.Blueprint.UGCGameData")
local ReplicatedStateFactory = UGCGameSystem.UGCRequire(
    "Script.Blueprint.GameFlow.Shared.ReplicatedStateFactory"
)
local SettlementConfig = UGCGameSystem.UGCRequire(
    "Script.Blueprint.GameFlow.Player.SettlementConfig"
)
local SettlementCalculator = UGCGameSystem.UGCRequire(
    "Script.Blueprint.GameFlow.Player.SettlementCalculator"
)

---服务端更新结算资格采集字段。
---@param PlayerState UGCPlayerState_C
---@param Field string
---@param Value boolean
---@return boolean
local function SetRecordFlag(PlayerState, Field, Value)
    if not UGCGameSystem.IsServer() or not PlayerState or not PlayerState.GameRecordData then
        return false
    end
    PlayerState.GameRecordData[Field] = Value == true
    return true
end

---记录玩家已在观战界面持续至结算。
function PlayerSettlementService.SetObservedToEnd(PlayerState, bObserved)
    return SetRecordFlag(PlayerState, "bObservedToEnd", bObserved)
end

---记录玩家是否在结算前主动退出。
function PlayerSettlementService.SetExitedEarly(PlayerState, bExited)
    return SetRecordFlag(PlayerState, "bExitedEarly", bExited)
end

---登记本局是否使用一枚倍率币；实际扣除只发生在统一结算提交阶段。
function PlayerSettlementService.SetUseMultiplierCoin(PlayerState, bUse)
    return SetRecordFlag(PlayerState, "bUseMultiplierCoin", bUse)
end

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
    if PlayerState.PlayerDataManager and PlayerState.PlayerDataManager._data then
        PlayerState.PlayerDataManager._data.GameCompletionRecord = CompletionRecord
    end
    PlayerData.GameCompletionRecord = CompletionRecord
    UnrealNetwork.RepLazyProperty(PlayerState, "GameCompletionRecord")
    UnrealNetwork.RepLazyProperty(PlayerState, "IsModeUnLock")
    UGCPlayerStateSystem.SavePlayerArchiveData(UID, PlayerData)
    return bUnlockedNewMode
end

---构造本局唯一标识。该标识同时用于运行时和存档幂等判断。
---@param InstanceID any
---@param PlayerStates table
---@return string
local function BuildMatchToken(InstanceID, PlayerStates)
    local StartTime = 0
    for _, PlayerState in ipairs(PlayerStates) do
        StartTime = math.max(StartTime, tonumber(PlayerState.GameStartTime) or 0)
    end
    return string.format(
        "%s:%s:%s",
        tostring(UGCMultiMode.GetModeID()),
        tostring(InstanceID or 0),
        tostring(StartTime)
    )
end

---读取服务端日期键。每日首通按服务器自然日计算。
---@return string
local function GetDailyKey()
    return os.date("%Y-%m-%d")
end

---@param PlayerState UGCPlayerState_C
---@param bIsFinished boolean
---@param DailyKey string
---@return table|nil
local function BuildPlayerSnapshot(PlayerState, bIsFinished, DailyKey)
    local PlayerDataManager = PlayerState.PlayerDataManager
    if not PlayerDataManager then
        return nil
    end

    local Record = PlayerState.GameRecordData or {}
    local bIsAlive = PlayerState.AliveState == UGCGameData.AliveState.Alive
    local LastFirstClear = PlayerDataManager:GetCustomData(
        SettlementConfig.ArchiveKeys.DailyFirstClear
    )
    return {
        PlayerState = PlayerState,
        PlayerController = UGCGameSystem.GetPlayerControllerByPlayerState(PlayerState),
        PlayerDataManager = PlayerDataManager,
        PlayerKey = UGCGameSystem.GetPlayerKeyByPlayerState(PlayerState),
        Score = PlayerDataManager:GetScore(),
        BossDamage = tonumber(Record.BossDamage) or 0,
        bExitedEarly = Record.bExitedEarly == true,
        -- TODO(SettlementEligibility): 接入观战界面的权威进入/退出事件后，移除在线死亡推断。
        bObservedToEnd = Record.bObservedToEnd == true
            or (PlayerState.bIsOnline == true and not bIsAlive),
        bUseMultiplierCoin = Record.bUseMultiplierCoin == true,
        -- 死亡观战可获得通关普通奖励，但不消耗每日首通双倍资格。
        bDailyFirstClear = bIsFinished
            and bIsAlive
            and Record.bExitedEarly ~= true
            and LastFirstClear ~= DailyKey,
    }
end

---@param PlayerCount number
---@param ModeConfig table
---@return number
local function CalculateTargetScore(PlayerCount, ModeConfig)
    local TeamTarget = tonumber(ModeConfig.TeamContributionTarget)
        or tonumber(ModeConfig.SettlementContributionTarget)
        or SettlementConfig.DefaultTeamContributionTarget
    if PlayerCount == 1 then
        return math.max(1, TeamTarget)
    end
    return math.max(1, TeamTarget / (PlayerCount + 1))
end

---@param Result table
local function DoubleRewardCategory(Result)
    local Categories = {}
    if Result.Gold > 0 then
        table.insert(Categories, "Gold")
    end
    if #Result.OrdinaryMaterials > 0 then
        table.insert(Categories, "OrdinaryMaterials")
    end
    if #Result.BossMaterials > 0 then
        table.insert(Categories, "BossMaterials")
    end
    if #Categories == 0 then
        return
    end

    local Category = Categories[math.random(1, #Categories)]
    Result.MultiplierCategory = Category
    if Category == "Gold" then
        Result.Gold = Result.Gold * 2
        return
    end
    for _, Reward in ipairs(Result[Category]) do
        Reward.Count = Reward.Count * 2
    end
end

---@param PlayerController any
---@param Rewards table
---@return boolean
local function GrantItems(PlayerController, Rewards)
    for _, Reward in ipairs(Rewards or {}) do
        local AddResult = UGCBackpackSystemV2.AddItemV2(
            PlayerController,
            Reward.ItemId,
            Reward.Count
        )
        if type(AddResult) ~= "number" or AddResult <= 0 then
            return false
        end
    end
    return true
end

---@param Snapshot table
---@param Result table
---@param MatchToken string
---@param DailyKey string
---@return boolean
local function CommitResult(Snapshot, Result, MatchToken, DailyKey)
    local PlayerDataManager = Snapshot.PlayerDataManager
    local LastReceipt = PlayerDataManager:GetCustomData(
        SettlementConfig.ArchiveKeys.LastReceipt
    )
    if LastReceipt and LastReceipt.MatchToken == MatchToken then
        return true
    end

    if Result.MultiplierCategory then
        if not PlayerDataManager:AddCoin(SettlementConfig.MultiplierCoin.ItemId, -1, false) then
            return false
        end
    end
    if Result.Gold > 0
        and not PlayerDataManager:AddCoin(SettlementConfig.Gold.ItemId, Result.Gold, false) then
        return false
    end
    if Result.SeasonExp > 0 and not PlayerDataManager:AddSeasonExp(Result.SeasonExp, false) then
        return false
    end
    if Result.MeritExp > 0 and not PlayerDataManager:AddCharacterExp(Result.MeritExp, false) then
        return false
    end
    -- 资源点和卡牌均为局内资产，结算存档时清空资源点。
    PlayerDataManager:SetCoin(ItemId.Coin_6, 0, false)
    if not GrantItems(Snapshot.PlayerController, Result.OrdinaryMaterials) then
        return false
    end
    if not GrantItems(Snapshot.PlayerController, Result.BossMaterials) then
        return false
    end
    if Result.CoreReward and not GrantItems(Snapshot.PlayerController, { Result.CoreReward }) then
        return false
    end

    if Result.bDailyFirstClear then
        PlayerDataManager:SaveCustomData(
            SettlementConfig.ArchiveKeys.DailyFirstClear,
            DailyKey,
            false
        )
    end
    PlayerDataManager:SaveCustomData(
        SettlementConfig.ArchiveKeys.LastReceipt,
        { MatchToken = MatchToken, Result = Result },
        false
    )
    PlayerDataManager:SyncData()
    return PlayerDataManager:Save()
end

---@param Snapshot table
---@param Context table
---@return boolean
local function SettleSnapshot(Snapshot, Context)
    local PlayerState = Snapshot.PlayerState
    if PlayerState.SettleParams and PlayerState.SettleParams.bIsSettled then
        return false
    end

    local LastReceipt = Snapshot.PlayerDataManager:GetCustomData(
        SettlementConfig.ArchiveKeys.LastReceipt
    )
    local Result
    if LastReceipt and LastReceipt.MatchToken == Context.MatchToken then
        Result = LastReceipt.Result
    else
        Result = SettlementCalculator.CalculatePlayerResult(Snapshot, Context)
        if Snapshot.bUseMultiplierCoin
            and Snapshot.PlayerDataManager:GetCoin(SettlementConfig.MultiplierCoin.ItemId) > 0 then
            DoubleRewardCategory(Result)
        end
        if not CommitResult(Snapshot, Result, Context.MatchToken, Context.DailyKey) then
            UGCLog.Log(
                "[Settlement] commit failed, PlayerKey=%s, MatchToken=%s",
                tostring(Snapshot.PlayerKey),
                Context.MatchToken
            )
            return false
        end
    end

    PlayerState:UpdateGameTime()
    PlayerState.GameRecordData.PlayerExp = Result.SeasonExp + Result.MeritExp
    UnrealNetwork.RepLazyProperty(PlayerState, "GameRecordData")
    local bUnlockedNewMode = false
    if Context.bIsFinished then
        bUnlockedNewMode = UnlockNextModes(PlayerState)
    else
        PlayerState.IsModeUnLock = false
        UnrealNetwork.RepLazyProperty(PlayerState, "IsModeUnLock")
    end

    PlayerState.SettleParams = ReplicatedStateFactory.NewSettleParams()
    PlayerState.SettleParams.bIsSettled = true
    PlayerState.SettleParams.bIsFinished = Context.bIsFinished
    PlayerState.SettleParams.bUnlockedNewMode = bUnlockedNewMode
    PlayerState.SettleParams.MatchToken = Context.MatchToken
    PlayerState.SettleParams.Result = Result
    UnrealNetwork.RepLazyProperty(PlayerState, "SettleParams")
    UGCLog.Log(
        "[Settlement] committed PlayerKey=%s Score=%s Coefficient=%.3f Gold=%d SeasonExp=%d MeritExp=%d Ordinary=%d Boss=%d Core=%s",
        tostring(Snapshot.PlayerKey),
        tostring(Result.Score),
        Result.Coefficient,
        Result.Gold,
        Result.SeasonExp,
        Result.MeritExp,
        #Result.OrdinaryMaterials,
        #Result.BossMaterials,
        tostring(Result.CoreReward and Result.CoreReward.ItemId or 0)
    )
    return true
end

---对当前关卡玩家生成同一份全局快照后统一结算。
---@param PlayerControllers table
---@param IsFinish boolean|nil
---@param InstanceID any
---@return number
function PlayerSettlementService.SettlePlayers(PlayerControllers, IsFinish, InstanceID)
    if not UGCGameSystem.IsServer() then
        return 0
    end

    local PlayerStates = {}
    for _, PlayerController in pairs(PlayerControllers or {}) do
        local PlayerState = UGCGameSystem.GetPlayerStateByPlayerController(PlayerController)
        if PlayerState then
            table.insert(PlayerStates, PlayerState)
        end
    end
    if #PlayerStates == 0 then
        return 0
    end

    local bIsFinished = IsFinish ~= false
    local ModeID = tonumber(UGCMultiMode.GetModeID())
    local ModeConfig = UGCGameData.GetGameModeConfig(ModeID) or {}
    local ModeDifficulty = ModeConfig.Difficulty or Difficulty.Simple
    local MapMaterialPools = SettlementConfig.Material.MapPools[ModeID] or {}
    local MaxWave = math.max(1, GameFlowCfg.GetMaxWave(ModeConfig))
    local CurrentWave = GameState and GameState.MobSpawnerManager
        and tonumber(GameState.MobSpawnerManager.waveIndex) or 0
    local DailyKey = GetDailyKey()
    local Context = {
        MatchToken = BuildMatchToken(InstanceID, PlayerStates),
        ModeID = ModeID,
        Difficulty = ModeDifficulty,
        bIsFinished = bIsFinished,
        PlayerCount = #PlayerStates,
        ProgressRatio = bIsFinished and 1 or math.min(1, CurrentWave / MaxWave),
        MaterialPool = MapMaterialPools[ModeDifficulty] or {},
        DailyKey = DailyKey,
    }
    Context.TargetScore = CalculateTargetScore(Context.PlayerCount, ModeConfig)

    if Context.TargetScore == SettlementConfig.DefaultTeamContributionTarget then
        UGCLog.Log(
            "[Settlement] TODO default contribution target is active, ModeID=%s, Target=%s",
            tostring(ModeID),
            tostring(Context.TargetScore)
        )
    end

    local SettledCount = 0
    for _, PlayerState in ipairs(PlayerStates) do
        local Snapshot = BuildPlayerSnapshot(PlayerState, bIsFinished, DailyKey)
        if Snapshot and SettleSnapshot(Snapshot, Context) then
            SettledCount = SettledCount + 1
        end
    end
    return SettledCount
end

---兼容旧的单玩家调用；新关卡结算应统一调用 SettlePlayers。
---@param PlayerState UGCPlayerState_C
---@param IsFinish boolean|nil
---@return boolean
function PlayerSettlementService.Settle(PlayerState, IsFinish)
    if not UGCGameSystem.IsServer() or not PlayerState then
        return false
    end
    local PlayerController = UGCGameSystem.GetPlayerControllerByPlayerState(PlayerState)
    if not PlayerController then
        return false
    end
    return PlayerSettlementService.SettlePlayers({ PlayerController }, IsFinish, "Legacy") > 0
end

return PlayerSettlementService
