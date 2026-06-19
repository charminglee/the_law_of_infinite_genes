---@type AttrMeta
AttributeMeta = {
    -- ===== 原有属性 =====
    [EAttribute.HealthMax]                  = { name = '最大血量', param = 'HealthMax' },
    [EAttribute.BaseImpactDamageWrapper]    = { name = '攻击力', param = 'BaseImpactDamageWrapper' },
    [EAttribute.NormalMonsterDamageBoost]   = { name = '普通怪物伤害加成', param = 'NormalMonsterDamageBoost' },
    [EAttribute.EliteMonsterDamageBoost]    = { name = '精锐怪物伤害加成', param = 'EliteMonsterDamageBoost' },
    [EAttribute.BossDamageBoost]            = { name = '首领怪物伤害加成', param = 'BossDamageBoost' },
    [EAttribute.CritChance]                 = { name = '暴击率', param = 'CritChance' },
    [EAttribute.CritDamageBoost]            = { name = '暴击伤害', param = 'CritDamageBoost' },
    [EAttribute.Defence]                    = { name = '防御', param = 'Defence' },
    [EAttribute.DefenseBoost]               = { name = '防御加成', param = 'DefenseBoost' },
    [EAttribute.HealthStealRatio]           = { name = '吸血倍率', param = 'HealthStealRatio' },
    [EAttribute.CounterAttackRatio]         = { name = '反弹伤害', param = 'CounterAttackRatio' },

    -- ===== 防御/护盾类 =====
    [EAttribute.MeleeDamageReduction]       = { name = '近战伤害减免', param = 'MeleeDamageReduction', desc = '% 减免' },
    [EAttribute.HeavyAttackReduction]       = { name = '重击伤害减免', param = 'HeavyAttackReduction', desc = '对重装感染者' },
    [EAttribute.ShieldOnHitProb]            = { name = '受击护盾概率', param = 'ShieldOnHitProb', desc = '概率 %' },
    [EAttribute.ShieldHPRatio]              = { name = '护盾生命百分比', param = 'ShieldHPRatio', desc = '最大生命 %' },
    [EAttribute.ShieldDuration]             = { name = '护盾持续秒数', param = 'ShieldDuration' },
    [EAttribute.ShieldThickness]            = { name = '护盾厚度', param = 'ShieldThickness', desc = '固定值' },
    [EAttribute.ShieldDMGReduce]            = { name = '护盾减伤', param = 'ShieldDMGReduce', desc = '护盾存在期间' },
    [EAttribute.AutoShieldInterval]         = { name = '自动护盾间隔', param = 'AutoShieldInterval', desc = '秒' },
    [EAttribute.AutoShieldHPRatio]          = { name = '自动护盾比例', param = 'AutoShieldHPRatio', desc = '最大生命 %' },

    -- ===== 疫毒类 =====
    [EAttribute.PlagueTriggerProb]          = { name = '疫毒触发概率', param = 'PlagueTriggerProb' },
    [EAttribute.PlagueDPS]                  = { name = '疫毒持续伤害', param = 'PlagueDPS', desc = '每秒' },
    [EAttribute.PlagueSpreadTargets]        = { name = '疫毒传染目标', param = 'PlagueSpreadTargets', desc = '额外目标数' },
    [EAttribute.PlagueRange]                = { name = '疫毒范围', param = 'PlagueRange', desc = '米' },
    [EAttribute.PlagueDuration]             = { name = '疫毒延长时间', param = 'PlagueDuration', desc = '秒' },
    [EAttribute.PlagueEnemyATKReduce]       = { name = '疫毒削弱攻击', param = 'PlagueEnemyATKReduce', desc = '感染敌人攻击降低 %' },
    [EAttribute.ReflectRange]               = { name = '反弹范围', param = 'ReflectRange', desc = '米' },

    -- ===== 速度/闪避类 =====
    [EAttribute.AttackSpeed]                = { name = '攻击速度', param = 'AttackSpeed' },
    [EAttribute.MoveSpeed]                  = { name = '移动速度', param = 'MoveSpeed' },
    [EAttribute.ReloadSpeed]                = { name = '换弹速度', param = 'ReloadSpeed' },
    [EAttribute.DodgeRate]                  = { name = '闪避率', param = 'DodgeRate' },

    -- ===== 特攻/特殊机制类 =====
    [EAttribute.RangedInfectedDamageBoost]  = { name = '远程感染者增伤', param = 'RangedInfectedDamageBoost' },
    [EAttribute.SwiftInfectedDamageBoost]   = { name = '迅捷感染者增伤', param = 'SwiftInfectedDamageBoost' },
    [EAttribute.RangedMonsterDamageBoost]   = { name = '远程怪物增伤', param = 'RangedMonsterDamageBoost' },
    [EAttribute.AllMonsterDamageBoost]      = { name = '全怪物增伤', param = 'AllMonsterDamageBoost' },
    [EAttribute.PenetrationDamage]          = { name = '穿透伤害', param = 'PenetrationDamage' },
    [EAttribute.CritIgnoreDefense]          = { name = '暴击无视防御', param = 'CritIgnoreDefense' },
    [EAttribute.ExtraCritDamage]            = { name = '暴击额外伤害', param = 'ExtraCritDamage', desc = '独立乘区' },
    [EAttribute.DoubleDamageProb]           = { name = '双倍伤害概率', param = 'DoubleDamageProb' },
    [EAttribute.ChainKillDurationExtend]    = { name = '连杀延长', param = 'ChainKillDurationExtend', desc = '秒' },
    [EAttribute.DodgeNextCrit]              = { name = '闪避必暴击', param = 'DodgeNextCrit', desc = '布尔标记' },
    [EAttribute.KillMoveSpeedBoost]         = { name = '击杀移速加成', param = 'KillMoveSpeedBoost' },
    [EAttribute.KillMoveSpeedDuration]      = { name = '击杀移速持续', param = 'KillMoveSpeedDuration', desc = '秒' },
}

