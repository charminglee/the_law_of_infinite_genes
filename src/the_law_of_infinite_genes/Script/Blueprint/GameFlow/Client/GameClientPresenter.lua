---客户端表现适配器。只把已同步状态映射到 UI 和委托，不参与服务端业务决策。
local GameClientPresenter = {}

local PromiseFuture = require("common.PromiseFuture")
local GameTypes = UGCGameSystem.UGCRequire("Script.Blueprint.GameFlow.Shared.GameTypes")
local LobbyFlowController = UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Lobby.LobbyFlow")
local LobbyUtilsModule = UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Lobby.LobbyUtils")
local LobbyModelModule = UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Lobby.LobbyModel")
local BreakthroughPresenter = UGCGameSystem.UGCRequire(
    "Script.Blueprint.Prefabs.UI.Game.Breakthrough.BreakthroughManager"
)

---替换主界面布局并隐藏项目不需要的原生控件。
function GameClientPresenter.SetMainUIWidget()
    if UGCGameSystem.IsServer() then
        return
    end

    local Path = UGCGameSystem.GetUGCResourcesFullPath("Asset/Blueprint/MainWidget.MainWidget_C")
    UGCWidgetManagerSystem.SetWidgetLayout(Path)
    local MainUI = UGCWidgetManagerSystem.GetMainControlUI()
    if not MainUI then
        return
    end
    if MainUI.NavigatorPanel then
        MainUI.NavigatorPanel:SetVisibility(ESlateVisibility.Collapsed)
    end
    if MainUI.Image_0 then
        MainUI.Image_0:SetVisibility(ESlateVisibility.Collapsed)
    end
end

---按项目布局调整设置、语音和聊天控件位置。
function GameClientPresenter.SetMainUIPosition()
    if UGCGameSystem.IsServer() then
        return
    end

    local MainUI = UGCWidgetManagerSystem.GetMainControlUI()
    if not MainUI then
        return
    end
    local Widgets = { MainUI.CanvasEnterSetting, MainUI.Canvas_Speaker, MainUI.ChatAndChatPanelCanvas }
    local Positions = { { X = -250, Y = 52 }, { X = -250, Y = 104 }, { X = -350, Y = 156 } }
    for Index, Widget in ipairs(Widgets) do
        if Widget then
            UGCWidgetManagerSystem.SlotAsCanvasSlot(Widget):SetPosition(Positions[Index])
        end
    end
end

---关卡重置时关闭可能残留的商店主界面。
function GameClientPresenter.OnLevelReset()
    if not UGCGameSystem.IsServer() and ShopV2Manager then
        ShopV2Manager:CloseMainUI()
    end
end

---把复制下来的全灭倒计时刷新到复活界面。
---@param GameState UGCGameState_C
function GameClientPresenter.OnRespawnCountdownReplicated(GameState)
    if BreakthroughPresenter then
        BreakthroughPresenter:RefreshRespawnUICountDown(GameState.CurrentRespawnChanceCountDown)
    end
end

---组装结算界面需要的玩家展示与战绩快照。
---@param PlayerState UGCPlayerState_C
---@return table
function GameClientPresenter.BuildResultPlayerData(PlayerState)
    return {
        GameRecordData = PlayerState.GameRecordData,
        UID = PlayerState:GetInt64UID(),
        IconURL = PlayerState.IconURL,
        Gender = PlayerState.Gender,
        FrameLevel = PlayerState.FrameLevel,
        PlayerLevel = PlayerState.PlayerLevel,
        PlayerName = PlayerState.PlayerName,
        PlayerKey = PlayerState.PlayerKey,
    }
end

---把玩家数据加入或更新到战斗结算缓存。
---@param PlayerState UGCPlayerState_C
function GameClientPresenter.RegisterResultPlayerState(PlayerState)
    BreakthroughPresenter:AddOrUpdateResultPlayerState(
        GameClientPresenter.BuildResultPlayerData(PlayerState)
    )
end

---战绩复制完成后的客户端表现。
---@param PlayerState UGCPlayerState_C
function GameClientPresenter.OnGameRecordDataReplicated(PlayerState)
    PlayerState.PlayerGameGameRecordDataDelegate(PlayerState.GameRecordData)
    if PlayerState.SettleParams and PlayerState.SettleParams.bIsSettled then
        BreakthroughPresenter:RefreshBattleResultUI()
    end
    GameClientPresenter.RegisterResultPlayerState(PlayerState)
end

