---@class SkyBox_C:BP_STExtraSkyBox_C
--Edit Below--
local SkyBox = {}
 
--[[
function SkyBox:ReceiveBeginPlay()
    SkyBox.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function SkyBox:ReceiveTick(DeltaTime)
    SkyBox.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function SkyBox:ReceiveEndPlay()
    SkyBox.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function SkyBox:GetReplicatedProperties()
    return
end
--]]

--[[
function SkyBox:GetAvailableServerRPCs()
    return
end
--]]

return SkyBox