-- =============================================
-- 费用等级配置
-- =============================================
GradeSettings = {
    [0] = { cost = 50,  HexColor = 'FFFFFF' },  -- 1费
    [1] = { cost = 100, HexColor = '00FF00' },  -- 2费
    [2] = { cost = 200, HexColor = '0000FF' },  -- 3费
    [3] = { cost = 350, HexColor = 'FF00FF' },  -- 4费
    [4] = { cost = 700, HexColor = 'FFA500' },  -- 5费
}

-- =============================================
-- 羁绊配置（含阶段效果）
-- =============================================
SuitSettings = {
    -- 0: 畸变猎手（红）
    [0] = {
        name = '畸变猎手',
        HexColor = 'FF4500',
        stages = {
            {
                need = 3,
                HexColor = '0DFF00',
                bonus = {
                    { property = EAttribute.BaseImpactDamageWrapper, value = 0.08 },
                    { property = EAttribute.CritChance, value = 0.04 },
                }
            },
            {
                need = 7,
                HexColor = 'FFD700',
                bonus = {
                    { property = EAttribute.BaseImpactDamageWrapper, value = 0.18 },
                    { property = EAttribute.CritChance, value = 0.08 },
                    { property = EAttribute.CritDamageBoost, value = 0.15 },
                }
            },
            {
                need = 9,
                HexColor = 'FF0000',
                bonus = {
                    { property = EAttribute.BaseImpactDamageWrapper, value = 0.30 },
                    { property = EAttribute.CritChance, value = 0.12 },
                    { property = EAttribute.CritDamageBoost, value = 0.30 },
                    { property = EAttribute.ExtraCritDamage, value = 0.50 },
                }
            },
        }
    },
    -- 1: 腐甲防御者（黄）
    [1] = {
        name = '腐甲防御者',
        HexColor = 'FFFF00',
        stages = {
            {
                need = 4,
                HexColor = 'FFD700',
                bonus = {
                    { property = EAttribute.HealthMax, value = 0.15 },
                    { property = EAttribute.MeleeDamageReduction, value = 0.10 },
                    { property = EAttribute.HeavyAttackReduction, value = 0.10 },
                }
            },
            {
                need = 7,
                HexColor = 'FFA500',
                bonus = {
                    { property = EAttribute.HealthMax, value = 0.35 },
                    { property = EAttribute.MeleeDamageReduction, value = 0.20 },
                    { property = EAttribute.HeavyAttackReduction, value = 0.20 },
                }
            },
            {
                need = 9,
                HexColor = 'FF4500',
                bonus = {
                    { property = EAttribute.HealthMax, value = 0.60 },
                    { property = EAttribute.MeleeDamageReduction, value = 0.30 },
                    { property = EAttribute.HeavyAttackReduction, value = 0.30 },
                    { property = EAttribute.ShieldOnHitProb, value = 0.30 },
                    { property = EAttribute.ShieldHPRatio, value = 0.10 },
                    { property = EAttribute.ShieldDuration, value = 4 },
                }
            },
        }
    },
    -- 2: 疫毒反噬者（紫）
    [2] = {
        name = '疫毒反噬者',
        HexColor = 'EE82EE',
        stages = {
            {
                need = 3,
                HexColor = 'DDA0DD',
                bonus = {
                    { property = EAttribute.PlagueTriggerProb, value = 0.10 },
                    { property = EAttribute.PlagueDPS, value = 5 },
                }
            },
            {
                need = 5,
                HexColor = 'DA70D6',
                bonus = {
                    { property = EAttribute.PlagueTriggerProb, value = 0.20 },
                    { property = EAttribute.PlagueDPS, value = 10 },
                    { property = EAttribute.CounterAttackRatio, value = 0.10 },
                }
            },
            {
                need = 8,
                HexColor = '8B008B',
                bonus = {
                    { property = EAttribute.PlagueTriggerProb, value = 0.35 },
                    { property = EAttribute.PlagueDPS, value = 15 },
                    { property = EAttribute.CounterAttackRatio, value = 0.20 },
                    { property = EAttribute.PlagueSpreadTargets, value = 2 },
                }
            },
        }
    },
    -- 3: 迅影突袭者（蓝）
    [3] = {
        name = '迅影突袭者',
        HexColor = '1E90FF',
        stages = {
            {
                need = 3,
                HexColor = '87CEEB',
                bonus = {
                    { property = EAttribute.AttackSpeed, value = 0.10 },
                    { property = EAttribute.MoveSpeed, value = 0.08 },
                }
            },
            {
                need = 5,
                HexColor = '4682B4',
                bonus = {
                    { property = EAttribute.AttackSpeed, value = 0.20 },
                    { property = EAttribute.MoveSpeed, value = 0.15 },
                    { property = EAttribute.ReloadSpeed, value = 0.15 },
                }
            },
            {
                need = 7,
                HexColor = '0000CD',
                bonus = {
                    { property = EAttribute.AttackSpeed, value = 0.30 },
                    { property = EAttribute.MoveSpeed, value = 0.25 },
                    { property = EAttribute.ReloadSpeed, value = 0.25 },
                    -- 以下为连杀机制参数（非玩家属性，保留为配置字段）
                    { property = "ChainKillASBonus", value = 0.25, note = "连杀攻速加成（配置参数）" },
                    { property = "ChainKillDuration", value = 3, note = "连杀爆发持续秒数（配置参数）" },
                    { property = "ChainKillCD", value = 5, note = "连杀冷却秒数（配置参数）" },
                    { property = "ChainKillTrigger", value = 3, note = "连杀触发所需击杀数（配置参数）" },
                }
            },
        }
    },
}

