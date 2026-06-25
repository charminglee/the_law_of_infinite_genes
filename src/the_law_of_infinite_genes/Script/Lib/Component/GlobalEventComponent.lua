---@class GlobalEventComponent_C:BaseComponent_C
local GlobalEventComponent = {}


function GlobalEventComponent:GetAvailableServerRPCs()
    return "ServerRPC_OnEmitAcross"
end


function GlobalEventComponent:ServerRPC_OnEmitAcross(...)
    Lib.EventSystem._EmitLocal(...)
end
 

--[[
function GlobalEventComponent:ReceiveBeginPlay()
    GlobalEventComponent.SuperClass.ReceiveBeginPlay(self)
end
--]]


--[[
function GlobalEventComponent:ReceiveTick(DeltaTime)
    GlobalEventComponent.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]


--[[
function GlobalEventComponent:ReceiveEndPlay()
    GlobalEventComponent.SuperClass.ReceiveEndPlay(self) 
end
--]]


return GlobalEventComponent