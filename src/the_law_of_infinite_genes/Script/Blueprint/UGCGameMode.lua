---@class UGCGameMode_C:BP_UGCGameBase_C
--Edit Below--
local UGCGameMode = {}; 


function UGCGameMode:ReceiveBeginPlay()
    self.SuperClass.ReceiveBeginPlay(self)
    GameMode = self
end


-- function UGCGameMode:ReceiveTick(DeltaTime)

-- end


-- function UGCGameMode:ReceiveEndPlay()
 
-- end


return UGCGameMode;