-- =============================================
-- 卡牌池（完整 38 张卡牌）
-- =============================================
CardPool = {
    -- ========================
    -- 畸变猎手（红）suit=0
    -- ========================

    -- 0: 拉姆达-λ（1费）
    [0] = {
        name = '拉姆达-λ',
        grade = 0,
        suit = 0,
        purchaseCost = 0,  -- 表格中为"送"
        bonus = {
            [1] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 3 },
                { property = EAttribute.CritChance, value = 0.01 },
            },
            [2] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 4 },
                { property = EAttribute.CritChance, value = 0.015 },
            },
            [3] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 5 },
                { property = EAttribute.CritChance, value = 0.02 },
            },
        },
        texture = '/Game/Mod/EscapeLobby/Arts_UI/TableIcons/Talent/Escape_Talent_icon_LiRen.Escape_Talent_icon_LiRen'
    },
    -- 1: 克西-ξ（1费）
    [1] = {
        name = '克西-ξ',
        grade = 0,
        suit = 0,
        bonus = {
            [1] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 3 },
                { property = EAttribute.NormalMonsterDamageBoost, value = 0.01 },
            },
            [2] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 4 },
                { property = EAttribute.NormalMonsterDamageBoost, value = 0.01 },
            },
            [3] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 5 },
                { property = EAttribute.NormalMonsterDamageBoost, value = 0.01 },
            },
        },
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_14.Icon_Skill_14'
    },
    -- 2: 柔（1费）
    [2] = {
        name = '柔',
        grade = 0,
        suit = 0,
        bonus = {
            [1] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 3 },
                { property = EAttribute.RangedInfectedDamageBoost, value = 0.01 },
            },
            [2] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 4 },
                { property = EAttribute.RangedInfectedDamageBoost, value = 0.02 },
            },
            [3] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 5 },
                { property = EAttribute.RangedInfectedDamageBoost, value = 0.03 },
            },
        },
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_117.Icon_Skill_117'
    },
    -- 3: 宇普西隆（1费）
    [3] = {
        name = '宇普西隆',
        grade = 0,
        suit = 0,
        purchaseCost = 300,
        bonus = {
            [1] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 2 },
                { property = EAttribute.CritDamageBoost, value = 0.01 },
            },
            [2] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 3 },
                { property = EAttribute.CritDamageBoost, value = 0.02 },
            },
            [3] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 5 },
                { property = EAttribute.CritChance, value = 0.03 },
            },
        },
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_99.Icon_Skill_99'
    },
    -- 4: 疫核（2费）
    [4] = {
        name = '疫核',
        grade = 1,
        suit = 0,
        purchaseCost = 300,
        bonus = {
            [1] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 5 },
                { property = EAttribute.CritChance, value = 0.015 },
                { property = EAttribute.RangedInfectedDamageBoost, value = 0.02 },
            },
            [2] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 7 },
                { property = EAttribute.CritChance, value = 0.02 },
                { property = EAttribute.RangedInfectedDamageBoost, value = 0.03 },
            },
            [3] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 9 },
                { property = EAttribute.CritChance, value = 0.025 },
                { property = EAttribute.RangedInfectedDamageBoost, value = 0.04 },
            },
        },
        texture = '/Game/Arts_Timeliness/GameMode/SuperPeople/Art_UI/NoAtlas/SkillIcon/CG029_SP_JobCyberSpider_0.CG029_SP_JobCyberSpider_0'
    },
    -- 5: 畸变（2费）
    [5] = {
        name = '畸变',
        grade = 1,
        suit = 0,
        purchaseCost = 300,
        bonus = {
            [1] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 5 },
                { property = EAttribute.SwiftInfectedDamageBoost, value = 0.04 },
                { property = EAttribute.CritChance, value = 0.01 },
            },
            [2] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 7 },
                { property = EAttribute.SwiftInfectedDamageBoost, value = 0.06 },
                { property = EAttribute.CritChance, value = 0.015 },
            },
            [3] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 9 },
                { property = EAttribute.SwiftInfectedDamageBoost, value = 0.08 },
                { property = EAttribute.CritChance, value = 0.02 },
            },
        },
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_8.Icon_Skill_8'
    },
    -- 6: 噬疫（2费）
    [6] = {
        name = '噬疫',
        grade = 1,
        suit = 0,
        purchaseCost = 500,
        bonus = {
            [1] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 4 },
                { property = EAttribute.CritDamageBoost, value = 0.05 },
            },
            [2] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 6 },
                { property = EAttribute.CritDamageBoost, value = 0.08 },
            },
            [3] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 8 },
                { property = EAttribute.CritDamageBoost, value = 0.12 },
                { property = EAttribute.CritChance, value = 0.01 },
            },
        },
        texture = '/Game/Mod/EscapeLobby/Arts_UI/TableIcons/Talent/Escape_Talent_icon_XiJia.Escape_Talent_icon_XiJia'
    },
    -- 7: 阿尔法·猎（3费）
    [7] = {
        name = '阿尔法·猎',
        grade = 2,
        suit = 0,
        purchaseCost = 500,
        bonus = {
            [1] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 10 },
                { property = EAttribute.CritChance, value = 0.04 },
                { property = EAttribute.EliteMonsterDamageBoost, value = 0.06 },
            },
            [2] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 13 },
                { property = EAttribute.CritChance, value = 0.05 },
                { property = EAttribute.EliteMonsterDamageBoost, value = 0.08 },
            },
            [3] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 16 },
                { property = EAttribute.CritChance, value = 0.06 },
                { property = EAttribute.EliteMonsterDamageBoost, value = 0.10 },
                { property = EAttribute.CritDamageBoost, value = 0.10 },
            },
        },
        texture = '/Game/Arts_Timeliness/GameMode/SuperPeople/Art_UI/NoAtlas/SkillIcon/CG025_SP_Dragn_1.CG025_SP_Dragn_1'
    },
    -- 8: 猎疫先锋（3费）
    [8] = {
        name = '猎疫先锋',
        grade = 2,
        suit = 0,
        purchaseCost = 500,
        bonus = {
            [1] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 9 },
                { property = EAttribute.CritChance, value = 0.03 },
                { property = EAttribute.RangedMonsterDamageBoost, value = 0.05 },
            },
            [2] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 12 },
                { property = EAttribute.CritChance, value = 0.04 },
                { property = EAttribute.RangedMonsterDamageBoost, value = 0.07 },
            },
            [3] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 15 },
                { property = EAttribute.CritChance, value = 0.05 },
                { property = EAttribute.RangedMonsterDamageBoost, value = 0.10 },
            },
        },
        texture = '/Game/Arts/UI/TableIcons/ProfessionResult_Icon/MS_Icon_jidonbing.MS_Icon_jidonbing'
    },
    -- 9: 灾变猎手（4费）
    [9] = {
        name = '灾变猎手',
        grade = 3,
        suit = 0,
        purchaseCost = 800,
        bonus = {
            [1] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 18 },
                { property = EAttribute.CritChance, value = 0.08 },
                { property = EAttribute.AllMonsterDamageBoost, value = 0.08 },
                { property = EAttribute.CritDamageBoost, value = 0.10 },
                { property = EAttribute.PenetrationDamage, value = 0.05 },
            },
            [2] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 22 },
                { property = EAttribute.CritChance, value = 0.10 },
                { property = EAttribute.AllMonsterDamageBoost, value = 0.12 },
                { property = EAttribute.CritDamageBoost, value = 0.15 },
                { property = EAttribute.PenetrationDamage, value = 0.08 },
            },
            [3] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 26 },
                { property = EAttribute.CritChance, value = 0.12 },
                { property = EAttribute.AllMonsterDamageBoost, value = 0.15 },
                { property = EAttribute.CritDamageBoost, value = 0.20 },
                { property = EAttribute.PenetrationDamage, value = 0.10 },
            },
        },
        texture = '/Game/Arts/UI/TableIcons/ProfessionResult_Icon/ProfessionSkill_Icon/tuji_kuangre2.tuji_kuangre2'
    },
    -- 10: 始祖·猎魂（5费）
    [10] = {
        name = '始祖·猎魂',
        grade = 4,
        suit = 0,
        purchaseCost = 800,
        bonus = {
            [1] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 30 },
                { property = EAttribute.CritChance, value = 0.15 },
                { property = EAttribute.BossDamageBoost, value = 0.20 },
                { property = EAttribute.CritDamageBoost, value = 0.30 },
            },
            [2] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 35 },
                { property = EAttribute.CritChance, value = 0.18 },
                { property = EAttribute.BossDamageBoost, value = 0.25 },
                { property = EAttribute.CritDamageBoost, value = 0.40 },
            },
            [3] = {
                { property = EAttribute.BaseImpactDamageWrapper, value = 40 },
                { property = EAttribute.CritChance, value = 0.20 },
                { property = EAttribute.BossDamageBoost, value = 0.30 },
                { property = EAttribute.CritDamageBoost, value = 0.50 },
                { property = EAttribute.CritIgnoreDefense, value = 0.10 },
            },
        },
        texture = '/Game/Arts_Timeliness/GameMode/SuperPeople/Art_UI/NoAtlas/SkillIcon/CG028_SP_JobGunman_3.CG028_SP_JobGunman_3'
    },

    -- ========================
    -- 腐甲防御者（黄）suit=1
    -- ========================

    -- 11: 奥米伽（1费）
    [11] = {
        name = '奥米伽',
        grade = 0,
        suit = 1,
        bonus = {
            [1] = { { property = EAttribute.HealthMax, value = 15 } },
            [2] = { { property = EAttribute.HealthMax, value = 25 } },
            [3] = {
                { property = EAttribute.HealthMax, value = 35 },
                { property = EAttribute.MeleeDamageReduction, value = 0.01 },
            },
        },
        texture = '/Game/Mod/EscapeLobby/Arts_UI/TableIcons/Talent/Escape_Talent_icon_GuiKe.Escape_Talent_icon_GuiKe'
    },
    -- 12: 西格玛（1费）
    [12] = {
        name = '西格玛',
        grade = 0,
        suit = 1,
        bonus = {
            [1] = {
                { property = EAttribute.HealthMax, value = 12 },
                { property = EAttribute.MeleeDamageReduction, value = 0.01 },
            },
            [2] = {
                { property = EAttribute.HealthMax, value = 20 },
                { property = EAttribute.MeleeDamageReduction, value = 0.015 },
            },
            [3] = {
                { property = EAttribute.HealthMax, value = 28 },
                { property = EAttribute.MeleeDamageReduction, value = 0.02 },
            },
        },
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_34.Icon_Skill_34'
    },
    -- 13: 菲（1费）
    [13] = {
        name = '菲',
        grade = 0,
        suit = 1,
        bonus = {
            [1] = {
                { property = EAttribute.HealthMax, value = 10 },
                { property = EAttribute.HeavyAttackReduction, value = 0.02 },
            },
            [2] = {
                { property = EAttribute.HealthMax, value = 18 },
                { property = EAttribute.HeavyAttackReduction, value = 0.03 },
            },
            [3] = {
                { property = EAttribute.HealthMax, value = 26 },
                { property = EAttribute.HeavyAttackReduction, value = 0.04 },
            },
        },
        texture = '/Game/Mod/EscapeLobby/Arts_UI/TableIcons/Talent/Escape_Talent_icon_RenXing.Escape_Talent_icon_RenXing'
    },
    -- 14: 岩甲（2费）
    [14] = {
        name = '岩甲',
        grade = 1,
        suit = 1,
        bonus = {
            [1] = {
                { property = EAttribute.HealthMax, value = 30 },
                { property = EAttribute.MeleeDamageReduction, value = 0.02 },
            },
            [2] = {
                { property = EAttribute.HealthMax, value = 45 },
                { property = EAttribute.MeleeDamageReduction, value = 0.03 },
            },
            [3] = {
                { property = EAttribute.HealthMax, value = 60 },
                { property = EAttribute.MeleeDamageReduction, value = 0.04 },
            },
        },
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_59.Icon_Skill_59'
    },
    -- 15: 厚腐（2费）
    [15] = {
        name = '厚腐',
        grade = 1,
        suit = 1,
        bonus = {
            [1] = {
                { property = EAttribute.HealthMax, value = 35 },
                { property = EAttribute.HeavyAttackReduction, value = 0.02 },
            },
            [2] = {
                { property = EAttribute.HealthMax, value = 50 },
                { property = EAttribute.HeavyAttackReduction, value = 0.04 },
            },
            [3] = {
                { property = EAttribute.HealthMax, value = 65 },
                { property = EAttribute.HeavyAttackReduction, value = 0.05 },
            },
        },
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_74.Icon_Skill_74'
    },
    -- 16: 骨盾（2费）
    [16] = {
        name = '骨盾',
        grade = 1,
        suit = 1,
        bonus = {
            [1] = {
                { property = EAttribute.HealthMax, value = 25 },
                { property = EAttribute.ShieldOnHitProb, value = 0.02 },
            },
            [2] = {
                { property = EAttribute.HealthMax, value = 40 },
                { property = EAttribute.ShieldOnHitProb, value = 0.03 },
            },
            [3] = {
                { property = EAttribute.HealthMax, value = 55 },
                { property = EAttribute.ShieldOnHitProb, value = 0.05 },
                { property = EAttribute.ShieldThickness, value = 5 },
            },
        },
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_30.Icon_Skill_30'
    },
    -- 17: 阿尔法·御（3费）
    [17] = {
        name = '阿尔法·御',
        grade = 2,
        suit = 1,
        bonus = {
            [1] = {
                { property = EAttribute.HealthMax, value = 70 },
                { property = EAttribute.MeleeDamageReduction, value = 0.05 },
                { property = EAttribute.HeavyAttackReduction, value = 0.05 },
                { property = EAttribute.ShieldOnHitProb, value = 0.03 },
            },
            [2] = {
                { property = EAttribute.HealthMax, value = 90 },
                { property = EAttribute.MeleeDamageReduction, value = 0.07 },
                { property = EAttribute.HeavyAttackReduction, value = 0.07 },
                { property = EAttribute.ShieldOnHitProb, value = 0.05 },
            },
            [3] = {
                { property = EAttribute.HealthMax, value = 110 },
                { property = EAttribute.MeleeDamageReduction, value = 0.09 },
                { property = EAttribute.HeavyAttackReduction, value = 0.09 },
                { property = EAttribute.ShieldOnHitProb, value = 0.08 },
                { property = EAttribute.ShieldThickness, value = 10 },
            },
        },
        texture = '/Game/Arts/UI/TableIcons/ProfessionResult_Icon/ProfessionSkill_Icon/houqing_zhizaofangju.houqing_zhizaofangju'
    },
    -- 18: 腐岩卫（3费）
    [18] = {
        name = '腐岩卫',
        grade = 2,
        suit = 1,
        bonus = {
            [1] = {
                { property = EAttribute.HealthMax, value = 60 },
                { property = EAttribute.MeleeDamageReduction, value = 0.06 },
                { property = EAttribute.HeavyAttackReduction, value = 0.08 },
            },
            [2] = {
                { property = EAttribute.HealthMax, value = 80 },
                { property = EAttribute.MeleeDamageReduction, value = 0.08 },
                { property = EAttribute.HeavyAttackReduction, value = 0.10 },
            },
            [3] = {
                { property = EAttribute.HealthMax, value = 100 },
                { property = EAttribute.MeleeDamageReduction, value = 0.10 },
                { property = EAttribute.HeavyAttackReduction, value = 0.12 },
                { property = EAttribute.CounterAttackRatio, value = 0.05 },
            },
        },
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_28.Icon_Skill_28'
    },
    -- 19: 骨甲巨卫（4费）
    [19] = {
        name = '骨甲巨卫',
        grade = 3,
        suit = 1,
        bonus = {
            [1] = {
                { property = EAttribute.HealthMax, value = 120 },
                { property = EAttribute.MeleeDamageReduction, value = 0.12 },
                { property = EAttribute.HeavyAttackReduction, value = 0.15 },
                { property = EAttribute.ShieldOnHitProb, value = 0.08 },
            },
            [2] = {
                { property = EAttribute.HealthMax, value = 150 },
                { property = EAttribute.MeleeDamageReduction, value = 0.15 },
                { property = EAttribute.HeavyAttackReduction, value = 0.18 },
                { property = EAttribute.ShieldOnHitProb, value = 0.12 },
            },
            [3] = {
                { property = EAttribute.HealthMax, value = 180 },
                { property = EAttribute.MeleeDamageReduction, value = 0.18 },
                { property = EAttribute.HeavyAttackReduction, value = 0.22 },
                { property = EAttribute.ShieldOnHitProb, value = 0.15 },
                { property = EAttribute.ShieldThickness, value = 20 },
                { property = EAttribute.ShieldDMGReduce, value = 0.10 },
            },
        },
        texture = '/Game/Arts_Timeliness/GameMode/SuperPeople/Art_UI/NoAtlas/SkillIcon/CG020_SP_JobBeltway_3.CG020_SP_JobBeltway_3'
    },
    -- 20: 始祖·御界（5费）
    [20] = {
        name = '始祖·御界',
        grade = 4,
        suit = 1,
        bonus = {
            [1] = {
                { property = EAttribute.HealthMax, value = 400 },
                { property = EAttribute.MeleeDamageReduction, value = 0.10 },
                { property = EAttribute.HeavyAttackReduction, value = 0.10 },
                { property = EAttribute.ShieldOnHitProb, value = 0.08 },
            },
            [2] = {
                { property = EAttribute.HealthMax, value = 600 },
                { property = EAttribute.MeleeDamageReduction, value = 0.15 },
                { property = EAttribute.HeavyAttackReduction, value = 0.15 },
                { property = EAttribute.ShieldOnHitProb, value = 0.12 },
                { property = EAttribute.ShieldThickness, value = 100 },
            },
            [3] = {
                { property = EAttribute.HealthMax, value = 800 },
                { property = EAttribute.MeleeDamageReduction, value = 0.20 },
                { property = EAttribute.HeavyAttackReduction, value = 0.20 },
                { property = EAttribute.ShieldOnHitProb, value = 0.15 },
                { property = EAttribute.ShieldThickness, value = 200 },
                { property = EAttribute.AutoShieldInterval, value = 30 },
                { property = EAttribute.AutoShieldHPRatio, value = 0.15 },
            },
        },
        texture = '/Game/Arts_Timeliness/GameMode/SuperPeople/Art_UI/NoAtlas/SkillIcon/CG032_SP_JobDriver_2.CG032_SP_JobDriver_2'
    },

    -- ========================
    -- 疫毒反噬者（紫）suit=2
    -- ========================

    -- 21: 纽（1费）
    [21] = {
        name = '纽',
        grade = 0,
        suit = 2,
        bonus = {
            [1] = {
                { property = EAttribute.PlagueTriggerProb, value = 0.02 },
                { property = EAttribute.CounterAttackRatio, value = 0.01 },
            },
            [2] = {
                { property = EAttribute.PlagueTriggerProb, value = 0.03 },
                { property = EAttribute.CounterAttackRatio, value = 0.015 },
            },
            [3] = {
                { property = EAttribute.PlagueTriggerProb, value = 0.04 },
                { property = EAttribute.CounterAttackRatio, value = 0.02 },
            },
        },
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_29.Icon_Skill_29'
    },
    -- 22: 派（1费）
    [22] = {
        name = '派',
        grade = 0,
        suit = 2,
        bonus = {
            [1] = {
                { property = EAttribute.PlagueTriggerProb, value = 0.015 },
                { property = EAttribute.CounterAttackRatio, value = 0.015 },
            },
            [2] = {
                { property = EAttribute.PlagueTriggerProb, value = 0.025 },
                { property = EAttribute.CounterAttackRatio, value = 0.02 },
            },
            [3] = {
                { property = EAttribute.PlagueTriggerProb, value = 0.035 },
                { property = EAttribute.CounterAttackRatio, value = 0.025 },
            },
        },
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_21.Icon_Skill_21'
    },
    -- 23: 陶（1费）
    [23] = {
        name = '陶',
        grade = 0,
        suit = 2,
        bonus = {
            [1] = {
                { property = EAttribute.PlagueDPS, value = 1 },
                { property = EAttribute.CounterAttackRatio, value = 0.01 },
            },
            [2] = {
                { property = EAttribute.PlagueDPS, value = 2 },
                { property = EAttribute.CounterAttackRatio, value = 0.015 },
            },
            [3] = {
                { property = EAttribute.PlagueDPS, value = 3 },
                { property = EAttribute.CounterAttackRatio, value = 0.02 },
            },
        },
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_16.Icon_Skill_16'
    },
    -- 24: 源生（2费）
    [24] = {
        name = '源生',
        grade = 1,
        suit = 2,
        bonus = {
            [1] = {
                { property = EAttribute.PlagueTriggerProb, value = 0.04 },
                { property = EAttribute.CounterAttackRatio, value = 0.03 },
                { property = EAttribute.PlagueDPS, value = 2 },
            },
            [2] = {
                { property = EAttribute.PlagueTriggerProb, value = 0.06 },
                { property = EAttribute.CounterAttackRatio, value = 0.04 },
                { property = EAttribute.PlagueDPS, value = 3 },
            },
            [3] = {
                { property = EAttribute.PlagueTriggerProb, value = 0.08 },
                { property = EAttribute.CounterAttackRatio, value = 0.05 },
                { property = EAttribute.PlagueDPS, value = 4 },
            },
        },
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_61.Icon_Skill_61'
    },
    -- 25: 灵能（2费）
    [25] = {
        name = '灵能',
        grade = 1,
        suit = 2,
        bonus = {
            [1] = {
                { property = EAttribute.PlagueTriggerProb, value = 0.04 },
                { property = EAttribute.CounterAttackRatio, value = 0.03 },
                { property = EAttribute.PlagueRange, value = 0.5 },
            },
            [2] = {
                { property = EAttribute.PlagueTriggerProb, value = 0.06 },
                { property = EAttribute.CounterAttackRatio, value = 0.04 },
                { property = EAttribute.PlagueRange, value = 1.0 },
            },
            [3] = {
                { property = EAttribute.PlagueTriggerProb, value = 0.08 },
                { property = EAttribute.CounterAttackRatio, value = 0.05 },
                { property = EAttribute.PlagueRange, value = 1.5 },
            },
        },
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_82.Icon_Skill_82'
    },
    -- 26: 阿尔法·能（3费）
    [26] = {
        name = '阿尔法·能',
        grade = 2,
        suit = 2,
        bonus = {
            [1] = {
                { property = EAttribute.PlagueTriggerProb, value = 0.07 },
                { property = EAttribute.CounterAttackRatio, value = 0.06 },
                { property = EAttribute.PlagueDPS, value = 4 },
            },
            [2] = {
                { property = EAttribute.PlagueTriggerProb, value = 0.10 },
                { property = EAttribute.CounterAttackRatio, value = 0.08 },
                { property = EAttribute.PlagueDPS, value = 6 },
            },
            [3] = {
                { property = EAttribute.PlagueTriggerProb, value = 0.13 },
                { property = EAttribute.CounterAttackRatio, value = 0.10 },
                { property = EAttribute.PlagueDPS, value = 8 },
                { property = EAttribute.PlagueDuration, value = 1 },
            },
        },
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_45.Icon_Skill_45'
    },
    -- 27: 源力师（3费）
    [27] = {
        name = '源力师',
        grade = 2,
        suit = 2,
        bonus = {
            [1] = {
                { property = EAttribute.PlagueTriggerProb, value = 0.06 },
                { property = EAttribute.CounterAttackRatio, value = 0.07 },
                { property = EAttribute.PlagueDPS, value = 5 },
                { property = EAttribute.ReflectRange, value = 1 },
            },
            [2] = {
                { property = EAttribute.PlagueTriggerProb, value = 0.09 },
                { property = EAttribute.CounterAttackRatio, value = 0.09 },
                { property = EAttribute.PlagueDPS, value = 7 },
                { property = EAttribute.ReflectRange, value = 1.5 },
            },
            [3] = {
                { property = EAttribute.PlagueTriggerProb, value = 0.12 },
                { property = EAttribute.CounterAttackRatio, value = 0.11 },
                { property = EAttribute.PlagueDPS, value = 9 },
                { property = EAttribute.ReflectRange, value = 2 },
            },
        },
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_62.Icon_Skill_62'
    },
    -- 28: 源能主宰（4费）
    [28] = {
        name = '源能主宰',
        grade = 3,
        suit = 2,
        bonus = {
            [1] = {
                { property = EAttribute.PlagueTriggerProb, value = 0.12 },
                { property = EAttribute.CounterAttackRatio, value = 0.10 },
                { property = EAttribute.PlagueDPS, value = 8 },
                { property = EAttribute.PlagueSpreadTargets, value = 1 },
            },
            [2] = {
                { property = EAttribute.PlagueTriggerProb, value = 0.16 },
                { property = EAttribute.CounterAttackRatio, value = 0.13 },
                { property = EAttribute.PlagueDPS, value = 10 },
                { property = EAttribute.PlagueSpreadTargets, value = 2 },
            },
            [3] = {
                { property = EAttribute.PlagueTriggerProb, value = 0.20 },
                { property = EAttribute.CounterAttackRatio, value = 0.16 },
                { property = EAttribute.PlagueDPS, value = 12 },
                { property = EAttribute.PlagueSpreadTargets, value = 3 },
            },
        },
        texture = '/Game/Arts_Timeliness/GameMode/SuperPeople/Art_UI/NoAtlas/SkillIcon/CG029_SP_JobCyberSpider_2.CG029_SP_JobCyberSpider_2'
    },
    -- 29: 始祖·疫源（5费）
    [29] = {
        name = '始祖·疫源',
        grade = 4,
        suit = 2,
        bonus = {
            [1] = {
                { property = EAttribute.PlagueTriggerProb, value = 0.15 },
                { property = EAttribute.CounterAttackRatio, value = 0.12 },
                { property = EAttribute.PlagueDPS, value = 8 },
                { property = EAttribute.PlagueSpreadTargets, value = 1 },
            },
            [2] = {
                { property = EAttribute.PlagueTriggerProb, value = 0.20 },
                { property = EAttribute.CounterAttackRatio, value = 0.15 },
                { property = EAttribute.PlagueDPS, value = 10 },
                { property = EAttribute.PlagueSpreadTargets, value = 1 },
            },
            [3] = {
                { property = EAttribute.PlagueTriggerProb, value = 0.25 },
                { property = EAttribute.CounterAttackRatio, value = 0.18 },
                { property = EAttribute.PlagueDPS, value = 12 },
                { property = EAttribute.PlagueSpreadTargets, value = 2 },
                { property = EAttribute.PlagueDuration, value = 3 },
                { property = EAttribute.PlagueEnemyATKReduce, value = 0.10 },
            },
        },
        texture = '/Game/Arts_Timeliness/GameMode/SuperPeople/Art_UI/NoAtlas/SkillIcon/CG029_SP_JobCyberSpider_1.CG029_SP_JobCyberSpider_1'
    },

    -- ========================
    -- 迅影突袭者（蓝）suit=3
    -- ========================

    -- 30: 罗（1费）
    [30] = {
        name = '罗',
        grade = 0,
        suit = 3,
        bonus = {
            [1] = { { property = EAttribute.AttackSpeed, value = 0.02 } },
            [2] = { { property = EAttribute.AttackSpeed, value = 0.03 } },
            [3] = {
                { property = EAttribute.AttackSpeed, value = 0.04 },
                { property = EAttribute.MoveSpeed, value = 0.01 },
            },
        },
        texture = '/Game/Arts_Timeliness/GameMode/SuperPeople/Art_UI/NoAtlas/SkillIcon/CG020_SP_JobRocket_3.CG020_SP_JobRocket_3'
    },
    -- 31: 桑（1费）
    [31] = {
        name = '桑',
        grade = 0,
        suit = 3,
        bonus = {
            [1] = { { property = EAttribute.MoveSpeed, value = 0.02 } },
            [2] = { { property = EAttribute.MoveSpeed, value = 0.03 } },
            [3] = {
                { property = EAttribute.MoveSpeed, value = 0.04 },
                { property = EAttribute.AttackSpeed, value = 0.01 },
            },
        },
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_49.Icon_Skill_49'
    },
    -- 32: 科（1费）
    [32] = {
        name = '科',
        grade = 0,
        suit = 3,
        bonus = {
            [1] = { { property = EAttribute.ReloadSpeed, value = 0.04 } },
            [2] = { { property = EAttribute.ReloadSpeed, value = 0.06 } },
            [3] = {
                { property = EAttribute.ReloadSpeed, value = 0.08 },
                { property = EAttribute.AttackSpeed, value = 0.01 },
            },
        },
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_41.Icon_Skill_41'
    },
    -- 33: 掠风（2费）
    [33] = {
        name = '掠风',
        grade = 1,
        suit = 3,
        bonus = {
            [1] = {
                { property = EAttribute.AttackSpeed, value = 0.05 },
                { property = EAttribute.MoveSpeed, value = 0.03 },
            },
            [2] = {
                { property = EAttribute.AttackSpeed, value = 0.07 },
                { property = EAttribute.MoveSpeed, value = 0.04 },
            },
            [3] = {
                { property = EAttribute.AttackSpeed, value = 0.09 },
                { property = EAttribute.MoveSpeed, value = 0.05 },
                { property = EAttribute.ReloadSpeed, value = 0.04 },
            },
        },
        texture = '/Game/Arts_Timeliness/GameMode/SuperPeople/Art_UI/NoAtlas/SkillIcon/CG020_SP_JobLightning_2.CG020_SP_JobLightning_2'
    },
    -- 34: 疾踪（2费）
    [34] = {
        name = '疾踪',
        grade = 1,
        suit = 3,
        bonus = {
            [1] = {
                { property = EAttribute.MoveSpeed, value = 0.05 },
                { property = EAttribute.ReloadSpeed, value = 0.05 },
            },
            [2] = {
                { property = EAttribute.MoveSpeed, value = 0.07 },
                { property = EAttribute.ReloadSpeed, value = 0.07 },
            },
            [3] = {
                { property = EAttribute.MoveSpeed, value = 0.09 },
                { property = EAttribute.ReloadSpeed, value = 0.09 },
                { property = EAttribute.AttackSpeed, value = 0.03 },
            },
        },
        texture = '/Game/Arts_Timeliness/GameMode/SuperPeople/Art_UI/NoAtlas/SkillIcon/CG020_SP_JobLightning_1.CG020_SP_JobLightning_1'
    },
    -- 35: 阿尔法·迅（3费）
    [35] = {
        name = '阿尔法·迅',
        grade = 2,
        suit = 3,
        bonus = {
            [1] = {
                { property = EAttribute.AttackSpeed, value = 0.10 },
                { property = EAttribute.MoveSpeed, value = 0.08 },
                { property = EAttribute.ReloadSpeed, value = 0.08 },
            },
            [2] = {
                { property = EAttribute.AttackSpeed, value = 0.13 },
                { property = EAttribute.MoveSpeed, value = 0.10 },
                { property = EAttribute.ReloadSpeed, value = 0.10 },
            },
            [3] = {
                { property = EAttribute.AttackSpeed, value = 0.16 },
                { property = EAttribute.MoveSpeed, value = 0.12 },
                { property = EAttribute.ReloadSpeed, value = 0.12 },
                { property = EAttribute.KillMoveSpeedBoost, value = 0.10 },
                { property = EAttribute.KillMoveSpeedDuration, value = 2 },
            },
        },
        texture = '/Game/Arts_Timeliness/GameMode/SuperPeople/Art_UI/NoAtlas/SkillIcon/CG029_SP_JobCyberSpider_3.CG029_SP_JobCyberSpider_3'
    },
    -- 36: 瞬刃（4费）
    [36] = {
        name = '瞬刃',
        grade = 3,
        suit = 3,
        bonus = {
            [1] = {
                { property = EAttribute.AttackSpeed, value = 0.15 },
                { property = EAttribute.MoveSpeed, value = 0.12 },
                { property = EAttribute.ReloadSpeed, value = 0.12 },
                { property = EAttribute.DodgeRate, value = 0.03 },
            },
            [2] = {
                { property = EAttribute.AttackSpeed, value = 0.18 },
                { property = EAttribute.MoveSpeed, value = 0.15 },
                { property = EAttribute.ReloadSpeed, value = 0.15 },
                { property = EAttribute.DodgeRate, value = 0.05 },
            },
            [3] = {
                { property = EAttribute.AttackSpeed, value = 0.22 },
                { property = EAttribute.MoveSpeed, value = 0.18 },
                { property = EAttribute.ReloadSpeed, value = 0.18 },
                { property = EAttribute.DodgeRate, value = 0.08 },
                { property = EAttribute.DoubleDamageProb, value = 0.10 },
            },
        },
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_9.Icon_Skill_9'
    },
    -- 37: 始祖·影（5费）
    [37] = {
        name = '始祖·影',
        grade = 4,
        suit = 3,
        bonus = {
            [1] = {
                { property = EAttribute.AttackSpeed, value = 0.20 },
                { property = EAttribute.MoveSpeed, value = 0.15 },
                { property = EAttribute.ReloadSpeed, value = 0.15 },
                { property = EAttribute.DodgeRate, value = 0.05 },
                { property = EAttribute.ChainKillDurationExtend, value = 1 },
            },
            [2] = {
                { property = EAttribute.AttackSpeed, value = 0.25 },
                { property = EAttribute.MoveSpeed, value = 0.20 },
                { property = EAttribute.ReloadSpeed, value = 0.20 },
                { property = EAttribute.DodgeRate, value = 0.08 },
                { property = EAttribute.ChainKillDurationExtend, value = 1.5 },
            },
            [3] = {
                { property = EAttribute.AttackSpeed, value = 0.30 },
                { property = EAttribute.MoveSpeed, value = 0.25 },
                { property = EAttribute.ReloadSpeed, value = 0.25 },
                { property = EAttribute.DodgeRate, value = 0.10 },
                { property = EAttribute.ChainKillDurationExtend, value = 2 },
                { property = EAttribute.DodgeNextCrit, value = true },
            },
        },
        texture = '/Game/Arts_Timeliness/GameMode/SuperPeople/Art_UI/NoAtlas/SkillIcon/CG028_SP_JobGunman_2.CG028_SP_JobGunman_2'
    },
}