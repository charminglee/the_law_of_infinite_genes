ItemCfg = ItemCfg or {}


-- 装备词条数值范围
ItemCfg.AttributeEntryRange = {
    [Attribute.AttackPower]                 = { Min=0, Max=1 },
    [Attribute.AttackPowerPct]              = { Min=0, Max=1 },
    [Attribute.DamagePct]                   = { Min=0, Max=1 },
    [Attribute.NormalMonsterDamagePct]      = { Min=0, Max=1 },
    [Attribute.EliteMonsterDamagePct]       = { Min=0, Max=1 },
    [Attribute.BossDamagePct]               = { Min=0, Max=1 },
    [Attribute.CritChance]                  = { Min=0, Max=1 },
    [Attribute.CritDamagePct]               = { Min=0, Max=1 },
    [Attribute.Defence]                     = { Min=0, Max=1 },
    [Attribute.DefensePct]                  = { Min=0, Max=1 },
    [Attribute.HealthStealPct]              = { Min=0, Max=1 },
    [Attribute.CounterAttackPct]            = { Min=0, Max=1 },
    [Attribute.DamageDecreace]              = { Min=0, Max=1 },
    [Attribute.DamageDecreacePct]           = { Min=0, Max=1 },
    [Attribute.BreakDefencePct]             = { Min=0, Max=1 },
    [Attribute.SeckillChance]               = { Min=0, Max=1 },
    [Attribute.DodgeChance]                 = { Min=0, Max=1 },
    [Attribute.HealthMax]                   = { Min=0, Max=1 },
    [Attribute.HealthMaxPct]                = { Min=0, Max=1 },
    [Attribute.RecoilPct]                   = { Min=0, Max=1 },
    [Attribute.ReloadTime]                  = { Min=0, Max=1 },
    [Attribute.ReloadTimePct]               = { Min=0, Max=1 },
    [Attribute.MoveSpeedScale]              = { Min=0, Max=2 },
    [Attribute.ShootSpeedScale]             = { Min=0, Max=2 },
    [Attribute.EpidemicToxinRatio]          = { Min=0, Max=1 },
    [Attribute.EpidemicToxinLevel]          = { Min=0, Max=1 },
    [Attribute.EpidemicToxinOverlyLimit]    = { Min=0, Max=1 },
    [Attribute.EpidemicToxinSettleRatio]    = { Min=0, Max=1 },
}
ItemCfg.AttributeEntryPool = Lib.Table.Keys(ItemCfg.AttributeEntryRange)


ItemCfg.EntryItemId = {
    [0] = ItemId.Kenl_0_0,
    [1] = ItemId.Kenl_0_1,
    [2] = ItemId.Kenl_0_2,
    [3] = ItemId.Kenl_0_3,
    [4] = ItemId.Kenl_0_4,
}


-- 词条数值曲线
ItemCfg.AttrCurve = function(min, max, ...)
    local p = math.random() ^ 2.2
    return min + p * (max - min)
end


