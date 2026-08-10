---@class UGCPlayerController_C:BP_UGCPlayerController_C
---@field AppraisalComponent ppraisalComponent_C
---@field ReinfComponent ReinfComponent_C
---@field PureComponent PureComponent_C
---@field FortifyComponent FortifyComponent_C
---@field RecruitComponent RecruitComponent_C
---@field ComposeComponent ComposeComponent_C
---@field RaidInstanceComponent RaidInstanceComponent_C
---@field PassComponent PassComponent_C
---@field GeneComponent GeneComponent_C
---@field GlobalEventComponent GlobalEventComponent_C
---@field GachaComponent GachaComponent_C
---@field FightComponent FightComponent_C
---@field ACHVComponent CHVComponent_C
---@field StoreComponent StoreComponent_C
---@field HomeComponent HomeComponent_C
---@field RankingListComponent RankingListComponent_C
---@field ShopV2Component ShopV2Component_C
---@field LotteryComponent LotteryComponent_C
--Edit Below--
local UGCPlayerController = {
    ---@type UGCPlayerPawn_C
    PlayerPawn = nil,
    ---@type UGCPlayerState_C
    PlayerState = nil,
}


local PromiseFuture = require("common.PromiseFuture")
local Delegate = require("common.Delegate")


-- GamePart是否加载完成
UGCPlayerController.GamePartReady = false
-- 是否是队长
UGCPlayerController.bIsTeamLeader = false
-- 大厅队友的PlayerKey
UGCPlayerController.LobbyTeammatePlayerKeys = {}
-- 大厅队友PlayerKey更新时的委托 
UGCPlayerController.OnLobbyTeammatePlayerKeysUpdate = Delegate.New()


-- 大厅信息配置
UGCPlayerController.LobbyInfo = {
    -- 当前选择的模式ID（默认1002）
    SelectedModeID = 1002,
    -- 是否自动填充队友
    bFillTeammate = false,
    -- 是否队伍状态完整
    bTeamComplete = true,
    -- 是否在匹配中
    bIsMatching = false
}


function UGCPlayerController:GetAvailableServerRPCs()
    return "RPC_Server_RespawnPlayer", "RPC_Server_RequestRespawn", "RPC_Server_SetLobbyReadyStatus", "RPC_Server_EnterSpectating",
     "RPC_Server_TeleportToPortal", "RPC_Server_SetLobbySelectedModeID", "RPC_Server_SetFillTeammate", "RPC_Server_SetLobbybIsMatching","RPC_Server_LikeOther"
end


function UGCPlayerController:GetReplicatedProperties()
    return {"bIsTeamLeader", "Lazy"}, {"LobbyTeammatePlayerKeys", "Lazy"}, {"LobbyInfo", "Lazy"}
end


function UGCPlayerController:ReceiveBeginPlay()
    UGCPlayerController.SuperClass.ReceiveBeginPlay(self)
    
    self.PlayerState = UGCGameSystem.GetPlayerStateByPlayerController(self)
    self.PlayerPawn = UGCGameSystem.GetPlayerPawnByPlayerController(self)
    if UE.IsValid(self.PlayerState) then
        self.PlayerState.PlayerController = self
    end
    if UE.IsValid(self.PlayerPawn) then
        self.PlayerPawn.PlayerController = self
    end

    if Lib.IsServer() then
        Lib.CreateTimer(2, false, function()
            -- 初始武器
            local weaponId = Config.InitialWeapon.WeaponId
            local bulletId = Config.InitialWeapon.BulletId
            local ps = UGCGameSystem.GetPlayerStateByPlayerController(self)
            local isNotFirstJoin = ps.PlayerDataManager:GetCustomData("isNotFirstJoin")
            if isNotFirstJoin ~= 1 then
                UGCBackpackSystemV2.AddItemV2(self, weaponId, 1)
                UGCBackpackSystemV2.AddItemV2(self, bulletId, 300)
                ps.PlayerDataManager:SaveCustomData("isNotFirstJoin", 1)
            end
        end)

        if GameState.IsInLobby() then
            self:HandleBeginPlayInServerForLobby()
        else
            self:HandleBeginPlayInServerForFighting()
        end
    else
        LocalPlayerController = self ---@type UGCPlayerController_C

        if GameState.IsInLobby() then
            self:HandleBeginPlayInClientForLobby()
        else
            self:HandleBeginPlayInClientForFighting()
        end
    end
