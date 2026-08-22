local ROOT = UGCMapInfoLib.GetRootLongPackagePath().."Asset/Blueprint/"


---@enum Event
Event = {
    OnItemCustomDataUpdateAfter = "OnItemCustomDataUpdateAfter",
    OnWaveStart                 = "OnWaveStart",
    OnWaveEnd                   = "OnWaveEnd",
    OnResetCardData             = "OnResetCardData",
    OnRepCardData               = "OnRepCardData",
    OnCardShopRefreshAfter      = "OnCardShopRefreshAfter",
    OnCardEquipAfter            = "OnCardEquipAfter",
    OnCardUnequipAfter          = "OnCardUnequipAfter",
    OnCardPurchaseAfter         = "OnCardPurchaseAfter",
    OnCardSellAfter             = "OnCardSellAfter",
    OnCoinChangeAfter           = "OnCoinChangeAfter",
    OnTitleEquipAfter           = "OnTitleEquipAfter",
    OnTitleUnlockAfter          = "OnTitleUnlockAfter",
    OnCardShopLevelUpAfter      = "OnCardShopLevelUpAfter",
    OnRepAppraisalData          = "OnRepAppraisalData",
}


ClassPath = {
    [Buff.CorpseHuntingSurge]               = ROOT.."Prefabs/Buffs/CorpseHuntingSurge.CorpseHuntingSurge_C",
    [Buff.CorpseSurgeGoldRush]              = ROOT.."Prefabs/Buffs/CorpseSurgeGoldRush.CorpseSurgeGoldRush_C",
    [Buff.HeavenPunishmentThunderStrike]    = ROOT.."Prefabs/Buffs/HeavenPunishmentThunderStrike.HeavenPunishmentThunderStrike_C",
    [Buff.PutridMiasma]                     = ROOT.."Prefabs/Buffs/PutridMiasma.PutridMiasma_C",
    [Buff.PutridMiasma_Monster]             = ROOT.."Prefabs/Buffs/PutridMiasma_Monster.PutridMiasma_Monster_C",

    BaseMonster = ROOT.."Prefabs/Monsters/BaseMonster.BaseMonster_C",
}


InstancePath = {
    LevelStart          = "Helipad.LevelStart_8",
    MobSpawnerManager   = "Helipad.MobSpawnerManager",
    MapStartLocation    = "Helipad.MapStartLocation_8",
    MapEndLocation      = "Helipad.MapEndLocation_23",
}


---@enum Tag
Tag = {
    Monster = "Monster",
    Elite   = "Elite",
    Boss    = "Boss",
}


GameplayTag = {
    Damage = {
        Type = {
            Critical        = "Damage.Type.Critical",
            Direct          = "Damage.Type.Direct",
            CounterAttack   = "Damage.Type.CounterAttack",
            Seckill         = "Damage.Type.Seckill",
            Dodge           = "Damage.Type.Dodge",
        },
    },
    Item = {
        Equipment = "Item.Equipment"
    },
    EquipmentSlot = {
        Kenl = "EquipmentSlot.Kenl",
        Suit = {
            Body = "EquipmentSlot.Suit.Body",
            Face = "EquipmentSlot.Suit.Face",
            Feet = "EquipmentSlot.Suit.Feet",
            Head = "EquipmentSlot.Suit.Head",
            Kenl = "EquipmentSlot.Suit.Kenl",
            Legs = "EquipmentSlot.Suit.Legs",
        }
    },
}


