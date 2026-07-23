---@class UGCGameState_C:BP_UGCGameState_C
---@field GlobalEventComponent GlobalEventComponent_C
---@field SpecialEventManager SpecialEventManager_C
--Edit Below--
local UGCGameState = {
    isWaiting = true,   -- 在大厅等待阶段时为true，否则为false
    totalWaves = 10,    -- 总波数
    waveIndex = -1,     -- 当前波数
}


UGCGameSystem.UGCRequire('Script.Common.ue_enum_custom')
UGCGameSystem.UGCRequire("Script.GameAttribute.game_attribute_type")
UGCGameSystem.UGCRequire("Script.Lib.Lib")
UGCGameSystem.UGCRequire("Script.Common.Const")
UGCGameSystem.UGCRequire("Script.Common.Common")
UGCGameSystem.UGCRequire("Script.Common.Config")
UGCGameSystem.UGCRequire("Script.Common.Card")
UGCGameSystem.UGCRequire("Script.Common.UGCLog")
UGCGameSystem.UGCRequire("Script.Common.TweenManager")
UGCGameSystem.UGCRequire("Script.Blueprint.UGCGameData")


local function InitSubControl(mainUI)
    if mainUI.index.topBar.IndexUIControl == nil then
        mainUI.index.topBar.IndexUIControl = mainUI.index
    end
end


function UGCGameState:ReceiveBeginPlay()
    UGCGameState.SuperClass.ReceiveBeginPlay(self)
    self.bIsOpenShovelingAbility = true
    GameState = self

    if not self:HasAuthority() then 
        -- 原生界面修改
        UGCWidgetManagerSystem.HideWidget(UGCWidgetManagerSystem.GetMainControlUI());
        -- local path = UGCGameSystem.GetUGCResourcesFullPath('Asset/Blueprint/MainWidget.MainWidget_C');
        -- UGCWidgetManagerSystem.SetWidgetLayout(path);
    end
end


-- function UGCGameState:ReceiveTick(DeltaTime)
-- end


-- function UGCGameState:ReceiveEndPlay()
-- end


function UGCGameState:_TpAllPlayers()
    local levelStart = UGCActorComponentUtility.GetActorByActorInstancePath(InstancePath.LevelStart)
    local loc = levelStart:K2_GetActorLocation()
    for _, c in pairs(UGCGameSystem.GetAllPlayerController(false)) do
        UGCPlayerControllerSystem.TeleportTo(c, loc.X, loc.Y, loc.Z)
    end
end


function UGCGameState:_StartMobSpawnerManager()
    local sm = UGCActorComponentUtility.GetActorByActorInstancePath(InstancePath.MobSpawnerManager)
    sm:StartSpawnerManager()
end


---开始游戏。
function UGCGameState:StartGame()
    if not self:HasAuthority() then
        return
    end

    self.isWaiting = false
    -- self:_TpAllPlayers()
    self:_StartMobSpawnerManager()
end


---结束游戏。
function UGCGameState:EndGame()
    if not self:HasAuthority() or self.isWaiting then
        return
    end

    self.isWaiting = true
end


--【客户端】佩戴称号广播事件。
function UGCGameState:MulticastRPC_EquippedTitle(uid, id)
    ACHVManager.CacheEquippedTitle = id;
end

-- 是否在大厅中
function UGCGameState.IsInLobby()
   return UGCGameData.GetGameModeName(UGCMultiMode.GetModeID()) == UGCGameData.ModeName.Lobby
end

return UGCGameState