local UGCGlobalDamageCalculation = {}


local function _HasDamageTag(context, tag)
    for _, t in pairs(context.DamageTypeTags) do
        if t == tag then
            return true
        end
    end
    return false
end

    
local function _SetDamageTag(extraResult, tag)
    tag = UGCGameplayTagSystem.RequestGameplayTag(tag)
    if tag then
        extraResult.ResultTags:Add(tag)
    end
end


local function _ApplyHealthSteal(instigator, victim, damage, healthStealPct)
    healthStealPct = Lib.Math.Clamp(healthStealPct, 0, 1)
    if healthStealPct <= 0 or damage <= 0 then
        return
    end

    local victimHealth = UGCAttributeSystem.GetGameAttributeValue(victim, UGCNativeGameAttributeType.Character_Health)
    local recoverableDamage = math.min(damage, math.max(0, victimHealth))
    local recoveredHealth = recoverableDamage * healthStealPct
    if recoveredHealth <= 0 then
        return
    end

    local currentHealth = UGCAttributeSystem.GetGameAttributeValue(instigator, UGCNativeGameAttributeType.Character_Health)
    local maxHealth = UGCAttributeSystem.GetGameAttributeValue(instigator, UGCNativeGameAttributeType.Character_HealthMax)
    local newHealth = math.min(maxHealth, currentHealth + recoveredHealth)
    if newHealth > currentHealth then
        UGCAttributeSystem.SetGameAttributeValue(instigator, UGCNativeGameAttributeType.Character_Health, newHealth)
    end
end


function UGCGlobalDamageCalculation:GetCalculationResult(context, extraResult)
    local damage = UGCAttributeSystem.GetSourceMagnitudeFromContext(context)

    -- 直伤/反伤类型的伤害不再参与公式计算
    if _HasDamageTag(context, GameplayTag.Damage.Type.Direct) or _HasDamageTag(context, GameplayTag.Damage.Type.CounterAttack) then
        return damage, extraResult
    end

    local instigator                = UGCAttributeSystem.GetInstigatorFromContext(context):K2_GetPawn()
    ugcprint("GetCalculationResult"..UGCObjectUtility.GetObjectFullName(instigator))
    local attackPower               = UGCAttributeSystem.GetGameAttributeValue(instigator, Attribute.AttackPower)
    local attackPowerPct            = UGCAttributeSystem.GetGameAttributeValue(instigator, Attribute.AttackPowerPct)
    local breakDefencePct           = UGCAttributeSystem.GetGameAttributeValue(instigator, Attribute.BreakDefencePct)
    local critChance                = UGCAttributeSystem.GetGameAttributeValue(instigator, Attribute.CritChance)
    local critDamagePct             = UGCAttributeSystem.GetGameAttributeValue(instigator, Attribute.CritDamagePct)
    local damagePct                 = UGCAttributeSystem.GetGameAttributeValue(instigator, Attribute.DamagePct)
    local normalMonsterDamagePct    = UGCAttributeSystem.GetGameAttributeValue(instigator, Attribute.NormalMonsterDamagePct)
    local eliteDamagePct            = UGCAttributeSystem.GetGameAttributeValue(instigator, Attribute.EliteMonsterDamagePct)
    local bossDamagePct             = UGCAttributeSystem.GetGameAttributeValue(instigator, Attribute.BossDamagePct)
    local healthStealPct            = UGCAttributeSystem.GetGameAttributeValue(instigator, Attribute.HealthStealPct)
    local seckillChance             = UGCAttributeSystem.GetGameAttributeValue(instigator, Attribute.SeckillChance)
    
    local victim            = UGCAttributeSystem.GetVictimFromContext(context)
    ugcprint("GetCalculationResult"..UGCObjectUtility.GetObjectFullName(victim))
    local defence           = UGCAttributeSystem.GetGameAttributeValue(victim, Attribute.Defence)
    local defencePct        = UGCAttributeSystem.GetGameAttributeValue(victim, Attribute.DefensePct)
    local damageDecreace    = UGCAttributeSystem.GetGameAttributeValue(victim, Attribute.DamageDecreace)
    local damageDecreacePct = UGCAttributeSystem.GetGameAttributeValue(victim, Attribute.DamageDecreacePct)
    local dodgeChance       = UGCAttributeSystem.GetGameAttributeValue(victim, Attribute.DodgeChance)
    local counterAttackPct  = UGCAttributeSystem.GetGameAttributeValue(victim, Attribute.CounterAttackPct)

    -- 秒杀
    if Lib.Math.Chance(seckillChance) then
        _SetDamageTag(extraResult, GameplayTag.Damage.Type.Seckill)
        return 999999999, extraResult
    end

    -- 闪避
    if Lib.Math.Chance(dodgeChance) then
        _SetDamageTag(extraResult, GameplayTag.Damage.Type.Dodge)
        return 0, extraResult
    end
    
    -- 攻击区
    local atkArea = math.max(1, attackPower * (1 + attackPowerPct))

    -- 暴击区
    local critArea = 1
    if Lib.Math.Chance(critChance) then
        critArea = 1 + critDamagePct
        _SetDamageTag(extraResult, GameplayTag.Damage.Type.Critical)
    end

    -- 增伤区
    local damagePctArea = 1 + damagePct
    if victim:ActorHasTag(Tag.Boss) then
        damagePctArea = damagePctArea + bossDamagePct
    elseif victim:ActorHasTag(Tag.Elite) then
        damagePctArea = damagePctArea + eliteDamagePct
    elseif victim:ActorHasTag(Tag.Monster) then
        damagePctArea = damagePctArea + normalMonsterDamagePct
    end

    -- 防御区
    local totalDefence = defence * (1 + defencePct)
    local defenceArea = 1 - totalDefence * (1 - breakDefencePct) / (totalDefence + Config.Damage.DefenceK)

    -- 减伤区
    local damageDecreaceArea = 1 - damageDecreacePct

    -- 最终伤害
    local finalDamage = atkArea * critArea * damagePctArea * defenceArea * damageDecreaceArea - damageDecreace
    finalDamage = math.max(1, finalDamage)

    -- 吸血
    _ApplyHealthSteal(instigator, victim, finalDamage, healthStealPct)
    
    -- 反伤
    local counterDamage = finalDamage * counterAttackPct
    if counterDamage > 0 then
        UGCGameSystem.ApplyDamage(
            instigator, 
            counterDamage,
            victim,
            victim, 
            GameplayTag.Damage.Type.CounterAttack
        )
    end
    
    return finalDamage, extraResult
end


return UGCGlobalDamageCalculation