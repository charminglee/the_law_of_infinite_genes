---@enum EAttribute
EAttribute = {
    -- ==========================================
    -- 1. 基础战斗属性（原版 0~10）
    -- ==========================================
    HealthMax = 0,                  -- 最大生命值
    BaseImpactDamageWrapper = 1,    -- 攻击力
    NormalMonsterDamageBoost = 2,   -- 普通怪物伤害加成
    EliteMonsterDamageBoost = 3,    -- 精锐怪物伤害加成
    BossDamageBoost = 4,            -- 首领怪物伤害加成
    CritChance = 5,                 -- 暴击率
    CritDamageBoost = 6,            -- 暴击伤害
    Defence = 7,                    -- 防御
    DefenseBoost = 8,               -- 防御加成
    HealthStealRatio = 9,           -- 吸血倍率
    CounterAttackRatio = 10,        -- 反弹伤害

    -- ==========================================
    -- 2. 近战 / 重击减免（腐甲防御者羁绊）
    -- ==========================================
    MeleeDamageReduction = 11,      -- 近战伤害减免
    HeavyAttackReduction = 12,      -- 重装感染者重击伤害减免

    -- ==========================================
    -- 3. 护盾机制（腐甲防御者羁绊）
    -- ==========================================
    ShieldOnHitProb = 13,           -- 受击时生成护盾的概率
    ShieldHPRatio = 14,             -- 护盾值（最大生命值百分比）
    ShieldDuration = 15,            -- 护盾持续秒数
    ShieldThickness = 16,           -- 护盾厚度（固定数值）
    ShieldDMGReduce = 17,           -- 护盾存在期间的额外减伤
    AutoShieldInterval = 18,        -- 自动生成护盾的间隔（秒）
    AutoShieldHPRatio = 19,         -- 自动护盾值（最大生命值百分比）

    -- ==========================================
    -- 4. 疫毒机制（疫毒反噬者羁绊）
    -- ==========================================
    PlagueTriggerProb = 20,         -- 疫毒触发概率
    PlagueDPS = 21,                 -- 疫毒持续伤害（每秒）
    PlagueSpreadTargets = 22,       -- 疫毒传染的额外目标数量
    PlagueRange = 23,               -- 疫毒作用范围（米）
    PlagueDuration = 24,            -- 疫毒持续时间延长（秒）
    PlagueEnemyATKReduce = 25,      -- 被疫毒感染的敌人攻击力降低
    ReflectRange = 26,              -- 反弹伤害作用范围（米）

    -- ==========================================
    -- 5. 速度 / 闪避（迅影突袭者羁绊）
    -- ==========================================
    AttackSpeed = 27,               -- 攻击速度
    MoveSpeed = 28,                 -- 移动速度
    ReloadSpeed = 29,               -- 换弹速度
    DodgeRate = 30,                 -- 闪避率

    -- ==========================================
    -- 6. 怪物特攻 / 穿透（畸变猎手羁绊）
    -- ==========================================
    RangedInfectedDamageBoost = 31, -- 对远程感染者伤害加成
    SwiftInfectedDamageBoost = 32,  -- 对迅捷感染者伤害加成
    RangedMonsterDamageBoost = 33,  -- 对远程怪物伤害加成
    AllMonsterDamageBoost = 34,     -- 对所有怪物伤害加成
    PenetrationDamage = 35,         -- 穿透伤害

    -- ==========================================
    -- 7. 暴击 / 特殊机制
    -- ==========================================
    CritIgnoreDefense = 36,         -- 暴击时无视目标防御
    ExtraCritDamage = 37,           -- 暴击时额外伤害（独立乘区）
    DoubleDamageProb = 38,          -- 攻击时造成双倍伤害的概率

    -- ==========================================
    -- 8. 连杀 / 闪避触发（迅影突袭者羁绊）
    -- ==========================================
    ChainKillDurationExtend = 39,   -- 连杀爆发效果延长（秒）
    DodgeNextCrit = 40,             -- 闪避后下一次攻击必定暴击（布尔标记，存 0/1）
    KillMoveSpeedBoost = 41,        -- 击杀敌人后移动速度加成
    KillMoveSpeedDuration = 42,     -- 击杀敌人后移动速度加成持续时间（秒）
}
