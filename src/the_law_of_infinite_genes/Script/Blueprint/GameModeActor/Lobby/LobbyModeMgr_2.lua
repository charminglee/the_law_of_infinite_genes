---@class LobbyModeMgr_2_C:UGCLevelActorMgr
--Edit Below--
local LobbyModeMgr_2 = {}
 
--[[
function LobbyModeMgr_2:ReceiveBeginPlay()
    LobbyModeMgr_2.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function LobbyModeMgr_2:ReceiveTick(DeltaTime)
    LobbyModeMgr_2.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function LobbyModeMgr_2:ReceiveEndPlay()
    LobbyModeMgr_2.SuperClass.ReceiveEndPlay(self) 
end
--]]

return LobbyModeMgr_2