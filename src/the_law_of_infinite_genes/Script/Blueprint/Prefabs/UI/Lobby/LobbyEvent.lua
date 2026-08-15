---@type Delegate
local Delegate = require("common.Delegate")


---大厅 UI 领域事件。
---这里只定义事件契约，不执行流程、网络或界面逻辑。
---@class LobbyEvent
LobbyEvent = LobbyEvent or {
    ---@field OnLobbyFlowSwitchBefore fun(From:string, To:string)
    OnLobbyFlowSwitchBefore = Delegate.New(),
    ---@field OnLobbyFlowSwitchAfter fun(From:string, To:string)
    OnLobbyFlowSwitchAfter = Delegate.New(),
    ---@field OnModeSelected fun(ModeID:int32)
    OnModeSelected = Delegate.New(),
    ---@field OnDifficultySelected fun(Difficulty:string)
    OnDifficultySelected = Delegate.New(),
    ---@field OnLobbyExited fun()
    OnLobbyExited = Delegate.New(),
    ---@field OnMatchStarted fun(bSucceeded:bool)
    OnMatchStarted = Delegate.New(),
    ---@field OnMatchCanceled fun()
    OnMatchCanceled = Delegate.New(),
    ---@field OnMatchSuccess fun()
    OnMatchSuccess = Delegate.New(),
}

return LobbyEvent
