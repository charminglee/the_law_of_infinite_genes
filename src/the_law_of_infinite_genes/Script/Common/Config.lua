Config = Config or {}


Config.Debug = {
    AutoStartGame = false,
    Coin = {
        [8310000] = 999999, -- Coin_0
        [8310001] = 999999, -- Coin_1
        [8310002] = 999999, -- Coin_2
        [8310003] = 999999, -- Coin_3
        [8310012] = 999999, -- Coin_4
    },
}


Config.Common = {
    AutoSaveInterval = 30,  -- 玩家数据自动保存间隔，单位秒
    SpawnerDelay = 10,      -- 刷怪延迟
}


-- 资源配置
Config.Resource = {
    -- 资源点配置
    Coin_0 = {
        MonsterLoot = {1, 10, 50},    -- 每只怪物掉落的资源点（对应三种怪物级别）
    }
}


-- 特殊事件配置
Config.SpecialEvent = {
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
Config.Damage = {
    -- 全局防御力K值
    DefenceK = 600
}

-- 物品类型配置
Config.ItemType = {
    [1] = '装备',
    [2] = '消耗品',
    [3] = '材料',
    [4] = '其他'
}

-- 物品品质配置
Config.ItemQuality = {
    [1] = {path='/the_law_of_infinite_genes/Asset/Texture/UI/Image_BigQualityBg_1.Image_BigQualityBg_1', name='普通'},
    [2] = {path='/the_law_of_infinite_genes/Asset/Texture/UI/Image_BigQualityBg_2.Image_BigQualityBg_2', name='平凡'},
    [3] = {path='/the_law_of_infinite_genes/Asset/Texture/UI/Image_BigQualityBg_3.Image_BigQualityBg_3', name='精良'},
    [4] = {path='/the_law_of_infinite_genes/Asset/Texture/UI/Image_BigQualityBg_4.Image_BigQualityBg_4', name='稀有'},
    [5] = {path='/the_law_of_infinite_genes/Asset/Texture/UI/Image_BigQualityBg_5.Image_BigQualityBg_5', name='传说'},
    [6] = {path='/the_law_of_infinite_genes/Asset/Texture/UI/Image_BigQualityBg_6.Image_BigQualityBg_6', name='史诗'},
    [7] = {path='/the_law_of_infinite_genes/Asset/Texture/UI/Image_BigQualityBg_7.Image_BigQualityBg_7', name='神话'}
}

-- 初始武器
Config.InitialWeapon = {
    WeaponId = 8310018,
    BulletId = 301001,
}


-- 合成表 材料ID {8310014 = 领主之眼, 8310015 = 腐化布料, 8310016 = 硬化骨片, 8310017 = 变异粘液}
Config.Formula = {
    -- 基础套装
    -- 基础工装长裤
    [8310019] = {
        [1]={ItemId=8310017, number=10},
        [2]={ItemId=8310015, number=5},
        [3]={ItemId=8310014, number=1},
    },
    -- 基础方形眼镜
    [8310020] = {
        [1]={ItemId=8310017, number=10},
        [2]={ItemId=8310015, number=5},
        [3]={ItemId=8310014, number=1},
    },
    -- 基础遮阳棒球帽
    [8310021] = {
        [1]={ItemId=8310017, number=10},
        [2]={ItemId=8310015, number=5},
        [3]={ItemId=8310014, number=1},
    },
    --- 基础防滑鞋
    [8310022] = {
        [1]={ItemId=8310017, number=10},
        [2]={ItemId=8310015, number=5},
        [3]={ItemId=8310014, number=1},
    },
    --- 基础透气亨利衫
    [8310023] = {
        [1]={ItemId=8310017, number=10},
        [2]={ItemId=8310015, number=5},
        [3]={ItemId=8310014, number=1},
    },
    --- 赤锋突击工装裤
    [8310024] = {
        [1]={ItemId=8310017, number=30},
        [2]={ItemId=8310015, number=20},
        [3]={ItemId=8310014, number=2},
        [4]={ItemId=8310019, number=1},
    },
    --- 赤锋突击面罩
    [8310025] = {
        [1]={ItemId=8310017, number=30},
        [2]={ItemId=8310015, number=20},
        [3]={ItemId=8310014, number=2},
        [4]={ItemId=8310020, number=1},
    },
    --- 赤锋突击头盔
    [8310026] = {
        [1]={ItemId=8310017, number=30},
        [2]={ItemId=8310015, number=20},
        [3]={ItemId=8310014, number=2},
        [4]={ItemId=8310020, number=1},
    },
    --- 赤锋突击战靴
    [8310027] = {
        [1]={ItemId=8310017, number=30},
        [2]={ItemId=8310015, number=20},
        [3]={ItemId=8310014, number=2},
        [4]={ItemId=8310020, number=1},
    },
    --- 赤锋突击外套
    [8310028] = {
        [1]={ItemId=8310017, number=30},
        [2]={ItemId=8310015, number=20},
        [3]={ItemId=8310014, number=2},
        [4]={ItemId=8310020, number=1},
    },
    --- 荒土耐磨工装裤
    [8310029] = {
        [1]={ItemId=8310017, number=30},
        [2]={ItemId=8310015, number=20},
        [3]={ItemId=8310014, number=2},
        [4]={ItemId=8310020, number=1},
    },
    --- 荒土防毒面罩
    [8310030] = {
        [1]={ItemId=8310017, number=30},
        [2]={ItemId=8310015, number=20},
        [3]={ItemId=8310014, number=2},
        [4]={ItemId=8310020, number=1},
    },
    --- 荒土战术帽
    [8310031] = {
        [1]={ItemId=8310017, number=30},
        [2]={ItemId=8310015, number=20},
        [3]={ItemId=8310014, number=2},
        [4]={ItemId=8310020, number=1},
    },
    --- 荒土战术靴
    [8310032] = {
        [1]={ItemId=8310017, number=30},
        [2]={ItemId=8310015, number=20},
        [3]={ItemId=8310014, number=2},
        [4]={ItemId=8310020, number=1},
    },
    --- 荒土迷彩外套
    [8310033] = {
        [1]={ItemId=8310017, number=30},
        [2]={ItemId=8310015, number=20},
        [3]={ItemId=8310014, number=2},
        [4]={ItemId=8310020, number=1},
    },
    --- 荒原·残戍夹克
    [8310007] = {
        [1]={ItemId=8310017, number=30},
        [2]={ItemId=8310015, number=20},
        [3]={ItemId=8310014, number=2},
        [4]={ItemId=8310020, number=1},
    },
    --- 荒原·工装长裤
    [8310008] = {
        [1]={ItemId=8310017, number=30},
        [2]={ItemId=8310015, number=20},
        [3]={ItemId=8310014, number=2},
        [4]={ItemId=8310020, number=1},
    },
    --- 荒原·破雾面罩
    [8310009] = {
        [1]={ItemId=8310017, number=30},
        [2]={ItemId=8310015, number=20},
        [3]={ItemId=8310014, number=2},
        [4]={ItemId=8310020, number=1},
    },
    --- 荒原·皮质手套
    [8310010] = {
        [1]={ItemId=8310017, number=30},
        [2]={ItemId=8310015, number=20},
        [3]={ItemId=8310014, number=2},
        [4]={ItemId=8310020, number=1},
    },
    --- 荒原·踏尘战靴
    [8310011] = {
        [1]={ItemId=8310017, number=30},
        [2]={ItemId=8310015, number=20},
        [3]={ItemId=8310014, number=2},
        [4]={ItemId=8310020, number=1},
    },
}

Config.ItemDef = {
    [1] = '帽子',
    [2] = '脸饰',
    [3] = '衣服',
    [4] = '裤子',
    [5] = '鞋子',
    [6] = '消耗品',
    [7] = '材料',
    [8] = '其他',
}

Config.ItemTable = {
    [1] = {
        8310021,
        8310026,
        8310031
    },
    [2] = {
        8310020,
        8310025,
        8310030,
        8310009,
    },
    [3] = {
        8310023,
        8310028,
        8310033,
        8310007,
    },
    [4] = {
        8310019,
        8310024,
        8310029,
        8310008
    },
    [5] = {
        8310022,
        8310027,
        8310032,
        8310011,
    },
    [6] = {

    },
    [7] = {
        8310014,
        8310015,
        8310016,
        8310017
    },
    [8] = {}
}

return Config