end


function UGCPlayerController:ReceiveEndPlay()
    UGCPlayerController.SuperClass.ReceiveEndPlay(self)

    if UE.IsValid(self.PlayerState) then
        self.PlayerState.PlayerController = nil
    end
    if UE.IsValid(self.PlayerPawn) then
        self.PlayerPawn.PlayerController = nil
    end
    
    if not Lib.IsServer() then
        LocalPlayerController = nil
    end
end


function UGCPlayerController:HandleBeginPlayInServerForLobby()
    LobbyFlow:Go(LobbyFlowState.LFS_Lobby)
    UGCGenericMessageSystem.ListenGlobalMessage(self, UGCGenericMessageSystem.Messages.UGC.Player.PlayerEnter, self, self.InitInServer) -- 在PlayerEnter时初始化
    UGCGenericMessageSystem.ListenGlobalMessage(self, UGCGenericMessageSystem.Messages.UGC.Player.PlayerExit, self, self.OnPlayerExit)
end

function UGCPlayerController:HandleBeginPlayInServerForFighting()
    local ld = UGCTeamSystem.GetTeamLeaderKeyByTeamID(UGCTeamSystem.GetTeamIDByPlayerKey(UGCGameSystem.GetPlayerKeyByPlayerController(self)))
    print("[UGCPlayerController] HandleBeginPlayInServerForFighting "..#ld)
end

function UGCPlayerController:HandleBeginPlayInClientForLobby()    
    LobbyFlow:Go(LobbyFlowState.LFS_Lobby)
    local NewIndex = TimingListUtils.NewList()
    TimingListUtils.Add(NewIndex, 0, self, "GamePartReady")
    TimingListUtils.Add(NewIndex, 0, UGCGameSystem, "GameState", self, self.RecieveGamePartReady)
    TimingListUtils.Activate(NewIndex, 0.2, 20)
end

function UGCPlayerController:HandleBeginPlayInClientForFighting()
    LobbyUtils.OpenWidget(LobbyWidgetType.LWT_RaidInstance)
    local GamePartReadyMessage = UGCGenericMessageSystem.Messages.UGC.GamePart.GamePartLoaded
    local ChangeGamePartReady = function()
        self.GamePartReady = true
    end
    UGCGenericMessageSystem.ListenGlobalMessage(self, GamePartReadyMessage, self, ChangeGamePartReady)
    local NewIndex = TimingListUtils.NewList()
    TimingListUtils.Add(NewIndex, 0, self, "GamePartReady")
    TimingListUtils.Add(NewIndex, 0, UGCGameSystem, "GameState", self, self.RecieveGamePartReady)
    TimingListUtils.Activate(NewIndex, 0.2, 20)
end

function UGCPlayerController:InitInServer(PlayerKey)
    local bIsUGCPIE = Lib.IsPIE();
    if PlayerKey == UGCGameSystem.GetPlayerKeyByPlayerController(self) then
        self.bIsTeamLeader = bIsUGCPIE and PlayerKey == 10001 or UGCTeamSystem.GetIsLeaderOrNotByPlayerKey(PlayerKey)
        UnrealNetwork.RepLazyProperty(self, "bIsTeamLeader")
        UGCGameSystem.GetPlayerStateByPlayerController(self):SetIsLobbyTeamLeader(self.bIsTeamLeader)
        
        ---如果是队长则默认已准备
        self:RPC_Server_SetLobbyReadyStatus(self.bIsTeamLeader)
    end
    
    if bIsUGCPIE then
        self.LobbyTeammatePlayerKeys = UGCTeamSystem.GetPlayerKeysByTeamID(UGCTeamSystem.GetTeamIDByPlayerKey(UGCGameSystem.GetPlayerKeyByPlayerController(self)), true)
        -- self.LobbyTeammatePlayerKeys = {self.PlayerKey}
    else
        self.LobbyTeammatePlayerKeys = UGCTeamSystem.GetLobbyTeammatePlayerKeysByPlayerKey(UGCGameSystem.GetPlayerKeyByPlayerController(self))
    end
    UnrealNetwork.RepLazyProperty(self, "LobbyTeammatePlayerKeys")

    -- 给加入游戏的队友同步大厅信息
    if self.bIsTeamLeader then
        if not bIsUGCPIE then
            self.LobbyInfo.bTeamComplete = #UGCTeamSystem.GetLobbyTeammatePlayerKeysByPlayerKey(self.PlayerKey) == #UGCTeamSystem.GetLobbyTeammateUIDsByUID(UGCGameSystem.GetUIDByPlayerController(self))
            UnrealNetwork.RepLazyProperty(self, "LobbyInfo.bTeamComplete")
        end

        for _, TeammatePlayerKey in ipairs(self.LobbyTeammatePlayerKeys) do
            if TeammatePlayerKey == PlayerKey then
                local PC = UGCGameSystem.GetPlayerControllerByPlayerKey(PlayerKey)
                PC:SetLobbyInfo(self.LobbyInfo)
                break     
            end
        end
    end
end

function UGCPlayerController:OnPlayerExit(PlayerKey)
    local bIsUGCPIE = UGCBlueprintFunctionLibrary.IsUGCPIE(self)
    
    for Index, TeammatePlayerKey in ipairs(self.LobbyTeammatePlayerKeys) do
        if TeammatePlayerKey == PlayerKey then
            self.LobbyInfo.bTeamComplete = false
            UnrealNetwork.RepLazyProperty(self, "LobbyInfo.bTeamComplete")
        end
    end
end

function UGCPlayerController:RecieveGamePartReady()
    ugcprint("[UGCPlayerController] ReceiveBeginPlay GamePartReady")

    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerController(self)

    if not PlayerState then
        print("[UGCPlayerController:RecieveGamePartReady] PlayerState is nil")
        return
    end

    if not PlayerState.SettleParams.bIsSettled then 
        PlayerState:OnRep_AliveState()
    end
    PlayerState:OnRep_SettleParams()
end

function UGCPlayerController:SetLobbyReadyStatus(bIsReady)
    UnrealNetwork.CallUnrealRPC(self, self, "RPC_Server_SetLobbyReadyStatus", bIsReady)
end

function UGCPlayerController:SetLobbyInfo(LobbyInfo)
    if Lib.IsServer() == false then
        return
    end

    print(string.format("UGCPlayerController:SetLobbyInfo ModeID=%d, bFillTeammate=%s", LobbyInfo.SelectedModeID, tostring(LobbyInfo.bFillTeammate)))

    self.LobbyInfo = LobbyInfo
    UnrealNetwork.RepLazyProperty(self, "LobbyInfo")
end

function UGCPlayerController:RPC_Server_SetLobbyReadyStatus(bIsReady)
    UGCGameSystem.GetPlayerStateByPlayerController(self):SetLobbyReadyStatus(bIsReady)
end

function UGCPlayerController:RPC_Server_RespawnPlayer()

    local pawn = UGCGameSystem.GetPlayerPawnByPlayerController(self)
        --判断是倒地还是死亡
    local DyingTag = UGCGameplayTagSystem.RequestGameplayTag("PawnState.Dying")

    if pawn and UGCPersistEffectSystem.HasDynamicState(pawn, DyingTag) then
        ugcprint("[UGCPlayerController:RPC_Server_RespawnPlayer]")
        UGCPlayerPawnSystem.ConfirmRescueOtherImmediately(pawn, pawn)
        UGCAttributeSystem.SetGameAttributeValue(
            pawn, 
            UGCNativeGameAttributeType.Character_Health,
            UGCAttributeSystem.GetGameAttributeValueMax(pawn, UGCNativeGameAttributeType.Character_HealthMax)
        )
    else
        local PlayerKey = UGCGameSystem.GetPlayerKeyByPlayerController(self)
        ugcprint("UGCPlayerController:RPC_Server_RespawnPlayer")
        UGCPlayerPawnSystem.RespawnPlayer(PlayerKey)

        local PlayerState = UGCGameSystem.GetPlayerStateByPlayerController(self)

        if not PlayerState then
            print("[UGCPlayerController:RPC_Server_RespawnPlayer]:PlayerState is nil")
            return
        end

        PlayerState.AliveState = UGCGameData.AliveState.Alive
        UnrealNetwork.RepLazyProperty(PlayerState, "AliveState")
    end
end

function UGCPlayerController:OpenRespawnUI()
    if UGCGameSystem.IsServer() then
        return
    end
    local ModeID = UGCMultiMode.GetModeID()
    BreakthroughManager:OpenRespawnUI(ModeID)
end

function UGCPlayerController:RPC_Server_RequestRespawn(bFreeRespawn)
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerController(self)

    if PlayerState == nil then
        print("[UGCPlayerController:RPC_Server_RequestRespawn] PlayerState is nil")
        return
    end

    if bFreeRespawn then
        self:RPC_Server_RespawnPlayer()
        PlayerState:ReduceFreeRespawnCount()
    else
        local VirtualItemManager = UGCGamePartSystem.VirtualItemManager.GetGlobalActor()
        if VirtualItemManager == nil then
            ugcprint("UGCPlayerController:RPC_Server_RequestCoinRespawn VirtualItemManager is nil")
            return
        end
        
        local CoinItemID = PlayerState.RespawnConfig.CurrencyID
        local Price = PlayerState.RespawnConfig.Price

        VirtualItemManager:RemoveItem(self, CoinItemID, Price, 
            function (Result)
                if Result.bSucceeded then
                    self:RPC_Server_RespawnPlayer()
                    PlayerState:ReducePaidRespawnCount()
                else
                    ugcprint("UGCPlayerController:RPC_Server_RequestCoinRespawn Coin respawn failed")
                end
            end
        )
    end
end

function UGCPlayerController:RPC_Server_SetLobbySelectedModeID(ModeID)
    if not Lib.IsServer() then
       return
    end
 
    if not self.bIsTeamLeader then
       print("UGCPlayerController:RPC_Server_SetLobbySelectedModeID PlayerKey="..tostring(UGCGameSystem.GetPlayerKeyByPlayerController(self)).." is not team leader!")
       return
    end

    --队长修改模式队友取消准备
    if self.LobbyInfo.SelectedModeID ~= ModeID then
        self.LobbyInfo.SelectedModeID = ModeID
        UnrealNetwork.RepLazyProperty(self, "LobbyInfo.SelectedModeID")

        local LeaderPlayerKey = UGCGameSystem.GetPlayerKeyByPlayerController(self)
        for _, PlayerKey in ipairs(self.LobbyTeammatePlayerKeys) do
            if PlayerKey ~= LeaderPlayerKey then
                local PC = UGCGameSystem.GetPlayerControllerByPlayerKey(PlayerKey)
                if PC ~= nil then
                    UGCGameSystem.GetPlayerStateByPlayerController(PC):SetLobbyReadyStatus(false)
                    PC:SetLobbyInfo(self.LobbyInfo)
                end
            end
        end
    end
end

function UGCPlayerController:RPC_Server_SetFillTeammate(bFillTeammate)
    if not Lib.IsServer() then
       return
    end
 
    if not self.bIsTeamLeader then
       print("UGCGameState:Server_ChangeLobbySelectedModeID PlayerKey="..tostring(UGCGameSystem.GetPlayerKeyByPlayerController(self)).." is not team leader!")
    end
 
    self.LobbyInfo.bFillTeammate = bFillTeammate
    UnrealNetwork.RepLazyProperty(self, "LobbyInfo.bFillTeammate")

    local LeaderPlayerKey = UGCGameSystem.GetPlayerKeyByPlayerController(self)
    for _, PlayerKey in ipairs(self.LobbyTeammatePlayerKeys) do
        if PlayerKey ~= LeaderPlayerKey then
            local PC = UGCGameSystem.GetPlayerControllerByPlayerKey(PlayerKey)
            if PC ~= nil then
                PC:SetLobbyInfo(self.LobbyInfo)
            end
        end
    end
end

function UGCPlayerController:RPC_Server_SetLobbybIsMatching(bIsMatching)
    if not Lib.IsServer() then
        return
     end
  
    if not self.bIsTeamLeader then
        print("UGCGameState:Server_ChangeLobbySelectedModeID PlayerKey="..tostring(UGCGameSystem.GetPlayerKeyByPlayerController(self)).." is not team leader!")
    end

    self.LobbyInfo.bIsMatching = bIsMatching
    UnrealNetwork.RepLazyProperty(self, "LobbyInfo.bIsMatching")

    local LeaderPlayerKey = UGCGameSystem.GetPlayerKeyByPlayerController(self)
    for _, PlayerKey in ipairs(self.LobbyTeammatePlayerKeys) do
        if PlayerKey ~= LeaderPlayerKey then
            local PC = UGCGameSystem.GetPlayerControllerByPlayerKey(PlayerKey)
            if PC ~= nil then
                PC:SetLobbyInfo(self.LobbyInfo)
            end
        end
    end
end

function UGCPlayerController:RPC_Server_LikeOther(otherPlayerKey)
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerController(self)
    if PlayerState == nil then
        print("[UGCPlayerController:RPC_Server_LikeOther] PlayerState is nil")
        return
    end
    
    local otherPlayerState = UGCGameSystem.GetPlayerStateByPlayerKey(otherPlayerKey)
    if otherPlayerState == nil then
        print("[UGCPlayerController:RPC_Server_LikeOther] otherPlayerState is nil")
        return
    end

    otherPlayerState.GameRecordData.LikeNum = otherPlayerState.GameRecordData.LikeNum + 1

    local PlayerKey = UGCGameSystem.GetPlayerKeyByPlayerState(PlayerState)
    local otherPlayerKey = UGCGameSystem.GetPlayerKeyByPlayerState(otherPlayerState)

    otherPlayerState.GameRecordData.ReceivedLikes[PlayerKey] = true
    PlayerState.GameRecordData.Likes[otherPlayerKey] = true
    
    UnrealNetwork.RepLazyProperty(otherPlayerState, "GameRecordData")
    UnrealNetwork.RepLazyProperty(PlayerState, "GameRecordData")
end

function UGCPlayerController:OnGameSettle()
    print("[UGCPlayerController:OnGameSettle]")
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerController(self)
    if not PlayerState then
        print("[UGCPlayerController:OnGameSettle] PlayerState is nil")
    end
    if PlayerState then
        ugcprint("UGCPlayerController:OnRep_bIsSettled, IsFinish: ".. tostring(PlayerState.SettleParams.bIsFinished).. "IsModeUnLock: ".. tostring(PlayerState.IsModeUnLock))
        local ModeID = UGCMultiMode.GetModeID()
        -- ShopV2Manager:DeactivateRandomRefreshTab()
        BreakthroughManager:OpenBattleResultUI(ModeID, PlayerState.SettleParams.bIsFinished, PlayerState.IsModeUnLock)
        BreakthroughManager:CloseRespawnUI()
    end
end

function UGCPlayerController:OnRep_LobbyTeammatePlayerKeys()
    ugcprint("UGCPlayerController:OnRep_LobbyTeammatePlayerKeys")
    self.OnLobbyTeammatePlayerKeysUpdate()
end

function UGCPlayerController:OnRep_LobbyInfo()
    print(string.format("UGCPlayerController:OnRep_LobbyInfo PlayerKey=%s ModeID=%d", tostring(UGCGameSystem.GetPlayerKeyByPlayerController(self)), self.LobbyInfo.SelectedModeID))

    -- if not self.LobbyInfo.bTeamComplete then
    --     UGCWidgetManagerSystem.ShowTipsUI("队伍有成员退出，请退出玩法重新进入")
    --     return
    -- end

    LobbyModel.CurrentSelectedModeID = self.LobbyInfo.SelectedModeID
    LobbyModel.bIsMatching = self.LobbyInfo.bIsMatching
    LobbyEvent.OnModeSelected(self.LobbyInfo.SelectedModeID)
    LobbyUtils.UpdateWidget(LobbyWidgetType.LWT_MainLobby, { ModeID = self.LobbyInfo.SelectedModeID, bIsMatching = self.LobbyInfo.bIsMatching })
end

function UGCPlayerController:ChangeState(State)
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerController(self)

    if PlayerState == nil then
        print("[UGCPlayerController:ChangeState] PlayerState is nil")
        return
    end

    PlayerState.AliveState = State
    UnrealNetwork.RepLazyProperty(PlayerState, "AliveState")

    if State == UGCGameData.AliveState.Dead then
        UGCGameSystem.SetPlayerRespawnInfo(UGCGameSystem.GetPlayerKeyByPlayerController(self), true, UGCActorComponentUtility.GetActorTransform(UGCGameSystem.GetPlayerPawnByPlayerController(self)):Copy())
        UGCGameSystem.GameState:OnPlayerDead(UGCGameSystem.GetPlayerKeyByPlayerController(self))
    elseif State == UGCGameData.AliveState.Alive then
        UGCGameSystem.GameState:OnPlayerAlive(UGCGameSystem.GetPlayerKeyByPlayerController(self))
    end
end

function UGCPlayerController:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	-- [Editor Generated Lua] BindingProperty Begin:
	-- [Editor Generated Lua] BindingProperty End;
	
	-- [Editor Generated Lua] BindingEvent Begin:
	-- [Editor Generated Lua] BindingEvent End;
end


return UGCPlayerController