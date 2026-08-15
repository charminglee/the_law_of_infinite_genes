UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Lobby.LobbyUtils")


---大厅页面状态枚举。
---@class LobbyState
LobbyFlowState = LobbyFlowState or {
    LFS_None = "LFS_None",
    LFS_Lobby = "LFS_Lobby",
    LFS_ModeSelect = "LFS_ModeSelect",
    LFS_ExitConfirm = "LFS_ExitPopup",
}

---@class LobbyStateSwitcher
local LobbyStateSwitcher = {}

local TransitionRules = {
    [LobbyFlowState.LFS_None] = {
        [LobbyFlowState.LFS_Lobby] = true,
    },
    [LobbyFlowState.LFS_Lobby] = {
        [LobbyFlowState.LFS_ModeSelect] = true,
        [LobbyFlowState.LFS_ExitConfirm] = true,
    },
    [LobbyFlowState.LFS_ModeSelect] = {
        [LobbyFlowState.LFS_Lobby] = true,
    },
    [LobbyFlowState.LFS_ExitConfirm] = {
        [LobbyFlowState.LFS_Lobby] = true,
    },
}

local StateHandlers = {
    [LobbyFlowState.LFS_None] = {
        Enter = function() end,
        Leave = function()
            LobbyModel:Init()
        end,
    },
    [LobbyFlowState.LFS_Lobby] = {
        Enter = function()
            LobbyUtils.OpenAndUpdateWidget(LobbyWidgetType.LWT_MainLobby, {
                ModeID = LobbyModel:GetCurrentSelectedModeID(),
                bIsMatching = LobbyModel:IsMatching(),
            })
        end,
        Leave = function()
            local PlayerController = UGCGameSystem.GetLocalPlayerController()
            if PlayerController then
                PlayerController.IsCurrentUsePersistStateView = false
            end
        end,
    },
    [LobbyFlowState.LFS_ModeSelect] = {
        Enter = function()
            LobbyUtils.CloseWidget(LobbyWidgetType.LWT_MainLobby)
            LobbyUtils.OpenAndUpdateWidget(LobbyWidgetType.LWT_ModeSelect, {
                FocusedMode = LobbyModel:GetCurrentSelectedModeID(),
            })
        end,
        Leave = function()
            LobbyUtils.CloseWidget(LobbyWidgetType.LWT_ModeSelect)
            LobbyUtils.CloseWidget(LobbyWidgetType.LWT_ModeDifficultyTip)
        end,
    },
    [LobbyFlowState.LFS_ExitConfirm] = {
        Enter = function()
            LobbyUtils.OpenWidget(LobbyWidgetType.LWT_ClosePopupsTips)
        end,
        Leave = function()
            LobbyUtils.CloseWidget(LobbyWidgetType.LWT_ClosePopupsTips)
        end,
    },
}

---以下入口保留给已有蓝图/Lua 调用，具体状态切换仍统一由 Switch 编排。
function LobbyStateSwitcher:Init()
    return LobbyModel:Init()
end

---进入大厅主页时执行对应页面副作用。
function LobbyStateSwitcher:Lobby_Enter()
    StateHandlers[LobbyFlowState.LFS_Lobby].Enter()
end

---离开大厅主页时清理对应页面状态。
function LobbyStateSwitcher:Lobby_Leave()
    StateHandlers[LobbyFlowState.LFS_Lobby].Leave()
end

---进入模式选择页时执行对应页面副作用。
function LobbyStateSwitcher:ModeSelect_Enter()
    StateHandlers[LobbyFlowState.LFS_ModeSelect].Enter()
end

---离开模式选择页并关闭其附属提示。
function LobbyStateSwitcher:ModeSelect_Leave()
    StateHandlers[LobbyFlowState.LFS_ModeSelect].Leave()
end

---打开退出确认弹窗。
function LobbyStateSwitcher:ExitConfirm_Enter()
    StateHandlers[LobbyFlowState.LFS_ExitConfirm].Enter()
end

---关闭退出确认弹窗。
function LobbyStateSwitcher:ExitConfirm_Leave()
    StateHandlers[LobbyFlowState.LFS_ExitConfirm].Leave()
end

---@param InState string
---@return boolean
function LobbyStateSwitcher:IsValid(InState)
    return type(InState) == "string" and StateHandlers[InState] ~= nil
end

---@param From string
---@param To string
---@return boolean
function LobbyStateSwitcher:CanSwitch(From, To)
    if not self:IsValid(From) or not self:IsValid(To) then
        return false
    end
    return TransitionRules[From] ~= nil and TransitionRules[From][To] == true
end

---@param From string
---@param To string
---@return boolean
function LobbyStateSwitcher:Switch(From, To)
    if not self:CanSwitch(From, To) then
        return false
    end

    StateHandlers[From].Leave()
    StateHandlers[To].Enter()
    return true
end

return LobbyStateSwitcher
