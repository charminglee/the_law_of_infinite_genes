---@class SingleMode_2_Actor_C:UGCLevelActor
---@field DefaultSceneRoot USceneComponent
--Edit Below--
local SingleMode_2_Actor = {}
 
--[[
function SingleMode_2_Actor:ReceiveBeginPlay()
    SingleMode_2_Actor.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function SingleMode_2_Actor:ReceiveTick(DeltaTime)
    SingleMode_2_Actor.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function SingleMode_2_Actor:ReceiveEndPlay()
    SingleMode_2_Actor.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function SingleMode_2_Actor:GetReplicatedProperties()
    return
end
--]]

--[[
function SingleMode_2_Actor:GetAvailableServerRPCs()
    return
end
--]]

return SingleMode_2_Actor