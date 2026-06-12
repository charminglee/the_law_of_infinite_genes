local UGCGlobalDamageCalculation = {}


function UGCGlobalDamageCalculation:GetCalculationResult(Context, ExtraResult)
    local victim        = UGCAttributeSystem.GetVictimFromContext(Context)
    local causer        = UGCAttributeSystem.GetCauserFromContext(Context)
    local instigator    = UGCAttributeSystem.GetInstigatorFromContext(Context)
    local damage        = UGCAttributeSystem.GetSourceMagnitudeFromContext(Context)

    -- 猎尸狂涌：玩家减免受到怪物的所有伤害
    if SpecialEventManager.currEvent == SpecialEvent.CorpseHuntingSurge and not instigator:IsPlayerController() then
        local mul = 1 - SpecialEventConfig[SpecialEvent.CorpseHuntingSurge].DefenseBuff
        damage = damage * mul
    end
    
    return damage, ExtraResult
end


return UGCGlobalDamageCalculation