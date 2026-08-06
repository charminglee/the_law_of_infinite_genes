---@class BaseComponent_C:ActorComponent
--Edit Below--
local BaseComponent = {
    owner = nil, ---@type Actor @属主 Actor
}


function BaseComponent:ReceiveBeginPlay()
    BaseComponent.SuperClass.ReceiveBeginPlay(self)
    self.owner = self:GetOwner()
end


--[[
function BaseComponent:ReceiveBeginPlay()
    BaseComponent.SuperClass.ReceiveBeginPlay(self)
end
--]]


--[[
function BaseComponent:ReceiveTick(DeltaTime)
    BaseComponent.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]


--[[
function BaseComponent:ReceiveEndPlay()
    BaseComponent.SuperClass.ReceiveEndPlay(self) 
end
--]]


return BaseComponent