ItemCfg = ItemCfg or {}


-- 装备词条数值范围
ItemCfg.AttributeEntryRange = {
    [Attribute.AttackPower]                 = { min=0, max=1 },
    [Attribute.AttackPowerPct]              = { min=0, max=1 },
    [Attribute.DamagePct]                   = { min=0, max=1 },
    [Attribute.NormalMonsterDamagePct]      = { min=0, max=1 },
    [Attribute.EliteMonsterDamagePct]       = { min=0, max=1 },
    [Attribute.BossDamagePct]               = { min=0, max=1 },
    [Attribute.CritChance]                  = { min=0, max=1 },
    [Attribute.CritDamagePct]               = { min=0, max=1 },
    [Attribute.Defence]                     = { min=0, max=1 },
    [Attribute.DefensePct]                  = { min=0, max=1 },
    [Attribute.HealthStealPct]              = { min=0, max=1 },
    [Attribute.CounterAttackPct]            = { min=0, max=1 },
    [Attribute.DamageDecreace]              = { min=0, max=1 },
    [Attribute.DamageDecreacePct]           = { min=0, max=1 },
    [Attribute.BreakDefencePct]             = { min=0, max=1 },
    [Attribute.SeckillChance]               = { min=0, max=1 },
    [Attribute.DodgeChance]                 = { min=0, max=1 },   
    [Attribute.HealthMax]                   = { min=0, max=1 },
    [Attribute.HealthMaxPct]                = { min=0, max=1 },
    [Attribute.RecoilPct]                   = { min=0, max=1 },
    [Attribute.ReloadTime]                  = { min=0, max=1 },
    [Attribute.ReloadTimePct]               = { min=0, max=1 },
    [Attribute.MoveSpeedScale]              = { min=0, max=2 },
    [Attribute.ShootSpeedScale]             = { min=0, max=2 },
    [Attribute.EpidemicToxinRatio]          = { min=0, max=1 },
    [Attribute.EpidemicToxinLevel]          = { min=0, max=1 },
    [Attribute.EpidemicToxinOverlyLimit]    = { min=0, max=1 },
    [Attribute.EpidemicToxinSettleRatio]    = { min=0, max=1 },
    [Attribute.BurstShootCDWrapper]         = { min=0, max=1 },
}


-- 每种装备的词条池
ItemCfg.EquipmentAttributePool = {
    -- [8310019] = {
    --     Attribute.AttackPower,
    --     Attribute.Defence,
    -- },
}


-- 物品类型配置
ItemCfg.ItemType = {
    [1] = '装备',
    [2] = '消耗品',
    [3] = '材料',
    [4] = '其他'
}


-- 物品品质配置
ItemCfg.ItemQuality = {
    [0] = {Bg='/the_law_of_infinite_genes/Asset/Texture/UI/Image_BigQualityBg_1.Image_BigQualityBg_1', name='普通', color='#FFFFFF', bar='/the_law_of_infinite_genes/Asset/Texture/UI/Image_QualityBar_1.Image_QualityBar_1'},
    [1] = {Bg='/the_law_of_infinite_genes/Asset/Texture/UI/Image_BigQualityBg_2.Image_BigQualityBg_2', name='平凡', color='#2ECC71', bar='/the_law_of_infinite_genes/Asset/Texture/UI/Image_QualityBar_2.Image_QualityBar_2'},
    [2] = {Bg='/the_law_of_infinite_genes/Asset/Texture/UI/Image_BigQualityBg_3.Image_BigQualityBg_3', name='精良', color='#3498DB', bar='/the_law_of_infinite_genes/Asset/Texture/UI/Image_QualityBar_3.Image_QualityBar_3'},
    [3] = {Bg='/the_law_of_infinite_genes/Asset/Texture/UI/Image_BigQualityBg_4.Image_BigQualityBg_4', name='稀有', color='#9B59B6', bar='/the_law_of_infinite_genes/Asset/Texture/UI/Image_QualityBar_4.Image_QualityBar_4'},
    [4] = {Bg='/the_law_of_infinite_genes/Asset/Texture/UI/Image_BigQualityBg_5.Image_BigQualityBg_5', name='传说', color='#E67E22', bar='/the_law_of_infinite_genes/Asset/Texture/UI/Image_QualityBar_5.Image_QualityBar_5'},
    [5] = {Bg='/the_law_of_infinite_genes/Asset/Texture/UI/Image_BigQualityBg_6.Image_BigQualityBg_6', name='史诗', color='#F1C40F', bar='/the_law_of_infinite_genes/Asset/Texture/UI/Image_QualityBar_6.Image_QualityBar_6'},
    [6] = {Bg='/the_law_of_infinite_genes/Asset/Texture/UI/Image_BigQualityBg_7.Image_BigQualityBg_7', name='神话', color='#E74C3C', bar='/the_law_of_infinite_genes/Asset/Texture/UI/Image_QualityBar_7.Image_QualityBar_7'}
}


ItemCfg.CustomizeType = {
    Body = true,
    Feet = true,
    Face = true,
    Head = true,
    Legs = true,
}
ItemCfg.KenlType = 'Kenl'

ItemCfg.MaterialType = 'Material'

ItemCfg.ItemDef = {
    [1] = '帽子',
    [2] = '脸饰',
    [3] = '衣服',
    [4] = '裤子',
    [5] = '鞋子',
    [6] = '消耗品',
    [7] = '材料',
    [8] = '其他',
}


ItemCfg.ItemTable = {
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


-- 合成表 材料ID {8310014 = 领主之眼, 8310015 = 腐化布料, 8310016 = 硬化骨片, 8310017 = 变异粘液}
ItemCfg.Formula = {
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


return ItemCfg