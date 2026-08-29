---@class SpecialEventManager_C:BaseManager_C
--Edit Below--
local SpecialEventManager = {
    currEvent = -1,
}


function SpecialEventManager:GetReplicatedProperties()
    return {"currEvent", "Lazy"}
end


function SpecialEventManager:ReceiveBeginPlay()
    SpecialEventManager.SuperClass.ReceiveBeginPlay(self)
end


--[[
function SpecialEventManager:ReceiveTick(DeltaTime)
    SpecialEventManager.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]


--[[
function SpecialEventManager:ReceiveEndPlay()
    SpecialEventManager.SuperClass.ReceiveEndPlay(self) 
end
--]]


---触发特殊事件。
---@param specialEvent SpecialEvent @SpecialEvent 枚举值
function SpecialEventManager:TriggerSpecialEvent(specialEvent)
    if not Lib.IsServer() then
        return
    end

    self.currEvent = specialEvent
    UnrealNetwork.RepLazyProperty(self, "currEvent")

    -- 持续时间结束后自动触发事件结束
    local dur = Config.SpecialEvent[specialEvent].Duration
    UGCTimerUtility.CreateUETimer(
        function()
            self:StopSpecialEvent() 
        end, 
        dur, 
        false
    )

    -- 给玩家添加对应buff
    local buffCls = ClassPath[specialEvent] ---@type string
    for _, i in pairs(UGCGameSystem.GetAllPlayerPawn()) do
        UGCPersistEffectSystem.AddBuffByClass(i, buffCls)
    end

    -- 给怪物添加对应buff
    if specialEvent == SpecialEvent.PutridMiasma then
        self:SetPutridMiasmaForAllMonsters()
    end
end


---结束当前正在进行的特殊事件。
function SpecialEventManager:StopSpecialEvent()
    if not Lib.IsServer() or self.currEvent == -1 then
        return
    end

    self.currEvent = -1
    UnrealNetwork.RepLazyProperty(self, "currEvent")
end


---为所有怪物添加腐秽瘴潮效果。
function SpecialEventManager:SetPutridMiasmaForAllMonsters()
    if not Lib.IsServer() then
        return
    end
    
    local buffCls = ClassPath[Buff.PutridMiasma_Monster]
    local allMonsters = {}
    GameplayStatics.GetAllActorsOfClass(GameState, UGCObjectUtility.LoadClass(ClassPath.BaseMonster), allMonsters)
    for _, i in pairs(allMonsters) do
        UGCPersistEffectSystem.AddBuffByClass(i, buffCls)
    end
end


return SpecialEventManager