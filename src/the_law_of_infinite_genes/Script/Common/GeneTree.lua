local GeneTree = {}


-- 称号类型文本
GeneTree.BranchText = {
    [0] = "狂袭之径",
    [1] = "铁壁之径",
    [2] = "渴血之径",
    [3] = "枪火之径",
    [4] = "疾步之径"
}


---@type table<number, GeneNodeDetail[]>
GeneTree.SkillData = {
    [0] = {
        {
            -- 技能ID
            Id = 0,
            -- 分支索引
            BranchId = 0,
            -- 技能文本
            SkillText = '尸骸破击',
            -- 最高等级
            LvHighest = 10,
            -- 等级文本
            LvText = '最高等级10级',
            -- 效果文本
            EffectText = {
                '暂无',
                '攻击伤害累计增加 0.01',
                '攻击伤害累计增加 0.02',
                '攻击伤害累计增加 0.03',
                '攻击伤害累计增加 0.04',
                '攻击伤害累计增加 0.05',
                '攻击伤害累计增加 0.06',
                '攻击伤害累计增加 0.07',
                '攻击伤害累计增加 0.08',
                '攻击伤害累计增加 0.09',
                '攻击伤害累计增加 0.10',
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
            LvHighest = 5,
            LvText = '最高等级5级',
            EffectText = {
                '暂无',
                '暴击率累计增加 0.03',
                '暴击率累计增加 0.06',
                '暴击率累计增加 0.09',
                '暴击率累计增加 0.12',
                '暴击率累计增加 0.20'
            },
            IconPath = '/the_law_of_infinite_genes/Asset/Texture/UI/GeneTree/Branch_0/Skill_1.Skill_1',
            Unlocked = false,
            Lv = 0
        },
        {
            Id = 2,
            BranchId = 0,
            SkillText = '残灭重击',
            LvHighest = 5,
            LvText = '最高等级5级',
            EffectText = {
                '暂无',
                '暴击伤害累计增加 0.05',
                '暴击伤害累计增加 0.10',
                '暴击伤害累计增加 0.15',
                '暴击伤害累计增加 0.20',
                '暴击伤害累计增加 0.30'
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
            LvHighest = 10,
            LvText = '最高等级10级',
            EffectText = {
                '暂无',
                '最大生命值累计增加 0.01',
                '最大生命值累计增加 0.02',
                '最大生命值累计增加 0.03',
                '最大生命值累计增加 0.04',
                '最大生命值累计增加 0.05',
                '最大生命值累计增加 0.06',
                '最大生命值累计增加 0.07',
                '最大生命值累计增加 0.08',
                '最大生命值累计增加 0.09',
                '最大生命值累计增加 0.10'
            },
            IconPath = '/the_law_of_infinite_genes/Asset/Texture/UI/GeneTree/Branch_1/Skill_0.Skill_0',
            Unlocked = false,
            Lv = 0
        },
        {
            Id = 4,
            BranchId = 1,
            SkillText = '坚盾格挡',
            LvHighest = 5,
            LvText = '最高等级5级',
            EffectText = {
                '暂无',
                '格挡率累计增加 0.03',
                '格挡率累计增加 0.06',
                '格挡率累计增加 0.09',
                '格挡率累计增加 0.12',
                '格挡率累计增加 0.20'
            },
            IconPath = '/the_law_of_infinite_genes/Asset/Texture/UI/GeneTree/Branch_1/Skill_1.Skill_1',
            Unlocked = false,
            Lv = 0
        },
        {
            Id = 5,
            BranchId = 1,
            SkillText = '铁壁守护',
            LvHighest = 5,
            LvText = '最高等级5级',
            EffectText = {
                '暂无',
                '减伤累计增加 0.03',
                '减伤累计增加 0.06',
                '减伤累计增加 0.09',
                '减伤累计增加 0.12',
                '减伤累计增加 0.20'
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
            LvHighest = 10,
            LvText = '最高等级10级',
            EffectText = {
                '暂无',
                '每6秒回复生命值累计增加 0.003',
                '每6秒回复生命值累计增加 0.006',
                '每6秒回复生命值累计增加 0.009',
                '每6秒回复生命值累计增加 0.012',
                '每6秒回复生命值累计增加 0.015',
                '每6秒回复生命值累计增加 0.018',
                '每6秒回复生命值累计增加 0.021',
                '每6秒回复生命值累计增加 0.024',
                '每6秒回复生命值累计增加 0.027',
                '每6秒回复生命值累计增加 0.030'
            },
            IconPath = '/the_law_of_infinite_genes/Asset/Texture/UI/GeneTree/Branch_2/Skill_0.Skill_0',
            Unlocked = false,
            Lv = 0
        },
        {
            Id = 7,
            BranchId = 2,
            SkillText = '速效施救',
            LvHighest = 5,
            LvText = '最高等级5级',
            EffectText = {
                '暂无',
                '药品效率累计增加 0.03',
                '药品效率累计增加 0.06',
                '药品效率累计增加 0.09',
                '药品效率累计增加 0.12',
                '药品效率累计增加 0.20'
            },
            IconPath = '/the_law_of_infinite_genes/Asset/Texture/UI/GeneTree/Branch_2/Skill_1.Skill_1',
            Unlocked = false,
            Lv = 0
        },
        {
            Id = 8,
            BranchId = 2,
            SkillText = '血噬觉醒',
            LvHighest = 5,
            LvText = '最高等级5级',
            EffectText = {
                '暂无',
                '枪械吸血累计增加 0.003',
                '枪械吸血累计增加 0.006',
                '枪械吸血累计增加 0.009',
                '枪械吸血累计增加 0.012',
                '枪械吸血累计增加 0.020'
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
            LvHighest = 10,
            LvText = '最高等级10级',
            EffectText = {
                '暂无',
                '弹夹容量累计增加 0.05',
                '弹夹容量累计增加 0.10',
                '弹夹容量累计增加 0.15',
                '弹夹容量累计增加 0.20',
                '弹夹容量累计增加 0.25',
                '弹夹容量累计增加 0.30',
                '弹夹容量累计增加 0.35',
                '弹夹容量累计增加 0.40',
                '弹夹容量累计增加 0.45',
                '弹夹容量累计增加 0.50'
            },
            IconPath = '/the_law_of_infinite_genes/Asset/Texture/UI/GeneTree/Branch_3/Skill_0.Skill_0',
            Unlocked = false,
            Lv = 0
        },
        {
            Id = 10,
            BranchId = 3,
            SkillText = '极速连射',
            LvHighest = 5,
            LvText = '最高等级5级',
            EffectText = {
                '暂无',
                '射击速度累计增加 0.03',
                '射击速度累计增加 0.06',
                '射击速度累计增加 0.09',
                '射击速度累计增加 0.12',
                '射击速度累计增加 0.20'
            },
            IconPath = '/the_law_of_infinite_genes/Asset/Texture/UI/GeneTree/Branch_3/Skill_1.Skill_1',
            Unlocked = false,
            Lv = 0
        },
        {
            Id = 11,
            BranchId = 3,
            SkillText = '战术换弹',
            LvHighest = 5,
            LvText = '最高等级5级',
            EffectText = {
                '暂无',
                '换弹速度累计增加 0.05',
                '换弹速度累计增加 0.10',
                '换弹速度累计增加 0.15',
                '换弹速度累计增加 0.20',
                '换弹速度累计增加 0.30'
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
            LvHighest = 10,
            LvText = '最高等级10级',
            EffectText = {
                '暂无',
                '移动速度累计增加 0.02',
                '移动速度累计增加 0.04',
                '移动速度累计增加 0.06',
                '移动速度累计增加 0.08',
                '移动速度累计增加 0.10',
                '移动速度累计增加 0.12',
                '移动速度累计增加 0.14',
                '移动速度累计增加 0.16',
                '移动速度累计增加 0.18',
                '移动速度累计增加 0.20'
            },
            IconPath = '/the_law_of_infinite_genes/Asset/Texture/UI/GeneTree/Branch_4/Skill_0.Skill_0',
            Unlocked = false,
            Lv = 0
        },
        {
            Id = 13,
            BranchId = 4,
            SkillText = '幻影闪避',
            LvHighest = 5,
            LvText = '最高等级5级',
            EffectText = {
                '暂无',
                '闪避率累计增加 0.03',
                '闪避率累计增加 0.06',
                '闪避率累计增加 0.09',
                '闪避率累计增加 0.12',
                '闪避率累计增加 0.20'
            },
            IconPath = '/the_law_of_infinite_genes/Asset/Texture/UI/GeneTree/Branch_4/Skill_1.Skill_1',
            Unlocked = false,
            Lv = 0
        },
        {
            Id = 14,
            BranchId = 4,
            SkillText = '不屈意志',
            LvHighest = 5,
            LvText = '最高等级5级',
            EffectText = {
                '暂无',
                '减免负面效果时间累计增加 0.03',
                '减免负面效果时间累计增加 0.06',
                '减免负面效果时间累计增加 0.09',
                '减免负面效果时间累计增加 0.12',
                '减免负面效果时间累计增加 0.20'
            },
            IconPath = '/the_law_of_infinite_genes/Asset/Texture/UI/GeneTree/Branch_4/Skill_2.Skill_2',
            Unlocked = false,
            Lv = 0
        }
    }
}


---@type table<number, GeneNode>
GeneTree.NodeIdMap = {}
for _, branch in pairs(GeneTree.SkillData) do
    for __, node in pairs(branch) do
        GeneTree.NodeIdMap[node.Id] = node
    end
end


return GeneTree