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
}
ItemCfg.AttributeEntryPool = Lib.Table.Keys(ItemCfg.AttributeEntryRange)


ItemCfg.EntryItemId = {
    [0] = 8310042,
    [1] = 8310046,
    [2] = 8310044,
    [3] = 8310049,
    [4] = 8310050,
}


-- 词条数值曲线
ItemCfg.AttrCurve = function(min, max, ...)
    local p = math.random() ^ 2.2
    return min + p * (max - min)
end


-- 鉴定配置
ItemCfg.Identify = {
    -- 消耗的材料ItemId
    Material = 8310000,
    -- 消耗的材料数量
    Cost = {
        [8310042] = 100,
        [8310046] = 150,
        [8310044] = 200,
        [8310049] = 250,
        [8310050] = 300,
    },
}


-- 融合配置
ItemCfg.Fusion = {
}


-- 洗炼配置
ItemCfg.Refine = {
    -- 洗炼次数上限
    Limit = 5,
}


-- 强化配置
ItemCfg.Strengthen = {
    -- 消耗的材料ItemId
    Material = 8310000,
    -- 最大强化等级
    MaxLevel = 100,
    -- 强化概率曲线
    _ProbMap = {
        [1] = 1.0,
        [2] = 0.95,
        [3] = 0.9,
        [4] = 0.85,
        [5] = 0.80,
        [6] = 0.75,
        [7] = 0.70,
        [8] = 0.65,
        [9] = 0.60,
        [10] = 0.55,
        [11] = 0.50,
        [12] = 0.45,
        [13] = 0.40,
        [14] = 0.35,
        [15] = 0.30,
        [16] = 0.25,
        [18] = 0.20,
        [19] = 0.15,
        [20] = 0.10,
        [21] = 0.05,
        [22] = 0.05,
        [23] = 0.05,
        [24] = 0.05,
        [25] = 0.05,
        [26] = 0.05,
        [27] = 0.05,
        [28] = 0.05,
        [29] = 0.05,
        [30] = 0.04,
        [31] = 0.03,
        [32] = 0.02,
        [33] = 0.01,
        [34] = 0.095,
        [35] = 0.090,
        [36] = 0.085,
        [37] = 0.080,
        [38] = 0.075,
        [39] = 0.07,
        [40] = 0.065,
        [41] = 0.060,
        -- [42...100] = 0.050,
    },
    ProbCurve = function (level, quality)
        return ItemCfg.Strengthen._ProbMap[level]
    end,
    -- 强化提升百分比曲线
    StrengthenCurve = function (attr, level, quality)
        return level * 0.01
    end,
}
for l = 42, 100 do
    ItemCfg.Strengthen._ProbMap[l] = 0.050
end


-- 精炼配置
ItemCfg.Reforge = {
}


