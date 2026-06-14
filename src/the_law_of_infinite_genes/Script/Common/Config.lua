-- 资源配置
ResourceConfig = {
    -- 资源点配置
    Coin_0 = {
        MonsterLoot = {1, 10, 50},    -- 每只怪物掉落的资源点（对应三种怪物级别）
    }
}


-- 特殊事件配置
SpecialEventConfig = {
    -- 猎尸狂涌
    [SpecialEvent.CorpseHuntingSurge] = {
        Duration    = 45,   -- 持续时间（编辑器定义）
        AttackBuff  = 0.2,  -- 攻击伤害提升百分比
        SpeedBuff   = 0.2,  -- 移速提升百分比
        DefenseBuff = 0.1,  -- 受到怪物所有伤害减免百分比
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