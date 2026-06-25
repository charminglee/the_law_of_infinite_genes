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
    CacheEquippedTitle = nil;
    TitleTopUIByPlayerUID = {};


    -- ===== 静态配置（固定数据） =====
    Config = {
        -- 玩家头顶称号界面路径
        TitleClassPath = 'Asset/Blueprint/Prefabs/UI/Title.Title_C';
        -- 动画时长
        AnimDur = {
            In = 0.2,
            Out = 0.2,
            Set = 0.5
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
        -- 称号状态文本
        TitleStateText = {
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
                    -- 称号ID（枚举排列在ue_enum_custom.Title）
                    Id = 0,
                    -- 分类索引
                    Category = 0,
                    -- 标题文本
                    NameText = '囊中羞涩',
                    -- 图标路径
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/WealthTitle_0.WealthTitle_0',
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
                    Id = 1,
                    Category = 0,
                    NameText = '略有盈余',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/WealthTitle_1.WealthTitle_1',
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
                    Id = 2,
                    Category = 0,
                    NameText = '小富即安',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/WealthTitle_2.WealthTitle_2',
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
                    Id = 3,
                    Category = 0,
                    NameText = '盆满钵满',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/WealthTitle_3.WealthTitle_3',
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
                    Id = 4,
                    Category = 0,
                    NameText = '腰缠万贯',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/WealthTitle_4.WealthTitle_4',
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
                    Id = 5,
                    Category = 0,
                    NameText = '富甲一方',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/WealthTitle_5.WealthTitle_5',
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
                    Id = 6,
                    Category = 0,
                    NameText = '富可敌国',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/WealthTitle_6.WealthTitle_6',
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
                    Id = 7,
                    Category = 1,
                    NameText = '首当其充',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/TopUpTitle_0.TopUpTitle_0',
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
                    Id = 8,
                    Category = 1,
                    NameText = '千金一掷',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/TopUpTitle_1.TopUpTitle_1',
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
                    Id = 9,
                    Category = 1,
                    NameText = '财大气粗',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/TopUpTitle_2.TopUpTitle_2',
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
                    Id = 10,
                    Category = 1,
                    NameText = '不差钱',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/TopUpTitle_3.TopUpTitle_3',
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
                    Id = 11,
                    Category = 1,
                    NameText = '马上有钱',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/TopUpTitle_4.TopUpTitle_4',
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
                    Id = 12,
                    Category = 1,
                    NameText = '钱能通神',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/TopUpTitle_5.TopUpTitle_5',
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
                    Id = 13,
                    Category = 2,
                    NameText = '尸墟巡猎者',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/SeasonTitle_0.SeasonTitle_0',
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
                    Id = 14,
                    Category = 2,
                    NameText = '腐潮肃清者',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/SeasonTitle_1.SeasonTitle_1',
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
                    Id = 15,
                    Category = 2,
                    NameText = '无殇镇疫使',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/SeasonTitle_2.SeasonTitle_2',
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
                    Id = 16,
                    Category = 2,
                    NameText = '荒城孤伐者',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/SeasonTitle_3.SeasonTitle_3',
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
                    Id = 17,
                    Category = 2,
                    NameText = '疫首诛灭者',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/SeasonTitle_4.SeasonTitle_4',
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
                    Id = 18,
                    Category = 2,
                    NameText = '万尸归墟尊',
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/Titles/SeasonTitle_5.SeasonTitle_5',
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

-- 当前选中称号状态
function ACHVManager:GetSelectedTitleState()
    return LocalPlayerState.PlayerDataManager:GetTitleState(self:SelectedTitleData().Id)
end

--【客户端】解锁称号
function ACHVManager:Unlock()
    -- 需解锁的条件
    UnrealNetwork.CallUnrealRPC(
        LocalPlayerController, 
        self.ComponentClass, 
        self.ComponentClass._Event.ServerRPC.UnlockTitle, 
        LocalPlayerController.PlayerUID,
        self:SelectedTitleData().Id
    );
    return true
end

--【客户端】佩戴称号
function ACHVManager:Equipped()
    local equipped = LocalPlayerState.PlayerDataManager:GetEquippedTitle();
    if equipped then
        self.TitleListUI.tabButtons[equipped]:ToggleState();
    end
    UnrealNetwork.CallUnrealRPC(
        LocalPlayerController, 
        self.ComponentClass, 
        self.ComponentClass._Event.ServerRPC.EquippedTitle, 
        LocalPlayerController.PlayerUID,
        self:SelectedTitleData().Id
    );
    return true
end

--【客户端】卸下称号
function ACHVManager:Unequipped()
    UnrealNetwork.CallUnrealRPC(
        LocalPlayerController, 
        self.ComponentClass, 
        self.ComponentClass._Event.ServerRPC.UnequippedTitle, 
        LocalPlayerController.PlayerUID,
        self:SelectedTitleData().Id
    );    
    return true
end

return ACHVManager