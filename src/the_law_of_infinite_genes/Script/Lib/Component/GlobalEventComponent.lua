---@class GlobalEventComponent_C:BaseComponent_C
local GlobalEventComponent = {}


function GlobalEventComponent:GetAvailableServerRPCs()
    return "ServerRPC_FromEventSystem"
end


function GlobalEventComponent:ClientRPC_FromEventSystem(...)
    Lib.EventSystem.Dispatch(...)
end


function GlobalEventComponent:ServerRPC_FromEventSystem(...)
    Lib.EventSystem.Dispatch(...)
end


function GlobalEventComponent:Multicast_FromEventSystem(...)
    Lib.EventSystem.Dispatch(...)
end
 

-- function GlobalEventComponent:ReceiveBeginPlay()
--     GlobalEventComponent.SuperClass.ReceiveBeginPlay(self)
-- end


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