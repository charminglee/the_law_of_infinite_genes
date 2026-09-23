GameFlowCfg = GameFlowCfg or {}


GameFlowCfg.AutoSaveInterval = 30  -- 玩家数据自动保存间隔，单位秒
GameFlowCfg.SpawnerDelay = 10      -- 准备阶段时长
GameFlowCfg.SpawnInterval = 0.2    -- 刷怪间隔


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
    OnDamage = {
        -- 得分倍率
        ScoreMultiplier = 1.0,
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


-- 怪物组表
local _Normal_Infected = {
    CampID = 0,
    MobClass = "Asset/Blueprint/Prefabs/Monsters/Normal_Infected.Normal_Infected_C",
}
local _Normal_SpeedInfected = {
    CampID = 0,
    MobClass = "Asset/Blueprint/Prefabs/Monsters/Normal_SpeedInfected.Normal_SpeedInfected_C",
}
local _Normal_HeavyInfected = {
    CampID = 0,
    MobClass = "Asset/Blueprint/Prefabs/Monsters/Normal_HeavyInfected.Normal_HeavyInfected_C",
}
local _Normal_PoisonInfected = {
    CampID = 0,
    MobClass = "Asset/Blueprint/Prefabs/Monsters/Normal_PoisonInfected.Normal_PoisonInfected_C",
}
local _Elite_Speed = {
    CampID = 0,
    MobClass = "Asset/Blueprint/Prefabs/Monsters/Elite_Speed.Elite_Speed_C",
}
local _Boss_RottenArmor = {
    CampID = 0,
    MobClass = "Asset/Blueprint/Prefabs/Monsters/Boss_RottenArmor.Boss_RottenArmor_C",
}
GameFlowCfg.MonsterGroups = {
    [1] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected, Weight = 1 },
        },
    },
    [2] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected, Weight = 1 },
        },
    },
    [3] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected     , Weight = 3 },
            { SpawnParam = _Normal_SpeedInfected, Weight = 1 },
        },
    },
    [4] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected     , Weight = 1 },
            { SpawnParam = _Normal_SpeedInfected, Weight = 1 },
        },
    },
    [5] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected     , Weight = 3 },
            { SpawnParam = _Normal_SpeedInfected, Weight = 3 },
            { SpawnParam = _Normal_HeavyInfected, Weight = 1 },
        },
    },
    [6] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected     , Weight = 3 },
            { SpawnParam = _Normal_SpeedInfected, Weight = 3 },
            { SpawnParam = _Elite_Speed         , Weight = 1 },
        },
    },
    [7] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected     , Weight = 3 },
            { SpawnParam = _Normal_SpeedInfected, Weight = 3 },
            { SpawnParam = _Normal_HeavyInfected, Weight = 1 },
        },
    },
    [8] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected      , Weight = 3 },
            { SpawnParam = _Normal_SpeedInfected , Weight = 3 },
            { SpawnParam = _Normal_PoisonInfected, Weight = 3 },
            { SpawnParam = _Normal_HeavyInfected , Weight = 1 },
        },
    },
    [9] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected      , Weight = 4 },
            { SpawnParam = _Normal_SpeedInfected , Weight = 4 },
            { SpawnParam = _Normal_HeavyInfected , Weight = 2 },
            { SpawnParam = _Elite_Speed          , Weight = 1 },
            { SpawnParam = _Normal_PoisonInfected, Weight = 2 },
        },
    },
    [10] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected      , Weight = 4 },
            { SpawnParam = _Normal_SpeedInfected , Weight = 4 },
            { SpawnParam = _Normal_PoisonInfected, Weight = 2 },
            { SpawnParam = _Boss_RottenArmor     , Weight = 1 },
        },
    },
    [11] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected      , Weight = 4 },
            { SpawnParam = _Normal_SpeedInfected , Weight = 4 },
            { SpawnParam = _Normal_PoisonInfected, Weight = 2 },
            { SpawnParam = _Normal_HeavyInfected , Weight = 2 },
            { SpawnParam = _Elite_Speed          , Weight = 1 },
        },
    },
    [12] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected      , Weight = 4 },
            { SpawnParam = _Normal_SpeedInfected , Weight = 4 },
            { SpawnParam = _Normal_PoisonInfected, Weight = 3 },
            { SpawnParam = _Normal_HeavyInfected , Weight = 2 },
            { SpawnParam = _Elite_Speed          , Weight = 1 },
        },
    },
    [13] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected      , Weight = 4 },
            { SpawnParam = _Normal_SpeedInfected , Weight = 4 },
            { SpawnParam = _Normal_PoisonInfected, Weight = 3 },
            { SpawnParam = _Normal_HeavyInfected , Weight = 3 },
            { SpawnParam = _Elite_Speed          , Weight = 1 },
        },
    },
    [14] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected      , Weight = 4 },
            { SpawnParam = _Normal_SpeedInfected , Weight = 5 },
            { SpawnParam = _Normal_PoisonInfected, Weight = 3 },
            { SpawnParam = _Normal_HeavyInfected , Weight = 3 },
            { SpawnParam = _Elite_Speed          , Weight = 1 },
        },
    },
    [15] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected      , Weight = 4 },
            { SpawnParam = _Normal_SpeedInfected , Weight = 5 },
            { SpawnParam = _Normal_PoisonInfected, Weight = 4 },
            { SpawnParam = _Normal_HeavyInfected , Weight = 3 },
            { SpawnParam = _Elite_Speed          , Weight = 2 },
        },
    },
    [16] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected      , Weight = 4 },
            { SpawnParam = _Normal_SpeedInfected , Weight = 5 },
            { SpawnParam = _Normal_PoisonInfected, Weight = 4 },
            { SpawnParam = _Normal_HeavyInfected , Weight = 4 },
            { SpawnParam = _Elite_Speed          , Weight = 2 },
        },
    },
    [17] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected      , Weight = 5 },
            { SpawnParam = _Normal_SpeedInfected , Weight = 5 },
            { SpawnParam = _Normal_PoisonInfected, Weight = 4 },
            { SpawnParam = _Normal_HeavyInfected , Weight = 4 },
            { SpawnParam = _Elite_Speed          , Weight = 2 },
        },
    },
    [18] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected      , Weight = 5 },
            { SpawnParam = _Normal_SpeedInfected , Weight = 5 },
            { SpawnParam = _Normal_PoisonInfected, Weight = 5 },
            { SpawnParam = _Normal_HeavyInfected , Weight = 4 },
            { SpawnParam = _Elite_Speed          , Weight = 2 },
        },
    },
    [19] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected      , Weight = 5 },
            { SpawnParam = _Normal_SpeedInfected , Weight = 6 },
            { SpawnParam = _Normal_PoisonInfected, Weight = 5 },
            { SpawnParam = _Normal_HeavyInfected , Weight = 4 },
            { SpawnParam = _Elite_Speed          , Weight = 2 },
        },
    },
    [20] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected      , Weight = 4 },
            { SpawnParam = _Normal_SpeedInfected , Weight = 4 },
            { SpawnParam = _Normal_PoisonInfected, Weight = 4 },
            { SpawnParam = _Normal_HeavyInfected , Weight = 3 },
            { SpawnParam = _Elite_Speed          , Weight = 2 },
            { SpawnParam = _Boss_RottenArmor     , Weight = 1 },
        },
    },
    [21] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected      , Weight = 5 },
            { SpawnParam = _Normal_SpeedInfected , Weight = 5 },
            { SpawnParam = _Normal_PoisonInfected, Weight = 5 },
            { SpawnParam = _Normal_HeavyInfected , Weight = 4 },
            { SpawnParam = _Elite_Speed          , Weight = 2 },
        },
    },
    [22] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected      , Weight = 5 },
            { SpawnParam = _Normal_SpeedInfected , Weight = 5 },
            { SpawnParam = _Normal_PoisonInfected, Weight = 5 },
            { SpawnParam = _Normal_HeavyInfected , Weight = 5 },
            { SpawnParam = _Elite_Speed          , Weight = 3 },
        },
    },
    [23] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected      , Weight = 5 },
            { SpawnParam = _Normal_SpeedInfected , Weight = 6 },
            { SpawnParam = _Normal_PoisonInfected, Weight = 5 },
            { SpawnParam = _Normal_HeavyInfected , Weight = 5 },
            { SpawnParam = _Elite_Speed          , Weight = 3 },
        },
    },
    [24] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected      , Weight = 6 },
            { SpawnParam = _Normal_SpeedInfected , Weight = 6 },
            { SpawnParam = _Normal_PoisonInfected, Weight = 6 },
            { SpawnParam = _Normal_HeavyInfected , Weight = 5 },
            { SpawnParam = _Elite_Speed          , Weight = 3 },
        },
    },
    [25] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected      , Weight = 6 },
            { SpawnParam = _Normal_SpeedInfected , Weight = 6 },
            { SpawnParam = _Normal_PoisonInfected, Weight = 6 },
            { SpawnParam = _Normal_HeavyInfected , Weight = 6 },
            { SpawnParam = _Elite_Speed          , Weight = 3 },
        },
    },
    [26] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected      , Weight = 6 },
            { SpawnParam = _Normal_SpeedInfected , Weight = 6 },
            { SpawnParam = _Normal_PoisonInfected, Weight = 6 },
            { SpawnParam = _Normal_HeavyInfected , Weight = 6 },
            { SpawnParam = _Elite_Speed          , Weight = 4 },
        },
    },
    [27] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected      , Weight = 6 },
            { SpawnParam = _Normal_SpeedInfected , Weight = 7 },
            { SpawnParam = _Normal_PoisonInfected, Weight = 6 },
            { SpawnParam = _Normal_HeavyInfected , Weight = 6 },
            { SpawnParam = _Elite_Speed          , Weight = 4 },
        },
    },
    [28] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected      , Weight = 7 },
            { SpawnParam = _Normal_SpeedInfected , Weight = 7 },
            { SpawnParam = _Normal_PoisonInfected, Weight = 7 },
            { SpawnParam = _Normal_HeavyInfected , Weight = 6 },
            { SpawnParam = _Elite_Speed          , Weight = 4 },
        },
    },
    [29] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected      , Weight = 7 },
            { SpawnParam = _Normal_SpeedInfected , Weight = 7 },
            { SpawnParam = _Normal_PoisonInfected, Weight = 7 },
            { SpawnParam = _Normal_HeavyInfected , Weight = 7 },
            { SpawnParam = _Elite_Speed          , Weight = 4 },
        },
    },
    [30] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected      , Weight = 6 },
            { SpawnParam = _Normal_SpeedInfected , Weight = 6 },
            { SpawnParam = _Normal_PoisonInfected, Weight = 6 },
            { SpawnParam = _Normal_HeavyInfected , Weight = 6 },
            { SpawnParam = _Elite_Speed          , Weight = 4 },
            { SpawnParam = _Boss_RottenArmor     , Weight = 1 },
        },
    },
    [31] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected      , Weight = 7 },
            { SpawnParam = _Normal_SpeedInfected , Weight = 7 },
            { SpawnParam = _Normal_PoisonInfected, Weight = 7 },
            { SpawnParam = _Normal_HeavyInfected , Weight = 6 },
            { SpawnParam = _Elite_Speed          , Weight = 4 },
        },
    },
    [32] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected      , Weight = 7 },
            { SpawnParam = _Normal_SpeedInfected , Weight = 7 },
            { SpawnParam = _Normal_PoisonInfected, Weight = 7 },
            { SpawnParam = _Normal_HeavyInfected , Weight = 7 },
            { SpawnParam = _Elite_Speed          , Weight = 5 },
        },
    },
    [33] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected      , Weight = 7 },
            { SpawnParam = _Normal_SpeedInfected , Weight = 8 },
            { SpawnParam = _Normal_PoisonInfected, Weight = 7 },
            { SpawnParam = _Normal_HeavyInfected , Weight = 7 },
            { SpawnParam = _Elite_Speed          , Weight = 5 },
        },
    },
    [34] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected      , Weight = 8 },
            { SpawnParam = _Normal_SpeedInfected , Weight = 8 },
            { SpawnParam = _Normal_PoisonInfected, Weight = 8 },
            { SpawnParam = _Normal_HeavyInfected , Weight = 7 },
            { SpawnParam = _Elite_Speed          , Weight = 5 },
        },
    },
    [35] = {
        MobConfigList = {
            { SpawnParam = _Normal_Infected      , Weight = 7 },
            { SpawnParam = _Normal_SpeedInfected , Weight = 7 },
            { SpawnParam = _Normal_PoisonInfected, Weight = 7 },
            { SpawnParam = _Normal_HeavyInfected , Weight = 7 },
            { SpawnParam = _Elite_Speed          , Weight = 5 },
            { SpawnParam = _Boss_RottenArmor     , Weight = 1 },
        },
    },
}


---当前模式配置了有效波数时使用该值；未配置时使用怪物组的最后一波。
function GameFlowCfg.GetMaxWave(ModeConfig)
    local configuredCount = ModeConfig and tonumber(ModeConfig.LevelCount)
    if configuredCount and configuredCount >= 1 then
        return configuredCount
    end

    local lastGroupIndex = 0
    for waveIndex in pairs(GameFlowCfg.MonsterGroups) do
        lastGroupIndex = math.max(lastGroupIndex, tonumber(waveIndex) or 0)
    end
    return lastGroupIndex
end






