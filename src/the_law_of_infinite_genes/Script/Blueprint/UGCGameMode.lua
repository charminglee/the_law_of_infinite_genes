---@class UGCGameMode_C:BP_UGCGameBase_C
--Edit Below--
local UGCGameMode = {}

---GameMode 生命周期入口：开启基础能力并初始化当前模式流程。
function UGCGameMode:ReceiveBeginPlay()
    UGCGameMode.SuperClass.ReceiveBeginPlay(self)
    self.bIsOpenShovelingAbility = true
    self:InitializeGameFlow(UGCMultiMode.GetModeID())
end

---服务端流程入口：绑定玩家进入事件，并启动所选模式的关卡流。
function UGCGameMode:InitializeGameFlow(ModeID)
    if not self.bPlayerEnterListenerBound then
        UGCGenericMessageSystem.ListenGlobalMessage(
            self,
            UGCGenericMessageSystem.Messages.UGC.Player.PlayerEnter,
            self,
            self.PlayerEnter
        )
        self.bPlayerEnterListenerBound = true
    end

    local ActorManagerPath = UGCGameData.GetGameModeActorMgrConfig(ModeID)
    if not ActorManagerPath then
        ugcprint("[UGCGameMode] missing GameModeActorMgr for ModeID=" .. tostring(ModeID))
        return false
    end
    UGCGameSystem.LoadStreamLevel(UGCGameData.GetSkyBox(ModeID), true, false)
    UGCLevelFlowSystem.EnableLevelFlow(UGCGameSystem.GetUGCResourcesFullPath(ActorManagerPath))
    return true
end

---玩家进入默认战斗模式时，通知 GameState 正式启动游戏。
---@param MessageOrPlayerKey any
---@param PlayerKey number|nil
function UGCGameMode:PlayerEnter(MessageOrPlayerKey, PlayerKey)
    PlayerKey = PlayerKey or MessageOrPlayerKey
    local ModeID = UGCMultiMode.GetModeID()
    if ModeID == UGCGameData.ModeID.DefaultGameplay and UGCGameSystem.GameState then
        UGCGameSystem.GameState:StartGame()
    end
end

return UGCGameMode
