---@diagnostic disable: duplicate-set-field


---@class BaseComponent_C:ActorComponent
--Edit Below--
local BaseComponent = {
    owner = nil, ---@type Actor @属主Actor
}


function BaseComponent:ReceiveBeginPlay()
    BaseComponent.SuperClass.ReceiveBeginPlay(self)
    self.owner = self:GetOwner()
    self.HasAuthority = BaseComponent.HasAuthority
end


---检查当前对象是否运行在服务器端。
---@return boolean @是否运行在服务器端
function BaseComponent:HasAuthority()
    return self.owner and self.owner:HasAuthority()
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