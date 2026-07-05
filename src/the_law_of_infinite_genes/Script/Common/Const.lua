local ROOT = UGCMapInfoLib.GetRootLongPackagePath()


ServerEvent = {
    OnRepCardData           = "OnRepCardData",
    OnCardShopRefreshAfter  = "OnCardShopRefreshAfter",
    OnCardEquipAfter        = "OnCardEquipAfter",
    OnCardUnequipAfter      = "OnCardUnequipAfter",
    OnCardPurchaseAfter     = "OnCardPurchaseAfter",
    OnCardSellAfter         = "OnCardSellAfter",
    OnCoinChangeAfter       = "OnCoinChangeAfter",
    OnTitleEquipAfter       = "OnTitleEquipAfter",
    OnTitleUnlockAfter      = "OnTitleUnlockAfter",
}


ClientEvent = {
}


ClassPath = {
    [Buff.CorpseHuntingSurge]               = ROOT.."Asset/Blueprint/Prefabs/Buffs/CorpseHuntingSurge.CorpseHuntingSurge_C",
    [Buff.CorpseSurgeGoldRush]              = ROOT.."Asset/Blueprint/Prefabs/Buffs/CorpseSurgeGoldRush.CorpseSurgeGoldRush_C",
    [Buff.HeavenPunishmentThunderStrike]    = ROOT.."Asset/Blueprint/Prefabs/Buffs/HeavenPunishmentThunderStrike.HeavenPunishmentThunderStrike_C",
    [Buff.PutridMiasma]                     = ROOT.."Asset/Blueprint/Prefabs/Buffs/PutridMiasma.PutridMiasma_C",
    [Buff.PutridMiasma_Monster]             = ROOT.."Asset/Blueprint/Prefabs/Buffs/PutridMiasma_Monster.PutridMiasma_Monster_C",

    BaseMonster                             = ROOT.."Asset/Blueprint/Prefabs/Monsters/BaseMonster.BaseMonster_C",
}


InstancePath = {
    LevelStart          = "UGCmap.LevelStart_8",
    MobSpawnerManager   = "UGCmap.MobSpawnerManager_10",
    MapStartLocation    = "UGCmap.MapStartLocation_8",
    MapEndLocation      = "UGCmap.MapEndLocation_23",
}


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
        },
    }
}


ItemId = {
    BossMaterial_0      = 8310013,
    BossMaterial_1      = 8310014,
    Coin_0              = 8310000,
    Coin_1              = 8310001,
    Coin_2              = 8310002,
    Coin_3              = 8310003,
    Coin_4              = 8310012,
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
}


Attribute = {
    AttackPower                 = UGCCustomGameAttributeType.UGCAttributeGroup_Character_AttackPower, -- 攻击力
    AttackPowerBoost            = UGCCustomGameAttributeType.UGCAttributeGroup_Character_AttackPowerBoost, -- 攻击力百分比
    DamageBoost                 = UGCCustomGameAttributeType.UGCAttributeGroup_Character_DamageBoost, -- 通用伤害加成
    NormalMonsterDamageBoost    = UGCCustomGameAttributeType.UGCAttributeGroup_Character_NormalMonsterDamageBoost, -- 普通怪伤害加成
    EliteMonsterDamageBoost     = UGCCustomGameAttributeType.UGCAttributeGroup_Character_EliteMonsterDamageBoost, -- 精英怪伤害加成
    BossDamageBoost             = UGCCustomGameAttributeType.UGCAttributeGroup_Character_BossDamageBoost, -- Boss伤害加成
    CritChance                  = UGCCustomGameAttributeType.UGCAttributeGroup_Character_CritChance, -- 暴击几率
    CritDamageBoost             = UGCCustomGameAttributeType.UGCAttributeGroup_Character_CritDamageBoost, -- 暴击伤害
    Defence                     = UGCCustomGameAttributeType.UGCAttributeGroup_Character_Defence, -- 防御力
    DefenseBoost                = UGCCustomGameAttributeType.UGCAttributeGroup_Character_DefenseBoost, -- 防御力百分比
    HealthStealRatio            = UGCCustomGameAttributeType.UGCAttributeGroup_Character_HealthStealRatio, -- 吸血倍率
    CounterAttackRatio          = UGCCustomGameAttributeType.UGCAttributeGroup_Character_CounterAttackRatio, -- 反伤倍率
    DamageDecreace              = UGCCustomGameAttributeType.UGCAttributeGroup_Character_DamageDecreace, -- 伤害减免
    DamageDecreacePct           = UGCCustomGameAttributeType.UGCAttributeGroup_Character_DamageDecreacePct, -- 伤害减免百分比
    BreakDefenceRatio           = UGCCustomGameAttributeType.UGCAttributeGroup_Character_BreakDefenceRatio, -- 防御穿透百分比
    RecoilPct                   = UGCCustomGameAttributeType.UGCAttributeGroup_Character_RecoilPct, -- 后坐力百分比
    ReloadTimePct               = UGCCustomGameAttributeType.UGCAttributeGroup_Character_ReloadTimePct, -- 换弹时间百分比
    DodgeChance                 = UGCCustomGameAttributeType.UGCAttributeGroup_Character_DodgeChance, -- 闪避率
    SeckillChance               = UGCCustomGameAttributeType.UGCAttributeGroup_Character_SeckillChance, -- 秒杀率
    HealthMax                   = UGCNativeGameAttributeType.Character_HealthMax, -- 生命值
    MoveSpeedScale              = UGCNativeGameAttributeType.Character_UGCGeneralMoveSpeedScale, -- 移速百分比
    ShootSpeedScale             = UGCCustomGameAttributeType.UGCAttributeGroup_Character_ShootSpeedScale, -- 射速百分比

    EpidemicToxinRatio          = 23, -- 疫毒触发概率
    EpidemicToxinLevel          = 24, -- 疫毒等级
    EpidemicToxinOverlyLimit    = 25, -- 疫毒叠加上限
    EpidemicToxinSettleRatio    = 26, -- 疫毒结算概率
    InfiniteAmmo                = 27, -- 无限子弹
    IgnoreHarmRatio             = 28, -- 无视伤害率
    DodgeRatio                  = 29,
    SeckillRatio                = 30,
    Recoilless                  = 31,
    HealthMaxBoost              = 32,
    UGCGeneralMoveSpeedScale    = UGCNativeGameAttributeType.Character_UGCGeneralMoveSpeedScale,
    ReloadTime                  = UGCNativeGameAttributeType.Weapon_ReloadTime,
    BurstShootCDWrapper         = UGCNativeGameAttributeType.Weapon_BurstShootCDWrapper,
}


