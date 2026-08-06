---@class UGCPlayerState_C:BP_UGCPlayerState_C
---@field ItemDataManager ItemDataManager_C
---@field PlayerDataManager PlayerDataManager_C
--Edit Below--
local UGCPlayerState = {
    -- 游戏记录数据表，存储玩家游戏过程中的各种统计数据
    GameRecordData = {},
    -- 游戏完成记录表，存储玩家已解锁的游戏模式
    GameCompletionRecord = {},
}


local Delegate = require("common.Delegate")
local PromiseFuture = require("common.PromiseFuture")
local UGCGameData = UGCGameSystem.UGCRequire('Script.Blueprint.UGCGameData')


-- 玩家等级变化委托，当玩家等级同步时触发（客户端）
UGCPlayerState.PlayerLevelChangedDelegate = Delegate.New()
-- 玩家经验变化委托，当玩家经验同步时触发（客户端）
UGCPlayerState.PlayerExpChangedDelegate = Delegate.New()
-- 玩家游戏记录数据变化委托，当游戏GameGameRecord数据同步时触发（客户端）
UGCPlayerState.PlayerGameGameRecordDataDelegate = Delegate.New()


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
        LocalPlayerState = LocalPlayerState or self ---@type UGCPlayerState_C
    end
    if UGCGameSystem.IsServer() and UGCActorComponentUtility.GetOwner(self) then
        self:HandleBeginPlayInServer()
    elseif not UGCGameSystem.IsServer() and not UGCGameState.IsInLobby() then
        self:HandleBeginPlayInClientForFighting()
    end
end


function UGCPlayerState:HandleBeginPlayInServer()
    UGCPlayerState.GameStartTime = UGCGameSystem.GetServerTimeSec()
    UnrealNetwork.RepLazyProperty(self,"GameStartTime")
    local MsgPawnSpawn = UGCGenericMessageSystem.Messages.UGC.PlayerPawn.PawnSpawn
    local MsgPawnRespawn = UGCGenericMessageSystem.Messages.UGC.PlayerPawn.PawnRespawn
    UGCGenericMessageSystem.ListenGlobalMessage(self, MsgPawnSpawn, self, self.OnPawnSpawn)
    UGCGenericMessageSystem.ListenGlobalMessage(self, MsgPawnRespawn, self, self.OnPawnRespawn)
    UGCGenericMessageSystem.ListenGlobalMessage(self, UGCGenericMessageSystem.Messages.UGC.LevelFlow.LevelBegin, self, self.UpdateCurrentStage)

    -- 在玩家PostLogin之后执行初始化逻辑
    local Message = UGCGenericMessageSystem.Messages.UGC.Player.PlayerEnter
    UGCGenericMessageSystem.ListenGlobalMessage(self, Message, UGCActorComponentUtility.GetOwner(self), 
        function (...)
            self:OnPlayerEnter(...) 
        end
    );

    Message = UGCGenericMessageSystem.Messages.UGC.Player.PlayerLost
    UGCGenericMessageSystem.ListenGlobalMessage(self, Message, UGCActorComponentUtility.GetOwner(self),
        function (...)
            self:OnPlayerLost(...)
        end
    )

    Message = UGCGenericMessageSystem.Messages.UGC.Player.PlayerReconnect
    UGCGenericMessageSystem.ListenGlobalMessage(self, Message, UGCActorComponentUtility.GetOwner(self),
        function (...)
            self:OnPlayerReconnect(...)
        end
    )

    self.OnLevelChanged = Delegate.New()

    -- 获取复活配置
    self.RespawnConfig = UGCGameData.GetRespawnConfig(UGCMultiMode.GetModeID())
    UnrealNetwork.RepLazyProperty(self, "RespawnConfig")

    -- 初始化暂时无法通
    self:InitGameGameRecordData()

end


