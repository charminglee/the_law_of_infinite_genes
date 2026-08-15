---单人模式最终结算节点。只负责收集本关玩家并分发结算命令。
local SingleModeSettlement = {}

---为当前关卡中的所有有效玩家执行一次幂等结算。
---@param InstanceID any 当前关卡实例 ID，由关卡流传入
---@param IsFinish boolean|nil nil 按成功处理，false 表示失败
function SingleModeSettlement:LuaExecuteWithFinish(InstanceID, IsFinish)
    if not UGCGameSystem.IsServer() then
        return
    end

    local PlayerControllers = UGCLevelFlowSystem.GetAllPlayerControllerInCurrentLevel()
    if not PlayerControllers or #PlayerControllers == 0 then
        UGCLog.Log(
            "[SingleModeSettlement] no player in current level, InstanceID=%s",
            tostring(InstanceID)
        )
        return
    end

    local SettledCount = 0
    for _, PlayerController in pairs(PlayerControllers) do
        local PlayerState = UGCGameSystem.GetPlayerStateByPlayerController(PlayerController)
        if PlayerState and PlayerState:Settle(IsFinish) then
            SettledCount = SettledCount + 1
        end
    end

    UGCLog.Log(
        "[SingleModeSettlement] InstanceID=%s, IsFinish=%s, PlayerCount=%d, SettledCount=%d",
        tostring(InstanceID),
        tostring(IsFinish ~= false),
        #PlayerControllers,
        SettledCount
    )
end

return SingleModeSettlement