AttributeMate = {
    [Attribute.AttackPower]                 = {index=1, anno="攻击力"},
    [Attribute.AttackPowerBoost]            = {index=2, anno="攻击力百分比"},
    [Attribute.DamageBoost]                 = {index=3, anno="通用伤害加成"},
    [Attribute.NormalMonsterDamageBoost]    = {index=4, anno="普通怪伤害加成"},
    [Attribute.EliteMonsterDamageBoost]     = {index=5, anno="精英怪伤害加成"},
    [Attribute.BossDamageBoost]             = {index=6, anno="Boss伤害加成"},
    [Attribute.CritChance]                  = {index=7, anno="暴击几率"},
    [Attribute.CritDamageBoost]             = {index=8, anno="暴击伤害"},
    [Attribute.Defence]                     = {index=9, anno="防御力"},
    [Attribute.DefenseBoost]                = {index=10, anno="防御力百分比"},
    [Attribute.HealthStealRatio]            = {index=11, anno="吸血倍率"},
    [Attribute.CounterAttackRatio]          = {index=12, anno="反伤倍率"},
    [Attribute.DamageDecreace]              = {index=13, anno="伤害减免"},
    [Attribute.DamageDecreacePct]           = {index=14, anno="伤害减免百分比"},
    [Attribute.BreakDefenceRatio]           = {index=15, anno="防御穿透百分比"},
    [Attribute.RecoilPct]                   = {index=16, anno="后坐力百分比"},
    [Attribute.ReloadTimePct]               = {index=17, anno="换弹时间百分比"},
    [Attribute.DodgeChance]                 = {index=18, anno="闪避率"},
    [Attribute.SeckillChance]               = {index=19, anno="秒杀率"},
    [Attribute.HealthMax]                   = {index=20, anno="生命值"},
    [Attribute.MoveSpeedScale]              = {index=21, anno="移速百分比"},
    [Attribute.ShootSpeedScale]             = {index=22, anno="射速百分比"},

    [Attribute.EpidemicToxinRatio]          = {index=23, anno="疫毒触发概率"},
    [Attribute.EpidemicToxinLevel]          = {index=24, anno="疫毒等级"},
    [Attribute.EpidemicToxinOverlyLimit]    = {index=25, anno="疫毒叠加上限"},
    [Attribute.EpidemicToxinSettleRatio]    = {index=26, anno="疫毒结算概率"},
    [Attribute.InfiniteAmmo]                = {index=27, anno="无限子弹"},
    [Attribute.IgnoreHarmRatio]             = {index=28, anno="无视伤害率"},
    [Attribute.HealthMaxBoost]              = {index=29, anno="生命值百分比"},
    [Attribute.DodgeRatio]                  = {index=30, anno="闪避率"},
    [Attribute.SeckillRatio]                = {index=31, anno="秒杀率"},
    [Attribute.Recoilless]                  = {index=32, anno="无后坐力"},
    [Attribute.UGCGeneralMoveSpeedScale]    = {index=33, anno="移速百分比"},
    [Attribute.ReloadTime]                  = {index=34, anno="换弹时间"},
    [Attribute.BurstShootCDWrapper]         = {index=35, anno="连发间隔"},
}
