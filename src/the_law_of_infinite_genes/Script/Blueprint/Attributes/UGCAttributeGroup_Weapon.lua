local UGCAttributeGroup_Weapon = {}
 
--[[
function UGCAttributeGroup_Weapon:ReceiveBeginPlay()
    UGCAttributeGroup_Weapon.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function UGCAttributeGroup_Weapon:ReceiveTick(DeltaTime)
    UGCAttributeGroup_Weapon.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function UGCAttributeGroup_Weapon:ReceiveEndPlay()
    UGCAttributeGroup_Weapon.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function UGCAttributeGroup_Weapon:GetReplicatedProperties()
    return
end
--]]

--[[
function UGCAttributeGroup_Weapon:GetAvailableServerRPCs()
    return
end
--]]

function UGCAttributeGroup_Weapon:GetA_Override(OriginalValue, AttributeOwnerActor)
	return OriginalValue;
end

return UGCAttributeGroup_Weapon