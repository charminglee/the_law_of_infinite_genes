---@class UGCPlayerPawn_C:BP_UGCPlayerPawn_C
--Edit Below--
local UGCPlayerPawn = {}
 
function UGCPlayerPawn:ReceiveBeginPlay()
    self.bVaultIsOpen = true
    UGCWidgetManagerSystem.AddObjectPositionUI(
        self, 
UGCGameSystem.GetUGCResourcesFullPath('Asset/Blueprint/Prefabs/UI/Title.Title_C'),
        { X = 0, Y = 0, Z = 100 }, 
        true, 
        false, 
        false, 
        true
    )
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