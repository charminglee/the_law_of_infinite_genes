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
    local instiBreakDefenceRatio    = UGCAttributeSystem.GetGameAttributeValue(instigator, UGCCustomGameAttributeType.UGCAttributeGroup_Character_BreakDefenceRatio)
    local instiCritChance           = UGCAttributeSystem.GetGameAttributeValue(instigator, UGCCustomGameAttributeType.UGCAttributeGroup_Character_CritChance)
    local instiCritDamageBoost      = UGCAttributeSystem.GetGameAttributeValue(instigator, UGCCustomGameAttributeType.UGCAttributeGroup_Character_CritDamageBoost)
    local instiDamageBoost          = UGCAttributeSystem.GetGameAttributeValue(instigator, UGCCustomGameAttributeType.UGCAttributeGroup_Character_DamageBoost)
    local instiLv                   = UGCAttributeSystem.GetGameAttributeValue(instigator, UGCCustomGameAttributeType.UGCAttributeGroup_Character_Level)
    
    local victim            = UGCAttributeSystem.GetVictimFromContext(context)
    local vicDefence        = UGCAttributeSystem.GetGameAttributeValue(victim, UGCCustomGameAttributeType.UGCAttributeGroup_Character_Defence)
    local vicDefenceBoost   = UGCAttributeSystem.GetGameAttributeValue(victim, UGCCustomGameAttributeType.UGCAttributeGroup_Character_DefenseBoost)
    local vicLv             = UGCAttributeSystem.GetGameAttributeValue(victim, UGCCustomGameAttributeType.UGCAttributeGroup_Character_Level)
    
    -- A = instigator, B = victim
    -- B.总防御 = B.防御 * (1 + B.防御加成比例)
    -- 防御减伤比 = B.总防御 * (1 - A.防御穿透百分比) / (B.总防御 + K)
    local totalDefence = vicDefence * (1 + vicDefenceBoost)
    local damageDecreace = totalDefence * (1 - instiBreakDefenceRatio) / (totalDefence + DamageConfig.DefenceK)

    -- 暴击
    local isCrit = (math.random() <= instiCritChance)
    local critBoost = 0
    if isCrit then
        critBoost = instiCritDamageBoost
        local critTag = UGCGameplayTagSystem.RequestGameplayTag("UGC.Damage.Type.Critical")
        if critTag then
            extraResult.ResultTags:Add(critTag)
        end
    end

    -- 猎尸狂涌：玩家减免受到怪物的所有伤害
    -- if SpecialEventManager.currEvent == SpecialEvent.CorpseHuntingSurge and not instigator:IsPlayerController() then
    --     local mul = 1 - SpecialEventConfig[SpecialEvent.CorpseHuntingSurge].DefenseBuff
    --     damage = damage * mul
    -- end
    
    -- 最终伤害
    local finalDamage = damage * (1 + critBoost) * (1 + instiDamageBoost) * (1 - damageDecreace)
    return finalDamage, extraResult
end


return UGCGlobalDamageCalculation