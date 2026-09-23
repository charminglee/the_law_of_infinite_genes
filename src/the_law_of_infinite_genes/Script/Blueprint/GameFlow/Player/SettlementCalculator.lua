---统一结算纯计算器。不读取 Actor、不修改存档，便于独立校验结算公式。
local SettlementCalculator = {}

local Config = UGCGameSystem.UGCRequire(
    "Script.Blueprint.GameFlow.Player.SettlementConfig"
)

---非负数四舍五入。所有奖励只在最终阶段调用。
---@param Value number|nil
---@return number
function SettlementCalculator.Round(Value)
    return math.floor(math.max(0, tonumber(Value) or 0) + 0.5)
end

---@param Score number
---@param TargetScore number
---@param PlayerCount number
---@param bIsFinished boolean
---@return number
function SettlementCalculator.CalculateCoefficient(Score, TargetScore, PlayerCount, bIsFinished)
    Score = math.max(0, tonumber(Score) or 0)
    TargetScore = math.max(1, tonumber(TargetScore) or Config.DefaultTeamContributionTarget)
    PlayerCount = math.max(1, tonumber(PlayerCount) or 1)

    local Coefficient
    if Score <= TargetScore then
        Coefficient = Score / TargetScore
        if bIsFinished then
            Coefficient = math.max(Config.Coefficient.CompletionFloor, Coefficient)
        end
    else
        Coefficient = 1 + (Score - TargetScore) / TargetScore * Config.Coefficient.OverflowScale
    end

    local Cap = PlayerCount == 1
        and Config.Coefficient.SinglePlayerCap
        or Config.Coefficient.MultiplayerCap
    return math.min(Cap, Coefficient)
end

---@param Entry table
---@param RandomValue number|nil
---@return number
local function RollBaseCount(Entry, RandomValue)
    RandomValue = RandomValue or math.random()
    if RandomValue < Config.Material.HighRollChance then
        return tonumber(Entry.Max) or tonumber(Entry.Min) or 0
    end
    return tonumber(Entry.Min) or 0
end

---@param Entries table
---@param DifficultyMultiplier number
---@param Coefficient number
---@param ExtraMultiplier number
---@param bCompletionGuarantee boolean
---@return table
local function CalculateMaterials(Entries, DifficultyMultiplier, Coefficient, ExtraMultiplier, bCompletionGuarantee)
    local Result = {}
    for _, Entry in ipairs(Entries or {}) do
        local BaseCount = RollBaseCount(Entry)
        local Count = SettlementCalculator.Round(
            BaseCount * DifficultyMultiplier * Coefficient * ExtraMultiplier
        )
        if bCompletionGuarantee then
            Count = math.max(1, Count)
        end
        if Count > 0 then
            table.insert(Result, {
                ItemId = Entry.ItemId,
                BaseCount = BaseCount,
                Count = Count,
            })
        end
    end
    return Result
end

---@param WeightedEntries table|nil
---@return number|nil
local function PickWeightedItem(WeightedEntries)
    local TotalWeight = 0
    for _, Entry in ipairs(WeightedEntries or {}) do
        TotalWeight = TotalWeight + math.max(0, tonumber(Entry.Weight) or 0)
    end
    if TotalWeight <= 0 then
        return nil
    end

    local Pick = math.random() * TotalWeight
    local Accumulated = 0
    for _, Entry in ipairs(WeightedEntries) do
        Accumulated = Accumulated + math.max(0, tonumber(Entry.Weight) or 0)
        if Pick <= Accumulated then
            return Entry.ItemId
        end
    end
    return WeightedEntries[#WeightedEntries].ItemId
end

---@param Snapshot table
---@param Context table
---@return table
function SettlementCalculator.CalculatePlayerResult(Snapshot, Context)
    local Score = math.max(0, tonumber(Snapshot.Score) or 0)
    local bIsFinished = Context.bIsFinished == true
    local Coefficient = SettlementCalculator.CalculateCoefficient(
        Score,
        Context.TargetScore,
        Context.PlayerCount,
        bIsFinished
    )
    local bStayedToEnd = Snapshot.bExitedEarly ~= true
    local bCanReceiveOrdinary = bStayedToEnd and (
        bIsFinished or Context.ProgressRatio >= Config.Material.WipeProgressThreshold
    )
    local bCanReceiveBoss = bIsFinished and bStayedToEnd and (Snapshot.BossDamage or 0) > 0
    local bCanReceiveCore = bIsFinished and bStayedToEnd

    local Guarantee = bIsFinished and bStayedToEnd
        and (Config.Gold.CompletionGuarantee[Context.Difficulty] or 0)
        or 0
    local Gold = SettlementCalculator.Round(
        Guarantee + Score / Config.Gold.ScoreDivisor * Coefficient
    )

    local SeasonBase = Snapshot.bDailyFirstClear
        and (Config.Experience.DailyFirstClear[Context.Difficulty] or 0)
        or (Config.Experience.NormalClear[Context.Difficulty] or 0)
    local SeasonExp = SettlementCalculator.Round(SeasonBase * Coefficient)
    local MeritExp = SettlementCalculator.Round(Score / Config.Experience.MeritScoreDivisor)

    local DifficultyMultiplier = Config.Material.DifficultyMultiplier[Context.Difficulty] or 1
    local Pool = Context.MaterialPool or {}
    local OrdinaryMultiplier = bIsFinished and 1 or Config.Material.WipeMultiplier
    local OrdinaryMaterials = bCanReceiveOrdinary and CalculateMaterials(
        Pool.Ordinary,
        DifficultyMultiplier,
        Coefficient,
        OrdinaryMultiplier,
        bIsFinished
    ) or {}
    local BossMaterials = bCanReceiveBoss and CalculateMaterials(
        Pool.Boss,
        DifficultyMultiplier,
        Coefficient,
        1,
        true
    ) or {}

    local CoreItemId
    if bCanReceiveCore then
        CoreItemId = PickWeightedItem(Config.Core[Context.Difficulty])
    end

    local SettlementTier = 4
    if Snapshot.bExitedEarly == true then
        SettlementTier = 1
    elseif bIsFinished and bCanReceiveBoss then
        SettlementTier = 3
    elseif bIsFinished then
        SettlementTier = 2
    end

    return {
        PlayerKey = Snapshot.PlayerKey,
        Score = Score,
        TargetScore = Context.TargetScore,
        Coefficient = Coefficient,
        ProgressRatio = Context.ProgressRatio,
        SettlementTier = SettlementTier,
        bIsFinished = bIsFinished,
        bExitedEarly = Snapshot.bExitedEarly == true,
        bObservedToEnd = Snapshot.bObservedToEnd == true,
        bBossEligible = bCanReceiveBoss,
        bDailyFirstClear = Snapshot.bDailyFirstClear == true,
        Eligibility = {
            CompletionGuarantee = bIsFinished and bStayedToEnd,
            OrdinaryMaterials = bCanReceiveOrdinary,
            BossMaterials = bCanReceiveBoss,
            Core = bCanReceiveCore,
        },
        Gold = Gold,
        SeasonExp = SeasonExp,
        MeritExp = MeritExp,
        OrdinaryMaterials = OrdinaryMaterials,
        BossMaterials = BossMaterials,
        CoreReward = CoreItemId and { ItemId = CoreItemId, Count = 1 } or nil,
        MultiplierCategory = nil,
    }
end

return SettlementCalculator
