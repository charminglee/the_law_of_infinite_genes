---@class UGCGameState_C:BP_UGCGameState_C
---@field SpecialEventManager SpecialEventManager_C
---@field CoinManager CoinManager_C
--Edit Below--
local UGCGameState = {
    isWaiting = true,   -- 在大厅等待阶段时为true，否则为false
    totalWaves = 10,    -- 总波数
    waveIndex = -1,     -- 当前波数
}


UGCGameSystem.UGCRequire('Script.Common.ue_enum_custom')
UGCGameSystem.UGCRequire("Script.GameAttribute.game_attribute_type")
UGCGameSystem.UGCRequire("Script.Common.Const")
UGCGameSystem.UGCRequire("Script.Common.Config")
UGCGameSystem.UGCRequire("Script.Common.Common")
UGCGameSystem.UGCRequire("Script.Common.UGCLog")
UGCGameSystem.UGCRequire("Script.Common.TweenManager")
UGCGameSystem.UGCRequire("Script.Common.EventSystem")


local function InitSubControl(mainUI)
    if mainUI.index.topBar.IndexUIControl == nil then
        mainUI.index.topBar.IndexUIControl = mainUI.index
    end
end


function UGCGameState:ReceiveBeginPlay()
    UGCGameState.SuperClass.ReceiveBeginPlay(self)
    GameState = self
    TweenManager.Initialize()

    if self:HasAuthority() == true then 
        -- 只有客户端加载UI
    else
        -- local MainUI = UE.LoadClass( UGCMapInfoLib.GetRootLongPackagePath().. "Asset/Blueprint/Prefabs/WidgetLayout/lobby.lobby_C");
        -- -- 加载 MainUI 蓝图类
        -- local PlayerController = GameplayStatics.GetPlayerController(self, 0);
        -- -- 获得当前PlayerController
        -- local MainUI_BP = UserWidget.NewWidgetObjectBP(PlayerController, MainUI);
        -- -- 加载 MainUI
        -- MainUI_BP:AddToViewport(10000);
        -- -- 将 MainUI 加入视口，显示UI
        -- -- 隐藏原生界面

        local path = UGCGameSystem.GetUGCResourcesFullPath('Asset/Blueprint/Prefabs/WidgetLayout/hideLayout.hideLayout_C')
        UGCWidgetManagerSystem.SetWidgetLayout(path)
        UGCWidgetManagerSystem.GetMainControlUI().NavigatorPanel:SetVisibility(ESlateVisibility.Collapsed)
        UGCWidgetManagerSystem.GetMainControlUI().Image_0:SetVisibility(ESlateVisibility.Collapsed)
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
    self:_TpAllPlayers()
    self:_StartMobSpawnerManager()
end


---结束游戏。
function UGCGameState:EndGame()
    if not self:HasAuthority() or self.isWaiting then
        return
    end

    self.isWaiting = true
end


return UGCGameState
