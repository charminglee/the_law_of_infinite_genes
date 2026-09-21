---@class SingleModeMgr_C:UGCLevelActorMgr
--Edit Below--
local SingleModeMgr_1 = {}
 
--[[
function SingleModeMgr_1:ReceiveBeginPlay()
    SingleModeMgr_1.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function SingleModeMgr_1:ReceiveTick(DeltaTime)
    SingleModeMgr_1.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function SingleModeMgr_1:ReceiveEndPlay()
    SingleModeMgr_1.SuperClass.ReceiveEndPlay(self) 
end
--]]

return SingleModeMgr_1