---玩家生存与复活服务。统一处理生命状态、复活资源和付费校验。
local PlayerRespawnService = {}

local GameTypes = UGCGameSystem.UGCRequire("Script.Blueprint.GameFlow.Shared.GameTypes")
local GameConfigRepository = UGCGameSystem.UGCRequire("Script.Blueprint.GameFlow.Data.GameConfigRepository")

---获取 Controller 对应的 PlayerState。
---@param Controller UGCPlayerController_C
---@return UGCPlayerState_C|nil
local function GetPlayerState(Controller)
    return UGCGameSystem.GetPlayerStateByPlayerController(Controller)
end

---为玩家创建当前模式独立的复活配置。
---@param PlayerState UGCPlayerState_C
---@param ModeID number|string
function PlayerRespawnService.InitializeConfig(PlayerState, ModeID)
    if not UGCGameSystem.IsServer() then
        return
    end
    PlayerState.RespawnConfig = GameConfigRepository.GetRespawnConfig(ModeID)
    UnrealNetwork.RepLazyProperty(PlayerState, "RespawnConfig")
end

---执行救援或重新生成玩家。
---@param Controller UGCPlayerController_C
---@return boolean
function PlayerRespawnService.ExecuteRespawn(Controller)
    if not UGCGameSystem.IsServer() then
        return false
    end

    local Pawn = UGCGameSystem.GetPlayerPawnByPlayerController(Controller)
    local DyingTag = UGCGameplayTagSystem.RequestGameplayTag("PawnState.Dying")
    if Pawn and UGCPersistEffectSystem.HasDynamicState(Pawn, DyingTag) then
        UGCPlayerPawnSystem.ConfirmRescueOtherImmediately(Pawn, Pawn)
        UGCAttributeSystem.SetGameAttributeValue(
            Pawn,
            UGCNativeGameAttributeType.Character_Health,
            UGCAttributeSystem.GetGameAttributeValueMax(Pawn, UGCNativeGameAttributeType.Character_HealthMax)
        )
        return true
    end

    UGCPlayerPawnSystem.RespawnPlayer(Controller.PlayerKey)
    local PlayerState = GetPlayerState(Controller)
    if PlayerState then
        PlayerRespawnService.SetAliveState(PlayerState, GameTypes.AliveState.Alive)
    end
    return true
end

---校验免费次数或付费资源，成功后执行复活并扣除次数。
---@param Controller UGCPlayerController_C
---@param bFreeRespawn boolean
function PlayerRespawnService.RequestRespawn(Controller, bFreeRespawn)
    if not UGCGameSystem.IsServer() then
        return
    end
    local PlayerState = GetPlayerState(Controller)
    if not PlayerState then
        return
    end

    if bFreeRespawn then
        if (PlayerState.RespawnConfig.CurrentFreeReviveCount or 0) <= 0 then
            return
        end
        if PlayerRespawnService.ExecuteRespawn(Controller) then
            PlayerRespawnService.ReduceFreeCount(PlayerState)
        end
        return
    end

    if (PlayerState.RespawnConfig.CurrentPaidReviveCount or 0) <= 0 then
        return
    end
    local VirtualItemManager = UGCGamePartSystem.VirtualItemManager.GetGlobalActor()
    if not VirtualItemManager then
        return
    end
    VirtualItemManager:RemoveItem(
        Controller,
        PlayerState.RespawnConfig.CurrencyID,
        PlayerState.RespawnConfig.Price,
        function(Result)
            if Result.bSucceeded and PlayerRespawnService.ExecuteRespawn(Controller) then
                PlayerRespawnService.ReducePaidCount(PlayerState)
            end
        end
    )
end

---设置玩家生存状态，并通知 GameState 更新全灭状态。
---@param PlayerState UGCPlayerState_C
---@param State number
---@return boolean
function PlayerRespawnService.SetAliveState(PlayerState, State)
    if not UGCGameSystem.IsServer() or State == PlayerState.AliveState then
        return false
    end
    if State ~= GameTypes.AliveState.Alive
        and State ~= GameTypes.AliveState.Dying
        and State ~= GameTypes.AliveState.Dead then
        return false
    end

    PlayerState.AliveState = State
    UnrealNetwork.RepLazyProperty(PlayerState, "AliveState")

    local GameState = UGCGameSystem.GameState
    if State == GameTypes.AliveState.Dead then
        local Pawn = UGCGameSystem.GetPlayerPawnByPlayerKey(PlayerState.PlayerKey)
        if Pawn then
            local Transform = UGCActorComponentUtility.GetActorTransform(Pawn)
            if Transform then
                UGCGameSystem.SetPlayerRespawnInfo(PlayerState.PlayerKey, true, Transform:Copy())
            end
        end
        if GameState then
            GameState:OnPlayerDead(PlayerState.PlayerKey)
        end
    elseif State == GameTypes.AliveState.Alive and GameState then
        GameState:OnPlayerAlive(PlayerState.PlayerKey)
    end
    return true
end

---扣除一次免费复活次数，最小值限制为零。
---@param PlayerState UGCPlayerState_C
function PlayerRespawnService.ReduceFreeCount(PlayerState)
    if not UGCGameSystem.IsServer() then
        return
    end
    local Count = tonumber(PlayerState.RespawnConfig.CurrentFreeReviveCount) or 0
    PlayerState.RespawnConfig.CurrentFreeReviveCount = math.max(0, Count - 1)
    UnrealNetwork.RepLazyProperty(PlayerState, "RespawnConfig")
end

---扣除一次付费复活次数，最小值限制为零。
---@param PlayerState UGCPlayerState_C
function PlayerRespawnService.ReducePaidCount(PlayerState)
    if not UGCGameSystem.IsServer() then
        return
    end
    local Count = tonumber(PlayerState.RespawnConfig.CurrentPaidReviveCount) or 0
    PlayerState.RespawnConfig.CurrentPaidReviveCount = math.max(0, Count - 1)
    UnrealNetwork.RepLazyProperty(PlayerState, "RespawnConfig")
end

return PlayerRespawnService