function UGCPlayerState:HandleBeginPlayInClientForFighting()
    BreakthroughManager:AddOrUpdateResultPlayerState({GameRecordData = self.GameRecordData, UID = self:GetInt64UID(), IconURL = self.IconURL, Gender = self.Gender, FrameLevel = self.FrameLevel, PlayerLevel = self.PlayerLevel, PlayerName = self.PlayerName, PlayerKey = UGCGameSystem.GetPlayerKeyByPlayerState(self)})
end


function UGCPlayerState:OnPawnSpawn()
    self:OnSpawnOrRespawn()
end


function UGCPlayerState:OnPawnRespawn()
    self:OnSpawnOrRespawn()
end


function UGCPlayerState:OnSpawnOrRespawn()
    if UGCGameSystem.IsServer() then
        ugcprint("[UGCPlayerState:OnSpawnOrRespawn] Called")

        local Uid = UGCGameSystem.GetUIDByPlayerState(self)
        local Data = UGCPlayerStateSystem.GetPlayerArchiveData(Uid)
        ugcprint("[UGCPlayerState] Data: " .. tostring(Data))
        if not Data then
            Data = {}
        end
        self.CustomData = Data

        local ModeID = UGCMultiMode.GetModeID()
        if ModeID == 1001 then
            -- 大厅逻辑
            print("[UGCPlayerState:OnSpawnOrRespawn]:初始游戏完成记录:")
            log_tree(Data.GameCompletionRecord)
        else
            -- 局内逻辑
        end
    end
end


function UGCPlayerState:OnPlayerEnter(_,PlayerKey)
    if UGCGameSystem.GetPlayerKeyByPlayerState(self) ~= PlayerKey then
        return
    end

    self.bIsOnline = true
    UnrealNetwork.RepLazyProperty(self, "bIsOnline")

    local Uid = UGCGameSystem.GetUIDByPlayerState(self)
    local Data = UGCPlayerStateSystem.GetPlayerArchiveData(Uid)
    ugcprint("[UGCPlayerState] Data: "..tostring(Data))
    if not Data then
        Data = {}
    end
    if not Data.UGCPlayerLevel or Data.UGCPlayerLevel <= 0 then
        Data.UGCPlayerLevel = 1
    end
    self.CustomData = Data
    self.PlayerExp = Data.PlayerExp
    self.UGCPlayerLevel = Data.UGCPlayerLevel

    -- 获取等级配置
    ugcprint("[UGCPlayerState] Init Level: "..tostring(self.UGCPlayerLevel))
    ugcprint("[UGCPlayerState] Init Exp: "..tostring(self.PlayerExp))

    self:InitGameCompletionRecord()

    -- self:SetShowTeammatePositionUI(UGCMultiMode.GetModeID() ~= 1001)
end


function UGCPlayerState:OnPlayerLost(_, PlayerKey)
    if UGCGameSystem.GetPlayerKeyByPlayerState(self) == PlayerKey then
        self.bIsOnline = false
        UnrealNetwork.RepLazyProperty(self, "bIsOnline")
    end
end


function UGCPlayerState:OnPlayerReconnect(_, PlayerKey)
    if UGCGameSystem.GetPlayerKeyByPlayerState(self) == PlayerKey then
        self.bIsOnline = true
        UnrealNetwork.RepLazyProperty(self, "bIsOnline")
    end
end


function UGCPlayerState:InitGameGameRecordData()
    PromiseFuture.New():Set(
        function (PromiseFuture)
            while true do
                local TotalLevelCount = UGCLevelFlowSystem.GetTotalLevelCount()
                if TotalLevelCount then
                    for i = 1, TotalLevelCount do
                        self.GameRecordData.LevelInfo[i] = {
                            LevelDamage = 0,                 -- 该关卡总伤害
                            LevelMonsterKill = 0,            -- 该关卡总击杀怪物
                            LevelMonsterKillByType = {       -- 击杀不同类型的怪物
                                Monster = 0,                 -- 普通怪物
                                EliteMonster = 0,            -- 精英怪物
                                Boss = 0                     -- BOSS
                            },
                            LevelPlayerExp = 0,              -- 该关卡总经验
                            LevelTime = 0,                   -- 该关卡游戏时间
                            LevelCriticalHit = 0             -- 该关卡总暴击
                        }
                    end
                    UnrealNetwork.RepLazyProperty(self, "GameRecordData")
                    return
                end
                PromiseFuture:Yield()
            end
        end
    ):AutoResume(self, 0.2, 5)
