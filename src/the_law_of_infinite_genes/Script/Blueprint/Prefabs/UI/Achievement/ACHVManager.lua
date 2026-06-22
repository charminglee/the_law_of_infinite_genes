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
    PlayerPawnTitle = nil;

    -- ===== 静态配置（固定数据） =====
    Config = {
        -- 玩家头顶称号界面路径
        TitleClassPath = 'Asset/Blueprint/Prefabs/UI/Title.Title_C';
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
            -- 无伤击败头目怪次数
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
        -- 目前已佩戴称号数据
        EquippedTitleData = nil;
        -- 称号数据
        TitleData = {
            [0] = {
                {
                    -- 分类索引
                    Category = 0,
                    -- 索引
                    Index = 1,
                    -- 标题文本
                    NameText = '囊中羞涩',
                    -- 图标路径
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/WealthTitle_%d.WealthTitle_%d',
                    -- 收集效果文本
                    CollectEffects = '金币结算加成1%',
                    -- 佩戴效果文本
                    WearEffects = '金币结算加成2%',
                    -- 解锁状态，0为未解锁，1为已解锁，2为已佩戴
                    UnlockState = 0,
                    -- 解锁类型与值
                    UnlockType = {
                        [0] = {
                            -- Condition = ItemId.Coin_0,
                            Value = 10000,
                            Text = '- 达到金币10000'
                        }
                    }
                },
                {
                    Category = 0,
                    Index = 2,
                    NameText = '略有盈余',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/WealthTitle_%d.WealthTitle_%d',
                    CollectEffects = '金币结算加成3%',
                    WearEffects = '金币结算加成5%',
                    UnlockState = 0,
                    UnlockType = {
                        [0] = {
                            -- Condition = ItemId.Coin_0,
                            Value = 100000,
                            Text = '- 达到金币100000'
                        }
                    }
                },
                {
                    Category = 0,
                    Index = 3,
                    NameText = '小富即安',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/WealthTitle_%d.WealthTitle_%d',
                    CollectEffects = '金币结算加成5%',
                    WearEffects = '金币结算加成8%',
                    UnlockState = 0,
                    UnlockType = {
                        [0] = {
                            -- Condition = ItemId.Coin_0,
                            Value = 500000,
                            Text = '- 达到金币500000'
                        }
                    }
                },
                {
                    Category = 0,
                    Index = 4,
                    NameText = '盆满钵满',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/WealthTitle_%d.WealthTitle_%d',
                    CollectEffects = '金币结算加成7%',
                    WearEffects = '金币结算加成10%',
                    UnlockState = 0,
                    UnlockType = {
                        [0] = {
                            -- Condition = ItemId.Coin_0,
                            Value = 1000000,
                            Text = '- 达到金币1000000'
                        }
                    }
                },
                {
                    Category = 0,
                    Index = 5,
                    NameText = '腰缠万贯',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/WealthTitle_%d.WealthTitle_%d',
                    CollectEffects = '金币结算加成9%',
                    WearEffects = '金币结算加成12%',
                    UnlockState = 0,
                    UnlockType = {
                        [0] = {
                            -- Condition = ItemId.Coin_0,
                            Value = 5000000,
                            Text = '- 达到金币5000000'
                        }
                    }
                },
                {
                    Category = 0,
                    Index = 6,
                    NameText = '富甲一方',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/WealthTitle_%d.WealthTitle_%d',
                    CollectEffects = '金币结算加成11%',
                    WearEffects = '金币结算加成14%',
                    UnlockState = 0,
                    UnlockType = {
                        [0] = {
                            -- Condition = ItemId.Coin_0,
                            Value = 10000000,
                            Text = '- 达到金币10000000'
                        }
                    }
                },
                {
                    Category = 0,
                    Index = 7,
                    NameText = '富可敌国',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/WealthTitle_%d.WealthTitle_%d',
                    CollectEffects = '金币结算加成13%',
                    WearEffects = '金币结算加成17%',
                    UnlockState = 0,
                    UnlockType = {
                        [0] = {
                            -- Condition = ItemId.Coin_0,
                            Value = 100000000,
                            Text = '- 达到金币100000000'
                        }
                    }
                }
            },
            [1] = {
                {
                    Category = 1,
                    Index = 1,
                    NameText = '首当其充',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/TopUpTitle_%d.TopUpTitle_%d',
                    CollectEffects = '金币结算加成8%',
                    WearEffects = '金币结算加成12%',
                    UnlockState = 0,
                    UnlockType = {
                        [0] = {
                            -- Condition = ItemId.Coin_0,
                            Value = 1,
                            Text = '- 首次充值'
                        }
                    }
                },
                {
                    Category = 1,
                    Index = 2,
                    NameText = '千金一掷',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/TopUpTitle_%d.TopUpTitle_%d',
                    CollectEffects = '金币结算加成10%',
                    WearEffects = '金币结算加成14%',
                    UnlockState = 0,
                    UnlockType = {
                        [0] = {
                            -- Condition = ItemId.Coin_0,
                            Value = 689,
                            Text = '- 累积充值689起源币'
                        }
                    }
                },
                {
                    Category = 1,
                    Index = 3,
                    NameText = '财大气粗',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/TopUpTitle_%d.TopUpTitle_%d',
                    CollectEffects = '金币结算加成12%',
                    WearEffects = '金币结算加成16%',
                    UnlockState = 0,
                    UnlockType = {
                        [0] = {
                            -- Condition = ItemId.Coin_0,
                            Value = 1888,
                            Text = '- 累积充值1888起源币'
                        }
                    }
                },
                {
                    Category = 1,
                    Index = 4,
                    NameText = '不差钱',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/TopUpTitle_%d.TopUpTitle_%d',
                    CollectEffects = '金币结算加成14%',
                    WearEffects = '金币结算加成18%',
                    UnlockState = 0,
                    UnlockType = {
                        [0] = {
                            -- Condition = ItemId.Coin_0,
                            Value = 5888,
                            Text = '- 累积充值5888起源币'
                        }
                    }
                },
                {
                    Category = 1,
                    Index = 5,
                    NameText = '马上有钱',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/TopUpTitle_%d.TopUpTitle_%d',
                    CollectEffects = '金币结算加成16%',
                    WearEffects = '金币结算加成20%',
                    UnlockState = 0,
                    UnlockType = {
                        [0] = {
                            -- Condition = ItemId.Coin_0,
                            Value = 8888,
                            Text = '- 累积充值8888起源币'
                        }
                    }
                },
                {
                    Category = 1,
                    Index = 6,
                    NameText = '钱能通神',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/TopUpTitle_%d.TopUpTitle_%d',
                    CollectEffects = '金币结算加成18%',
                    WearEffects = '金币结算加成25%',
                    UnlockState = 0,
                    UnlockType = {
                        [0] = {
                            -- Condition = ItemId.Coin_0,
                            Value = 16888,
                            Text = '- 累积充值16888起源币'
                        }
                    }
                }
            },
            [2] = {
                {
                    Category = 2,
                    Index = 1,
                    NameText = '尸墟巡猎者',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/SeasonTitle_%d.SeasonTitle_%d',
                    CollectEffects = '',
                    WearEffects = '对普通僵尸伤害 +5%',
                    UnlockState = 0,
                    UnlockType = {
                        [0] = {
                            -- Condition = Statistics.BossKillCount,
                            Value = 10,
                            Text = '- 赛季等级达到10级'
                        },
                        [1] = {
                            -- Condition = Statistics.NormalMonsterKillCount,
                            Value = 500,
                            Text = '- 累计击杀普通僵尸 500 只'
                        }
                    }
                },
                {
                    Category = 2,
                    Index = 2,
                    NameText = '腐潮肃清者',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/SeasonTitle_%d.SeasonTitle_%d',
                    CollectEffects = '',
                    WearEffects = '对精英僵尸伤害 +5%',
                    UnlockState = 0,
                    UnlockType = {
                        [0] = {
                            -- Condition = Statistics.BossKillCount,
                            Value = 20,
                            Text = '- 赛季等级达到20级'
                        },
                        [1] = {
                            -- Condition = Statistics.EliteMonsterKillCount,
                            Value = 150,
                            Text = '- 累计击杀精英怪 150 只'
                        }
                    }
                },
                {
                    Category = 2,
                    Index = 3,
                    NameText = '无殇镇疫使',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/SeasonTitle_%d.SeasonTitle_%d',
                    CollectEffects = '',
                    WearEffects = '- 对普通僵尸伤害 +8%\n- 受到普通僵尸伤害 -3%',
                    UnlockState = 0,
                    UnlockType = {
                        [0] = {
                            -- Condition = Statistics.BossKillCount,
                            Value = 30,
                            Text = '- 赛季等级达到30级'
                        },
                        [1] = {
                            -- Condition = Statistics.NormalMonsterKillCountHealthAboveHalf,
                            Value = 100,
                            Text = '- 单局内击杀100普通僵尸，且全程生命值从未低于50%'
                        }
                    }
                },
                {
                    Category = 2,
                    Index = 4,
                    NameText = '荒城孤伐者',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/SeasonTitle_%d.SeasonTitle_%d',
                    CollectEffects = '',
                    WearEffects = '- 对精英僵尸伤害 +8%\n- 受到精英僵尸伤害 -3%',
                    UnlockState = 0,
                    UnlockType = {
                        [0] = {
                            -- Condition = Statistics.BossKillCount,
                            Value = 40,
                            Text = '- 赛季等级达到40级'
                        },
                        [1] = {
                            -- Condition = Statistics.EliteMonsterKillCountHealthAboveHalf,
                            Value = 30,
                            Text = '- 单局内击杀30只精英怪，且全程生命值从未低于50%'
                        }
                    }
                },
                {
                    Category = 2,
                    Index = 5,
                    NameText = '疫首诛灭者',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/SeasonTitle_%d.SeasonTitle_%d',
                    CollectEffects = '',
                    WearEffects = '- 全伤+10%\n- 伤害-5%\n- 暴击率+3%',
                    UnlockState = 0,
                    UnlockType = {
                        [0] = {
                            -- Condition = Statistics.BossKillCount,
                            Value = 50,
                            Text = '- 赛季等级达到50级'
                        },
                        [1] = {
                            -- Condition = Statistics.BossKillCount,
                            Value = 50,
                            Text = '- 累积击杀50次boss'
                        }
                    }
                },
                {
                    Category = 2,
                    Index = 6,
                    NameText = '万尸归墟尊',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/SeasonTitle_%d.SeasonTitle_%d',
                    CollectEffects = '',
                    WearEffects = '- 全伤+15%\n- 伤害-10%\n- 暴击率+5%\n- 第一次死亡时候无敌3秒，并且回复30%血量',
                    UnlockState = 0,
                    UnlockType = {
                        [0] = {
                            -- Condition = Statistics.BossKillCount,
                            Value = 100,
                            Text = '- 赛季等级达到100级'
                        },
                        [1] = {
                            -- Condition = Statistics.BossKillCount,
                            Value = 1,
                            Text = '- 无伤击败boss一次'
                        }
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

-- 当前选中称号实例
function ACHVManager:SelectedTitleObj()
    return self.TitleListUI.tabButtons[self.TitleListUI.selectedTabID]
end

-- 当前选中称号数据表
function ACHVManager:SelectedTitleData()
    return self.Config.TitleData[self.CategoryListUI.selectedTabID][self.TitleListUI.selectedTabID + 1]
end

-- 解锁称号
function ACHVManager:Unlock()
    -- 需解锁的条件
    return true
end

-- 佩戴称号
function ACHVManager:Equipped()
    if self.Config.EquippedTitleData then
        self.Config.TitleData[self.Config.EquippedTitleData.Category][self.Config.EquippedTitleData.Index].UnlockState = 1;
        self.TitleListUI.tabButtons[self.Config.EquippedTitleData.Index - 1]:Refresh();
        self:Unequipped();
    end
    self.Config.EquippedTitleData = self:SelectedTitleData();
    self.PlayerPawnTitle = UGCWidgetManagerSystem.AddObjectPositionUI(
        UGCGameSystem.GetLocalPlayerPawn(), 
        UGCGameSystem.GetUGCResourcesFullPath(self.Config.TitleClassPath),
        { X = 0, Y = 0, Z = 100 }, 
        true, 
        true, 
        false, 
        true
    );
    return true
end

-- 卸下称号
function ACHVManager:Unequipped()
    UGCWidgetManagerSystem.RemoveObjectPositionUI(UGCGameSystem.GetLocalPlayerPawn(), self.PlayerPawnTitle);
    self.Config.EquippedTitleData = nil;
    self.PlayerPawnTitle = nil;
    return true
end

return ACHVManager