---@class UGCGameMode_C:BP_UGCGameBase_C
--Edit Below--
local UGCGameMode = {}; 


function UGCGameMode:ReceiveBeginPlay()
    UGCGameMode.SuperClass.ReceiveBeginPlay(self)
    GameMode = self
    local ModeID = UGCMultiMode.GetModeID()
    self:InitMode(ModeID)
end

function UGCGameMode:InitMode(ModeID)
    if GameState.IsInLobby() then
        -- UGCGenericMessageSystem.ListenGlobalMessage(self,  UGCGenericMessageSystem.Messages.UGC.Player.PlayerEnter, self, self.ExecuteStartMatch)
        -- UGCGameSystem.LoadStreamLevel("LobbySkyBox", true, false)
    else
        -- UGCGameSystem.LoadStreamLevel("BattleSkyBox", true, false)
    end

    ugcprint("UGCGameMode:ReceiveBeginPlay ModeID=" .. ModeID)

    UGCLevelFlowSystem.EnableLevelFlow(UGCGameSystem.GetUGCResourcesFullPath(UGCGameData.GetGameModeActorMgrConfig(ModeID)))
    
end

-- function UGCGameMode:ReceiveTick(DeltaTime)

-- end


-- function UGCGameMode:ReceiveEndPlay()
 
-- end


return UGCGameMode;