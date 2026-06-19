local root = UGCMapInfoLib.GetRootLongPackagePath()


ClassPath = {
    [Buff.CorpseHuntingSurge]               = root.."Asset/Blueprint/Prefabs/Buffs/CorpseHuntingSurge.CorpseHuntingSurge_C",
    [Buff.CorpseSurgeGoldRush]              = root.."Asset/Blueprint/Prefabs/Buffs/CorpseSurgeGoldRush.CorpseSurgeGoldRush_C",
    [Buff.HeavenPunishmentThunderStrike]    = root.."Asset/Blueprint/Prefabs/Buffs/HeavenPunishmentThunderStrike.HeavenPunishmentThunderStrike_C",
    [Buff.PutridMiasma]                     = root.."Asset/Blueprint/Prefabs/Buffs/PutridMiasma.PutridMiasma_C",
    [Buff.PutridMiasma_Monster]             = root.."Asset/Blueprint/Prefabs/Buffs/PutridMiasma_Monster.PutridMiasma_Monster_C",

    MonsterTemplate                         = root.."Asset/Blueprint/Prefabs/Monsters/MonsterTemplate.MonsterTemplate_C",
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
