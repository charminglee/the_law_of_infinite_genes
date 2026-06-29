---@class PlayerAttrManager_C:BaseManager_C
--Edit Below--
local PlayerAttrManager = {
    _base = {},        -- 计算后的基础值 { [attrType] = number }
    _bonus = {},       -- 命名加成源 { [来源名] = { [attrType] = number } }
    _level = 1,        -- 当前等级
    _isReady = false,  -- 是否已完成初始化
}


-- 默认配置首次初始化时填充（避免文件加载顺序依赖全局枚举，与 PlayerDataManager 同思路：枚举仅在函数调用时解析）
local DEFAULT_BASE = nil
local DEFAULT_GROWTH = nil
local ATTRIBUTE_TO_GAS = nil  -- 卡牌属性(Attribute枚举) → GAS属性类型 的映射，由 InitDefaults 构建

local INITIAL_LEVEL = 1
local INIT_DELAY    = 1.0  -- 延迟初始化秒数：等待 Pawn 的属性组件与 PlayerState 绑定就绪（与引擎 UGCAttributeGroup 模板一致）


---构建默认基础值、成长表与卡牌属性映射（仅执行一次）。
local function InitDefaults()
    if DEFAULT_BASE ~= nil then
        return
    end
    -- 1 级初始基础值（后续可外移到 Config）
    DEFAULT_BASE = {
        [UGCCustomGameAttributeType.UGCAttributeGroup_Character_AttackPower]        = 10,
        [UGCCustomGameAttributeType.UGCAttributeGroup_Character_Defence]            = 0,
        [UGCCustomGameAttributeType.UGCAttributeGroup_Character_CritChance]         = 0.05,
        [UGCCustomGameAttributeType.UGCAttributeGroup_Character_CritDamageBoost]    = 0.5,
        [UGCCustomGameAttributeType.UGCAttributeGroup_Character_DamageBoost]        = 0,
        [UGCCustomGameAttributeType.UGCAttributeGroup_Character_DamageDecreace]     = 0,
        [UGCCustomGameAttributeType.UGCAttributeGroup_Character_DamageDecreacePct]  = 0,
        [UGCCustomGameAttributeType.UGCAttributeGroup_Character_BreakDefenceRatio]  = 0,
        [UGCCustomGameAttributeType.UGCAttributeGroup_Character_HealthStealRatio]   = 0,
        [UGCCustomGameAttributeType.UGCAttributeGroup_Character_CounterAttackRatio] = 0,
        [UGCNativeGameAttributeType.Character_HealthMax]                            = 100,
    }
    -- 每升一级的增量
    DEFAULT_GROWTH = {
        [UGCCustomGameAttributeType.UGCAttributeGroup_Character_AttackPower] = 2,
        [UGCCustomGameAttributeType.UGCAttributeGroup_Character_Defence]     = 1,
        [UGCNativeGameAttributeType.Character_HealthMax] = 10,
    }
    -- 卡牌属性（Script.Common.Card 的 Attribute 枚举）→ GAS 属性类型 映射。
    -- 仅映射 GAS 已定义的属性；以下卡牌属性无对应 GAS 属性，聚合时跳过：
    --   HealthMaxBoost（百分比生命，需单独乘算基生命）、EpidemicToxin*（疫毒机制）、
    --   UGCGeneralMoveSpeedScale / BurstShootCDWrapper / ReloadTime（移速/武器）、
    --   SeckillRatio / IgnoreHarmRatio / DodgeRatio / InfiniteAmmo / Recoilless（特殊机制）。
    ATTRIBUTE_TO_GAS = {
        [Attribute.AttackPowerBoost]         = UGCCustomGameAttributeType.UGCAttributeGroup_Character_AttackPowerBoost,
        [Attribute.NormalMonsterDamageBoost] = UGCCustomGameAttributeType.UGCAttributeGroup_Character_NormalMonsterDamageBoost,
        [Attribute.EliteMonsterDamageBoost]  = UGCCustomGameAttributeType.UGCAttributeGroup_Character_EliteMonsterDamageBoost,
        [Attribute.BossDamageBoost]          = UGCCustomGameAttributeType.UGCAttributeGroup_Character_BossDamageBoost,
        [Attribute.CritChance]               = UGCCustomGameAttributeType.UGCAttributeGroup_Character_CritChance,
        [Attribute.CritDamageBoost]          = UGCCustomGameAttributeType.UGCAttributeGroup_Character_CritDamageBoost,
        [Attribute.DefenseBoost]             = UGCCustomGameAttributeType.UGCAttributeGroup_Character_DefenseBoost,
        [Attribute.HealthStealRatio]         = UGCCustomGameAttributeType.UGCAttributeGroup_Character_HealthStealRatio,
        [Attribute.DamageDecreacePct]        = UGCCustomGameAttributeType.UGCAttributeGroup_Character_DamageDecreacePct,
        [Attribute.BreakDefenceRatio]        = UGCCustomGameAttributeType.UGCAttributeGroup_Character_BreakDefenceRatio,
    }
