---@class LobbyModeActor_2_C:UGCLevelActor
---@field DefaultSceneRoot USceneComponent
--Edit Below--
local LobbyModeActor_2 = {}
 
--[[
function LobbyModeActor_2:ReceiveBeginPlay()
    LobbyModeActor_2.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function LobbyModeActor_2:ReceiveTick(DeltaTime)
    LobbyModeActor_2.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function LobbyModeActor_2:ReceiveEndPlay()
    LobbyModeActor_2.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function LobbyModeActor_2:GetReplicatedProperties()
    return
end
--]]

--[[
function LobbyModeActor_2:GetAvailableServerRPCs()
    return
end
--]]

return LobbyModeActor_2