---@class UGCPlayerState_C:BP_UGCPlayerState_C
---@field PlayerDataManager PlayerDataManager_C
--Edit Below--
local Delegate = require("common.Delegate")
local PromiseFuture = require("common.PromiseFuture")
local UGCPlayerState = {
    -- 玩家等级变化委托，当玩家等级同步时触发（客户端）
    PlayerLevelChangedDelegate = Delegate.New(),
    -- 玩家经验变化委托，当玩家经验同步时触发（客户端）
    PlayerExpChangedDelegate = Delegate.New(),
    -- 玩家游戏记录数据变化委托，当游戏GameGameRecord数据同步时触发（客户端）
    PlayerGameGameRecordDataDelegate = Delegate.New(),
    -- 游戏记录数据表，存储玩家游戏过程中的各种统计数据
    GameRecordData = {},
    -- 游戏完成记录表，存储玩家已解锁的游戏模式
    GameCompletionRecord = {},
}
local UGCGameData = UGCGameSystem.UGCRequire('Script.Blueprint.UGCGameData')
UGCPlayerState.RespawnConfig = {}
UGCPlayerState.GameRecordData = {
    LevelInfo = {},                      -- 每个关卡的分数
    TotalDamage = 0,                     -- 总伤害
    TotalMonsterKill = 0,                -- 总击杀怪物
    TotalMonsterKillByType = {           -- 击杀不同类型的怪物
        Monster = 0,                     -- 普通怪物
        EliteMonster = 0,                -- 精英怪物
        Boss = 0                         -- BOSS
    },
    PlayerExp = 0,                       -- 玩家经验
    GameTime = 0,                        -- 游戏时间
    TotalCriticalHit = 0,                -- 总暴击
    CurrentStage = 1,                    -- 当前关卡
    LikeNum = 0,                         -- 点赞数
    Likes = {},                          -- 点赞列表
    ReceivedLikes = {},                  -- 收到的点赞列表
}

-- 初始化结算参数表
-- 该表用于存储游戏结算相关的状态信息
UGCPlayerState.SettleParams = {}
UGCPlayerState.SettleParams.bIsSettled = false  -- 标记当前是否已结算
UGCPlayerState.SettleParams.bIsFinished = true  -- 标记结算时流程是否已完成（是否胜利）
UGCPlayerState.IsModeUnLock = false  -- 标记模式是否已解锁
--判断玩家所处的状态（Alive、Dying、Dead）
UGCPlayerState.AliveState = UGCGameData.AliveState.Alive;

-- 玩家在大厅中的准备状态，初始为未准备
UGCPlayerState.bIsReadyInLobby = false
-- 准备状态更新委托，用于通知准备状态变化（客户端）
UGCPlayerState.ReadyStateUpdateDelegate = Delegate.New()
-- 在线状态更新委托，用于通知玩家在线状态变化（客户端）
UGCPlayerState.OnlineStateUpdateDelegate = Delegate.New()
-- 判断当前玩家是否进入传送门，判断UI显隐
UGCPlayerState.bIsPlayerInPortalDoor = false

-- 玩家在线状态
UGCPlayerState.bIsOnline = true 

UGCPlayerState.bIsLobbyTeamLeader = false


function UGCPlayerState:GetReplicatedProperties()
    return {"RespawnConfig", "Lazy"}, {"HeroID", "Lazy"}, {"GameRecordData", "Lazy"}, {"GameCompletionRecord", "Lazy"},
    {"bIsReadyInLobby", "Lazy"}, {"SettleParams", "Lazy"}, {"bIsPlayerInPortalDoor", "Lazy"}, {"IsModeUnLock", "Lazy"},
    {"AliveState", "Lazy"}, {"bIsOnline", "Lazy"}, {"bIsLobbyTeamLeader", "Lazy"},{"GameStartTime", "Lazy"}
end

function UGCPlayerState:GetAvailableServerRPCs()
    return "RPC_Server_ReduceFreeReviveCount", "RPC_Server_ReducePaidReviveCount"
end

function UGCPlayerState:ReceiveBeginPlay()
    UGCPlayerState.SuperClass.ReceiveBeginPlay(self)
    if not self:HasAuthority() then
        LocalPlayerState = LocalPlayerState or self
    end
end

function UGCPlayerState:SetLobbyReadyStatus(bIsReady)
    if not UGCGameSystem.IsServer() then
        return
    end
    
    self.bIsReadyInLobby = bIsReady
    UnrealNetwork.RepLazyProperty(self, "bIsReadyInLobby")
end

function UGCPlayerState:SetIsLobbyTeamLeader(bIsTeamLeader)
    if not UGCGameSystem.IsServer() then
        return
    end

    self.bIsLobbyTeamLeader = bIsTeamLeader
    UnrealNetwork.RepLazyProperty(self, "bIsTeamLeader")
end

--[[
function UGCPlayerState:ReceiveTick(DeltaTime)
    UGCPlayerState.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]


--[[
function UGCPlayerState:ReceiveEndPlay()
    UGCPlayerState.SuperClass.ReceiveEndPlay(self) 
end
--]]


return UGCPlayerState