end


function UGCPlayerState:InitGameCompletionRecord()
    ugcprint("[UGCPlayerState] InitGameCompletionRecord")
    local UID = UGCGameSystem.GetUIDByPlayerState(self)
    local PlayerData = UGCPlayerStateSystem.GetPlayerArchiveData(UID)

    if PlayerData == nil then
        PlayerData = {}
    end

    -- 必须解锁的关卡列表
    local requiredLevels = {1001, 1002}
    
    -- 初始化或合并存档数据
    PlayerData.GameCompletionRecord = PlayerData.GameCompletionRecord or {}
    
    -- 创建哈希表用于快速查找已存在关卡
    local existingLevels = {}
    for _, level in ipairs(PlayerData.GameCompletionRecord) do
        existingLevels[level] = true
    end
    
    -- 添加缺失的必须关卡
    for _, level in ipairs(requiredLevels) do
        if not existingLevels[level] then
            table.insert(PlayerData.GameCompletionRecord, level)
            existingLevels[level] = true  -- 更新哈希表防止重复插入
        end
    end
    
    UGCLog.Log("[UGCPlayerState:InitGameCompletionRecord]:最终游戏完成记录:")
    log_tree(PlayerData.GameCompletionRecord)
    self.GameCompletionRecord = PlayerData.GameCompletionRecord
    UnrealNetwork.RepLazyProperty(self, "GameCompletionRecord")
    UGCPlayerStateSystem.SavePlayerArchiveData(UID, PlayerData)    
end


function UGCPlayerState:UpdateCurrentStage(CurrentStage)
    ugcprint("UGCPlayerState:UpdateCurrentStage CurrentStage="..tostring(CurrentStage))
    self.GameRecordData.CurrentStage = CurrentStage
    UnrealNetwork.RepLazyProperty(self, "GameRecordData")
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


function UGCPlayerState:ReduceFreeRespawnCount()
    self.RespawnConfig.CurrentFreeReviveCount = self.RespawnConfig.CurrentFreeReviveCount - 1
    UnrealNetwork.RepLazyProperty(self, "RespawnConfig.CurrentFreeReviveCount")
    ugcprint("RespawnConfigTable.CurrentFreeReviveCount = "..self.RespawnConfig.CurrentFreeReviveCount)
end


function UGCPlayerState:ReducePaidRespawnCount()
    self.RespawnConfig.CurrentPaidReviveCount = self.RespawnConfig.CurrentPaidReviveCount - 1
    UnrealNetwork.RepLazyProperty(self, "RespawnConfig.CurrentPaidReviveCount")
    ugcprint("RespawnConfigTable.CurrentPaidReviveCount = "..self.RespawnConfig.CurrentPaidReviveCount)
end


function UGCPlayerState:OnRep_GameRecordData()
    ugcprint("[UGCPlayerState] OnRep_GameRecordData"..tostring(self.GameRecordData.TotalCriticalHit))
    self.PlayerGameGameRecordDataDelegate(self.GameRecordData)
    if self.SettleParams.bIsSettled then
        BreakthroughManager:RefreshBattleResultUI()
    end
    BreakthroughManager:AddOrUpdateResultPlayerState({GameRecordData = self.GameRecordData, UID = self:GetInt64UID(), IconURL = self.IconURL, Gender = self.Gender, FrameLevel = self.FrameLevel, PlayerLevel = self.PlayerLevel, PlayerName = self.PlayerName, PlayerKey = UGCGameSystem.GetPlayerKeyByPlayerState(self)})
end