-- 鉴定配置
ItemCfg.Identify = {
    -- 消耗的材料ItemId
    Material = ItemId.Coin_0,
    -- 消耗的材料数量
    Cost = {
        [ItemId.Kenl_0_0] = 100,
        [ItemId.Kenl_0_1] = 150,
        [ItemId.Kenl_0_2] = 200,
        [ItemId.Kenl_0_3] = 250,
        [ItemId.Kenl_0_4] = 300,
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
    Material = ItemId.Coin_0,
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
        [17] = 0.20,
        [18] = 0.15,
        [19] = 0.10,
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
for i = 42, 100 do
    ItemCfg.Strengthen._ProbMap[i] = 0.050
end


-- 精炼配置
ItemCfg.Reforge = {
    -- 宇宙晶石概率提升
    AdvancedProbBoost = 0.2,
    ReforgeMap = {
        --- =========== 衣服 -- Body =========== ---
        --- suit 0 新手套装 15 16 17 13 14
        [8310020] = {Result = 8310051,Requirement={{ItemId=8310015, Value=5 },{ItemId=8310016, Value=5 }},Prob=0.95},
        [8310051] = {Result = 8310054,Requirement={{ItemId=8310015, Value=10},{ItemId=8310016, Value=10}},Prob=0.80},
        [8310054] = {Result = 8310058,Requirement={{ItemId=8310016, Value=15},{ItemId=8310017, Value=5 }},Prob=0.60},
        [8310058] = {Result = 8310057,Requirement={{ItemId=8310017, Value=10},{ItemId=8310013, Value=5 }},Prob=0.40},
        --- suit0 进阶 suit1
        [8310057] = {Result = 8310028,Requirement={{ItemId=8310013, Value=10},{ItemId=8310014, Value=5 }},Prob=0.20},
        --- suit 1  赤锋套装 189 194 201 206 207
        [8310028] = {Result = 8310071,Requirement={{ItemId=8310189, Value=5},{ItemId=8310194, Value=5 }},Prob=0.95},
        [8310071] = {Result = 8310072,Requirement={{ItemId=8310189, Value=10},{ItemId=8310194, Value=10 }},Prob=0.80},
        [8310072] = {Result = 8310073,Requirement={{ItemId=8310194, Value=15},{ItemId=8310201, Value=15 }},Prob=0.65},
        [8310073] = {Result = 8310074,Requirement={{ItemId=8310194, Value=20},{ItemId=8310201, Value=5 }},Prob=0.50},
        [8310074] = {Result = 8310075,Requirement={{ItemId=8310194, Value=30},{ItemId=8310201, Value=10 }},Prob=0.35},
        [8310075] = {Result = 8310076,Requirement={{ItemId=8310201, Value=50},{ItemId=8310206, Value=20 }},Prob=0.20},
        --- suit1 进阶 suit 2
        [8310076] = {Result = 8310033,Requirement={{ItemId=8310206, Value=30},{ItemId=8310207, Value=10 }},Prob=0.05},
        --- suit 2  荒土套装 190 197 204 208 209
        [8310033] = {Result = 8310101,Requirement={{ItemId=8310190, Value=5},{ItemId=8310197, Value=5 }},Prob=0.95},
        [8310101] = {Result = 8310102,Requirement={{ItemId=8310190, Value=10},{ItemId=8310197, Value=10 }},Prob=0.80},
        [8310102] = {Result = 8310103,Requirement={{ItemId=8310197, Value=15},{ItemId=8310204, Value=15 }},Prob=0.65},
        [8310103] = {Result = 8310104,Requirement={{ItemId=8310197, Value=20},{ItemId=8310204, Value=5 }},Prob=0.50},
        [8310104] = {Result = 8310105,Requirement={{ItemId=8310197, Value=30},{ItemId=8310204, Value=10 }},Prob=0.35},
        [8310105] = {Result = 8310106,Requirement={{ItemId=8310204, Value=50},{ItemId=8310208, Value=20}},Prob=0.20},
        --- suit2 进阶 suit 3
        [8310106] = {Result = 8310007,Requirement={{ItemId=8310208, Value=30},{ItemId=8310209, Value=10}},Prob=0.05},
        --- suit 3  荒漠套装 191 198 205 210 211
        [8310007] = {Result = 8310131,Requirement={{ItemId=8310191, Value=5 },{ItemId=8310198, Value=5 }},Prob=0.95},
        [8310131] = {Result = 8310132,Requirement={{ItemId=8310191, Value=10},{ItemId=8310198, Value=10}},Prob=0.80},
        [8310132] = {Result = 8310133,Requirement={{ItemId=8310198, Value=15},{ItemId=8310205, Value=15}},Prob=0.65},
        [8310133] = {Result = 8310134,Requirement={{ItemId=8310198, Value=20},{ItemId=8310205, Value=5 }},Prob=0.50},
        [8310134] = {Result = 8310135,Requirement={{ItemId=8310198, Value=30},{ItemId=8310205, Value=10}},Prob=0.35},
        [8310135] = {Result = 8310136,Requirement={{ItemId=8310205, Value=50},{ItemId=8310210, Value=20}},Prob=0.20},


        --- =========== 脸饰 -- Face =========== ---
        --- suit 0 新手套装 15 16 17 13 14
        [8310022] = {Result = 8310059,Requirement={{ItemId=8310015, Value=5 },{ItemId=8310016, Value=5 }},Prob=0.95},
        [8310059] = {Result = 8310060,Requirement={{ItemId=8310015, Value=10},{ItemId=8310016, Value=10}},Prob=0.80},
        [8310060] = {Result = 8310061,Requirement={{ItemId=8310016, Value=15},{ItemId=8310017, Value=5 }},Prob=0.60},
        [8310061] = {Result = 8310062,Requirement={{ItemId=8310017, Value=10},{ItemId=8310013, Value=5 }},Prob=0.40},
        --- suit0 进阶 suit1
        [8310062] = {Result = 8310025,Requirement={{ItemId=8310013, Value=10},{ItemId=8310014, Value=5 }},Prob=0.20},
        --- suit 1  赤锋套装 189 194 201 206 207
        [8310025] = {Result = 8310077,Requirement={{ItemId=8310189, Value=5},{ItemId=8310194, Value=5 }},Prob=0.95},
        [8310077] = {Result = 8310078,Requirement={{ItemId=8310189, Value=10},{ItemId=8310194, Value=10 }},Prob=0.80},
        [8310078] = {Result = 8310079,Requirement={{ItemId=8310194, Value=15},{ItemId=8310201, Value=15 }},Prob=0.65},
        [8310079] = {Result = 8310080,Requirement={{ItemId=8310194, Value=20},{ItemId=8310201, Value=5 }},Prob=0.50},
        [8310080] = {Result = 8310081,Requirement={{ItemId=8310194, Value=30},{ItemId=8310201, Value=10 }},Prob=0.35},
        [8310081] = {Result = 8310082,Requirement={{ItemId=8310201, Value=50},{ItemId=8310206, Value=20 }},Prob=0.20},
        --- suit1 进阶 suit 2
        [8310082] = {Result = 8310030,Requirement={{ItemId=8310206, Value=30},{ItemId=8310207, Value=10 }},Prob=0.05},
        --- suit 2  荒土套装 190 197 204 208 209
        [8310030] = {Result = 8310107,Requirement={{ItemId=8310190, Value=5},{ItemId=8310197, Value=5 }},Prob=0.95},
        [8310107] = {Result = 8310108,Requirement={{ItemId=8310190, Value=10},{ItemId=8310197, Value=10 }},Prob=0.80},
        [8310108] = {Result = 8310109,Requirement={{ItemId=8310197, Value=15},{ItemId=8310204, Value=15 }},Prob=0.65},
        [8310109] = {Result = 8310110,Requirement={{ItemId=8310197, Value=20},{ItemId=8310204, Value=5 }},Prob=0.50},
        [8310110] = {Result = 8310111,Requirement={{ItemId=8310197, Value=30},{ItemId=8310204, Value=10 }},Prob=0.35},
        [8310111] = {Result = 8310112,Requirement={{ItemId=8310204, Value=50},{ItemId=8310208, Value=20}},Prob=0.20},
        --- suit2 进阶 suit 3
        [8310112] = {Result = 8310009,Requirement={{ItemId=8310208, Value=30},{ItemId=8310209, Value=10}},Prob=0.05},
        --- suit 3  荒漠套装 191 198 205 210 211
        [8310009] = {Result = 8310137,Requirement={{ItemId=8310191, Value=5},{ItemId=8310198, Value=5 }},Prob=0.95},
        [8310137] = {Result = 8310138,Requirement={{ItemId=8310191, Value=10},{ItemId=8310198, Value=10 }},Prob=0.80},
        [8310138] = {Result = 8310139,Requirement={{ItemId=8310198, Value=15},{ItemId=8310205, Value=15 }},Prob=0.65},
        [8310139] = {Result = 8310140,Requirement={{ItemId=8310198, Value=20},{ItemId=8310205, Value=5 }},Prob=0.50},
        [8310140] = {Result = 8310141,Requirement={{ItemId=8310198, Value=30},{ItemId=8310205, Value=10 }},Prob=0.35},
        [8310141] = {Result = 8310142,Requirement={{ItemId=8310205, Value=50},{ItemId=8310210, Value=20 }},Prob=0.20},

        --- =========== 鞋子 -- Feet =========== ---
        --- suit 0 新手套装 15 16 17 13 14
        [8310023] = {Result = 8310063,Requirement={{ItemId=8310015, Value=5 },{ItemId=8310016, Value=5 }},Prob=0.95},
        [8310063] = {Result = 8310064,Requirement={{ItemId=8310015, Value=10},{ItemId=8310016, Value=10}},Prob=0.80},
        [8310064] = {Result = 8310065,Requirement={{ItemId=8310016, Value=15},{ItemId=8310017, Value=5 }},Prob=0.60},
        [8310065] = {Result = 8310066,Requirement={{ItemId=8310017, Value=10},{ItemId=8310013, Value=5 }},Prob=0.40},
        --- suit0 进阶 suit1
        [8310066] = {Result = 8310027,Requirement={{ItemId=8310013, Value=10},{ItemId=8310014, Value=5 }},Prob=0.20},
        --- suit 1 赤锋套装 189 194 201 206 207
        [8310027] = {Result = 8310083,Requirement={{ItemId=8310189, Value=5},{ItemId=8310194, Value=5 }},Prob=0.95},
        [8310083] = {Result = 8310084,Requirement={{ItemId=8310189, Value=10},{ItemId=8310194, Value=10}},Prob=0.80},
        [8310084] = {Result = 8310085,Requirement={{ItemId=8310194, Value=15},{ItemId=8310201, Value=15}},Prob=0.65},
        [8310085] = {Result = 8310086,Requirement={{ItemId=8310194, Value=20},{ItemId=8310201, Value=5 }},Prob=0.50},
        [8310086] = {Result = 8310087,Requirement={{ItemId=8310194, Value=30},{ItemId=8310201, Value=10}},Prob=0.35},
        [8310087] = {Result = 8310088,Requirement={{ItemId=8310201, Value=50},{ItemId=8310206, Value=20}},Prob=0.20},
        --- suit1 进阶 suit2
        [8310088] = {Result = 8310032,Requirement={{ItemId=8310206, Value=30},{ItemId=8310207, Value=10}},Prob=0.05},
        --- suit 2 荒土套装 190 197 204 208 209
        [8310032] = {Result = 8310113,Requirement={{ItemId=8310190, Value=5},{ItemId=8310197, Value=5 }},Prob=0.95},
        [8310113] = {Result = 8310114,Requirement={{ItemId=8310190, Value=10},{ItemId=8310197, Value=10}},Prob=0.80},
        [8310114] = {Result = 8310115,Requirement={{ItemId=8310197, Value=15},{ItemId=8310204, Value=15}},Prob=0.65},
        [8310115] = {Result = 8310116,Requirement={{ItemId=8310197, Value=20},{ItemId=8310204, Value=5 }},Prob=0.50},
        [8310116] = {Result = 8310117,Requirement={{ItemId=8310197, Value=30},{ItemId=8310204, Value=10}},Prob=0.35},
        [8310117] = {Result = 8310118,Requirement={{ItemId=8310204, Value=50},{ItemId=8310208, Value=20}},Prob=0.20},
        --- suit2 进阶 suit3
        [8310118] = {Result = 8310011,Requirement={{ItemId=8310208, Value=30},{ItemId=8310209, Value=10}},Prob=0.05},
        --- suit 3 荒漠套装 191 198 205 210 211
        [8310011] = {Result = 8310143,Requirement={{ItemId=8310191, Value=5},{ItemId=8310198, Value=5 }},Prob=0.95},
        [8310143] = {Result = 8310144,Requirement={{ItemId=8310191, Value=10},{ItemId=8310198, Value=10}},Prob=0.80},
        [8310144] = {Result = 8310145,Requirement={{ItemId=8310198, Value=15},{ItemId=8310205, Value=15}},Prob=0.65},
        [8310145] = {Result = 8310146,Requirement={{ItemId=8310198, Value=20},{ItemId=8310205, Value=5 }},Prob=0.50},
        [8310146] = {Result = 8310147,Requirement={{ItemId=8310198, Value=30},{ItemId=8310205, Value=10}},Prob=0.35},
        [8310147] = {Result = 8310148,Requirement={{ItemId=8310205, Value=50},{ItemId=8310210, Value=20}},Prob=0.20},

        --- =========== 帽子 -- Head =========== ---
        --- suit 0 新手套装 15 16 17 13 14
        [8310019] = {Result = 8310067,Requirement={{ItemId=8310015, Value=5 },{ItemId=8310016, Value=5 }},Prob=0.95},
        [8310067] = {Result = 8310068,Requirement={{ItemId=8310015, Value=10},{ItemId=8310016, Value=10}},Prob=0.80},
        [8310068] = {Result = 8310069,Requirement={{ItemId=8310016, Value=15},{ItemId=8310017, Value=5 }},Prob=0.60},
        [8310069] = {Result = 8310070,Requirement={{ItemId=8310017, Value=10},{ItemId=8310013, Value=5 }},Prob=0.40},
        --- suit0 进阶 suit1
        [8310070] = {Result = 8310026,Requirement={{ItemId=8310013, Value=10},{ItemId=8310014, Value=5 }},Prob=0.20},
        --- suit 1 赤锋套装 189 194 201 206 207
        [8310026] = {Result = 8310089,Requirement={{ItemId=8310189, Value=5},{ItemId=8310194, Value=5 }},Prob=0.95},
        [8310089] = {Result = 8310090,Requirement={{ItemId=8310189, Value=10},{ItemId=8310194, Value=10}},Prob=0.80},
        [8310090] = {Result = 8310091,Requirement={{ItemId=8310194, Value=15},{ItemId=8310201, Value=15}},Prob=0.65},
        [8310091] = {Result = 8310092,Requirement={{ItemId=8310194, Value=20},{ItemId=8310201, Value=5 }},Prob=0.50},
        [8310092] = {Result = 8310093,Requirement={{ItemId=8310194, Value=30},{ItemId=8310201, Value=10}},Prob=0.35},
        [8310093] = {Result = 8310094,Requirement={{ItemId=8310201, Value=50},{ItemId=8310206, Value=20}},Prob=0.20},
        --- suit1 进阶 suit2
        [8310094] = {Result = 8310031,Requirement={{ItemId=8310206, Value=30},{ItemId=8310207, Value=10}},Prob=0.05},
        --- suit 2 荒土套装 190 197 204 208 209
        [8310031] = {Result = 8310119,Requirement={{ItemId=8310190, Value=5},{ItemId=8310197, Value=5 }},Prob=0.95},
        [8310119] = {Result = 8310120,Requirement={{ItemId=8310190, Value=10},{ItemId=8310197, Value=10}},Prob=0.80},
        [8310120] = {Result = 8310121,Requirement={{ItemId=8310197, Value=15},{ItemId=8310204, Value=15}},Prob=0.65},
        [8310121] = {Result = 8310122,Requirement={{ItemId=8310197, Value=20},{ItemId=8310204, Value=5 }},Prob=0.50},
        [8310122] = {Result = 8310123,Requirement={{ItemId=8310197, Value=30},{ItemId=8310204, Value=10}},Prob=0.35},
        [8310123] = {Result = 8310124,Requirement={{ItemId=8310204, Value=50},{ItemId=8310208, Value=20}},Prob=0.20},
        --- suit2 进阶 suit3
        [8310124] = {Result = 8310010,Requirement={{ItemId=8310208, Value=30},{ItemId=8310209, Value=10}},Prob=0.05},
        --- suit 3 荒漠套装 191 198 205 210 211
        [8310010] = {Result = 8310149,Requirement={{ItemId=8310191, Value=5},{ItemId=8310198, Value=5 }},Prob=0.95},
        [8310149] = {Result = 8310150,Requirement={{ItemId=8310191, Value=10},{ItemId=8310198, Value=10}},Prob=0.80},
        [8310150] = {Result = 8310151,Requirement={{ItemId=8310198, Value=15},{ItemId=8310205, Value=15}},Prob=0.65},
        [8310151] = {Result = 8310152,Requirement={{ItemId=8310198, Value=20},{ItemId=8310205, Value=5 }},Prob=0.50},
        [8310152] = {Result = 8310153,Requirement={{ItemId=8310198, Value=30},{ItemId=8310205, Value=10}},Prob=0.35},
        [8310153] = {Result = 8310154,Requirement={{ItemId=8310205, Value=50},{ItemId=8310210, Value=20}},Prob=0.20},


        --- =========== 裤子 -- Legs =========== ---
        --- suit 0 新手套装 15 16 17 13 14
        [8310021] = {Result = 8310034,Requirement={{ItemId=8310015, Value=5 },{ItemId=8310016, Value=5 }},Prob=0.95},
        [8310034] = {Result = 8310035,Requirement={{ItemId=8310015, Value=10},{ItemId=8310016, Value=10}},Prob=0.80},
        [8310035] = {Result = 8310038,Requirement={{ItemId=8310016, Value=15},{ItemId=8310017, Value=5 }},Prob=0.60},
        [8310038] = {Result = 8310041,Requirement={{ItemId=8310017, Value=10},{ItemId=8310013, Value=5 }},Prob=0.40},
        --- suit0 进阶 suit1
        [8310041] = {Result = 8310024,Requirement={{ItemId=8310013, Value=10},{ItemId=8310014, Value=5 }},Prob=0.20},
        --- suit 1 赤锋套装 189 194 201 206 207
        [8310024] = {Result = 8310095,Requirement={{ItemId=8310189, Value=5},{ItemId=8310194, Value=5 }},Prob=0.95},
        [8310095] = {Result = 8310096,Requirement={{ItemId=8310189, Value=10},{ItemId=8310194, Value=10}},Prob=0.80},
        [8310096] = {Result = 8310097,Requirement={{ItemId=8310194, Value=15},{ItemId=8310201, Value=15}},Prob=0.65},
        [8310097] = {Result = 8310098,Requirement={{ItemId=8310194, Value=20},{ItemId=8310201, Value=5 }},Prob=0.50},
        [8310098] = {Result = 8310099,Requirement={{ItemId=8310194, Value=30},{ItemId=8310201, Value=10}},Prob=0.35},
        [8310099] = {Result = 8310100,Requirement={{ItemId=8310201, Value=50},{ItemId=8310206, Value=20}},Prob=0.20},
        --- suit1 进阶 suit2
        [8310100] = {Result = 8310029,Requirement={{ItemId=8310206, Value=30},{ItemId=8310207, Value=10}},Prob=0.05},
        --- suit 2 荒土套装 190 197 204 208 209
        [8310029] = {Result = 8310125,Requirement={{ItemId=8310190, Value=5},{ItemId=8310197, Value=5 }},Prob=0.95},
        [8310125] = {Result = 8310126,Requirement={{ItemId=8310190, Value=10},{ItemId=8310197, Value=10}},Prob=0.80},
        [8310126] = {Result = 8310127,Requirement={{ItemId=8310197, Value=15},{ItemId=8310204, Value=15}},Prob=0.65},
        [8310127] = {Result = 8310128,Requirement={{ItemId=8310197, Value=20},{ItemId=8310204, Value=5 }},Prob=0.50},
        [8310128] = {Result = 8310129,Requirement={{ItemId=8310197, Value=30},{ItemId=8310204, Value=10}},Prob=0.35},
        [8310129] = {Result = 8310130,Requirement={{ItemId=8310204, Value=50},{ItemId=8310208, Value=20}},Prob=0.20},
        --- suit2 进阶 suit3
        [8310130] = {Result = 8310008,Requirement={{ItemId=8310208, Value=30},{ItemId=8310209, Value=10}},Prob=0.05},
        --- suit 3 荒漠套装 191 198 205 210 211
        [8310008] = {Result = 8310155,Requirement={{ItemId=8310191, Value=5},{ItemId=8310198, Value=5 }},Prob=0.95},
        [8310155] = {Result = 8310156,Requirement={{ItemId=8310191, Value=10},{ItemId=8310198, Value=10}},Prob=0.80},
        [8310156] = {Result = 8310157,Requirement={{ItemId=8310198, Value=15},{ItemId=8310205, Value=15}},Prob=0.65},
        [8310157] = {Result = 8310158,Requirement={{ItemId=8310198, Value=20},{ItemId=8310205, Value=5 }},Prob=0.50},
        [8310158] = {Result = 8310159,Requirement={{ItemId=8310198, Value=30},{ItemId=8310205, Value=10}},Prob=0.35},
        [8310159] = {Result = 8310160,Requirement={{ItemId=8310205, Value=50},{ItemId=8310210, Value=20}},Prob=0.20},

    }
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
        {ItemId=8310185, cost=100},
        {ItemId=8310186, cost=100},
        {ItemId=8310163, cost=100},
        {ItemId=8310161, cost=100},
        {ItemId=8310164, cost=100},
        {ItemId=8310184, cost=100},

    },
    SMG = {
        {ItemId=8310018, cost=100},
        {ItemId=8310165, cost=100},
        {ItemId=8310167, cost=100},
        {ItemId=8310166, cost=100},
    },
    LMG = {
        {ItemId=8310187, cost=100},
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
        {ItemId=8310173, cost=100},
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


ItemCfg.UnlockConditions = {
    [8310163] = {ItemId=8310162, value=3}, --- AUG
    [8310161] = {ItemId=8310162, value=1}, --- M416
    [8310164] = {ItemId=8310162, value=3}, --- Groza
    [8310184] = {ItemId=0, value=0}, --- 激光枪
    [8310018] = {ItemId=8310003, value=3000}, --- UZI
    [8310165] = {ItemId=8310162, value=3}, --- UMP45
    [8310167] = {ItemId=8310003, value=6000}, --- 野牛
    [8310166] = {ItemId=8310162, value=3}, --- P90
    [8310178] = {ItemId=8310162, value=3}, --- M249
    [8310180] = {ItemId=8310162, value=3}, --- M134
    [8310179] = {ItemId=8310162, value=3}, --- MG3
    [8310176] = {ItemId=8310162, value=3}, --- DBS
    [8310175] = {ItemId=8310003, value=3000}, --- S686
    [8310177] = {ItemId=8310003, value=6000}, --- S12K
    [8310168] = {ItemId=8310003, value=3000}, --- 98k
    [8310169] = {ItemId=8310003, value=6000}, --- M24
    [8310173] = {ItemId=8310003, value=3000}, --- VSS
    [8310174] = {ItemId=8310003, value=6000}, --- Mini14
    [8310172] = {ItemId=8310003, value=6000}, --- SKS
    [8310170] = {ItemId=8310162, value=3}, --- AWM
    [8310171] = {ItemId=8310162, value=3}, --- M200
    [8310181] = {ItemId=8310162, value=3}, --- 双持左轮
    [8310182] = {ItemId=8310003, value=3000}, --- 霰弹手枪
    [8310183] = {ItemId=8310003, value=3000}, --- 冲锋手枪
    [8310185] = {ItemId=8310003, value=6000}, --- AKM
    [8310186] = {ItemId=8310003, value=6000}, --- SCAR-L
    [8310187] = {ItemId=8310003, value=6000}, --- DP-28
}

return ItemCfg