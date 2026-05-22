---@class BP_Placeholder_C:AActor
---@field DefaultSceneRoot USceneComponent
--Edit Below--
local BP_Placeholder = {};
 
--[[
function BP_Placeholder:ReceiveBeginPlay()
    self.SuperClass.ReceiveBeginPlay(self);
end
--]]

--[[
function BP_Placeholder:ReceiveTick(DeltaTime)
    self.SuperClass.ReceiveTick(self, DeltaTime);
end
--]]

--[[
function BP_Placeholder:ReceiveEndPlay()
    self.SuperClass.ReceiveEndPlay(self); 
end
--]]

--[[
function BP_Placeholder:GetReplicatedProperties()
    return
end
--]]

--[[
function BP_Placeholder:GetAvailableServerRPCs()
    return
end
--]]

return BP_Placeholder;