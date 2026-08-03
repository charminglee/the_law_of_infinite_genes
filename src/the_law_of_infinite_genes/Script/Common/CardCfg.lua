Card = Card or {}


CardCfg.Common = {
    SellRefundRatio     = 1,    -- 出售卡牌返还比例
    RefreshBaseCost     = 10,   -- 刷新商店的首次价格
    RefreshStepCost     = 10,   -- 每次刷新相比上一次的加价
    MaxCardSlotLevel    = 12,   -- 最大卡槽等级
    EquippedSlotCount   = 12,   -- 已装备卡槽数量
    StoreSlotCount      = 20,   -- 仓库卡槽数量
    ShopSlotCount       = 6,    -- 商店卡槽数量
}


CardCfg.StoreWeight = {
    [1]  = { [1]=1.00, [2]=0.00, [3]=0.00, [4]=0.00, [5]=0.00 },
    [2]  = { [1]=0.90, [2]=0.10, [3]=0.00, [4]=0.00, [5]=0.00 },
    [3]  = { [1]=0.70, [2]=0.30, [3]=0.00, [4]=0.00, [5]=0.00 },
    [4]  = { [1]=0.50, [2]=0.35, [3]=0.15, [4]=0.00, [5]=0.00 },
    [5]  = { [1]=0.40, [2]=0.35, [3]=0.25, [4]=0.00, [5]=0.00 },
    [6]  = { [1]=0.30, [2]=0.39, [3]=0.30, [4]=0.01, [5]=0.00 },
    [7]  = { [1]=0.25, [2]=0.30, [3]=0.40, [4]=0.05, [5]=0.00 },
    [8]  = { [1]=0.20, [2]=0.25, [3]=0.45, [4]=0.09, [5]=0.01 },
    [9]  = { [1]=0.15, [2]=0.25, [3]=0.40, [4]=0.15, [5]=0.05 },
    [10] = { [1]=0.10, [2]=0.20, [3]=0.40, [4]=0.20, [5]=0.10 },
    [11] = { [1]=0.10, [2]=0.15, [3]=0.40, [4]=0.25, [5]=0.15 },
    [12] = { [1]=0.10, [2]=0.10, [3]=0.20, [4]=0.35, [5]=0.25 },
}


CardCfg.Grade = {
    [1] = {cost=50, HexColor='FFFFFF', anno='一费卡'},
    [2] = {cost=100, HexColor='00FF00', anno='二费卡'},
    [3] = {cost=200, HexColor='0000FF', anno='三费卡'},
    [4] = {cost=350, HexColor='FF00FF', anno='四费卡'},
    [5] = {cost=700, HexColor='FFA500', anno='五费卡'},
}


CardCfg.Group = {
    [1] = {name='畸变猎手', HexColor='FF0000'},
    [2] = {name='腐甲防御者', HexColor='FFFF00'},
    [3] = {name='疫毒反噬者', HexColor='EE82EE'},
    [4] = {name='迅影突袭者', HexColor='1E90FF'},
}


CardCfg.Combo = {
    [1] = {name='4/12套装效果', HexColor='0DFF00'},
    [2] = {name='8/12套装效果', HexColor='FFD700'},
    [3] = {name='12/12套装效果', HexColor='FF424F'},
    [4] = {name='FullStar达成效果', HexColor='FF00FF'}
}


CardCfg.Suit = {
    [1] = {
        Group = 1,
        Combo = {
            [1] = {
                {property = Attribute.AttackPowerPct, value = 0.08},
                {property = Attribute.CritChance, value = 0.04},
            },
            [2] = {
                {property = Attribute.AttackPowerPct, value = 0.16},
                {property = Attribute.CritChance, value = 0.08},
                {property = Attribute.CritDamagePct, value = 0.15},
            },
            [3] = {
                {property = Attribute.AttackPowerPct, value = 0.3},
                {property = Attribute.CritChance, value = 0.12},
                {property = Attribute.CritDamagePct, value = 0.3},
                {property = Attribute.HealthStealPct, value = 0.01}
            },
            [4] = {
                {property = Attribute.SeckillChance, value = 0.01}
            }
        }
    },
    [2] = {
        Group = 2,
        Combo = {
            [1] = {
                {property = Attribute.HealthMaxPct, value = 0.05},
                {property = Attribute.DamageDecreacePct, value = 0.05},
            },
            [2] = {
                {property = Attribute.HealthMaxPct, value = 0.10},
                {property = Attribute.DamageDecreacePct, value = 0.10},
            },
            [3] = {
                {property = Attribute.HealthMaxPct, value = 0.20},
                {property = Attribute.DamageDecreacePct, value = 0.20},
                {property = Attribute.DodgeChance, value = 0.01}
            },
            [4] = {
                {property = Attribute.DodgeChance, value = 0.10}
            }
        }
    },
    [3] = {
        Group = 3,
        Combo = {
            [1] = {
                {property = Attribute.EpidemicToxinRatio, value = 0.10},
                {property = Attribute.EpidemicToxinLevel, value = 2},
            },
            [2] = {
                {property = Attribute.EpidemicToxinRatio, value = 0.20},
                {property = Attribute.EpidemicToxinLevel, value = 5},
            },
            [3] = {
                {property = Attribute.EpidemicToxinSettleRatio, value = 0.01}
            },
            [4] = {
                {property = Attribute.EpidemicToxinSettleRatio, value = 0.05}
            }
        }
    },
    [4] = {
        Group = 4,
        Combo = {
            [1] = {
                {property = Attribute.BurstShootCDWrapper, value = 0.10},
                {property = Attribute.MoveSpeedScale, value = 0.05},
            },
            [2] = {
                {property = Attribute.BurstShootCDWrapper, value = 0.20},
                {property = Attribute.MoveSpeedScale, value = 0.10},
                {property = Attribute.ReloadTime, value = 0.15},
            },
            [3] = {
                {property = Attribute.BurstShootCDWrapper, value = 0.30},
                {property = Attribute.MoveSpeedScale, value = 0.20},
                {property = Attribute.ReloadTime, value = 0.25},
            },
            [4] = {
                {property = Attribute.InfiniteAmmo, value = 1}
            }
        }
    }
}


