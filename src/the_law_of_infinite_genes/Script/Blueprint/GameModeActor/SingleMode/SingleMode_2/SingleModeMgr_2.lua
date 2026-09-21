---@class SingleModeMgr_2_C:UGCLevelActorMgr
--Edit Below--
local SingleModeMgr_2 = {}
 
--[[
function SingleModeMgr_2:ReceiveBeginPlay()
    SingleModeMgr_2.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function SingleModeMgr_2:ReceiveTick(DeltaTime)
    SingleModeMgr_2.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function SingleModeMgr_2:ReceiveEndPlay()
    SingleModeMgr_2.SuperClass.ReceiveEndPlay(self) 
end
--]]

return SingleModeMgr_2