-- 物品类型配置
ItemCfg.ItemTypeName = {
    [1] = '装备',
    [2] = '消耗品',
    [3] = '材料',
    [4] = '其他'
}
ItemCfg.ItemType = {
    Kenl = "Kenl",
    Material = "Material",
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

ItemCfg.colorTable = {
    -- ============ 凡尘（Lv.1 ~ Lv.9）============
    [0] = { HexColor = '#3D3D3D', Text = '凡尘' },  -- Lv.1
    [1] = { HexColor = '#3E4040', Text = '凡尘' },  -- Lv.2
    [2] = { HexColor = '#3F4343', Text = '凡尘' },  -- Lv.3
    [3] = { HexColor = '#404646', Text = '凡尘' },  -- Lv.4
    [4] = { HexColor = '#414949', Text = '凡尘' },  -- Lv.5
    [5] = { HexColor = '#424C4C', Text = '凡尘' },  -- Lv.6
    [6] = { HexColor = '#434F4F', Text = '凡尘' },  -- Lv.7
    [7] = { HexColor = '#445252', Text = '凡尘' },  -- Lv.8
    [8] = { HexColor = '#455555', Text = '凡尘' },  -- Lv.9

    -- ============ 百炼（Lv.10 ~ Lv.24）============
    [9] = { HexColor = '#4A5A5A', Text = '百炼' },  -- Lv.10
    [10] = { HexColor = '#475E5A', Text = '百炼' }, -- Lv.11
    [11] = { HexColor = '#44625A', Text = '百炼' }, -- Lv.12
    [12] = { HexColor = '#41665A', Text = '百炼' }, -- Lv.13
    [13] = { HexColor = '#3E6A5A', Text = '百炼' }, -- Lv.14
    [14] = { HexColor = '#3B6E5A', Text = '百炼' }, -- Lv.15
    [15] = { HexColor = '#38725A', Text = '百炼' }, -- Lv.16
    [16] = { HexColor = '#35765A', Text = '百炼' }, -- Lv.17
    [17] = { HexColor = '#327A5A', Text = '百炼' }, -- Lv.18
    [18] = { HexColor = '#2F7E5A', Text = '百炼' }, -- Lv.19
    [19] = { HexColor = '#2C825A', Text = '百炼' }, -- Lv.20
    [20] = { HexColor = '#29865A', Text = '百炼' }, -- Lv.21
    [21] = { HexColor = '#268A5A', Text = '百炼' }, -- Lv.22
    [22] = { HexColor = '#238E5A', Text = '百炼' }, -- Lv.23
    [23] = { HexColor = '#20925A', Text = '百炼' }, -- Lv.24

    -- ============ 凝气（Lv.25 ~ Lv.39）============
    [24] = { HexColor = '#1D5C3A', Text = '凝气' }, -- Lv.25
    [25] = { HexColor = '#1C623C', Text = '凝气' }, -- Lv.26
    [26] = { HexColor = '#1B683E', Text = '凝气' }, -- Lv.27
    [27] = { HexColor = '#1A6E40', Text = '凝气' }, -- Lv.28
    [28] = { HexColor = '#197442', Text = '凝气' }, -- Lv.29
    [29] = { HexColor = '#187A44', Text = '凝气' }, -- Lv.30
    [30] = { HexColor = '#178046', Text = '凝气' }, -- Lv.31
    [31] = { HexColor = '#168648', Text = '凝气' }, -- Lv.32
    [32] = { HexColor = '#158C4A', Text = '凝气' }, -- Lv.33
    [33] = { HexColor = '#14924C', Text = '凝气' }, -- Lv.34
    [34] = { HexColor = '#13984E', Text = '凝气' }, -- Lv.35
    [35] = { HexColor = '#129E50', Text = '凝气' }, -- Lv.36
    [36] = { HexColor = '#11A452', Text = '凝气' }, -- Lv.37
    [37] = { HexColor = '#10AA54', Text = '凝气' }, -- Lv.38
    [38] = { HexColor = '#0FB056', Text = '凝气' }, -- Lv.39

    -- ============ 化灵（Lv.40 ~ Lv.54）============
    [39] = { HexColor = '#1050A0', Text = '化灵' }, -- Lv.40
    [40] = { HexColor = '#125599', Text = '化灵' }, -- Lv.41
    [41] = { HexColor = '#145A92', Text = '化灵' }, -- Lv.42
    [42] = { HexColor = '#165F8B', Text = '化灵' }, -- Lv.43
    [43] = { HexColor = '#186484', Text = '化灵' }, -- Lv.44
    [44] = { HexColor = '#1A697D', Text = '化灵' }, -- Lv.45
    [45] = { HexColor = '#1C6E76', Text = '化灵' }, -- Lv.46
    [46] = { HexColor = '#1E736F', Text = '化灵' }, -- Lv.47
    [47] = { HexColor = '#207868', Text = '化灵' }, -- Lv.48
    [48] = { HexColor = '#227D61', Text = '化灵' }, -- Lv.49
    [49] = { HexColor = '#24825A', Text = '化灵' }, -- Lv.50
    [50] = { HexColor = '#268753', Text = '化灵' }, -- Lv.51
    [51] = { HexColor = '#288C4C', Text = '化灵' }, -- Lv.52
    [52] = { HexColor = '#2A9145', Text = '化灵' }, -- Lv.53
    [53] = { HexColor = '#2C963E', Text = '化灵' }, -- Lv.54

    -- ============ 道蕴（Lv.55 ~ Lv.69）============
    [54] = { HexColor = '#5500AA', Text = '道蕴' }, -- Lv.55
    [55] = { HexColor = '#5300A6', Text = '道蕴' }, -- Lv.56
    [56] = { HexColor = '#5100A2', Text = '道蕴' }, -- Lv.57
    [57] = { HexColor = '#4F009E', Text = '道蕴' }, -- Lv.58
    [58] = { HexColor = '#4D009A', Text = '道蕴' }, -- Lv.59
    [59] = { HexColor = '#4B0096', Text = '道蕴' }, -- Lv.60
    [60] = { HexColor = '#490092', Text = '道蕴' }, -- Lv.61
    [61] = { HexColor = '#47008E', Text = '道蕴' }, -- Lv.62
    [62] = { HexColor = '#45008A', Text = '道蕴' }, -- Lv.63
    [63] = { HexColor = '#430086', Text = '道蕴' }, -- Lv.64
    [64] = { HexColor = '#410082', Text = '道蕴' }, -- Lv.65
    [65] = { HexColor = '#3F007E', Text = '道蕴' }, -- Lv.66
    [66] = { HexColor = '#3D007A', Text = '道蕴' }, -- Lv.67
    [67] = { HexColor = '#3B0076', Text = '道蕴' }, -- Lv.68
    [68] = { HexColor = '#390072', Text = '道蕴' }, -- Lv.69

    -- ============ 涅槃（Lv.70 ~ Lv.84）============
    [69] = { HexColor = '#B02800', Text = '涅槃' }, -- Lv.70
    [70] = { HexColor = '#B43008', Text = '涅槃' }, -- Lv.71
    [71] = { HexColor = '#B83810', Text = '涅槃' }, -- Lv.72
    [72] = { HexColor = '#BC4018', Text = '涅槃' }, -- Lv.73
    [73] = { HexColor = '#C04820', Text = '涅槃' }, -- Lv.74
    [74] = { HexColor = '#C45028', Text = '涅槃' }, -- Lv.75
    [75] = { HexColor = '#C85830', Text = '涅槃' }, -- Lv.76
    [76] = { HexColor = '#CC6038', Text = '涅槃' }, -- Lv.77
    [77] = { HexColor = '#D06840', Text = '涅槃' }, -- Lv.78
    [78] = { HexColor = '#D47048', Text = '涅槃' }, -- Lv.79
    [79] = { HexColor = '#D87850', Text = '涅槃' }, -- Lv.80
    [80] = { HexColor = '#DC8058', Text = '涅槃' }, -- Lv.81
    [81] = { HexColor = '#E08860', Text = '涅槃' }, -- Lv.82
    [82] = { HexColor = '#E49068', Text = '涅槃' }, -- Lv.83
    [83] = { HexColor = '#E89870', Text = '涅槃' }, -- Lv.84

    -- ============ 造化（Lv.85 ~ Lv.100）============
    [84] = { HexColor = '#CC8800', Text = '造化' }, -- Lv.85
    [85] = { HexColor = '#D18E08', Text = '造化' }, -- Lv.86
    [86] = { HexColor = '#D69410', Text = '造化' }, -- Lv.87
    [87] = { HexColor = '#DB9A18', Text = '造化' }, -- Lv.88
    [88] = { HexColor = '#E0A020', Text = '造化' }, -- Lv.89
    [89] = { HexColor = '#E5A628', Text = '造化' }, -- Lv.90
    [90] = { HexColor = '#EAAC30', Text = '造化' }, -- Lv.91
    [91] = { HexColor = '#EFB238', Text = '造化' }, -- Lv.92
    [92] = { HexColor = '#F4B840', Text = '造化' }, -- Lv.93
    [93] = { HexColor = '#F9BE48', Text = '造化' }, -- Lv.94
    [94] = { HexColor = '#FEC450', Text = '造化' }, -- Lv.95
    [95] = { HexColor = '#FFCA58', Text = '造化' }, -- Lv.96
    [96] = { HexColor = '#FFD060', Text = '造化' }, -- Lv.97
    [97] = { HexColor = '#FFD668', Text = '造化' }, -- Lv.98
    [98] = { HexColor = '#FFDC70', Text = '造化' }, -- Lv.99
    [99] = { HexColor = '#FFD800', Text = '造化' }, -- Lv.100
}


ItemCfg.CustomizeType = {
    Body = true,
    Feet = true,
    Face = true,
    Head = true,
    Legs = true,
}


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
    Head = {
        8310021,
        8310026,
        8310031
    },
    Face = {
        8310020,
        8310025,
        8310030,
        8310009,
    },
    Body = {
        8310023,
        8310028,
        8310033,
        8310007,
    },
    Legs = {
        8310019,
        8310024,
        8310029,
        8310008
    },
    Feet = {
        8310022,
        8310027,
        8310032,
        8310011,
    },
    [6] = {

    },
    Material = {
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

ItemCfg.EquipmentAttribute = {
    ['基础帽子'] = {
        Base = {
            {property = Attribute.HealthMax, value = 20},
            {property = Attribute.AttackPower, value = 20},
            {property = Attribute.Defence, value = 10}
        },
        Factor = {
            [0] = 1.00,
            [1] = 1.20,
            [2] = 1.60,
            [3] = 1.80,
            [4] = 2.00
        }
    },
    ['基础脸饰'] = {
        Base = {
            {property = Attribute.HealthMax, value = 20},
            {property = Attribute.AttackPower, value = 20},
            {property = Attribute.Defence, value = 10}
        },
        Factor = {
            [0] = 1.00,
            [1] = 1.20,
            [2] = 1.60,
            [3] = 1.80,
            [4] = 2.00
        }
    },
    ['基础上衣'] = {
        Base = {
            {property = Attribute.HealthMax, value = 20},
            {property = Attribute.AttackPower, value = 20},
            {property = Attribute.Defence, value = 10}
        },
        Factor = {
            [0] = 1.00,
            [1] = 1.20,
            [2] = 1.60,
            [3] = 1.80,
            [4] = 2.00
        }
    },
    ['基础裤子'] = {
        Base = {
            {property = Attribute.HealthMax, value = 20},
            {property = Attribute.AttackPower, value = 20},
            {property = Attribute.Defence, value = 10}
        },
        Factor = {
            [0] = 1.00,
            [1] = 1.20,
            [2] = 1.60,
            [3] = 1.80,
            [4] = 2.00
        }
    },
    ['基础鞋子'] = {
        Base = {
            {property = Attribute.HealthMax, value = 20},
            {property = Attribute.AttackPower, value = 20},
            {property = Attribute.Defence, value = 10}
        },
        Factor = {
            [0] = 1.00,
            [1] = 1.20,
            [2] = 1.60,
            [3] = 1.80,
            [4] = 2.00
        }
    },

}

ItemCfg.FirearmType = {
    {Type = 'Ammo', Text = '子弹'},
    {Type = 'Rifle', Text = '步枪'},
    {Type = 'SMG', Text = '冲锋枪'},
    {Type = 'LMG', Text = '轻机枪'},
    {Type = 'Shotgun', Text = '霰弹枪'},
    {Type = 'Snipe', Text = '狙击枪'},
    {Type = 'Pistol', Text = '手枪'},
}

ItemCfg.FirearmPurchase = {
    Ammo = {
        {ItemId=831301001, cost=100},
        {ItemId=831301002, cost=100},
        {ItemId=831302001, cost=100},
        {ItemId=831303001, cost=100},
        {ItemId=831304001, cost=100},
        {ItemId=831305001, cost=100},
        {ItemId=831305002, cost=100},
        {ItemId=831306001, cost=100},
        {ItemId=831306002, cost=100},
        {ItemId=831306003, cost=100},
        {ItemId=831307001, cost=100},
        {ItemId=831307002, cost=100},
        {ItemId=831307003, cost=100},
        {ItemId=831307004, cost=100},
        {ItemId=831307099, cost=100},
        {ItemId=831307100, cost=100},
        {ItemId=831307101, cost=100},
        {ItemId=831307102, cost=100},
        {ItemId=831307103, cost=100},
    },
    Rifle = {
        {ItemId=8310163, cost=100},
        {ItemId=8310161, cost=100},
        {ItemId=8310164, cost=100},
        {ItemId=8310184, cost=100},

    },
    SMG = {
        {ItemId=8310018, cost=100},
        {ItemId=8310165, cost=100},
        {ItemId=8310167, cost=100},
        {ItemId=8310163, cost=100},
        {ItemId=8310166, cost=100},
    },
    LMG = {
        {ItemId=8310178, cost=100},
        {ItemId=8310180, cost=100},
        {ItemId=8310179, cost=100},
    },
    Shotgun = {
        {ItemId=8310176, cost=100},
        {ItemId=8310175, cost=100},
        {ItemId=8310177, cost=100},
    },
    Snipe = {
        {ItemId=8310168, cost=100},
        {ItemId=8310169, cost=100},
        {ItemId=8310174, cost=100},
        {ItemId=8310172, cost=100},
        {ItemId=8310170, cost=100},
        {ItemId=8310171, cost=100},
    },
    Pistol = {
        {ItemId=8310181, cost=100},
        {ItemId=8310182, cost=100},
        {ItemId=8310183, cost=100},
    }
}

return ItemCfg