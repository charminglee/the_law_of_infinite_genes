---@class UGCPlayerPawn_C:BP_UGCPlayerPawn_C
---@field AttrManager AttrManager_C
--Edit Below--
local UGCPlayerPawn = {}
 

function UGCPlayerPawn:ReceiveBeginPlay()
    UGCPlayerPawn.SuperClass.ReceiveBeginPlay(self)
    self.bVaultIsOpen = true
    self.IsOpenShovelAbility = true
    if not self:HasAuthority() then
        LocalPlayerPawn = LocalPlayerPawn or self ---@type UGCPlayerPawn_C
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