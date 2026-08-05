local SingleMode_1_Settle = {}

function SingleMode_1_Settle:LuaExecuteWithFinish(InstanceId, IsFinish)

    if not IsFinish then
        -- 如果关卡失败，则返回，若需自定义逻辑可在这里处理
        print("SingleMode_1 Failed")
        UGCGameSystem.GameState.LevelState = UGCGameSystem.GameState.LevelStateEnum.Failure
        return
    end

    ugcprint("SingleMode_1_Settle:LuaExecuteWithFinish")
    UGCGameSystem.GameState.LevelState = UGCGameSystem.GameState.LevelStateEnum.Victory

    -- 获取当前InstanceId内的所有玩家
    local AllPlayer = UGCLevelFlowSystem.GetAllPlayerControllerInCurrentLevel()
    
    -- 关底结算完成，跳转到下个关卡
    self:OnFinish()

end

--[[
function SingleMode_1_Settle:ReceiveBeginPlay()
    SingleMode_1_Settle.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function SingleMode_1_Settle:ReceiveTick(DeltaTime)
    SingleMode_1_Settle.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function SingleMode_1_Settle:ReceiveEndPlay()
    SingleMode_1_Settle.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function SingleMode_1_Settle:GetReplicatedProperties()
    return
end
--]]

--[[
function SingleMode_1_Settle:GetAvailableServerRPCs()
    return
end
--]]

return SingleMode_1_Settle