CardCfg.Cards = {
    [1] = {
        suit = 1,
        star = 1,
        grade = 1,
        name = '克西',
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_14.Icon_Skill_14',
        bonus = {
            [1] = {
                {property = Attribute.AttackPowerPct, value = 0.005},
                {property = Attribute.NormalMonsterDamagePct, value = 0.015},
            },
            [2] = {
                {property = Attribute.AttackPowerPct, value = 0.01},
                {property = Attribute.NormalMonsterDamagePct, value = 0.03},
            },
            [3] = {
                {property = Attribute.AttackPowerPct, value = 0.02},
                {property = Attribute.NormalMonsterDamagePct, value = 0.05},
            }
        }
    },
    [2] = {
        suit = 1,
        star = 2,
        grade = 1,
        name = '宇普西隆',
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_99.Icon_Skill_99',
        bonus = {
            [1] = {
                {property = Attribute.AttackPowerPct, value = 0.005},
                {property = Attribute.CritDamagePct, value = 0.01},
            },
            [2] = {
                {property = Attribute.AttackPowerPct, value = 0.01},
                {property = Attribute.CritDamagePct, value = 0.02},
            },
            [3] = {
                {property = Attribute.AttackPowerPct, value = 0.02},
                {property = Attribute.CritDamagePct, value = 0.03},
            },
        }
    },
    [3] = {
        suit = 1,
        star = 3,
        grade = 1,
        name = '拉姆达',
        texture = '/Game/Mod/EscapeLobby/Arts_UI/TableIcons/Talent/Escape_Talent_icon_LiRen.Escape_Talent_icon_LiRen',
        bonus = {
            [1] = {
                {property = Attribute.AttackPowerPct, value = 0.005},
                {property = Attribute.CritChance, value = 0.005},
            },
            [2] = {
                {property = Attribute.AttackPowerPct, value = 0.01},
                {property = Attribute.CritChance, value = 0.01},
            },
            [3] = {
                {property = Attribute.AttackPowerPct, value = 0.02},
                {property = Attribute.CritChance, value = 0.02},
            },
        }
    },
    [4] = {
        suit = 1,
        star = 4,
        grade = 1,
        name = '柔',
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_117.Icon_Skill_117',
        bonus = {
            [1] = {
                {property = Attribute.AttackPowerPct, value = 0.005},
                {property = Attribute.EliteMonsterDamagePct, value = 0.015},
            },
            [2] = {
                {property = Attribute.AttackPowerPct, value = 0.01},
                {property = Attribute.EliteMonsterDamagePct, value = 0.03},
            },
            [3] = {
                {property = Attribute.AttackPowerPct, value = 0.02},
                {property = Attribute.EliteMonsterDamagePct, value = 0.05},
            },
        }
    },
    [5] = {
        suit = 1,
        star = 1,
        grade = 2,
        name = '噬疫',
        texture = '/Game/Mod/EscapeLobby/Arts_UI/TableIcons/Talent/Escape_Talent_icon_XiJia.Escape_Talent_icon_XiJia',
        bonus = {
            [1] = {
                {property = Attribute.AttackPowerPct, value = 0.01},
                {property = Attribute.CritDamagePct, value = 0.02},
                {property = Attribute.CritChance, value = 0.01},
            },
            [2] = {
                {property = Attribute.AttackPowerPct, value = 0.02},
                {property = Attribute.CritDamagePct, value = 0.03},
                {property = Attribute.CritChance, value = 0.02},
            },
            [3] = {
                {property = Attribute.AttackPowerPct, value = 0.04},
                {property = Attribute.CritDamagePct, value = 0.05},
                {property = Attribute.CritChance, value = 0.03},
            },
        }
    },
    [6] = {
        suit = 1,
        star = 2,
        grade = 2,
        name = '畸变',
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_8.Icon_Skill_8',
        bonus = {
            [1] = {
                {property = Attribute.AttackPowerPct, value = 0.01},
                {property = Attribute.EliteMonsterDamagePct, value = 0.025},
            },
            [2] = {
                {property = Attribute.AttackPowerPct, value = 0.02},
                {property = Attribute.EliteMonsterDamagePct, value = 0.05},
            },
            [3] = {
                {property = Attribute.AttackPowerPct, value = 0.04},
                {property = Attribute.EliteMonsterDamagePct, value = 0.1},
            },
        }
    },
    [7] = {
        suit = 1,
        star = 3,
        grade = 2,
        name = '疫核',
        texture = '/Game/Arts_Timeliness/GameMode/SuperPeople/Art_UI/NoAtlas/SkillIcon/CG029_SP_JobCyberSpider_0.CG029_SP_JobCyberSpider_0',
        bonus = {
            [1] = {
                {property = Attribute.AttackPowerPct, value = 0.01},
                {property = Attribute.NormalMonsterDamagePct, value = 0.025},
            },
            [2] = {
                {property = Attribute.AttackPowerPct, value = 0.02},
                {property = Attribute.NormalMonsterDamagePct, value = 0.06},
            },
            [3] = {
                {property = Attribute.AttackPowerPct, value = 0.04},
                {property = Attribute.NormalMonsterDamagePct, value = 0.1},
            },
        }
    },
    [8] = {
        suit = 1,
        star = 1,
        grade = 3,
        name = '猎疫先锋',
        texture = '/Game/Arts/UI/TableIcons/ProfessionResult_Icon/MS_Icon_jidonbing.MS_Icon_jidonbing',
        bonus = {
            [1] = {
                {property = Attribute.AttackPowerPct, value = 0.02},
                {property = Attribute.CritChance, value = 0.02},
                {property = Attribute.NormalMonsterDamagePct, value = 0.05},
            },
            [2] = {
                {property = Attribute.AttackPowerPct, value = 0.04},
                {property = Attribute.CritChance, value = 0.03},
                {property = Attribute.NormalMonsterDamagePct, value = 0.1},
            },
            [3] = {
                {property = Attribute.AttackPowerPct, value = 0.08},
                {property = Attribute.CritChance, value = 0.04},
                {property = Attribute.NormalMonsterDamagePct, value = 0.2},
            },
        }
    },
    [9] = {
        suit = 1,
        star = 2,
        grade = 3,
        name = '阿尔法·猎',
        texture = '/Game/Arts_Timeliness/GameMode/SuperPeople/Art_UI/NoAtlas/SkillIcon/CG025_SP_Dragn_1.CG025_SP_Dragn_1',
        bonus = {
            [1] = {
                {property = Attribute.AttackPowerPct, value = 0.02},
                {property = Attribute.CritDamagePct, value = 0.03},
                {property = Attribute.EliteMonsterDamagePct, value = 0.05},
            },
            [2] = {
                {property = Attribute.AttackPowerPct, value = 0.04},
                {property = Attribute.CritDamagePct, value = 0.04},
                {property = Attribute.EliteMonsterDamagePct, value = 0.1},
            },
            [3] = {
                {property = Attribute.AttackPowerPct, value = 0.08},
                {property = Attribute.CritDamagePct, value = 0.07},
                {property = Attribute.EliteMonsterDamagePct, value = 0.2},
            },
        }
    },
    [10] = {
        suit = 1,
        star = 1,
        grade = 4,
        name = '灾变猎手',
        texture = '/Game/Arts/UI/TableIcons/ProfessionResult_Icon/ProfessionSkill_Icon/tuji_kuangre2.tuji_kuangre2',
        bonus = {
            [1] = {
                {property = Attribute.AttackPowerPct, value = 0.04},
                {property = Attribute.BossDamagePct, value = 0.05},
                {property = Attribute.BreakDefencePct, value = 0.03},
            },
            [2] = {
                {property = Attribute.AttackPowerPct, value = 0.08},
                {property = Attribute.BossDamagePct, value = 0.1},
                {property = Attribute.BreakDefencePct, value = 0.06},
            },
            [3] = {
                {property = Attribute.AttackPowerPct, value = 0.16},
                {property = Attribute.BossDamagePct, value = 0.2},
                {property = Attribute.BreakDefencePct, value = 0.1},
            },
        }
    },
    [11] = {
        suit = 1,
        star = 2,
        grade = 4,
        name = '猎颅者',
        texture = '/Game/Arts_Timeliness/GameMode/SuperPeople/Art_UI/NoAtlas/SkillIcon/CG020_SP_JobLightning_3.CG020_SP_JobLightning_3',
        bonus = {
            [1] = {
                {property = Attribute.AttackPowerPct, value = 0.04},
                {property = Attribute.CritChance, value = 0.03},
                {property = Attribute.CritDamagePct, value = 0.04},
            },
            [2] = {
                {property = Attribute.AttackPowerPct, value = 0.08},
                {property = Attribute.CritChance, value = 0.04},
                {property = Attribute.CritDamagePct, value = 0.06},
            },
            [3] = {
                {property = Attribute.AttackPowerPct, value = 0.16},
                {property = Attribute.CritChance, value = 0.07},
                {property = Attribute.CritDamagePct, value = 0.1},
            },
        }
    },
    [12] = {
        suit = 1,
        star = 1,
        grade = 5,
        name = '始祖·猎魂',
        texture = '/Game/Arts_Timeliness/GameMode/SuperPeople/Art_UI/NoAtlas/SkillIcon/CG028_SP_JobGunman_3.CG028_SP_JobGunman_3',
        bonus = {
            [1] = {
                {property = Attribute.AttackPowerPct, value = 0.08},
                {property = Attribute.CritChance, value = 0.04},
                {property = Attribute.BossDamagePct, value = 0.1},
                {property = Attribute.CritDamagePct, value = 0.05},
                {property = Attribute.BreakDefencePct, value = 0.05},
            },
            [2] = {
                {property = Attribute.AttackPowerPct, value = 0.16},
                {property = Attribute.CritChance, value = 0.06},
                {property = Attribute.BossDamagePct, value = 0.15},
                {property = Attribute.CritDamagePct, value = 0.1},
                {property = Attribute.BreakDefencePct, value = 0.1},
            },
            [3] = {
                {property = Attribute.AttackPowerPct, value = 0.82},
                {property = Attribute.CritChance, value = 0.2},
                {property = Attribute.BossDamagePct, value = 0.3},
                {property = Attribute.CritDamagePct, value = 0.2},
                {property = Attribute.BreakDefencePct, value = 0.2},
            },
        }
    },
    [13] = {
        suit = 2,
        star = 1,
        grade = 1,
        name = '塔乌',
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_12.Icon_Skill_12',
        bonus = {
            [1] = {
                {property = Attribute.HealthMaxPct, value = 0.005},
            },
            [2] = {
                {property = Attribute.HealthMaxPct, value = 0.01},
            },
            [3] = {
                {property = Attribute.HealthMaxPct, value = 0.02},
            },
        }
    },
    [14] = {
        suit = 2,
        star = 2,
        grade = 1,
        name = '奥米伽',
        texture = '/Game/Mod/EscapeLobby/Arts_UI/TableIcons/Talent/Escape_Talent_icon_GuiKe.Escape_Talent_icon_GuiKe',
        bonus = {
            [1] = {
                {property = Attribute.DefensePct, value = 0.005},
            },
            [2] = {
                {property = Attribute.DefensePct, value = 0.01},
            },
            [3] = {
                {property = Attribute.DefensePct, value = 0.02},
            },
        }
    },
    [15] = {
        suit = 2,
        star = 3,
        grade = 1,
        name = '菲',
        texture = '/Game/Mod/EscapeLobby/Arts_UI/TableIcons/Talent/Escape_Talent_icon_RenXing.Escape_Talent_icon_RenXing',
        bonus = {
            [1] = {
                {property = Attribute.HealthMaxPct, value = 0.0025},
                {property = Attribute.DefensePct, value = 0.0025},
            },
            [2] = {
                {property = Attribute.HealthMaxPct, value = 0.005},
                {property = Attribute.DefensePct, value = 0.005},
            },
            [3] = {
                {property = Attribute.HealthMaxPct, value = 0.01},
                {property = Attribute.DefensePct, value = 0.01},
            },
        }
    },
    [16] = {
        suit = 2,
        star = 4,
        grade = 1,
        name = '西格玛',
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_34.Icon_Skill_34',
        bonus = {
            [1] = {
                {property = Attribute.DamageDecreacePct, value = 0.0025},
            },
            [2] = {
                {property = Attribute.DamageDecreacePct, value = 0.005},
            },
            [3] = {
                {property = Attribute.DamageDecreacePct, value = 0.01},
            },
        }
    },
    [17] = {
        suit = 2,
        star = 1,
        grade = 2,
        name = '厚腐',
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_74.Icon_Skill_74',
        bonus = {
            [1] = {
                {property = Attribute.HealthMaxPct, value = 0.01},
            },
            [2] = {
                {property = Attribute.HealthMaxPct, value = 0.02},
            },
            [3] = {
                {property = Attribute.HealthMaxPct, value = 0.04},
            },
        }
    },
    [18] = {
        suit = 2,
        star = 2,
        grade = 2,
        name = '岩甲',
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_59.Icon_Skill_59',
        bonus = {
            [1] = {
                {property = Attribute.DefensePct, value = 0.01},
            },
            [2] = {
                {property = Attribute.DefensePct, value = 0.02},
            },
            [3] = {
                {property = Attribute.DefensePct, value = 0.04},
            },
        }
    },
    [19] = {
        suit = 2,
        star = 3,
        grade = 2,
        name = '骨盾',
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_30.Icon_Skill_30',
        bonus = {
            [1] = {
                {property = Attribute.DamageDecreacePct, value = 0.005},
            },
            [2] = {
                {property = Attribute.DamageDecreacePct, value = 0.01},
            },
            [3] = {
                {property = Attribute.DamageDecreacePct, value = 0.02},
            },
        }
    },
    [20] = {
        suit = 2,
        star = 1,
        grade = 3,
        name = '腐岩卫',
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_28.Icon_Skill_28',
        bonus = {
            [1] = {
                {property = Attribute.HealthMaxPct, value = 0.02},
                {property = Attribute.DamageDecreacePct, value = 0.01},
            },
            [2] = {
                {property = Attribute.HealthMaxPct, value = 0.03},
                {property = Attribute.DamageDecreacePct, value = 0.015},
            },
            [3] = {
                {property = Attribute.HealthMaxPct, value = 0.06},
                {property = Attribute.DamageDecreacePct, value = 0.03},
            },
        }
    },
    [21] = {
        suit = 2,
        star = 2,
        grade = 3,
        name = '阿尔法·御',
        texture = '/Game/Arts/UI/TableIcons/ProfessionResult_Icon/ProfessionSkill_Icon/houqing_zhizaofangju.houqing_zhizaofangju',
        bonus = {
            [1] = {
                {property = Attribute.DefensePct, value = 0.02},
                {property = Attribute.DamageDecreacePct, value = 0.01},
            },
            [2] = {
                {property = Attribute.DefensePct, value = 0.03},
                {property = Attribute.DamageDecreacePct, value = 0.015},
            },
            [3] = {
                {property = Attribute.DefensePct, value = 0.06},
                {property = Attribute.DamageDecreacePct, value = 0.03},
            },
        }
    },
    [22] = {
        suit = 2,
        star = 1,
        grade = 4,
        name = '磐石堡垒',
        texture = '/Game/Arts_Timeliness/GameMode/SuperPeople/Art_UI/NoAtlas/SkillIcon/CG020_SP_JobCommander_1.CG020_SP_JobCommander_1',
        bonus = {
            [1] = {
                {property = Attribute.HealthMaxPct, value = 0.025},
                {property = Attribute.DamageDecreacePct, value = 0.015},
            },
            [2] = {
                {property = Attribute.HealthMaxPct, value = 0.05},
                {property = Attribute.DamageDecreacePct, value = 0.03},
            },
            [3] = {
                {property = Attribute.HealthMaxPct, value = 0.1},
                {property = Attribute.DamageDecreacePct, value = 0.05},
            },
        }
    },
    [23] = {
        suit = 2,
        star = 2,
        grade = 4,
        name = '骨甲巨卫',
        texture = '/Game/Arts_Timeliness/GameMode/SuperPeople/Art_UI/NoAtlas/SkillIcon/CG020_SP_JobBeltway_3.CG020_SP_JobBeltway_3',
        bonus = {
            [1] = {
                {property = Attribute.DefensePct, value = 0.025},
                {property = Attribute.DamageDecreacePct, value = 0.015},
            },
            [2] = {
                {property = Attribute.DefensePct, value = 0.05},
                {property = Attribute.DamageDecreacePct, value = 0.03},
            },
            [3] = {
                {property = Attribute.DefensePct, value = 0.1},
                {property = Attribute.DamageDecreacePct, value = 0.05},
            },
        }
    },
    [24] = {
        suit = 2,
        star = 1,
        grade = 5,
        name = '始祖·御界',
        texture = '/Game/Arts_Timeliness/GameMode/SuperPeople/Art_UI/NoAtlas/SkillIcon/CG032_SP_JobDriver_2.CG032_SP_JobDriver_2',
        bonus = {
            [1] = {
                {property = Attribute.HealthMaxPct, value = 0.04},
                {property = Attribute.DefensePct, value = 0.04},
                {property = Attribute.DamageDecreacePct, value = 0.025},
            },
            [2] = {
                {property = Attribute.HealthMaxPct, value = 0.08},
                {property = Attribute.DefensePct, value = 0.08},
                {property = Attribute.DamageDecreacePct, value = 0.05},
            },
            [3] = {
                {property = Attribute.HealthMaxPct, value = 0.2},
                {property = Attribute.DefensePct, value = 0.2},
                {property = Attribute.DamageDecreacePct, value = 0.2},
            },
        }
    },
    [25] = {
        suit = 3,
        star = 1,
        grade = 1,
        name = '厄',
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_18.Icon_Skill_18',
        bonus = {
            [1] = {
                {property = Attribute.EpidemicToxinRatio, value = 0.01},
            },
            [2] = {
                {property = Attribute.EpidemicToxinRatio, value = 0.02},
            },
            [3] = {
                {property = Attribute.EpidemicToxinRatio, value = 0.04},
            },
        }
    },
    [26] = {
        suit = 3,
        star = 2,
        grade = 1,
        name = '派',
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_21.Icon_Skill_21',
        bonus = {
            [1] = {
                {property = Attribute.EpidemicToxinLevel, value = 1},
            },
            [2] = {
                {property = Attribute.EpidemicToxinLevel, value = 2},
            },
            [3] = {
                {property = Attribute.EpidemicToxinLevel, value = 3},
            },
        }
    },
    [27] = {
        suit = 3,
        star = 3,
        grade = 1,
        name = '纽',
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_29.Icon_Skill_29',
        bonus = {
            [1] = {
                {property = Attribute.EpidemicToxinOverlyLimit, value = 1},
            },
            [2] = {
                {property = Attribute.EpidemicToxinOverlyLimit, value = 2},
            },
            [3] = {
                {property = Attribute.EpidemicToxinOverlyLimit, value = 3},
            },
        }
    },
    [28] = {
        suit = 3,
        star = 4,
        grade = 1,
        name = '陶',
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_16.Icon_Skill_16',
        bonus = {
            [1] = {
                {property = Attribute.DefensePct, value = 0.005},
            },
            [2] = {
                {property = Attribute.DefensePct, value = 0.01},
            },
            [3] = {
                {property = Attribute.DefensePct, value = 0.02},
            },
        }
    },
    [29] = {
        suit = 3,
        star = 1,
        grade = 2,
        name = '源生',
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_61.Icon_Skill_61',
        bonus = {
            [1] = {
                {property = Attribute.EpidemicToxinLevel, value = 2},
            },
            [2] = {
                {property = Attribute.EpidemicToxinLevel, value = 4},
            },
            [3] = {
                {property = Attribute.EpidemicToxinLevel, value = 6},
            },
        }
    },
    [30] = {
        suit = 3,
        star = 2,
        grade = 2,
        name = '灵能',
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_82.Icon_Skill_82',
        bonus = {
            [1] = {
                {property = Attribute.EpidemicToxinRatio, value = 0.015},
            },
            [2] = {
                {property = Attribute.EpidemicToxinRatio, value = 0.03},
            },
            [3] = {
                {property = Attribute.EpidemicToxinRatio, value = 0.06},
            },
        }
    },
    [31] = {
        suit = 3,
        star = 3,
        grade = 2,
        name = '蚀骨',
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_58.Icon_Skill_58',
        bonus = {
            [1] = {
                {property = Attribute.EpidemicToxinOverlyLimit, value = 2},
            },
            [2] = {
                {property = Attribute.EpidemicToxinOverlyLimit, value = 4},
            },
            [3] = {
                {property = Attribute.EpidemicToxinOverlyLimit, value = 6},
            },
        }
    },
    [32] = {
        suit = 3,
        star = 1,
        grade = 3,
        name = '源力师',
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_62.Icon_Skill_62',
        bonus = {
            [1] = {
                {property = Attribute.EpidemicToxinOverlyLimit, value = 3},
                {property = Attribute.EpidemicToxinRatio, value = 0.02},
            },
            [2] = {
                {property = Attribute.EpidemicToxinOverlyLimit, value = 6},
                {property = Attribute.EpidemicToxinRatio, value = 0.04},
            },
            [3] = {
                {property = Attribute.EpidemicToxinOverlyLimit, value = 9},
                {property = Attribute.EpidemicToxinRatio, value = 0.08},
            },
        }
    },
    [33] = {
        suit = 3,
        star = 2,
        grade = 3,
        name = '阿尔法·能',
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_45.Icon_Skill_45',
        bonus = {
            [1] = {
                {property = Attribute.EpidemicToxinLevel, value = 3},
                {property = Attribute.EpidemicToxinRatio, value = 0.02},
            },
            [2] = {
                {property = Attribute.EpidemicToxinLevel, value = 6},
                {property = Attribute.EpidemicToxinRatio, value = 0.04},
            },
            [3] = {
                {property = Attribute.EpidemicToxinLevel, value = 9},
                {property = Attribute.EpidemicToxinRatio, value = 0.08},
            },
        }
    },
    [34] = {
        suit = 3,
        star = 1,
        grade = 4,
        name = '源能主宰',
        texture = '/Game/Arts_Timeliness/GameMode/SuperPeople/Art_UI/NoAtlas/SkillIcon/CG029_SP_JobCyberSpider_2.CG029_SP_JobCyberSpider_2',
        bonus = {
            [1] = {
                {property = Attribute.EpidemicToxinOverlyLimit, value = 4},
                {property = Attribute.EpidemicToxinRatio, value = 0.03},
            },
            [2] = {
                {property = Attribute.EpidemicToxinOverlyLimit, value = 8},
                {property = Attribute.EpidemicToxinRatio, value = 0.06},
            },
            [3] = {
                {property = Attribute.EpidemicToxinOverlyLimit, value = 15},
                {property = Attribute.EpidemicToxinRatio, value = 0.12},
            },
        }
    },
    [35] = {
        suit = 3,
        star = 2,
        grade = 4,
        name = '疫变领主',
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_86.Icon_Skill_86',
        bonus = {
            [1] = {
                {property = Attribute.EpidemicToxinLevel, value = 4},
                {property = Attribute.EpidemicToxinRatio, value = 0.03},
            },
            [2] = {
                {property = Attribute.EpidemicToxinLevel, value = 8},
                {property = Attribute.EpidemicToxinRatio, value = 0.06},
            },
            [3] = {
                {property = Attribute.EpidemicToxinLevel, value = 15},
                {property = Attribute.EpidemicToxinRatio, value = 0.12},
            },
        }
    },
    [36] = {
        suit = 3,
        star = 1,
        grade = 5,
        name = '始祖·疫源',
        texture = '/Game/Arts_Timeliness/GameMode/SuperPeople/Art_UI/NoAtlas/SkillIcon/CG029_SP_JobCyberSpider_1.CG029_SP_JobCyberSpider_1',
        bonus = {
            [1] = {
                {property = Attribute.EpidemicToxinLevel, value = 5},
                {property = Attribute.EpidemicToxinOverlyLimit, value = 5},
            },
            [2] = {
                {property = Attribute.EpidemicToxinLevel, value = 10},
                {property = Attribute.EpidemicToxinOverlyLimit, value = 10},
            },
            [3] = {
                {property = Attribute.EpidemicToxinLevel, value = 20},
                {property = Attribute.EpidemicToxinOverlyLimit, value = 20},
                {property = Attribute.EpidemicToxinSettleRatio, value = 0.01},
            },
        }
    },
    [37] = {
        suit = 4,
        star = 1,
        grade = 1,
        name = '桑',
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_49.Icon_Skill_49',
        bonus = {
            [1] = {
                {property = Attribute.MoveSpeedScale, value = 0.005},
            },
            [2] = {
                {property = Attribute.MoveSpeedScale, value = 0.01},
            },
            [3] = {
                {property = Attribute.MoveSpeedScale, value = 0.02},
            },
        }
    },
    [38] = {
        suit = 4,
        star = 2,
        grade = 1,
        name = '科',
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_41.Icon_Skill_41',
        bonus = {
            [1] = {
                {property = Attribute.ReloadTime, value = -0.01},
            },
            [2] = {
                {property = Attribute.ReloadTime, value = -0.02},
            },
            [3] = {
                {property = Attribute.ReloadTime, value = -0.04},
            },
        }
    },
    [39] = {
        suit = 4,
        star = 3,
        grade = 1,
        name = '罗',
        texture = '/Game/Arts_Timeliness/GameMode/SuperPeople/Art_UI/NoAtlas/SkillIcon/CG020_SP_JobRocket_3.CG020_SP_JobRocket_3',
        bonus = {
            [1] = {
                {property = Attribute.DodgeChance, value = 0.01},
            },
            [2] = {
                {property = Attribute.DodgeChance, value = 0.02},
            },
            [3] = {
                {property = Attribute.DodgeChance, value = 0.04},
            },
        }
    },
    [40] = {
        suit = 4,
        star = 4,
        grade = 1,
        name = '菲克斯',
        texture = '/Game/Arts_Timeliness/GameMode/SuperPeople/Art_UI/NoAtlas/SkillIcon/CG020_SP_JobLightning_1.CG020_SP_JobLightning_1',
        bonus = {
            [1] = {
                {property = Attribute.BurstShootCDWrapper, value = -0.01},
            },
            [2] = {
                {property = Attribute.BurstShootCDWrapper, value = -0.02},
            },
            [3] = {
                {property = Attribute.BurstShootCDWrapper, value = -0.04},
            },
        }
    },
    [41] = {
        suit = 4,
        star = 1,
        grade = 2,
        name = '影步',
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_38.Icon_Skill_38',
        bonus = {
            [1] = {
                {property = Attribute.MoveSpeedScale, value = 0.015},
            },
            [2] = {
                {property = Attribute.MoveSpeedScale, value = 0.03},
            },
            [3] = {
                {property = Attribute.MoveSpeedScale, value = 0.06},
            },
        }
    },
    [42] = {
        suit = 4,
        star = 2,
        grade = 2,
        name = '掠风',
        texture = '/Game/Arts_Timeliness/GameMode/SuperPeople/Art_UI/NoAtlas/SkillIcon/CG020_SP_JobLightning_2.CG020_SP_JobLightning_2',
        bonus = {
            [1] = {
                {property = Attribute.DodgeChance, value = 0.015},
            },
            [2] = {
                {property = Attribute.DodgeChance, value = 0.03},
            },
            [3] = {
                {property = Attribute.DodgeChance, value = 0.06},
            },
        }
    },
    [43] = {
        suit = 4,
        star = 3,
        grade = 2,
        name = '速射',
        texture = '/Game/Arts_Timeliness/GameMode/SuperPeople/Art_UI/NoAtlas/SkillIcon/CG020_SP_JobLightning_1.CG020_SP_JobLightning_1',
        bonus = {
            [1] = {
                {property = Attribute.BurstShootCDWrapper, value = 0.015},
            },
            [2] = {
                {property = Attribute.BurstShootCDWrapper, value = -0.03},
            },
            [3] = {
                {property = Attribute.BurstShootCDWrapper, value = -0.06},
            },
        }
    },
    [44] = {
        suit = 4,
        star = 1,
        grade = 3,
        name = '影袭者',
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_82.Icon_Skill_82',
        bonus = {
            [1] = {
                {property = Attribute.MoveSpeedScale, value = 0.025},
                {property = Attribute.DodgeChance, value = 0.025},
            },
            [2] = {
                {property = Attribute.MoveSpeedScale, value = 0.05},
                {property = Attribute.DodgeChance, value = 0.05},
            },
            [3] = {
                {property = Attribute.MoveSpeedScale, value = 0.1},
                {property = Attribute.DodgeChance, value = 0.1},
            },
        }
    },
    [45] = {
        suit = 4,
        star = 2,
        grade = 3,
        name = '阿尔法·迅',
        texture = '/Game/Arts_Timeliness/GameMode/SuperPeople/Art_UI/NoAtlas/SkillIcon/CG029_SP_JobCyberSpider_3.CG029_SP_JobCyberSpider_3',
        bonus = {
            [1] = {
                {property = Attribute.BurstShootCDWrapper, value = -0.025},
                {property = Attribute.ReloadTime, value = -0.025},
            },
            [2] = {
                {property = Attribute.BurstShootCDWrapper, value = -0.05},
                {property = Attribute.ReloadTime, value = -0.05},
            },
            [3] = {
                {property = Attribute.BurstShootCDWrapper, value = -0.1},
                {property = Attribute.ReloadTime, value = -0.1},
            },
        }
    },
    [46] = {
        suit = 4,
        star = 1,
        grade = 4,
        name = '瞬刃',
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_9.Icon_Skill_9',
        bonus = {
            [1] = {
                {property = Attribute.BurstShootCDWrapper, value = -0.04},
                {property = Attribute.ReloadTime, value = -0.04},
            },
            [2] = {
                {property = Attribute.BurstShootCDWrapper, value = -0.08},
                {property = Attribute.ReloadTime, value = -0.08},
            },
            [3] = {
                {property = Attribute.BurstShootCDWrapper, value = -0.15},
                {property = Attribute.ReloadTime, value = -0.15},
            },
        }
    },
    [47] = {
        suit = 4,
        star = 2,
        grade = 4,
        name = '虚空行者',
        texture = '/Game/UGC/Repository/Icon/Skill/Icon_Skill_78.Icon_Skill_78',
        bonus = {
            [1] = {
                {property = Attribute.MoveSpeedScale, value = 0.04},
                {property = Attribute.DodgeChance, value = 0.04},
            },
            [2] = {
                {property = Attribute.MoveSpeedScale, value = 0.08},
                {property = Attribute.DodgeChance, value = 0.08},
            },
            [3] = {
                {property = Attribute.MoveSpeedScale, value = 0.15},
                {property = Attribute.DodgeChance, value = 0.15},
            },
        }
    },
    [48] = {
        suit = 4,
        star = 1,
        grade = 5,
        name = '始祖·影',
        texture = '/Game/Arts_Timeliness/GameMode/SuperPeople/Art_UI/NoAtlas/SkillIcon/CG028_SP_JobGunman_2.CG028_SP_JobGunman_2',
        bonus = {
            [1] = {
                {property = Attribute.MoveSpeedScale, value = 0.06},
                {property = Attribute.DodgeChance, value = 0.06},
                {property = Attribute.BurstShootCDWrapper, value = -0.06},
                {property = Attribute.ReloadTime, value = -0.06},
            },
            [2] = {
                {property = Attribute.MoveSpeedScale, value = 0.12},
                {property = Attribute.DodgeChance, value = 0.12},
                {property = Attribute.BurstShootCDWrapper, value = -0.12},
                {property = Attribute.ReloadTime, value = -0.12},
            },
            [3] = {
                {property = Attribute.Recoilless, value = 1},
                {property = Attribute.BurstShootCDWrapper, value = -0.25},
                {property = Attribute.MoveSpeedScale, value = 0.25},
                {property = Attribute.DodgeChance, value = 0.25},
            },
        }
    },
}


return Card