---@enum ItemId
ItemId = {
    BossMaterial_0      = 8310013,
    BossMaterial_1      = 8310014,
    Coin_0              = 8310000,
    Coin_1              = 8310001,
    Coin_2              = 8310002,
    Coin_3              = 8310003,
    Coin_4              = 8310012,
    Coin_5              = 8310162,
    EquipmentMaterial_0 = 8310004,
    EquipmentMaterial_1 = 8310005,
    EquipmentMaterial_2 = 8310006,
    EquipmentMaterial_3 = 8310015,
    EquipmentMaterial_4 = 8310016,
    EquipmentMaterial_5 = 8310017,
    HySuitBottom        = 8310008,
    HySuitGloves        = 8310010,
    HySuitHelmet        = 8310009,
    HySuitShoes         = 8310011,
    HySuitTop           = 8310007,
    UZI                 = 8310018,
    Kenl_0_0            = 8310042,
    Kenl_0_1            = 8310046,
    Kenl_0_2            = 8310044,
    Kenl_0_3            = 8310049,
    Kenl_0_4            = 8310050,
    Advanced_1          = 8310188,
}


---@enum Attribute
Attribute = {
    AttackPower                 = UGCCustomGameAttributeType.UGCAttributeGroup_Character_AttackPower,               -- 攻击力
    AttackPowerPct              = UGCCustomGameAttributeType.UGCAttributeGroup_Character_AttackPowerPct,            -- 攻击力百分比
    DamagePct                   = UGCCustomGameAttributeType.UGCAttributeGroup_Character_DamagePct,                 -- 通用伤害加成
    NormalMonsterDamagePct      = UGCCustomGameAttributeType.UGCAttributeGroup_Character_NormalMonsterDamagePct,    -- 普通怪伤害加成
    EliteMonsterDamagePct       = UGCCustomGameAttributeType.UGCAttributeGroup_Character_EliteMonsterDamagePct,     -- 精英怪伤害加成
    BossDamagePct               = UGCCustomGameAttributeType.UGCAttributeGroup_Character_BossDamagePct,             -- Boss伤害加成
    CritChance                  = UGCCustomGameAttributeType.UGCAttributeGroup_Character_CritChance,                -- 暴击几率
    CritDamagePct               = UGCCustomGameAttributeType.UGCAttributeGroup_Character_CritDamagePct,             -- 暴击伤害
    Defence                     = UGCCustomGameAttributeType.UGCAttributeGroup_Character_Defence,                   -- 防御力
    DefensePct                  = UGCCustomGameAttributeType.UGCAttributeGroup_Character_DefensePct,                -- 防御力百分比
    HealthStealPct              = UGCCustomGameAttributeType.UGCAttributeGroup_Character_HealthStealPct,            -- 吸血倍率
    CounterAttackPct            = UGCCustomGameAttributeType.UGCAttributeGroup_Character_CounterAttackPct,          -- 反伤倍率
    DamageDecreace              = UGCCustomGameAttributeType.UGCAttributeGroup_Character_DamageDecreace,            -- 伤害减免
    DamageDecreacePct           = UGCCustomGameAttributeType.UGCAttributeGroup_Character_DamageDecreacePct,         -- 伤害减免百分比
    BreakDefencePct             = UGCCustomGameAttributeType.UGCAttributeGroup_Character_BreakDefencePct,           -- 防御穿透百分比
    SeckillChance               = UGCCustomGameAttributeType.UGCAttributeGroup_Character_SeckillChance,             -- 秒杀率
    DodgeChance                 = UGCCustomGameAttributeType.UGCAttributeGroup_Character_DodgeChance,               -- 闪避率
    MoveSpeedScale              = UGCNativeGameAttributeType.Character_UGCGeneralMoveSpeedScale,                    -- 移速百分比
    HealthMax                   = UGCNativeGameAttributeType.Character_HealthMax,                                   -- 最大血量
    HealthMaxPct                = UGCCustomGameAttributeType.UGCAttributeGroup_Character_HealthMaxPct,              -- 最大血量百分比

    RecoilPct                   = UGCCustomGameAttributeType.UGCAttributeGroup_Character_RecoilPct,                 -- 后坐力百分比
    ReloadTime                  = UGCCustomGameAttributeType.UGCAttributeGroup_Character_ReloadTime,                -- 换弹时间
    ReloadTimePct               = UGCCustomGameAttributeType.UGCAttributeGroup_Character_ReloadTimePct,             -- 换弹时间百分比
    ShootSpeedScale             = UGCCustomGameAttributeType.UGCAttributeGroup_Character_ShootSpeedScale,           -- 射速百分比

    EpidemicToxinRatio          = UGCCustomGameAttributeType.UGCAttributeGroup_Character_EpidemicToxinRatio,        -- 疫毒触发概率
    EpidemicToxinLevel          = UGCCustomGameAttributeType.UGCAttributeGroup_Character_EpidemicToxinLevel,        -- 疫毒等级
    EpidemicToxinOverlyLimit    = UGCCustomGameAttributeType.UGCAttributeGroup_Character_EpidemicToxinOverlyLimit,  -- 疫毒叠加上限
    EpidemicToxinSettleRatio    = UGCCustomGameAttributeType.UGCAttributeGroup_Character_EpidemicToxinSettleRatio,  -- 疫毒结算概率
    InfiniteAmmo                = UGCCustomGameAttributeType.UGCAttributeGroup_Character_InfiniteAmmo,              -- 无限子弹

    _HealthMax = UGCCustomGameAttributeType.UGCAttributeGroup_Character__HealthMax,
}


