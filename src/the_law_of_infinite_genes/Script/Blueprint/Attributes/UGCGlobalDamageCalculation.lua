local UGCGlobalDamageCalculation = {}


local function hasDamageTag(context, tag)
    for _, t in pairs(context.DamageTypeTags) do
        if t == tag then
            return true
        end
    end
    return false
end


function UGCGlobalDamageCalculation:GetCalculationResult(context, extraResult)
    local damage = UGCAttributeSystem.GetSourceMagnitudeFromContext(context)

    -- 直伤/反伤
    if hasDamageTag(context, GameplayTag.Damage.Type.Direct) or hasDamageTag(context, GameplayTag.Damage.Type.CounterAttack) then
        return damage, extraResult
    end
    
    local instigator                = UGCAttributeSystem.GetInstigatorFromContext(context):K2_GetPawn()
    local breakDefenceRatio         = UGCAttributeSystem.GetGameAttributeValue(instigator, UGCCustomGameAttributeType.UGCAttributeGroup_Character_BreakDefenceRatio)
    local critChance                = UGCAttributeSystem.GetGameAttributeValue(instigator, UGCCustomGameAttributeType.UGCAttributeGroup_Character_CritChance)
    local critDamageBoost           = UGCAttributeSystem.GetGameAttributeValue(instigator, UGCCustomGameAttributeType.UGCAttributeGroup_Character_CritDamageBoost)
    local damageBoost               = UGCAttributeSystem.GetGameAttributeValue(instigator, UGCCustomGameAttributeType.UGCAttributeGroup_Character_DamageBoost)
    local normalMonsterDamageBoost  = UGCAttributeSystem.GetGameAttributeValue(instigator, UGCCustomGameAttributeType.UGCAttributeGroup_Character_NormalMonsterDamageBoost)
    local eliteDamageBoost          = UGCAttributeSystem.GetGameAttributeValue(instigator, UGCCustomGameAttributeType.UGCAttributeGroup_Character_EliteMonsterDamageBoost)
    local bossDamageBoost           = UGCAttributeSystem.GetGameAttributeValue(instigator, UGCCustomGameAttributeType.UGCAttributeGroup_Character_BossDamageBoost)
    
    local victim            = UGCAttributeSystem.GetVictimFromContext(context)
    local defence           = UGCAttributeSystem.GetGameAttributeValue(victim, UGCCustomGameAttributeType.UGCAttributeGroup_Character_Defence)
    local defenceBoost      = UGCAttributeSystem.GetGameAttributeValue(victim, UGCCustomGameAttributeType.UGCAttributeGroup_Character_DefenseBoost)
    local damageDecreace    = UGCAttributeSystem.GetGameAttributeValue(victim, UGCCustomGameAttributeType.UGCAttributeGroup_Character_DamageDecreace)
    local damageDecreacePct = UGCAttributeSystem.GetGameAttributeValue(victim, UGCCustomGameAttributeType.UGCAttributeGroup_Character_DamageDecreacePct)
    
    -- 暴击区
    local isCrit = (math.random() <= critChance)
    local critArea = 1
    if isCrit then
        critArea = 1 + critDamageBoost
        local critTag = UGCGameplayTagSystem.RequestGameplayTag(GameplayTag.Damage.Type.Critical)
        if critTag then
            extraResult.ResultTags:Add(critTag)
        end
    end

    -- 增伤区
    local damageBoostArea = 1 + damageBoost + normalMonsterDamageBoost + eliteDamageBoost + bossDamageBoost

    -- 防御区
    local totalDefence = defence * (1 + defenceBoost)
    local defenceArea = 1 - totalDefence * (1 - breakDefenceRatio) / (totalDefence + Config.Damage.DefenceK)
    defenceArea = math.min(math.max(defenceArea, 0), 1)

    -- 减伤区
    local damageDecreaceArea = 1 - damageDecreacePct
    damageDecreaceArea = math.min(math.max(damageDecreaceArea, 0), 1)

    -- 最终伤害
    local finalDamage = damage * critArea * damageBoostArea * defenceArea * damageDecreaceArea - damageDecreace
    finalDamage = math.max(0, finalDamage)
    
    return finalDamage, extraResult
end


return UGCGlobalDamageCalculation