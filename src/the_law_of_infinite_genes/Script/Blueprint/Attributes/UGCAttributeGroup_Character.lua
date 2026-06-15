local UGCAttributeGroup_Character = {}
 

--[[
function UGCAttributeGroup_Character:ReceiveBeginPlay()
    UGCAttributeGroup_Character.SuperClass.ReceiveBeginPlay(self)
end
--]]


--[[
function UGCAttributeGroup_Character:ReceiveTick(DeltaTime)
    UGCAttributeGroup_Character.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]


--[[
function UGCAttributeGroup_Character:ReceiveEndPlay()
    UGCAttributeGroup_Character.SuperClass.ReceiveEndPlay(self) 
end
--]]


--[[
function UGCAttributeGroup_Character:GetReplicatedProperties()
    return
end
--]]


--[[
function UGCAttributeGroup_Character:GetAvailableServerRPCs()
    return
end
--]]


return UGCAttributeGroup_Character