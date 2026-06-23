---@class UGCPlayerState_C:BP_UGCPlayerState_C
---@field PlayerDataManager PlayerDataManager_C
--Edit Below--
local UGCPlayerState = {}
 

function UGCPlayerState:ReceiveBeginPlay()
    UGCPlayerState.SuperClass.ReceiveBeginPlay(self)
    if not self:HasAuthority() then
        LocalPlayerState = self
    end
end


--[[
function UGCPlayerState:ReceiveTick(DeltaTime)
    UGCPlayerState.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]


--[[
function UGCPlayerState:ReceiveEndPlay()
    UGCPlayerState.SuperClass.ReceiveEndPlay(self) 
end
--]]


--[[
function UGCPlayerState:GetReplicatedProperties()
    return
end
--]]


--[[
function UGCPlayerState:GetAvailableServerRPCs()
    return
end
--]]


return UGCPlayerState