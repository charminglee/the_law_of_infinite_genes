---@class UGCPlayerPawn_C:BP_UGCPlayerPawn_C
---@field Widget UWidgetComponent
--Edit Below--
local UGCPlayerPawn = {}
 
function UGCPlayerPawn:ReceiveBeginPlay()
    self.bVaultIsOpen = true
    self.SuperClass.ReceiveBeginPlay(self)
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