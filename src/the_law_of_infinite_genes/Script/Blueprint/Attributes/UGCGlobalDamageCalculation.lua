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
    if hasDamageTag(context, "UGC.Damage.Type.Direct") or hasDamageTag(context, "UGC.Damage.Type.CounterAttack") then
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
    
    local victim        = UGCAttributeSystem.GetVictimFromContext(context)
    local defence       = UGCAttributeSystem.GetGameAttributeValue(victim, UGCCustomGameAttributeType.UGCAttributeGroup_Character_Defence)
    local defenceBoost  = UGCAttributeSystem.GetGameAttributeValue(victim, UGCCustomGameAttributeType.UGCAttributeGroup_Character_DefenseBoost)
    
    -- 暴击区
    local isCrit = (math.random() <= critChance)
    local critBoost = 0
    if isCrit then
        critBoost = critDamageBoost
        local critTag = UGCGameplayTagSystem.RequestGameplayTag("UGC.Damage.Type.Critical")
        if critTag then
            extraResult.ResultTags:Add(critTag)
        end
    end

    -- 增伤区
    local totalDamageBoost = damageBoost + normalMonsterDamageBoost + eliteDamageBoost + bossDamageBoost

    -- 总防御 = 防御 * (1 + 防御加成比)
    -- 防御减伤比 = 总防御 * (1 - 防御穿透比) / (总防御 + K)
    local totalDefence = defence * (1 + defenceBoost)
    local damageDecreace = totalDefence * (1 - breakDefenceRatio) / (totalDefence + Config.Damage.DefenceK)

    -- 最终伤害
    local finalDamage = damage * (1 + critBoost) * (1 + totalDamageBoost) * (1 - damageDecreace)
    return finalDamage, extraResult
end


return UGCGlobalDamageCalculation