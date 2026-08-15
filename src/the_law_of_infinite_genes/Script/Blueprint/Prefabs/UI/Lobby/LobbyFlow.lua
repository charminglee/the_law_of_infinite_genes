UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Lobby.LobbyUtils")
UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Lobby.LobbyModel")
UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Lobby.LobbyEvent")

---@type LobbyStateSwitcher
local LobbyStateSwitcher = UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Lobby.LobbyState")


---大厅页面流程控制器。
---只负责校验和编排状态切换；具体页面副作用由 LobbyState 执行。
---@class LobbyFlow
LobbyFlow = LobbyFlow or {}

local FlowRuntime = {
    CurrentState = LobbyFlowState.LFS_None,
    bIsSwitching = false,
}

---@param From string
---@param To string
---@return boolean
function LobbyFlow:CanGO(From, To)
    if UGCGameSystem.IsServer() then
        return false
    end
    return LobbyStateSwitcher:CanSwitch(From or FlowRuntime.CurrentState, To)
end

---@param To string
---@return boolean
function LobbyFlow:Go(To)
    if UGCGameSystem.IsServer() or FlowRuntime.bIsSwitching then
        return false
    end

    local From = FlowRuntime.CurrentState
    if not self:CanGO(From, To) then
        ugcprint(string.format("[LobbyFlow] rejected transition: %s -> %s", tostring(From), tostring(To)))
        return false
    end

    FlowRuntime.bIsSwitching = true
    LobbyEvent.OnLobbyFlowSwitchBefore(From, To)

    local bSucceeded = LobbyStateSwitcher:Switch(From, To)
    if bSucceeded then
        FlowRuntime.CurrentState = To
        LobbyEvent.OnLobbyFlowSwitchAfter(From, To)
    end

    FlowRuntime.bIsSwitching = false
    return bSucceeded
end

---@return string
function LobbyFlow:CurrentState()
    return FlowRuntime.CurrentState
end

return LobbyFlow
