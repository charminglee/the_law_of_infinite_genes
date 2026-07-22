---@class SingleMode_1_Actor_C:UGCLevelActor
---@field DefaultSceneRoot USceneComponent
--Edit Below--
local SingleMode_1_Actor = {}
 
--[[
function SingleMode_1_Actor:ReceiveBeginPlay()
    SingleMode_1_Actor.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function SingleMode_1_Actor:ReceiveTick(DeltaTime)
    SingleMode_1_Actor.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function SingleMode_1_Actor:ReceiveEndPlay()
    SingleMode_1_Actor.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function SingleMode_1_Actor:GetReplicatedProperties()
    return
end
--]]

--[[
function SingleMode_1_Actor:GetAvailableServerRPCs()
    return
end
--]]

return SingleMode_1_Actor