end


function PlayerAttrManager:GetReplicatedProperties()
    return {
        {"_base", "Lazy"},
        {"_level", "Lazy"},
    }
end


function PlayerAttrManager:OnRep__base()
end


function PlayerAttrManager:OnRep__level()
end


function PlayerAttrManager:ReceiveBeginPlay()
    PlayerAttrManager.SuperClass.ReceiveBeginPlay(self)
    self:_Init()
end


--===========================  内部  ===========================--


---初始化：仅服务端，延迟等待 Pawn 的属性组件与 PlayerState 绑定就绪后计算并推送基础属性。
function PlayerAttrManager:_Init()
    if not self:HasAuthority() then
        return
    end
    UGCTimerUtility.CreateUETimer(
        function()
            if self._isReady then
                return
            end
            InitDefaults()
            self._level = INITIAL_LEVEL
            self:_ComputeBase()
            self:_Refresh()
            self._isReady = true
            self:Sync()
        end, 
        INIT_DELAY, false
    )
end


---根据默认表与等级成长，重新计算全部基础值。
---注意：会清掉手动 SetBase/AddBase 的改动，仅在初始化与 Reset 时调用。
function PlayerAttrManager:_ComputeBase()
    self._base = {}
    for attr, baseVal in pairs(DEFAULT_BASE) do
        self._base[attr] = baseVal + (DEFAULT_GROWTH[attr] or 0) * (self._level - 1)
    end
end


---汇总指定属性在所有命名加成源中的加成总和。
---@param attrType UGCNativeGameAttributeType|UGCCustomGameAttributeType 属性枚举
---@return number 加成总和
function PlayerAttrManager:_BonusTotal(attrType)
    local total = 0
    for _, bonusTable in pairs(self._bonus) do
        total = total + (bonusTable[attrType] or 0)
    end
    return total
end


---把指定属性的基础值+加成推送到 GAS（self.owner 即 Pawn 本身）。
---@param attrType UGCNativeGameAttributeType|UGCCustomGameAttributeType 属性枚举
function PlayerAttrManager:_Push(attrType)
    local value = (self._base[attrType] or 0) + self:_BonusTotal(attrType)
    UGCAttributeSystem.SetGameAttributeValue(self.owner, attrType, value)
end


---重算并推送全部属性。
function PlayerAttrManager:_Refresh()
    for attrType in pairs(self._base) do
        self:_Push(attrType)
    end
end


---汇总玩家已拥有卡牌提供的加成，累加进 out 表（按 GAS 属性聚合）。
---卡牌配置见 Script.Common.Card：Cards[id].bonus[tier] = { {property=Attribute.X, value=n}, ... }。
---当前每张卡牌取 bonus[1]（一阶）；待卡牌升阶/等级数据落地后，改为按实际阶数取值。
---仅映射到 GAS 已定义的属性（见 ATTRIBUTE_TO_GAS），其余卡牌属性跳过。
---@param out table 待累加的加成表 {[GAS属性类型]=number}
function PlayerAttrManager:_CalcCardBonus(out)
    local playerState = self.owner:GetPlayerState()
    local pdm = playerState and playerState.PlayerDataManager
    local owned = pdm and pdm:Get("card") or {}
    for cardId in pairs(owned) do
        local tier = Cards[cardId] and Cards[cardId].bonus and Cards[cardId].bonus[1]
        if tier then
            for _, entry in ipairs(tier) do
                local gasAttr = ATTRIBUTE_TO_GAS[entry.property]
                if gasAttr then
                    out[gasAttr] = (out[gasAttr] or 0) + entry.value
                end
            end
        end
    end
end


---【服务端】将自管数据同步到客户端。
function PlayerAttrManager:Sync()
    if not self:HasAuthority() or not self._isReady then
        return
    end
    UnrealNetwork.RepLazyProperty(self, "_base")
    UnrealNetwork.RepLazyProperty(self, "_level")
end


--===========================  读取  ===========================--


---【双端】获取属性当前值（含加成与 Buff，来自 GAS，由引擎自动同步）。
---@param attrType UGCNativeGameAttributeType|UGCCustomGameAttributeType 属性枚举
---@return number 当前值
function PlayerAttrManager:Get(attrType)
    return UGCAttributeSystem.GetGameAttributeValue(self.owner, attrType)
end


---【双端】获取属性最大值。
---@param attrType UGCNativeGameAttributeType|UGCCustomGameAttributeType 属性枚举
---@return number 最大值
function PlayerAttrManager:GetMax(attrType)
    return UGCAttributeSystem.GetGameAttributeValueMax(self.owner, attrType)
end


---【双端】获取属性最小值。
---@param attrType UGCNativeGameAttributeType|UGCCustomGameAttributeType 属性枚举
---@return number 最小值
function PlayerAttrManager:GetMin(attrType)
    return UGCAttributeSystem.GetGameAttributeValueMin(self.owner, attrType)
