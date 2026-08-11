---@class UGCGameState_C:BP_UGCGameState_C
---@field GlobalEventComponent GlobalEventComponent_C
---@field SpecialEventManager SpecialEventManager_C
---@field MobSpawnerManager MobSpawnerManager_C
--Edit Below--
local UGCGameState = {
    isWaiting = true,   -- 在大厅等待阶段时为true，否则为false
}


UGCGameSystem.UGCRequire('Script.Common.ue_enum_custom')
UGCGameSystem.UGCRequire("Script.GameAttribute.game_attribute_type")
UGCGameSystem.UGCRequire("Script.Lib.Lib")
UGCGameSystem.UGCRequire("Script.Common.UGCLog")
UGCGameSystem.UGCRequire("Script.Common.Const")
UGCGameSystem.UGCRequire("Script.Common.Common")
UGCGameSystem.UGCRequire("Script.Common.Config")
UGCGameSystem.UGCRequire("Script.Common.CardCfg")
UGCGameSystem.UGCRequire("Script.Common.ItemCfg")
UGCGameSystem.UGCRequire("Script.Common.GeneTreeCfg")
UGCGameSystem.UGCRequire("Script.Common.TweenManager")
UGCGameSystem.UGCRequire("Script.Common.TimingListUtils")
UGCGameSystem.UGCRequire("Script.Common.RichText")
UGCGameSystem.UGCRequire("Script.Blueprint.UGCGameData")
UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Lobby.LobbyFlow")
UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.UGCItem.UGCItemManager")
UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Game.Breakthrough.BreakthroughManager")


-- 复活机会倒计时总时长（秒）
UGCGameState.RespawnChanceCountDown = 10
-- 当前复活机会剩余倒计时
UGCGameState.CurrentRespawnChanceCountDown = 0
-- 死亡玩家键值表（记录已死亡玩家）
UGCGameState.DeadPlayerKeys = {}


UGCGameState.LevelStateEnum = {
    Game = 0,    -- 进行中
    Victory = 1, -- 胜利
    Failure = 2, -- 失败
}
UGCGameState.LevelState = UGCGameState.LevelStateEnum.Game


function UGCGameState:ReceiveBeginPlay()
    UGCGameState.SuperClass.ReceiveBeginPlay(self)

    self.bIsOpenShovelingAbility = true

    self:Listen()
    if not Lib.IsServer() then
        -- 原生界面修改
        self:SetUIWidget()
        -- self:SetUIPosition();
    end
end


function UGCGameState:Listen()
    UGCGenericMessageSystem.ListenGlobalMessage(self, "UGC.LevelFlow.LevelBegin", self, self.ResetData)
end


function UGCGameState:ResetData()
    self.LevelState = self.LevelStateEnum.Game

    UGCGameState.DeadPlayerNum = 0

    if not Lib.IsServer() and ShopV2Manager then
        ShopV2Manager:CloseMainUI()
    end
end


function UGCGameState:IsAllLobbyTeammateReady()
    local bIsUGCPIE = Lib.IsPIE()

    local bReady = true
    if bIsUGCPIE then --- PIE 默认全部玩家都是一个大厅队伍
        for _, PlayerState in ipairs(self.PlayerArray) do
            bReady = bReady and PlayerState.bIsReadyInLobby
        end
    else
        local PC = UGCGameSystem.GetLocalPlayerController()

        if PC ~= nil then
            for _, PlayerKey in ipairs(PC.LobbyTeammatePlayerKeys) do
                for _, PlayerState in ipairs(self.PlayerArray) do
                    if UGCGameSystem.GetPlayerKeyByPlayerState(PlayerState) == PlayerKey then
                        bReady = bReady and PlayerState.bIsReadyInLobby
                        break
                    end
                end
            end
        else
            bReady = false
        end
    end

    return bReady
end


function UGCGameState:StartRespawnChanceCountDown()
    if Lib.IsServer() and self.CurrentRespawnChanceCountDown <= 0 then
        ugcprint("UGCGameState:StartRespawnChanceCountDown")
        self.RespawnChanceCountDownStartTime = UGCGameSystem.GetServerTimeSec()
        self:CalCulateRespawnChanceCountDown()
    end
end


function UGCGameState:StopRespawnChanceCountDown()
    if Lib.IsServer() and self.CurrentRespawnChanceCountDown > 0 then
        ugcprint("UGCGameState:StopRespawnChanceCountDown")
        if self.RespawnChanceCountDownTimer ~= nil then
            UGCTimerUtility.RemoveLuaTimer(self.RespawnChanceCountDownTimer)
            self.RespawnChanceCountDownTimer = nil
        end

        self.CurrentRespawnChanceCountDown = -1
        UnrealNetwork.RepLazyProperty(self, "CurrentRespawnChanceCountDown")
    end
end