function UGCPlayerState:OnRep_GameCompletionRecord()
    ugcprint(string.format("[UGCPlayerState] OnRep_GameCompletionRecord : %s", table.concat(self.GameCompletionRecord, ",")))

    local function DoWork()
        local ModeID = UGCMultiMode.GetModeID()
        if ModeID == 1001 then
            -- 大厅逻辑
            LobbyUtils.UpdateWidget(LobbyWidgetType.LWT_MainLobby)
        else
            -- 局内逻辑
        end
    end

    PromiseFuture.New():Set(
            function(P)
                while true do
                    local GameState = UGCGameSystem.GameState
                    local IsLobby = LobbyFlow:CurrentState() == LobbyFlowState.LFS_Lobby

                    if GameState and IsLobby then
                        DoWork()
                        return
                    else
                        P:Yield()
                    end
                end
            end
    ):AutoResume(self, 0.2, 60)
end


function UGCPlayerState:OnRep_bIsReadyInLobby()
    local PlayerKey = UGCGameSystem.GetPlayerKeyByPlayerState(self)
    ugcprint(string.format("[UGCPlayerState:OnRep_bIsReadyInLobby] PlayerKey=%d, bIsReadyInLobby=%s", PlayerKey, tostring(self.bIsReadyInLobby)))

    self.ReadyStateUpdateDelegate()
    LobbyUtils.UpdateWidget(LobbyWidgetType.LWT_MainLobby, {})
end


function UGCPlayerState:OnRep_bIsLobbyTeamLeader()
    local PlayerKey = UGCGameSystem.GetPlayerKeyByPlayerState(self)
    ugcprint(string.format("[UGCPlayerState:OnRep_bIsLobbyTeamLeader] PlayerKey=%d, bIsLobbyTeamLeader=%s", PlayerKey, tostring(self.bIsLobbyTeamLeader)))

    self.ReadyStateUpdateDelegate()
    LobbyUtils.UpdateWidget(LobbyWidgetType.LWT_MainLobby, {})
end


function UGCPlayerState:OnRep_bIsOnline()
    local PlayerKey = UGCGameSystem.GetPlayerKeyByPlayerState(self)
    ugcprint(string.format("[UGCPlayerState:OnRep_bIsOnline] PlayerKey=%d, bIsOnline=%s", PlayerKey, tostring(self.bIsOnline)))

    self.OnlineStateUpdateDelegate()
end


function UGCPlayerState:UpdateGameTime()
    self.GameRecordData.GameTime = UGCGameSystem.GetServerTimeSec() - self.GameStartTime
    UnrealNetwork.RepLazyProperty(self, "GameRecordData.GameTime")
    ugcprint(string.format("[UGCPlayerState] UpdateGameTime : %d", self.GameRecordData.GameTime))
end


function UGCPlayerState:OnRep_SettleParams()
    print(string.format("[UGCPlayerState] OnRep_SettleParams, bIsSettled is : %s, bIsFinished is : %s", tostring(self.SettleParams.bIsSettled), tostring(self.SettleParams.bIsFinished)))
    if self.SettleParams and self.SettleParams.bIsSettled then
        local PC = UGCGameSystem.GetPlayerControllerByPlayerState(self)
        if PC then
            PC:OnGameSettle()
        else
            print("[UGCPlayerState:OnRep_SettleParams] : PC is nil")
        end
    end
end


function UGCPlayerState:OnRep_AliveState()
    local PC = UGCGameSystem.GetPlayerControllerByPlayerState(self)
    if not PC then
        ugcprint("OnRep_AliveState: PC is nil")
        return
    end
    if self.AliveState == UGCGameData.AliveState.Dying then
        PC:OpenRespawnUI()
    elseif self.AliveState == UGCGameData.AliveState.Dead then
        PC:OpenRespawnUI()
    elseif self.AliveState == UGCGameData.AliveState.Alive then
        BreakthroughManager:CloseRespawnUI()
    end
end


function UGCPlayerState:ReceiveEndPlay()
    if UGCGameSystem.IsServer() then
        self:UpdateGameTime()
    end
end


return UGCPlayerState