end


---【双端】获取管理器计算的基础值（默认+成长+手动修改，不含加成与 Buff）。
---@param attrType UGCNativeGameAttributeType|UGCCustomGameAttributeType 属性枚举
---@return number 基础值
function PlayerAttrManager:GetBase(attrType)
    return self._base[attrType] or 0
end


---【双端】获取当前等级。
---@return number 等级
function PlayerAttrManager:GetLevel()
    return self._level
end


--===========================  基础值  ===========================--


---【服务端】覆盖某属性的基础值。
---@param attrType UGCNativeGameAttributeType|UGCCustomGameAttributeType 属性枚举
---@param value number 基础值
---@param sync? boolean 是否立即同步数据，默认为true
function PlayerAttrManager:SetBase(attrType, value, sync)
    if not self:HasAuthority() or not self._isReady then
        return
    end
    self._base[attrType] = value
    self:_Push(attrType)
    if sync ~= false then
        self:Sync()
    end
end


---【服务端】在当前基础值上叠加增量。
---@param attrType UGCNativeGameAttributeType|UGCCustomGameAttributeType 属性枚举
---@param delta number 增量
---@param sync? boolean 是否立即同步数据，默认为true
function PlayerAttrManager:AddBase(attrType, delta, sync)
    if not self:HasAuthority() or not self._isReady then
        return
    end
    self._base[attrType] = (self._base[attrType] or 0) + delta
    self:_Push(attrType)
    if sync ~= false then
        self:Sync()
    end
end


--===========================  等级  ===========================--


---【服务端】设置等级，按成长表把等级差对应的增量叠加到基础值（保留手动 SetBase/AddBase 的改动）。
---@param level number 等级
---@param sync? boolean 是否立即同步数据，默认为true
function PlayerAttrManager:SetLevel(level, sync)
    if not self:HasAuthority() or not self._isReady then
        return
    end
    level = math.max(1, math.floor(level))
    local diff = level - self._level
    if diff == 0 then
        return
    end
    for attr, growth in pairs(DEFAULT_GROWTH) do
        self._base[attr] = (self._base[attr] or DEFAULT_BASE[attr] or 0) + growth * diff
    end
    self._level = level
    self:_Refresh()
    if sync ~= false then
        self:Sync()
    end
end


---【服务端】等级提升若干级。
---@param n number 提升的级数，默认为1
---@param sync? boolean 是否立即同步数据，默认为true
function PlayerAttrManager:AddLevel(n, sync)
    self:SetLevel(self._level + (n or 1), sync)
end


--===========================  加成源  ===========================--


---【服务端】设置/替换一个命名加成源（如 "Equipment"、"Title"）。
---@param source string 加成来源名
---@param bonusTable table 加成表 { [attrType] = number }
---@param sync? boolean 是否立即同步数据，默认为true
function PlayerAttrManager:SetBonus(source, bonusTable, sync)
    if not self:HasAuthority() or not self._isReady then
        return
    end
    self._bonus[source] = bonusTable or {}
    self:_Refresh()
    if sync ~= false then
        self:Sync()
    end
end


---【服务端】清除一个命名加成源。
---@param source string 加成来源名
---@param sync? boolean 是否立即同步数据，默认为true
function PlayerAttrManager:ClearBonus(source, sync)
    if not self:HasAuthority() or not self._isReady then
        return
    end
    self._bonus[source] = nil
    self:_Refresh()
    if sync ~= false then
        self:Sync()
    end
end


---【双端】计算玩家身上装备与卡牌提供的总加成，返回按 GAS 属性聚合的加成表。
---结果可直接传给 SetBonus，例如：self:SetBonus("Card", self:CalcEquipAndCardBonus())。
---当前仅汇总卡牌（玩家已拥有的全部卡牌，每张取一阶 bonus）；装备部分待装备加成配置落地后补充。
---@return table {[GAS属性类型]=number} 加成总和表
function PlayerAttrManager:CalcEquipAndCardBonus()
    InitDefaults()  -- 确保 ATTRIBUTE_TO_GAS 已构建（客户端不会走 _Init，需在此保证）
    local out = {}
    self:_CalcCardBonus(out)
    -- self:_CalcEquipmentBonus(out)  -- TODO: 装备加成（待装备加成配置表落地后实现）
    return out
end


--===========================  重置  ===========================--


---【服务端】重置为默认状态：清空加成源、等级回初始、按默认表重算基础值。
---@param sync? boolean 是否立即同步数据，默认为true
function PlayerAttrManager:Reset(sync)
    if not self:HasAuthority() or not self._isReady then
        return
    end
    self._bonus = {}
    self._level = INITIAL_LEVEL
    self:_ComputeBase()
    self:_Refresh()
    if sync ~= false then
        self:Sync()
    end
end


return PlayerAttrManager
