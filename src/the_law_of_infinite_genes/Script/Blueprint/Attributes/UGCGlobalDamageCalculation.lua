local UGCGlobalDamageCalculation = {}


local function HasDamageTag(context, tag)
    for _, t in pairs(context.DamageTypeTags) do
        if t == tag then
            return true
        end
    end
    return false
end


function UGCGlobalDamageCalculation:GetCalculationResult(context, extraResult)
    -- 直伤/反伤
    if HasDamageTag(context, GameplayTag.Damage.Type.Direct) or HasDamageTag(context, GameplayTag.Damage.Type.CounterAttack) then
        local damage = UGCAttributeSystem.GetSourceMagnitudeFromContext(context)
        return damage, extraResult
    end
    
    local instigator                = UGCAttributeSystem.GetInstigatorFromContext(context):K2_GetPawn()
    local attackPower               = UGCAttributeSystem.GetGameAttributeValue(instigator, UGCCustomGameAttributeType.UGCAttributeGroup_Character_AttackPower)
    local attackPowerPct            = UGCAttributeSystem.GetGameAttributeValue(instigator, UGCCustomGameAttributeType.UGCAttributeGroup_Character_AttackPowerPct)
    local BreakDefencePct           = UGCAttributeSystem.GetGameAttributeValue(instigator, UGCCustomGameAttributeType.UGCAttributeGroup_Character_BreakDefencePct)
    local critChance                = UGCAttributeSystem.GetGameAttributeValue(instigator, UGCCustomGameAttributeType.UGCAttributeGroup_Character_CritChance)
    local critDamagePct             = UGCAttributeSystem.GetGameAttributeValue(instigator, UGCCustomGameAttributeType.UGCAttributeGroup_Character_CritDamagePct)
    local damagePct                 = UGCAttributeSystem.GetGameAttributeValue(instigator, UGCCustomGameAttributeType.UGCAttributeGroup_Character_DamagePct)
    local normalMonsterDamagePct    = UGCAttributeSystem.GetGameAttributeValue(instigator, UGCCustomGameAttributeType.UGCAttributeGroup_Character_NormalMonsterDamagePct)
    local eliteDamagePct            = UGCAttributeSystem.GetGameAttributeValue(instigator, UGCCustomGameAttributeType.UGCAttributeGroup_Character_EliteMonsterDamagePct)
    local bossDamagePct             = UGCAttributeSystem.GetGameAttributeValue(instigator, UGCCustomGameAttributeType.UGCAttributeGroup_Character_BossDamagePct)
    
    local victim            = UGCAttributeSystem.GetVictimFromContext(context)
    local defence           = UGCAttributeSystem.GetGameAttributeValue(victim, UGCCustomGameAttributeType.UGCAttributeGroup_Character_Defence)
    local defencePct        = UGCAttributeSystem.GetGameAttributeValue(victim, UGCCustomGameAttributeType.UGCAttributeGroup_Character_DefensePct)
    local damageDecreace    = UGCAttributeSystem.GetGameAttributeValue(victim, UGCCustomGameAttributeType.UGCAttributeGroup_Character_DamageDecreace)
    local damageDecreacePct = UGCAttributeSystem.GetGameAttributeValue(victim, UGCCustomGameAttributeType.UGCAttributeGroup_Character_DamageDecreacePct)
    
    -- 攻击区
    local atkArea = math.max(1, attackPower * (1 + attackPowerPct))

    -- 暴击区
    local isCrit = (math.random() <= critChance)
    local critArea = 1
    if isCrit then
        critArea = 1 + critDamagePct
        local critTag = UGCGameplayTagSystem.RequestGameplayTag(GameplayTag.Damage.Type.Critical)
        if critTag then
            extraResult.ResultTags:Add(critTag)
        end
    end

    -- 增伤区
    local damagePctArea = 1 + damagePct + normalMonsterDamagePct + eliteDamagePct + bossDamagePct

    -- 防御区
    local totalDefence = defence * (1 + defencePct)
    local defenceArea = 1 - totalDefence * (1 - BreakDefencePct) / (totalDefence + Config.Damage.DefenceK)
    defenceArea = math.min(math.max(0, defenceArea), 1)

    -- 减伤区
    local damageDecreaceArea = 1 - damageDecreacePct
    damageDecreaceArea = math.min(math.max(0, damageDecreaceArea), 1)

    -- 最终伤害
    local finalDamage = atkArea * critArea * damagePctArea * defenceArea * damageDecreaceArea - damageDecreace
    finalDamage = math.max(1, finalDamage)
    
    return finalDamage, extraResult
end


return UGCGlobalDamageCalculation