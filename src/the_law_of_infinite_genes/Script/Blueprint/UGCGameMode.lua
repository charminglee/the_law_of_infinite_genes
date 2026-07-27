---@class UGCGameMode_C:BP_UGCGameBase_C
--Edit Below--
local UGCGameMode = {}; 
UGCGameMode.IsStartMatch = false


function UGCGameMode:ReceiveBeginPlay()
    UGCGameMode.SuperClass.ReceiveBeginPlay(self)
    self.bIsOpenShovelingAbility = true
    GameMode = self
    local ModeID = UGCMultiMode.GetModeID()
    self:InitMode(ModeID)
end

function UGCGameMode:InitMode(modeId)
    -- if GameState.IsInLobby() then
    --     -- UGCGameSystem.LoadStreamLevel("LobbySkyBox", true, false)
    -- else
    --     -- UGCGameSystem.LoadStreamLevel("BattleSkyBox", true, false)
    -- end
    UGCGenericMessageSystem.ListenGlobalMessage(self,  UGCGenericMessageSystem.Messages.UGC.Player.PlayerEnter, self, self.PlayerEnter)
    UGCLevelFlowSystem.EnableLevelFlow(UGCGameSystem.GetUGCResourcesFullPath(UGCGameData.GetGameModeActorMgrConfig(modeId)))
end

function UGCGameMode:PlayerEnter(playerKey)
    local ModeID = UGCMultiMode.GetModeID()
    if ModeID == 1002 then
        GameState:StartGame();
    end
end

-- function UGCGameMode:ReceiveTick(DeltaTime)

-- end


-- function UGCGameMode:ReceiveEndPlay()
 
-- end


return UGCGameMode;