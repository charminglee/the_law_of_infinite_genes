---@class LobbyModeMgr_C:UGCLevelActorMgr
--Edit Below--
local LobbyModeMgr = {}
 
--[[
function LobbyModeMgr:ReceiveBeginPlay()
    LobbyModeMgr.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function LobbyModeMgr:ReceiveTick(DeltaTime)
    LobbyModeMgr.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function LobbyModeMgr:ReceiveEndPlay()
    LobbyModeMgr.SuperClass.ReceiveEndPlay(self) 
end
--]]

return LobbyModeMgr