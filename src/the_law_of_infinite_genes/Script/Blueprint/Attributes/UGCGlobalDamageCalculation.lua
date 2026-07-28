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


local function _ApplyHealthSteal(instigator, damage, healthStealPct)
    local recoveredHealth = damage * healthStealPct
    if recoveredHealth <= 0 then
        return
    end
    local currHealth = UGCAttributeSystem.GetGameAttributeValue(instigator, UGCNativeGameAttributeType.Character_Health)
    local maxHealth = UGCAttributeSystem.GetGameAttributeValue(instigator, UGCNativeGameAttributeType.Character_HealthMax)
    local newHealth = math.min(maxHealth, currHealth + recoveredHealth)
    UGCAttributeSystem.SetGameAttributeValue(instigator, UGCNativeGameAttributeType.Character_Health, newHealth)
end


local function _ApplyCounterAttack(instigator, victim, damage)
    local instigatorController = UGCGameSystem.GetControllerByPawn(instigator)
    local tag = UGCGameplayTagSystem.RequestGameplayTag(GameplayTag.Damage.Type.CounterAttack)
    UGCGameSystem.ApplyDamage(victim, damage, instigatorController, instigator, {tag})
end


function UGCGlobalDamageCalculation:GetCalculationResult(context, extraResult)
    local damage = UGCAttributeSystem.GetSourceMagnitudeFromContext(context)

    -- 直伤/反伤类型的伤害不再参与公式计算
    if _HasDamageTag(context, GameplayTag.Damage.Type.Direct) or _HasDamageTag(context, GameplayTag.Damage.Type.CounterAttack) then
        return damage, extraResult
    end

    local instigator                = UGCAttributeSystem.GetInstigatorFromContext(context):K2_GetPawn()
    local instigatorAM              = instigator.AttrManager ---@type AttrManager_C
    local attackPower               = instigatorAM:GetAttr(Attribute.AttackPower)
    local breakDefencePct           = instigatorAM:GetAttr(Attribute.BreakDefencePct)
    local critChance                = instigatorAM:GetAttr(Attribute.CritChance)
    local critDamagePct             = instigatorAM:GetAttr(Attribute.CritDamagePct)
    local damagePct                 = instigatorAM:GetAttr(Attribute.DamagePct)
    local normalMonsterDamagePct    = instigatorAM:GetAttr(Attribute.NormalMonsterDamagePct)
    local eliteDamagePct            = instigatorAM:GetAttr(Attribute.EliteMonsterDamagePct)
    local bossDamagePct             = instigatorAM:GetAttr(Attribute.BossDamagePct)
    local healthStealPct            = instigatorAM:GetAttr(Attribute.HealthStealPct)
    local seckillChance             = instigatorAM:GetAttr(Attribute.SeckillChance)
    
    local victim            = UGCAttributeSystem.GetVictimFromContext(context)
    local victimAM          = victim.AttrManager ---@type AttrManager_C
    local defence           = victimAM:GetAttr(Attribute.Defence)
    local defencePct        = victimAM:GetAttr(Attribute.DefensePct)
    local damageDecreace    = victimAM:GetAttr(Attribute.DamageDecreace)
    local damageDecreacePct = victimAM:GetAttr(Attribute.DamageDecreacePct)
    local dodgeChance       = victimAM:GetAttr(Attribute.DodgeChance)
    local counterAttackPct  = victimAM:GetAttr(Attribute.CounterAttackPct)

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
    local atkArea = attackPower

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
    ugcprint(
        "GetCalculationResult " 
        .. " instigator:" .. UGCObjectUtility.GetDisplayName(instigator)
        .. " victim:" .. UGCObjectUtility.GetDisplayName(victim)
        .. " atkArea:" .. atkArea 
        .. " critArea:" .. critArea 
        .. " damagePctArea:" .. damagePctArea 
        .. " defenceArea:" .. defenceArea 
        .. " damageDecreaceArea:" .. damageDecreaceArea
        .. " damageDecreace:" .. damageDecreace
        .. " finalDamage:" .. finalDamage
    )

    -- 吸血
    _ApplyHealthSteal(instigator, finalDamage, healthStealPct)
    
    -- 反伤
    local counterDamage = damage * counterAttackPct
    if counterDamage > 0 then
        _ApplyCounterAttack(victim, instigator, counterDamage)
    end
    
    return finalDamage, extraResult
end


return UGCGlobalDamageCalculation