function UGCGameState:CalCulateRespawnChanceCountDown()
    local CurrentTime = UGCGameSystem.GetServerTimeSec()
    self.CurrentRespawnChanceCountDown = self.RespawnChanceCountDown - (CurrentTime - self.RespawnChanceCountDownStartTime)
    UnrealNetwork.RepLazyProperty(self, "CurrentRespawnChanceCountDown")

    if self.CurrentRespawnChanceCountDown > 0 then
        self.RespawnChanceCountDownTimer = UGCTimerUtility.CreateLuaTimer(1, function ()
            self:CalCulateRespawnChanceCountDown()
        end, false)
    else
        -- 触发结算
        ugcprint("UGCGameState:CalCulateRespawnChanceCountDown Begin settlement")
        self.RespawnChanceCountDownTimer = nil
        if #self.PlayerArray > 0 then
            UGCLevelFlowSystem.GameSettle(false)
        end
    end
end


function UGCGameState:OnPlayerDead(PlayerKey)
    if self.DeadPlayerKeys[PlayerKey] == true then
        return
    end
    self.DeadPlayerKeys[PlayerKey] = true

    local DeadPlayerNum = 0
    for PlayerKey, Value in pairs(self.DeadPlayerKeys) do
        DeadPlayerNum = DeadPlayerNum + 1
    end
    ugcprint("UGCGameState:OnPlayerDead Current DeadPlayerNum=" .. tostring(DeadPlayerNum))

    local PlayerNum = #self.PlayerArray
    if DeadPlayerNum >= PlayerNum then
        self:StartRespawnChanceCountDown()
    end
end


function UGCGameState:OnPlayerAlive(PlayerKey)
    if self.DeadPlayerKeys[PlayerKey] == nil then
        return
    end
    self.DeadPlayerKeys[PlayerKey] = nil

    local DeadPlayerNum = 0
    for PlayerKey, Value in pairs(self.DeadPlayerKeys) do
        DeadPlayerNum = DeadPlayerNum + 1
    end
    ugcprint("UGCGameState:OnPlayerAlive Current DeadPlayerNum=" .. tostring(DeadPlayerNum))

    local PlayerNum = #self.PlayerArray
    if DeadPlayerNum < PlayerNum then
        self:StopRespawnChanceCountDown()
    end
end


function UGCGameState:GetAvailableServerRPCs()
    return
end


function UGCGameState:GetReplicatedProperties()
    return { "CurrentRespawnChanceCountDown", "Lazy" }
end


function UGCGameState:OnRep_CurrentRespawnChanceCountDown()
    BreakthroughManager:RefreshRespawnUICountDown(self.CurrentRespawnChanceCountDown)
end


function UGCGameState:OnRep_LobbyInfo()
    print("UGCGameState:OnRep_LobbyInfo")

    LobbyModel.CurrentSelectedModeID = LobbyModel:IsModeIDValid(self.LobbyInfo.SelectedModeID)
        and self.LobbyInfo.SelectedModeID
        or 1001
    LobbyEvent.OnModeSelected(self.LobbyInfo.SelectedModeID)
    LobbyUtils.UpdateWidget(LobbyWidgetType.LWT_MainLobby, { ModeID = self.LobbyInfo.SelectedModeID })
end


function UGCGameState:SetUIWidget()
    -- UGCWidgetManagerSystem.HideWidget(UGCWidgetManagerSystem.GetMainControlUI());
    local path = UGCGameSystem.GetUGCResourcesFullPath('Asset/Blueprint/MainWidget.MainWidget_C')
    UGCWidgetManagerSystem.SetWidgetLayout(path)
    UGCWidgetManagerSystem.GetMainControlUI().NavigatorPanel:SetVisibility(ESlateVisibility.Collapsed)
    UGCWidgetManagerSystem.GetMainControlUI().Image_0:SetVisibility(ESlateVisibility.Collapsed)
end


function UGCGameState:SetUIPosition()
    local widget = {
        UGCWidgetManagerSystem.GetMainControlUI().CanvasEnterSetting,
        UGCWidgetManagerSystem.GetMainControlUI().Canvas_Speaker,
        UGCWidgetManagerSystem.GetMainControlUI().ChatAndChatPanelCanvas
    }
    local vector2D = { { X = -250, Y = 52 }, { X = -250, Y = 104 }, { X = -350, Y = 156 } }
    for k, v in pairs(widget) do
        UGCWidgetManagerSystem.SlotAsCanvasSlot(v):SetPosition(vector2D[k])
    end
end


---【服务端】开始游戏。
function UGCGameState:StartGame()
    if not Lib.IsServer() or not self.isWaiting then
        return
    end
    self.isWaiting = false
    self.MobSpawnerManager:NextWave()
end


---【服务端】结束游戏。
function UGCGameState:EndGame()
    if not Lib.IsServer() or self.isWaiting then
        return
    end
    self.isWaiting = true
end


function UGCGameState:MulticastRPC_EquippedTitle(uid, id)
    ACHVManager.CacheEquippedTitle = id
end


-- 是否在大厅中
function UGCGameState.IsInLobby()
    return UGCGameData.GetGameModeName(UGCMultiMode.GetModeID()) == UGCGameData.ModeName.Lobby
end


return UGCGameState
