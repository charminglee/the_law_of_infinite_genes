GameFlowCfg = GameFlowCfg or {}


GameFlowCfg.AutoSaveInterval = 30  -- 玩家数据自动保存间隔，单位秒
GameFlowCfg.SpawnerDelay = 10      -- 准备阶段时长


-- 怪物属性倍率曲线
GameFlowCfg.MobMultiplier = {
    -- 怪物攻击力倍率
    Attack = {
        { Wave = 1,  Multiplier = 1.00 },
        { Wave = 5,  Multiplier = 1.30 },
        { Wave = 10, Multiplier = 1.80 },
        { Wave = 15, Multiplier = 2.40 },
        { Wave = 20, Multiplier = 3.00 },
    },
    -- 怪物防御力倍率
    Defense = {
        { Wave = 1,  Multiplier = 1.00 },
        { Wave = 5,  Multiplier = 1.15 },
        { Wave = 10, Multiplier = 1.40 },
        { Wave = 15, Multiplier = 1.70 },
        { Wave = 20, Multiplier = 2.00 },
    },
    -- 怪物血量倍率
    Health = {
        { Wave = 1,  Multiplier = 1.00 },
        { Wave = 5,  Multiplier = 1.60 },
        { Wave = 10, Multiplier = 2.50 },
        { Wave = 15, Multiplier = 3.70 },
        { Wave = 20, Multiplier = 5.20 },
    },
}


-- 资源配置
GameFlowCfg.Resource = {
    OnKill = {
        -- 每类怪物掉落的资源点
        Loot = {
            [Tag.Normal] = { ItemId=ItemId.Coin_6, Count=2 },
            [Tag.Elite]  = { ItemId=ItemId.Coin_6, Count=10 },
            [Tag.Boss]   = { ItemId=ItemId.Coin_6, Count=50 },
        },
        -- 加分
        Score = {
            [Tag.Normal] = 20,
            [Tag.Elite]  = 100,
            [Tag.Boss]   = 500,
        },
        -- 赛季经验
        SeasonExp = {
            [Tag.Normal] = 2,
            [Tag.Elite]  = 10,
            [Tag.Boss]   = 50,
        },
        -- 永久经验（角色经验）
        CharacterExp = {
            [Tag.Normal] = 2,
            [Tag.Elite]  = 10,
            [Tag.Boss]   = 50,
        },
    },
    BossLoot = {
        -- 难度倍率
        DifficultyMultiplier = {
            Min = 0.8,
            Max = 2.0,
            [Difficulty.Simple]    = 0.8,
            [Difficulty.Normal]    = 1.0,
            [Difficulty.Hard]      = 1.3,
            [Difficulty.Nightmare] = 2.0,
        },
        -- 关卡倍率
        WaveMultiplier = {
            Min = 1.0,
            Max = 2.0,
            [5]  = 1.0,
            [10] = 1.2,
            [15] = 1.2,
            [20] = 1.5,
            [25] = 2.0,
            [30] = 2.0,
        },
        -- 奖励物品池
        RewardPool = {
            { ItemId=ItemId.EquipmentMaterial_3_1, Min=8, Max=12, MinDifficulty=Difficulty.Simple },
            { ItemId=ItemId.EquipmentMaterial_4_1, Min=6, Max=10, MinDifficulty=Difficulty.Simple },
            { ItemId=ItemId.EquipmentMaterial_5_1, Min=4, Max=8,  MinDifficulty=Difficulty.Normal },
            { ItemId=ItemId.BossMaterial_1,        Min=1, Max=3,  MinDifficulty=Difficulty.Hard },
            { ItemId=ItemId.BossMaterial_0,        Min=1, Max=2,  MinDifficulty=Difficulty.Nightmare },
            { ItemId=ItemId.BossMaterial_4,        Min=1, Max=3,  MinDifficulty=Difficulty.Hard },
            { ItemId=ItemId.BossMaterial_5,        Min=1, Max=2,  MinDifficulty=Difficulty.Nightmare },
            { ItemId=ItemId.BossMaterial_6,        Min=1, Max=3,  MinDifficulty=Difficulty.Hard },
            { ItemId=ItemId.BossMaterial_7,        Min=1, Max=2,  MinDifficulty=Difficulty.Nightmare },
            { ItemId=ItemId.BossMaterial_2,        Min=1, Max=3,  MinDifficulty=Difficulty.Hard },
            { ItemId=ItemId.BossMaterial_3,        Min=1, Max=2,  MinDifficulty=Difficulty.Nightmare },
        },
    },
}


-- 特殊事件配置
GameFlowCfg.SpecialEvent = {
    -- 猎尸狂涌
    [SpecialEvent.CorpseHuntingSurge] = {
        Duration    = 45,   -- 持续时间（编辑器定义）
        AttackBuff  = 0.2,  -- 攻击伤害提升百分比
        SpeedBuff   = 0.2,  -- 移速提升百分比
        DefenseBuff = 0.1,  -- 防御加成百分比
    },
    -- 尸潮淘金
    [SpecialEvent.CorpseSurgeGoldRush] = {
        Duration            = 45,   -- 持续时间（编辑器定义）
        ResourcePointBuff   = 1.0,  -- 资源点获取量提升百分比
        GoldBuff            = 1.0,  -- 金币获取量提升百分比
    },
    -- 天罚雷陨
    [SpecialEvent.HeavenPunishmentThunderStrike] = {
        Duration            = 30,   -- 持续时间（编辑器定义）
        ThunderDelay        = 3,    -- 雷电落下延迟时间
        ThunderDamagePct    = 0.2,  -- 雷电伤害百分比
        SlowdownBuff        = 0.05, -- 雷电减速百分比
        SlowdownDuration    = 5,    -- 雷电减速持续时间
    },
    -- 腐秽瘴潮
    [SpecialEvent.PutridMiasma] = {
        Duration            = 30,   -- 持续时间（编辑器定义）
        MiasmaDamage        = 5,    -- 毒气伤害
        MiasmaInterval      = 2,    -- 毒气伤害间隔时间（编辑器定义）
        InfectedAllAttrBuff = 0.1,  -- 感染者全属性加成百分比
    },
}


-- 伤害配置
GameFlowCfg.Damage = {
    -- 全局防御力K值
    DefenceK = 600
}


-- 初始武器
GameFlowCfg.InitialWeapon = {
    WeaponId = 8310018,
    BulletId = 831301001,
}