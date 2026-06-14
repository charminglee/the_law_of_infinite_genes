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
