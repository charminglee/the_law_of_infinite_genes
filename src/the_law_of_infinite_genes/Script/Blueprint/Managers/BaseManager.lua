---@diagnostic disable: duplicate-set-field


---@class BaseManager_C:ActorComponent
--Edit Below-- 
local BaseManager = {
    ---@type Actor @属主 Actor
    owner = nil, 
}


function BaseManager:ReceiveBeginPlay()
    BaseManager.SuperClass.ReceiveBeginPlay(self)
    self.owner = self:GetOwner()
    self.HasAuthority = BaseManager.HasAuthority
end


---检查当前对象是否运行在服务器端。
---@return boolean @是否运行在服务器端
function BaseManager:HasAuthority()
    return self.owner and self.owner:HasAuthority()
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