---解锁记录复制后，在大厅就绪时刷新难度锁定状态。
---@param PlayerState UGCPlayerState_C
function GameClientPresenter.OnGameCompletionRecordReplicated(PlayerState)
    if not UGCGameData.IsLobbyMode(UGCMultiMode.GetModeID()) then
        return
    end

    local function RefreshLobby()
        LobbyUtilsModule.UpdateWidget(LobbyWidgetType.LWT_MainLobby, {})
    end

    if UGCGameSystem.GameState and LobbyFlowController:CurrentState() == LobbyFlowState.LFS_Lobby then
        RefreshLobby()
        return
    end
    PromiseFuture.New():Set(function(Future)
        while true do
            if UGCGameSystem.GameState and LobbyFlowController:CurrentState() == LobbyFlowState.LFS_Lobby then
                RefreshLobby()
                return
            end
            Future:Yield()
        end
    end):AutoResume(PlayerState, 0.2, 60)
end

---大厅准备状态复制完成后的客户端表现。
---@param PlayerState UGCPlayerState_C
function GameClientPresenter.OnLobbyReadyReplicated(PlayerState)
    PlayerState.ReadyStateUpdateDelegate()
    LobbyUtilsModule.UpdateWidget(LobbyWidgetType.LWT_MainLobby, {})
end

---大厅队长状态复制完成后的客户端表现。
---@param PlayerState UGCPlayerState_C
function GameClientPresenter.OnLobbyLeaderReplicated(PlayerState)
    PlayerState.ReadyStateUpdateDelegate()
    LobbyUtilsModule.UpdateWidget(LobbyWidgetType.LWT_MainLobby, {})
end

---在线状态复制完成后的客户端表现。
---@param PlayerState UGCPlayerState_C
function GameClientPresenter.OnOnlineStateReplicated(PlayerState)
    PlayerState.OnlineStateUpdateDelegate()
end

---结算参数复制完成后通知所属 Controller 打开结果界面。
---@param PlayerState UGCPlayerState_C
function GameClientPresenter.OnSettleParamsReplicated(PlayerState)
    if not PlayerState.SettleParams or not PlayerState.SettleParams.bIsSettled then
        return
    end
    local Controller = UGCGameSystem.GetPlayerControllerByPlayerState(PlayerState)
    if Controller then
        Controller:OnGameSettle()
    end
end

---生存状态复制完成后切换复活界面。
---@param PlayerState UGCPlayerState_C
function GameClientPresenter.OnAliveStateReplicated(PlayerState)
    local Controller = UGCGameSystem.GetPlayerControllerByPlayerState(PlayerState)
    if not Controller then
        return
    end
    if PlayerState.AliveState == GameTypes.AliveState.Alive then
        BreakthroughPresenter:CloseRespawnUI()
    else
        Controller:OpenRespawnUI()
    end
end

---打开当前模式对应的复活界面。
function GameClientPresenter.OpenRespawnUI()
    if not UGCGameSystem.IsServer() then
        BreakthroughPresenter:OpenRespawnUI(UGCMultiMode.GetModeID())
    end
end

---根据所属 PlayerState 的结算快照打开战斗结果界面。
---@param Controller UGCPlayerController_C
function GameClientPresenter.OpenBattleResult(Controller)
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerController(Controller)
    if not PlayerState then
        return
    end
    local bUnlockedNewMode = PlayerState.SettleParams.bUnlockedNewMode
    if bUnlockedNewMode == nil then
        bUnlockedNewMode = PlayerState.IsModeUnLock
    end
    BreakthroughPresenter:OpenBattleResultUI(
        UGCMultiMode.GetModeID(),
        PlayerState.SettleParams.bIsFinished,
        bUnlockedNewMode
    )
    BreakthroughPresenter:CloseRespawnUI()
end

---队友列表复制完成后广播 Controller 的本地更新委托。
---@param Controller UGCPlayerController_C
function GameClientPresenter.OnLobbyTeammatesReplicated(Controller)
    Controller.OnLobbyTeammatePlayerKeysUpdate()
end

---大厅快照复制完成后交给 LobbyModel 应用。
---@param Controller UGCPlayerController_C
function GameClientPresenter.OnLobbyInfoReplicated(Controller)
    LobbyModelModule:ApplyLobbyInfo(Controller.LobbyInfo)
end

---GamePart 与 GameState 就绪后恢复当前生存和结算表现。
---@param Controller UGCPlayerController_C
function GameClientPresenter.OnGamePartReady(Controller)
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerController(Controller)
    if not PlayerState then
        return
    end
    if not UGCGameData.IsLobbyMode(UGCMultiMode.GetModeID()) then
        RaidInstanceManager.MainUI.RaidInstanceCardGrid:RefreshCardLists()
    end
    if not PlayerState.SettleParams or not PlayerState.SettleParams.bIsSettled then
        PlayerState:OnRep_AliveState()
    end
    PlayerState:OnRep_SettleParams()
end

return GameClientPresenter
