SpecialEventManager = SpecialEventManager or 
{
    currEvent = -1
}


---触发特殊事件。
---@param specialEvent number SpecialEvent枚举值
function SpecialEventManager.TriggerSpecialEvent(specialEvent)
    SpecialEventManager.currEvent = specialEvent

    -- 持续时间结束后自动触发事件结束
    local dur = Config.SpecialEvent[specialEvent].Duration
    UGCTimerUtility.CreateUETimer(SpecialEventManager.StopSpecialEvent, dur, false)

    if GameState:HasAuthority() then
        -- 给玩家添加对应buff
        local buffCls = ClassPath[specialEvent]
        local allPlayers = UGCGameSystem.GetAllPlayerPawn()
        for _, pawn in pairs(allPlayers) do
            UGCPersistEffectSystem.AddBuffByClass(pawn, buffCls)
        end

        -- 给怪物添加对应buff
        if specialEvent == SpecialEvent.PutridMiasma then
            SpecialEventManager.SetPutridMiasmaForAllMonsters()
        end
    end
end


---结束当前正在进行的特殊事件。
function SpecialEventManager.StopSpecialEvent()
    if SpecialEventManager.currEvent == -1 then
        return
    end

    SpecialEventManager.currEvent = -1
end


---为所有怪物添加腐秽瘴潮效果。
function SpecialEventManager.SetPutridMiasmaForAllMonsters()
    if not GameState:HasAuthority() then
        return
    end
    
    local buffCls = ClassPath[Buff.PutridMiasma_Monster]
    local allMonsters = {}
    GameplayStatics.GetAllActorsOfClass(GameState, UGCObjectUtility.LoadClass(ClassPath.MonsterTemplate), allMonsters)
    for _, actor in pairs(allMonsters) do
        UGCPersistEffectSystem.AddBuffByClass(actor, buffCls)
    end
end


return SpecialEventManager