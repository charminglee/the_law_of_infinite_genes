---@class UGCPlayerPawn_C:BP_UGCPlayerPawn_C
--Edit Below--
local UGCPlayerPawn = {}
 

function UGCPlayerPawn:ReceiveBeginPlay()
    UGCPlayerPawn.SuperClass.ReceiveBeginPlay(self)

    if not self:HasAuthority() then
        LocalPlayerPawn = self
    end

end


--[[
function UGCPlayerPawn:ReceiveTick(DeltaTime)
    UGCPlayerPawn.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]


--[[
function UGCPlayerPawn:ReceiveEndPlay()
    UGCPlayerPawn.SuperClass.ReceiveEndPlay(self) 
end
--]]


--[[
function UGCPlayerPawn:GetAvailableServerRPCs()
    return
end
--]]


function UGCPlayerPawn:GetReplicatedProperties()
    return {"__SubObjectRepList", "Lazy"}
end


return UGCPlayerPawn