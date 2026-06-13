---@class UGCGameState: ASTExtraGameStateBase
UGCGameSystem.UGCRequire('Script.Common.ue_enum_custom')
local UGCGameState = {
    isWaiting = true,   -- 在大厅等待阶段时为true，否则为false
    totalWaves = 10,    -- 总波数
    waveIndex = -1,     -- 当前波数
    specialEvent = -1,  -- 当前特殊事件
}


UGCGameSystem.UGCRequire("Script.Common.ue_enum_custom")
UGCGameSystem.UGCRequire("Script.GameAttribute.game_attribute_type")
UGCGameSystem.UGCRequire("Script.Common.Const")
UGCGameSystem.UGCRequire("Script.Common.Config")
UGCGameSystem.UGCRequire("Script.Common.Common")
UGCGameSystem.UGCRequire("Script.Common.UGCLog")
UGCGameSystem.UGCRequire("Script.Common.TweenManager")


local function InitSubControl(mainUI)
    if mainUI.index.topBar.IndexUIControl == nil then
        mainUI.index.topBar.IndexUIControl = mainUI.index
    end
end


function UGCGameState:ReceiveBeginPlay()
    self.SuperClass.ReceiveBeginPlay(self)
    TweenManager:Initialize();
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


---开始游戏
function UGCGameState:StartGame()
    self.isWaiting = false

    if not self:HasAuthority() then
        return
    end

    -- 传送所有玩家到关卡
    local levelStart = UGCActorComponentUtility.GetActorByActorInstancePath(InstancePath.LevelStart)
    local loc = levelStart:K2_GetActorLocation()
    for _, controller in pairs(UGCGameSystem.GetAllPlayerController(false)) do
        UGCPlayerControllerSystem.TeleportTo(controller, loc.X, loc.Y, loc.Z)
    end

    -- 启动刷怪
    -- local sm = UGCActorComponentUtility.GetActorByActorInstancePath(InstancePath.MobSpawnerManager)
    -- sm:StartSpawnerManager()
end


---结束游戏
function UGCGameState:EndGame()
    if self.isWaiting then
        return
    end

    self.isWaiting = true
end


---触发特殊事件
function UGCGameState:TriggerSpecialEvent(specialEvent, autoStop)
    self.specialEvent = specialEvent
    if autoStop then
        -- 自动触发事件结束
        local dur = SpecialEventConfig[specialEvent].Duration
        local delegate = ObjectExtend.CreateDelegate(self, self.StopSpecialEvent)
        KismetSystemLibrary.K2_SetTimerDelegateForLua(delegate, self, dur, false)
    end

    if not self:HasAuthority() then
        return
    end

    -- 给玩家添加对应buff
    local buffCls = ClassPath[specialEvent]
    local allPlayers = UGCGameSystem.GetAllPlayerPawn()
    for _, pawn in pairs(allPlayers) do
        UGCPersistEffectSystem.AddBuffByClass(pawn, buffCls)
    end

    -- 腐秽瘴潮：所有怪物获得全属性加成
    if specialEvent == SpecialEvent.PutridMiasma then
        local buffCls = ClassPath[Buff.PutridMiasma_Monster]
        local allMonsters = {}
        GameplayStatics.GetAllActorsOfClass(self, UGCObjectUtility.LoadClass(ClassPath.MonsterTemplate), allMonsters)
        for _, actor in pairs(allMonsters) do
            UGCPersistEffectSystem.AddBuffByClass(actor, buffCls)
        end
    end
end


---结束当前正在进行的特殊事件
function UGCGameState:StopSpecialEvent()
    if self.specialEvent == -1 then
        return
    end

    self.specialEvent = -1
end


return UGCGameState
