-- 成就系统界面管理器

ACHVManager = ACHVManager or
{
    -- ===== 运行时变量 =====
    PlayerId = nil;
    MainUI = nil;
    CategoryListUI = nil;
    TitleListUI = nil;
    Preview = nil;
    RightContent = nil;

    -- ===== 静态配置（固定数据） =====
    Config = {
        -- 动画时长
        AnimDur = {
            In = 0.2,
            Out = 0.2
        };
        -- 条件类型枚举
        ConditionType = {
            -- 金币数量
            CoinCount = 0,
            -- 起源币数量
            QYCoinCount = 1,
            -- 赛季等级
            SeasonLevel = 2,
            -- 普通怪物击杀数量
            NormalMonsterKillCount = 3,
            -- 精英怪物击杀数量
            EliteMonsterKillCount = 4,
            -- 头目怪物击杀数量
            BossKillCount = 5,
            -- 全程生命值从未低于50%单局内普通怪物击杀数量'
            NormalMonsterKillCountHealthAboveHalf = 6,
            -- 全程生命值从未低于50%单局内精英怪物击杀数量'
            EliteMonsterKillCountHealthAboveHalf = 7,
            -- 无伤击败头目怪
            HasPerfectBossFight = 8
        };
        -- 称号类型文本
        CategoryNameLabel = {
            [0] = "财富称号",
            [1] = "充值称号",
            [2] = "赛季称号"
        };
        -- 解锁状态文本
        UnlockStateText = {
            [0] = '未解锁',
            [1] = '已解锁',
            [2] = '已佩戴'
        };
        -- 设置按钮状态文本
        SetStateText = {
            [0] = '解锁',
            [1] = '佩戴',
            [2] = '卸下'
        };
        -- 设置按钮切换状态固定模式
        SetToggleState = {[0] = 1, [1] = 2, [2] = 1};
        -- 称号数据
        TitleData = {
            [0] = {
                {
                    -- 标题文本
                    NameText = '囊中羞涩',
                    -- 图标路径
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/WealthTitle_%d.WealthTitle_%d',
                    -- 解锁条件文本
                    UnlockConditions = '达到金币10000',
                    -- 收集效果文本
                    CollectEffects = '金币结算加成1%',
                    -- 佩戴效果文本
                    WearEffects = '金币结算加成2%',
                    -- 解锁状态
                    UnlockState = 0,
                    -- 解锁类型与值
                    UnlockType = {
                        [0] = 10000
                    }
                },
                {
                    NameText = '略有盈余',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/WealthTitle_%d.WealthTitle_%d',
                    UnlockConditions = '达到金币100000',
                    CollectEffects = '金币结算加成3%',
                    WearEffects = '金币结算加成5%',
                    UnlockState = 0,
                    UnlockType = {
                        [0] = 100000
                    }
                },
                {
                    NameText = '小富即安',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/WealthTitle_%d.WealthTitle_%d',
                    UnlockConditions = '达到金币500000',
                    CollectEffects = '金币结算加成5%',
                    WearEffects = '金币结算加成8%',
                    UnlockState = 0,
                    UnlockType = {
                        [0] = 500000
                    }
                },
                {
                    NameText = '盆满钵满',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/WealthTitle_%d.WealthTitle_%d',
                    UnlockConditions = '达到金币1000000',
                    CollectEffects = '金币结算加成7%',
                    WearEffects = '金币结算加成10%',
                    UnlockState = 0,
                    UnlockType = {
                        [0] = 1000000
                    }
                },
                {
                    NameText = '腰缠万贯',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/WealthTitle_%d.WealthTitle_%d',
                    UnlockConditions = '达到金币5000000',
                    CollectEffects = '金币结算加成9%',
                    WearEffects = '金币结算加成12%',
                    UnlockState = 0,
                    UnlockType = {
                        [0] = 5000000
                    }
                },
                {
                    NameText = '富甲一方',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/WealthTitle_%d.WealthTitle_%d',
                    UnlockConditions = '达到金币10000000',
                    CollectEffects = '金币结算加成11%',
                    WearEffects = '金币结算加成14%',
                    UnlockState = 0,
                    UnlockType = {
                        [0] = 10000000
                    }
                },
                {
                    NameText = '富可敌国',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/WealthTitle_%d.WealthTitle_%d',
                    UnlockConditions = '达到金币100000000',
                    CollectEffects = '金币结算加成13%',
                    WearEffects = '金币结算加成17%',
                    UnlockState = 0,
                    UnlockType = {
                        [0] = 100000000
                    }
                }
            },
            [1] = {
                {
                    NameText = '首当其充',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/TopUpTitle_%d.TopUpTitle_%d',
                    UnlockConditions = '首次充值',
                    CollectEffects = '金币结算加成8%',
                    WearEffects = '金币结算加成12%',
                    UnlockState = 0,
                    UnlockType = {
                        [1] = 1
                    }
                },
                {
                    NameText = '千金一掷',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/TopUpTitle_%d.TopUpTitle_%d',
                    UnlockConditions = '累积充值689起源币',
                    CollectEffects = '金币结算加成10%',
                    WearEffects = '金币结算加成14%',
                    UnlockState = 0,
                    UnlockType = {
                        [1] = 689
                    }
                },
                {
                    NameText = '财大气粗',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/TopUpTitle_%d.TopUpTitle_%d',
                    UnlockConditions = '累积充值1888起源币',
                    CollectEffects = '金币结算加成12%',
                    WearEffects = '金币结算加成16%',
                    UnlockState = 0,
                    UnlockType = {
                        [1] = 1888
                    }
                },
                {
                    NameText = '不差钱',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/TopUpTitle_%d.TopUpTitle_%d',
                    UnlockConditions = '累积充值5888起源币',
                    CollectEffects = '金币结算加成14%',
                    WearEffects = '金币结算加成18%',
                    UnlockState = 0,
                    UnlockType = {
                        [1] = 5888
                    }
                },
                {
                    NameText = '马上有钱',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/TopUpTitle_%d.TopUpTitle_%d',
                    UnlockConditions = '累积充值8888起源币',
                    CollectEffects = '金币结算加成16%',
                    WearEffects = '金币结算加成20%',
                    UnlockState = 0,
                    UnlockType = {
                        [1] = 8888
                    }
                },
                {
                    NameText = '钱能通神',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/TopUpTitle_%d.TopUpTitle_%d',
                    UnlockConditions = '累积充值16888起源币',
                    CollectEffects = '金币结算加成18%',
                    WearEffects = '金币结算加成25%',
                    UnlockState = 0,
                    UnlockType = {
                        [1] = 16888
                    }
                }
            },
            [2] = {
                {
                    NameText = '尸墟巡猎者',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/SeasonTitle_%d.SeasonTitle_%d',
                    UnlockConditions = '- 赛季等级达到10级\n- 累计击杀普通僵尸 500 只',
                    CollectEffects = '',
                    WearEffects = '对普通僵尸伤害 +5%',
                    UnlockState = 0,
                    UnlockType = {
                        [2] = 10,
                        [3] = 500
                    }
                },
                {
                    NameText = '腐潮肃清者',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/SeasonTitle_%d.SeasonTitle_%d',
                    UnlockConditions = '- 赛季等级达到20级\n- 累计击杀精英怪 150 只',
                    CollectEffects = '',
                    WearEffects = '对精英僵尸伤害 +5%',
                    UnlockState = 0,
                    UnlockType = {
                        [2] = 20,
                        [4] = 150
                    }
                },
                {
                    NameText = '无殇镇疫使',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/SeasonTitle_%d.SeasonTitle_%d',
                    UnlockConditions = '- 赛季等级达到30级\n- 单局内击杀100普通僵尸，且全程生命值从未低于50%',
                    CollectEffects = '',
                    WearEffects = '- 对普通僵尸伤害 +8%\n- 受到普通僵尸伤害 -3%',
                    UnlockState = 0,
                    UnlockType = {
                        [2] = 30,
                        [6] = 100
                    }
                },
                {
                    NameText = '荒城孤伐者',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/SeasonTitle_%d.SeasonTitle_%d',
                    UnlockConditions = '- 赛季等级达到40级\n- 单局内击杀30只精英怪，且全程生命值从未低于50%',
                    CollectEffects = '',
                    WearEffects = '- 对精英僵尸伤害 +8%\n- 受到精英僵尸伤害 -3%',
                    UnlockState = 0,
                    UnlockType = {
                        [2] = 40,
                        [7] = 30
                    }
                },
                {
                    NameText = '疫首诛灭者',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/SeasonTitle_%d.SeasonTitle_%d',
                    UnlockConditions = '- 赛季等级达到50级\n- 累积击杀50次boss',
                    CollectEffects = '',
                    WearEffects = '- 全伤+10%\n- 伤害-5%\n- 暴击率+3%',
                    UnlockState = 0,
                    UnlockType = {
                        [2] = 50,
                        [5] = 50
                    }
                },
                {
                    NameText = '万尸归墟尊',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/SeasonTitle_%d.SeasonTitle_%d',
                    UnlockConditions = '- 赛季等级达到100级\n- 无伤击败boss一次',
                    CollectEffects = '',
                    WearEffects = '- 全伤+15%\n- 伤害-10%\n- 暴击率+5%\n- 第一次死亡时候无敌3秒，并且回复30%血量',
                    UnlockState = 0,
                    UnlockType = {
                        [2] = 100,
                        [8] = 1
                    }
                }
            }
        };
    };
}

function ACHVManager:RegisterComponentClass(CompClass)

    if CompClass ~= nil then
        self.ComponentClass = CompClass;
    end
end

function ACHVManager:RegisterMainUI(MainUI)
    
    if self.MainUI == nil then
        self.MainUI = MainUI;
    end
end

function ACHVManager:UnregisterMainUI()
    self.MainUI = nil;
end

function ACHVManager:OpenMainUI()
    if self.MainUI == nil then
        return;
    end
    self.MainUI:Open();
end

function ACHVManager:CloseMainUI()
    if self.MainUI == nil then
        return;
    end
    self.MainUI:Close();
end

return ACHVManager