AttributeMate = {
    [Attribute.AttackPower]                 = {index=1, anno="攻击力"},
    [Attribute.AttackPowerPct]              = {index=2, anno="攻击力百分比"},
    [Attribute.DamagePct]                   = {index=3, anno="通用伤害加成"},
    [Attribute.NormalMonsterDamagePct]      = {index=4, anno="普通怪伤害加成"},
    [Attribute.EliteMonsterDamagePct]       = {index=5, anno="精英怪伤害加成"},
    [Attribute.BossDamagePct]               = {index=6, anno="Boss伤害加成"},
    [Attribute.CritChance]                  = {index=7, anno="暴击几率"},
    [Attribute.CritDamagePct]               = {index=8, anno="暴击伤害"},
    [Attribute.Defence]                     = {index=9, anno="防御力"},
    [Attribute.DefensePct]                  = {index=10, anno="防御力百分比"},
    [Attribute.HealthStealPct]              = {index=11, anno="吸血倍率"},
    [Attribute.CounterAttackPct]            = {index=12, anno="反伤倍率"},
    [Attribute.DamageDecreace]              = {index=13, anno="伤害减免"},
    [Attribute.DamageDecreacePct]           = {index=14, anno="伤害减免百分比"},
    [Attribute.BreakDefencePct]             = {index=15, anno="防御穿透百分比"},
    [Attribute.RecoilPct]                   = {index=16, anno="后坐力百分比"},
    [Attribute.ReloadTimePct]               = {index=17, anno="换弹时间百分比"},
    [Attribute.DodgeChance]                 = {index=18, anno="闪避率"},
    [Attribute.SeckillChance]               = {index=19, anno="秒杀率"},
    [Attribute.HealthMax]                   = {index=20, anno="最大血量"},
    [Attribute.MoveSpeedScale]              = {index=21, anno="移速百分比"},
    [Attribute.ShootSpeedScale]             = {index=22, anno="射速百分比"},
    [Attribute.EpidemicToxinRatio]          = {index=23, anno="疫毒触发概率"},
    [Attribute.EpidemicToxinLevel]          = {index=24, anno="疫毒等级"},
    [Attribute.EpidemicToxinOverlyLimit]    = {index=25, anno="疫毒叠加上限"},
    [Attribute.EpidemicToxinSettleRatio]    = {index=26, anno="疫毒结算概率"},
    [Attribute.InfiniteAmmo]                = {index=27, anno="无限子弹"},
    [Attribute.HealthMaxPct]                = {index=29, anno="最大血量百分比"},
    [Attribute.ReloadTime]                  = {index=34, anno="换弹时间"},
}
