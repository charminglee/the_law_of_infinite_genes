-- 基因树系统界面管理器

GeneManager = GeneManager or
{
    -- ===== 运行时变量 =====
    PlayerId = nil;
    MainUI = nil;
    Content = nil;
    SkillBranch = nil;
    SkillNode = nil;
    InfoBar = nil;

    -- ===== 静态配置（固定数据） =====
    Config = {
        -- 动画时长
        AnimDur = {
            In = 0.2,
            Out = 0.2,
            Set = 0.5
        };
        -- 称号类型文本
        BranchText = {
            [0] = "狂袭之径",
            [1] = "铁壁之径",
            [2] = "渴血之径",
            [3] = "枪火之径",
            [4] = "疾步之径"
        };
        -- 技能数据
        SkillData = {
            [0] = {
                {
                    -- 技能ID
                    Id = 0,
                    -- 分支索引
                    BranchId = 0,
                    -- 技能文本
                    SkillText = '尸骸破击',
                    -- 效果文本
                    EffectText = {
                        '攻击伤害      +0.01',
                        '攻击伤害      +0.01',
                        '攻击伤害      +0.01',
                        '攻击伤害      +0.01',
                        '攻击伤害      +0.01',
                        '攻击伤害      +0.01',
                        '攻击伤害      +0.01',
                        '攻击伤害      +0.01',
                        '攻击伤害      +0.01',
                        '攻击伤害      +0.01'
                    },
                    -- 条件文本
                    ConditionText = {
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000'
                    },
                    -- 图标路径
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/UI/GeneTree/Branch_0/Skill_0.Skill_0',
                    -- 是否解锁
                    Unlocked = false,
                    -- 等级
                    Lv = 0
                },
                {
                    Id = 1,
                    BranchId = 0,
                    SkillText = '致命洞悉',
                    EffectText = {
                        '暴击率       +0.03',
                        '暴击率       +0.03',
                        '暴击率       +0.03',
                        '暴击率       +0.03',
                        '暴击率       +0.08'
                    },
                    ConditionText = {
                        '升级所需金币      2500',
                        '升级所需金币      2500',
                        '升级所需金币      2500',
                        '升级所需金币      2500',
                        '升级所需金币      2500'
                    },
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/UI/GeneTree/Branch_0/Skill_1.Skill_1',
                    Unlocked = false,
                    Lv = 0
                },
                {
                    Id = 2,
                    BranchId = 0,
                    SkillText = '残灭重击',
                    EffectText = {
                        '暴击伤害      +0.05',
                        '暴击伤害      +0.05',
                        '暴击伤害      +0.05',
                        '暴击伤害      +0.05',
                        '暴击伤害      +0.10'
                    },
                    ConditionText = {
                        '升级所需金币      6000',
                        '升级所需金币      6000',
                        '升级所需金币      6000',
                        '升级所需金币      6000',
                        '升级所需金币      6000'
                    },
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/UI/GeneTree/Branch_0/Skill_2.Skill_2',
                    Unlocked = false,
                    Lv = 0
                }
            },
            [1] = {
                {
                    Id = 3,
                    BranchId = 1,
                    SkillText = '体魄强化',
                    EffectText = {
                        '最大生命值     +0.01',
                        '最大生命值     +0.01',
                        '最大生命值     +0.01',
                        '最大生命值     +0.01',
                        '最大生命值     +0.01',
                        '最大生命值     +0.01',
                        '最大生命值     +0.01',
                        '最大生命值     +0.01',
                        '最大生命值     +0.01',
                        '最大生命值     +0.01'
                    },
                    ConditionText = {
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000'
                    },
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/UI/GeneTree/Branch_1/Skill_0.Skill_0',
                    Unlocked = false,
                    Lv = 0
                },
                {
                    Id = 4,
                    BranchId = 1,
                    SkillText = '坚盾格挡',
                    EffectText = {
                        '格挡率       +0.03',
                        '格挡率       +0.03',
                        '格挡率       +0.03',
                        '格挡率       +0.03',
                        '格挡率       +0.08'
                    },
                    ConditionText = {
                        '升级所需金币      2500',
                        '升级所需金币      2500',
                        '升级所需金币      2500',
                        '升级所需金币      2500',
                        '升级所需金币      2500'
                    },
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/UI/GeneTree/Branch_1/Skill_1.Skill_1',
                    Unlocked = false,
                    Lv = 0
                },
                {
                    Id = 5,
                    BranchId = 1,
                    SkillText = '铁壁守护',
                    EffectText = {
                        '减伤        +0.03',
                        '减伤        +0.03',
                        '减伤        +0.03',
                        '减伤        +0.03',
                        '减伤        +0.08'
                    },
                    ConditionText = {
                        '升级所需金币      6000',
                        '升级所需金币      6000',
                        '升级所需金币      6000',
                        '升级所需金币      6000',
                        '升级所需金币      6000'
                    },
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/UI/GeneTree/Branch_1/Skill_2.Skill_2',
                    Unlocked = false,
                    Lv = 0
                }
            },
            [2] = {
                {
                    Id = 6,
                    BranchId = 2,
                    SkillText = '尸血回生',
                    EffectText = {
                        '回复生命值/6s  +0.003',
                        '回复生命值/6s  +0.003',
                        '回复生命值/6s  +0.003',
                        '回复生命值/6s  +0.003',
                        '回复生命值/6s  +0.003',
                        '回复生命值/6s  +0.003',
                        '回复生命值/6s  +0.003',
                        '回复生命值/6s  +0.003',
                        '回复生命值/6s  +0.003',
                        '回复生命值/6s  +0.003'
                    },
                    ConditionText = {
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000'
                    },
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/UI/GeneTree/Branch_2/Skill_0.Skill_0',
                    Unlocked = false,
                    Lv = 0
                },
                {
                    Id = 7,
                    BranchId = 2,
                    SkillText = '速效施救',
                    EffectText = {
                        '药品效率      +0.03',
                        '药品效率      +0.03',
                        '药品效率      +0.03',
                        '药品效率      +0.03',
                        '药品效率      +0.08'
                    },
                    ConditionText = {
                        '升级所需金币      2500',
                        '升级所需金币      2500',
                        '升级所需金币      2500',
                        '升级所需金币      2500',
                        '升级所需金币      2500'
                    },
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/UI/GeneTree/Branch_2/Skill_1.Skill_1',
                    Unlocked = false,
                    Lv = 0
                },
                {
                    Id = 8,
                    BranchId = 2,
                    SkillText = '血噬觉醒',
                    EffectText = {
                        '枪械吸血      +0.003',
                        '枪械吸血      +0.003',
                        '枪械吸血      +0.003',
                        '枪械吸血      +0.003',
                        '枪械吸血      +0.008'
                    },
                    ConditionText = {
                        '升级所需金币      6000',
                        '升级所需金币      6000',
                        '升级所需金币      6000',
                        '升级所需金币      6000',
                        '升级所需金币      6000'
                    },
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/UI/GeneTree/Branch_2/Skill_2.Skill_2',
                    Unlocked = false,
                    Lv = 0
                }
            },
            [3] = {
                {
                    Id = 9,
                    BranchId = 3,
                    SkillText = '扩容精通',
                    EffectText = {
                        '弹夹容量      +0.05',
                        '弹夹容量      +0.05',
                        '弹夹容量      +0.05',
                        '弹夹容量      +0.05',
                        '弹夹容量      +0.05',
                        '弹夹容量      +0.05',
                        '弹夹容量      +0.05',
                        '弹夹容量      +0.05',
                        '弹夹容量      +0.05',
                        '弹夹容量      +0.05'
                    },
                    ConditionText = {
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000'
                    },
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/UI/GeneTree/Branch_3/Skill_0.Skill_0',
                    Unlocked = false,
                    Lv = 0
                },
                {
                    Id = 10,
                    BranchId = 3,
                    SkillText = '极速连射',
                    EffectText = {
                        '射击速度      +0.03',
                        '射击速度      +0.03',
                        '射击速度      +0.03',
                        '射击速度      +0.03',
                        '射击速度      +0.08'
                    },
                    ConditionText = {
                        '升级所需金币      2500',
                        '升级所需金币      2500',
                        '升级所需金币      2500',
                        '升级所需金币      2500',
                        '升级所需金币      2500'
                    },
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/UI/GeneTree/Branch_3/Skill_1.Skill_1',
                    Unlocked = false,
                    Lv = 0
                },
                {
                    Id = 11,
                    BranchId = 3,
                    SkillText = '战术换弹',
                    EffectText = {
                        '换弹速度      +0.05',
                        '换弹速度      +0.05',
                        '换弹速度      +0.05',
                        '换弹速度      +0.05',
                        '换弹速度      +0.10'
                    },
                    ConditionText = {
                        '升级所需金币      6000',
                        '升级所需金币      6000',
                        '升级所需金币      6000',
                        '升级所需金币      6000',
                        '升级所需金币      6000'
                    },
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/UI/GeneTree/Branch_3/Skill_2.Skill_2',
                    Unlocked = false,
                    Lv = 0
                }
            },
            [4] = {
                {
                    Id = 12,
                    BranchId = 4,
                    SkillText = '疾风步法',
                    EffectText = {
                        '移动速度      +0.02',
                        '移动速度      +0.02',
                        '移动速度      +0.02',
                        '移动速度      +0.02',
                        '移动速度      +0.02',
                        '移动速度      +0.02',
                        '移动速度      +0.02',
                        '移动速度      +0.02',
                        '移动速度      +0.02',
                        '移动速度      +0.02'
                    },
                    ConditionText = {
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000',
                        '升级所需金币      1000'
                    },
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/UI/GeneTree/Branch_4/Skill_0.Skill_0',
                    Unlocked = false,
                    Lv = 0
                },
                {
                    Id = 13,
                    BranchId = 4,
                    SkillText = '幻影闪避',
                    EffectText = {
                        '闪避率       +0.03',
                        '闪避率       +0.03',
                        '闪避率       +0.03',
                        '闪避率       +0.03',
                        '闪避率       +0.08'
                    },
                    ConditionText = {
                        '升级所需金币      2500',
                        '升级所需金币      2500',
                        '升级所需金币      2500',
                        '升级所需金币      2500',
                        '升级所需金币      2500'
                    },
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/UI/GeneTree/Branch_4/Skill_1.Skill_1',
                    Unlocked = false,
                    Lv = 0
                },
                {
                    Id = 14,
                    BranchId = 4,
                    SkillText = '不屈意志',
                    EffectText = {
                        '减免负面效果时间  +0.03',
                        '减免负面效果时间  +0.03',
                        '减免负面效果时间  +0.03',
                        '减免负面效果时间  +0.03',
                        '减免负面效果时间  +0.08'
                    },
                    ConditionText = {
                        '升级所需金币      6000',
                        '升级所需金币      6000',
                        '升级所需金币      6000',
                        '升级所需金币      6000',
                        '升级所需金币      6000'
                    },
                    IconPath = '/the_law_of_infinite_genes/Asset/Texture/UI/GeneTree/Branch_4/Skill_2.Skill_2',
                    Unlocked = false,
                    Lv = 0
                }
            }
        }
    }
}

function GeneManager:RegisterComponentClass(CompClass)

    if CompClass ~= nil then
        self.ComponentClass = CompClass;
    end
end

function GeneManager:RegisterMainUI(MainUI)
    
    if self.MainUI == nil then
        self.MainUI = MainUI;
    end
end

function GeneManager:UnregisterMainUI()
    self.MainUI = nil;
end

function GeneManager:OpenMainUI()
    if self.MainUI == nil then
        return;
    end
    self.MainUI:Open();
end

function GeneManager:CloseMainUI()
    if self.MainUI == nil then
        return;
    end
    self.MainUI:Close();
end

return GeneManager