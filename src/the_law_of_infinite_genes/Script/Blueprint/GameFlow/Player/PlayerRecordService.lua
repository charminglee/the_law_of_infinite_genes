---玩家战绩服务。负责关卡记录、游戏时长和玩家点赞数据。
local PlayerRecordService = {}

local PromiseFuture = require("common.PromiseFuture")
local ReplicatedStateFactory = UGCGameSystem.UGCRequire(
    "Script.Blueprint.GameFlow.Shared.ReplicatedStateFactory"
)

---开始记录本局游戏时长。
---@param PlayerState UGCPlayerState_C
function PlayerRecordService.StartSession(PlayerState)
    if not UGCGameSystem.IsServer() then
        return
    end
    PlayerState.GameStartTime = UGCGameSystem.GetServerTimeSec()
    UnrealNetwork.RepLazyProperty(PlayerState, "GameStartTime")
end

---等待关卡流就绪后，为每个关卡创建独立统计记录。
---@param PlayerState UGCPlayerState_C
function PlayerRecordService.InitializeLevelRecords(PlayerState)
    if not UGCGameSystem.IsServer() then
        return
    end

    PromiseFuture.New():Set(function(Future)
        while true do
            local LevelCount = UGCLevelFlowSystem.GetTotalLevelCount()
            if LevelCount and LevelCount > 0 then
                for Index = 1, LevelCount do
                    PlayerState.GameRecordData.LevelInfo[Index] =
                        ReplicatedStateFactory.NewLevelRecord()
                end
                UnrealNetwork.RepLazyProperty(PlayerState, "GameRecordData")
                return
            end
            Future:Yield()
        end
    end):AutoResume(PlayerState, 0.2, 5)
end

---更新当前关卡阶段并复制战斗统计。
---@param PlayerState UGCPlayerState_C
---@param MessageOrStage any
---@param CurrentStage number|nil
function PlayerRecordService.UpdateCurrentStage(PlayerState, MessageOrStage, CurrentStage)
    if not UGCGameSystem.IsServer() then
        return
    end
    CurrentStage = CurrentStage or MessageOrStage
    PlayerState.GameRecordData.CurrentStage =
        tonumber(CurrentStage) or PlayerState.GameRecordData.CurrentStage
    UnrealNetwork.RepLazyProperty(PlayerState, "GameRecordData")
end

---根据开始时间更新并复制累计游戏时长。
---@param PlayerState UGCPlayerState_C
function PlayerRecordService.UpdateGameTime(PlayerState)
    if not UGCGameSystem.IsServer() or not PlayerState.GameStartTime then
        return
    end
    PlayerState.GameRecordData.GameTime = math.max(
        0,
        UGCGameSystem.GetServerTimeSec() - PlayerState.GameStartTime
    )
    UnrealNetwork.RepLazyProperty(PlayerState, "GameRecordData")
end

---记录一次不可重复的玩家点赞，并复制双方战绩。
---@param Controller UGCPlayerController_C
---@param OtherPlayerKey number
function PlayerRecordService.LikeOther(Controller, OtherPlayerKey)
    if not UGCGameSystem.IsServer() then
        return
    end
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerController(Controller)
    local OtherPlayerState = UGCGameSystem.GetPlayerStateByPlayerKey(OtherPlayerKey)
    if not PlayerState or not OtherPlayerState then
        return
    end

    local PlayerKey = UGCGameSystem.GetPlayerKeyByPlayerState(PlayerState)
    local TargetPlayerKey = UGCGameSystem.GetPlayerKeyByPlayerState(OtherPlayerState)
    PlayerState.GameRecordData.Likes = PlayerState.GameRecordData.Likes or {}
    OtherPlayerState.GameRecordData.ReceivedLikes =
        OtherPlayerState.GameRecordData.ReceivedLikes or {}
    if PlayerState.GameRecordData.Likes[TargetPlayerKey] then
        return
    end

    OtherPlayerState.GameRecordData.LikeNum =
        (OtherPlayerState.GameRecordData.LikeNum or 0) + 1
    OtherPlayerState.GameRecordData.ReceivedLikes[PlayerKey] = true
    PlayerState.GameRecordData.Likes[TargetPlayerKey] = true
    UnrealNetwork.RepLazyProperty(OtherPlayerState, "GameRecordData")
    UnrealNetwork.RepLazyProperty(PlayerState, "GameRecordData")
end

return PlayerRecordService
