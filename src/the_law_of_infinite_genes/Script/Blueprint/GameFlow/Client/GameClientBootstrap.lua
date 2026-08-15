---客户端游戏入口编排。负责大厅/战斗 UI 启动以及 GamePart 就绪等待。
local GameClientBootstrap = {}

local LobbyFlowController = UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Lobby.LobbyFlow")
local LobbyUtilsModule = UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Lobby.LobbyUtils")

---启动大厅客户端流程。
---@param Controller UGCPlayerController_C
function GameClientBootstrap.InitializeLobby(Controller)
    LobbyFlowController:Go(LobbyFlowState.LFS_Lobby)
    GameClientBootstrap.WaitForGamePartReady(Controller)
end

---启动战斗客户端流程，并监听 GamePart 加载完成事件。
---@param Controller UGCPlayerController_C
function GameClientBootstrap.InitializeFighting(Controller)
    LobbyUtilsModule.OpenWidget(LobbyWidgetType.LWT_RaidInstance)
    local Message = UGCGenericMessageSystem.Messages.UGC.GamePart.GamePartLoaded
    UGCGenericMessageSystem.ListenGlobalMessage(Controller, Message, Controller, function()
        Controller.GamePartReady = true
    end)
    GameClientBootstrap.WaitForGamePartReady(Controller)
end

---等待 GamePart 与 GameState 同时可用，然后回调 Controller 的兼容入口。
---@param Controller UGCPlayerController_C
function GameClientBootstrap.WaitForGamePartReady(Controller)
    local TimingList = TimingListUtils.NewList()
    TimingListUtils.Add(TimingList, 0, Controller, "GamePartReady")
    TimingListUtils.Add(
        TimingList,
        0,
        UGCGameSystem,
        "GameState",
        Controller,
        Controller.RecieveGamePartReady
    )
    TimingListUtils.Activate(TimingList, 0.2, 20)
end

return GameClientBootstrap
