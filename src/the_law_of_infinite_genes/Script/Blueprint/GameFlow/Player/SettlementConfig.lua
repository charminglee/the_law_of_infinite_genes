---统一结算配置。模块加载时不依赖 Const 的全局初始化顺序。
---物品 ID 与 Script.Common.Const 中的 ItemId 定义保持一致。
local ItemId = {
    Coin_1 = 8310001,
    Coin_3 = 8310003,
    BossMaterial_0 = 8310013,
    BossMaterial_1 = 8310014,
    EquipmentMaterial_3_1 = 8310015,
    EquipmentMaterial_4_1 = 8310016,
    EquipmentMaterial_5_1 = 8310017,
    Kenl_0_1 = 8310046,
    Kenl_0_2 = 8310044,
    Kenl_0_3 = 8310049,
    Kenl_0_4 = 8310050,
}

---难度键与 Script.Common.Const 中的 Difficulty 定义保持一致。
local Difficulty = {
    Simple = "简单",
    Normal = "普通",
    Hard = "困难",
    Nightmare = "噩梦",
}

local SettlementConfig = {}

SettlementConfig.DefaultTeamContributionTarget = 1
-- TODO(SettlementBalance): 当前仅用于避免目标贡献为 0。正式值应由模式配置表覆盖；
-- 使用该默认值会使有伤害的多人玩家很快达到 1.5 系数上限。

SettlementConfig.Coefficient = {
    CompletionFloor = 0.1,
    MultiplayerCap = 1.5,
    SinglePlayerCap = 1.0,
    OverflowScale = 0.5,
}

SettlementConfig.Gold = {
    ItemId = ItemId.Coin_3,
    ScoreDivisor = 2000,
    CompletionGuarantee = {
        [Difficulty.Simple] = 500,
        [Difficulty.Normal] = 300,
        [Difficulty.Hard] = 200,
        [Difficulty.Nightmare] = 100,
    },
}

SettlementConfig.Experience = {
    MeritScoreDivisor = 1000,
    -- TODO(SettlementBalance): 永久功勋换算比例仍需实测确认。
    DailyFirstClear = {
        [Difficulty.Simple] = 160,
        [Difficulty.Normal] = 200,
        [Difficulty.Hard] = 240,
        [Difficulty.Nightmare] = 300,
    },
    NormalClear = {
        [Difficulty.Simple] = 80,
        [Difficulty.Normal] = 100,
        [Difficulty.Hard] = 120,
        [Difficulty.Nightmare] = 150,
    },
}

SettlementConfig.Material = {
    HighRollChance = 0.4,
    WipeProgressThreshold = 0.4,
    WipeMultiplier = 0.5,
    DifficultyMultiplier = {
        [Difficulty.Simple] = 0.8,
        [Difficulty.Normal] = 1.0,
        [Difficulty.Hard] = 1.5,
        [Difficulty.Nightmare] = 3.0,
    },
    -- 当前仅录入第一张地图的掉落。后续地图未配置时必须返回空池，不能虚构 ItemID。
    DefaultMapPool = {
        [Difficulty.Simple] = {
            Ordinary = {
                { ItemId = ItemId.EquipmentMaterial_3_1, Min = 2, Max = 3 },
                { ItemId = ItemId.EquipmentMaterial_4_1, Min = 2, Max = 3 },
            },
            Boss = {},
        },
        [Difficulty.Normal] = {
            Ordinary = {
                { ItemId = ItemId.EquipmentMaterial_3_1, Min = 3, Max = 4 },
                { ItemId = ItemId.EquipmentMaterial_4_1, Min = 3, Max = 4 },
                { ItemId = ItemId.EquipmentMaterial_5_1, Min = 3, Max = 4 },
            },
            Boss = {},
        },
        [Difficulty.Hard] = {
            Ordinary = {
                { ItemId = ItemId.EquipmentMaterial_3_1, Min = 4, Max = 5 },
                { ItemId = ItemId.EquipmentMaterial_4_1, Min = 4, Max = 5 },
                { ItemId = ItemId.EquipmentMaterial_5_1, Min = 4, Max = 5 },
            },
            Boss = {
                { ItemId = ItemId.BossMaterial_0, Min = 1, Max = 1 },
            },
        },
        [Difficulty.Nightmare] = {
            Ordinary = {
                { ItemId = ItemId.EquipmentMaterial_3_1, Min = 5, Max = 6 },
                { ItemId = ItemId.EquipmentMaterial_4_1, Min = 5, Max = 6 },
                { ItemId = ItemId.EquipmentMaterial_5_1, Min = 5, Max = 6 },
            },
            Boss = {
                { ItemId = ItemId.BossMaterial_0, Min = 1, Max = 2 },
                { ItemId = ItemId.BossMaterial_1, Min = 1, Max = 1 },
            },
        },
    },
}

SettlementConfig.Material.MapPools = {
    [1002] = SettlementConfig.Material.DefaultMapPool,
}
-- TODO(SettlementBalance): 1003 及后续地图材料尚未定稿，未配置地图按空池处理。

SettlementConfig.Core = {
    [Difficulty.Hard] = {
        { ItemId = ItemId.Kenl_0_1, Weight = 1 },
        { ItemId = ItemId.Kenl_0_2, Weight = 1 },
    },
    [Difficulty.Nightmare] = {
        { ItemId = ItemId.Kenl_0_3, Weight = 1 },
        { ItemId = ItemId.Kenl_0_4, Weight = 1 },
    },
}
-- TODO(SettlementBalance): 核心档位当前使用 1:1 权重，正式权重待确认。

SettlementConfig.MultiplierCoin = {
    ItemId = ItemId.Coin_1,
    MaxPerMatch = 1,
    Scope = "Self",
    CanReroll = false,
    IncludeEmptyCategory = false,
}
-- TODO(SettlementBalance): 倍率币的单局上限、组队范围与重抽规则均为临时默认值。

SettlementConfig.ArchiveKeys = {
    DailyFirstClear = "Settlement.DailyFirstClear",
    LastReceipt = "Settlement.LastReceipt",
}

return SettlementConfig
