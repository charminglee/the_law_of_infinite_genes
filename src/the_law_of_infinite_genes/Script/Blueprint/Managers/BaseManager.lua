---@class BaseManager_C:ActorComponent
--Edit Below-- 
local BaseManager = {
    ---@type Actor @属主 Actor
    owner = nil, 
}


function BaseManager:ReceiveBeginPlay()
    BaseManager.SuperClass.ReceiveBeginPlay(self)
    self.owner = self:GetOwner()
end



--[[
function BaseManager:ReceiveTick(DeltaTime)
    BaseManager.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]


--[[
function BaseManager:ReceiveEndPlay()
    BaseManager.SuperClass.ReceiveEndPlay(self) 
end
--]]


return BaseManager