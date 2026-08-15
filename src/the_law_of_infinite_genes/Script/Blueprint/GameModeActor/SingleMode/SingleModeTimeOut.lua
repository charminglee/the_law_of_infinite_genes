local SingleModeTimeOut = {}

function SingleModeTimeOut:LuaExecute()

end
 
--[[
function SingleModeTimeOut:ReceiveBeginPlay()
    SingleModeTimeOut.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function SingleModeTimeOut:ReceiveTick(DeltaTime)
    SingleModeTimeOut.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function SingleModeTimeOut:ReceiveEndPlay()
    SingleModeTimeOut.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function SingleModeTimeOut:GetReplicatedProperties()
    return
end
--]]

--[[
function SingleModeTimeOut:GetAvailableServerRPCs()
    return
end
--]]

return SingleModeTimeOut