---@class UGCPlayerController_C:BP_UGCPlayerController_C
---@field RecruitComponent RecruitComponent_C
---@field ComposeComponent ComposeComponent_C
---@field RaidInstanceComponent RaidInstanceComponent_C
---@field PassComponent PassComponent_C
---@field GeneComponent GeneComponent_C
---@field GlobalEventComponent GlobalEventComponent_C
---@field GachaComponent GachaComponent_C
---@field FightComponent FightComponent_C
---@field ACHVComponent ACHVComponent_C
---@field StoreComponent StoreComponent_C
---@field HomeComponent HomeComponent_C
---@field RankingListComponent RankingListComponent_C
---@field ShopV2Component ShopV2Component_C
---@field LotteryComponent LotteryComponent_C
--Edit Below--
local UGCPlayerController = {}

-- GamePart是否加载完成
UGCPlayerController.GamePartReady = false
-- 是否是队长
UGCPlayerController.bIsTeamLeader = false
-- 大厅队友的PlayerKey
UGCPlayerController.LobbyTeammatePlayerKeys = {}
-- 大厅队友PlayerKey更新时的委托 
-- UGCPlayerController.OnLobbyTeammatePlayerKeysUpdate = Delegate.New()

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

    if not self:HasAuthority() then
        LocalPlayerController = self

    else
        local delegate = ObjectExtend.CreateDelegate(
            self, 
            function()
                -- 初始武器
                local weaponId = Config.InitialWeapon.WeaponId
                local bulletId = Config.InitialWeapon.BulletId
                if UGCBackpackSystemV2.GetWarehouseItemCount(self, weaponId) == 0 then
                    UGCBackpackSystemV2.AddItemV2(self, weaponId, 1)  
                    UGCBackpackSystemV2.AddItemV2(self, bulletId, 100)
                    UGCBackpackSystemV2.AddItemV2(self, bulletId, 100)
                    UGCBackpackSystemV2.AddItemV2(self, bulletId, 100)
                end

                if UGCGameSystem.IsUGCPIE() and Config.Debug.AutoStartGame then
                    GameState:StartGame()
                end
            end
        )
        KismetSystemLibrary.K2_SetTimerDelegateForLua(delegate, self, 2, false)
    end

    if UGCGameSystem.IsServer() then
        if UGCGameSystem.GameState.IsInLobby() then
            self:HandleBeginPlayInServerForLobby()
        else
            self:HandleBeginPlayInServerForFighting()
        end
    else
        if UGCGameSystem.GameState.IsInLobby() then
            self:HandleBeginPlayInClientForLobby()
        else
            self:HandleBeginPlayInClientForFighting()
        end
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
    -- local NewIndex = TimingListUtils.NewList()
    -- TimingListUtils.Add(NewIndex, 0, self, "GamePartReady")
    -- TimingListUtils.Add(NewIndex, 0, UGCGameSystem, "GameState", self, self.RecieveGamePartReady)
    -- TimingListUtils.Activate(NewIndex, 0.2, 20)
end

function UGCPlayerController:HandleBeginPlayInClientForFighting()
    local GamePartReadyMessage = UGCGenericMessageSystem.Messages.UGC.GamePart.GamePartLoaded
    local ChangeGamePartReady = function()
        self.GamePartReady = true
    end
    UGCGenericMessageSystem.ListenGlobalMessage(self, GamePartReadyMessage, self, ChangeGamePartReady)
    -- local NewIndex = TimingListUtils.NewList()
    -- TimingListUtils.Add(NewIndex, 0, self, "GamePartReady")
    -- TimingListUtils.Add(NewIndex, 0, UGCGameSystem, "GameState", self, self.RecieveGamePartReady)
    -- TimingListUtils.Activate(NewIndex, 0.2, 20)
end

function UGCPlayerController:InitInServer(PlayerKey)
    local bIsUGCPIE = UGCGameSystem.IsUGCPIE();
    if PlayerKey == UGCGameSystem.GetPlayerKeyByPlayerController(self) then
        self.bIsTeamLeader = bIsUGCPIE and PlayerKey == 10001 or UGCTeamSystem.GetIsLeaderOrNotByPlayerKey(PlayerKey)
        UGCLog.Log('InitInServer', self.bIsTeamLeader);
        UnrealNetwork.RepLazyProperty(self, "bIsTeamLeader")
        UGCGameSystem.GetPlayerStateByPlayerController(self):SetIsLobbyTeamLeader(self.bIsTeamLeader)
        
        ---如果是队长则默认已准备
        self:RPC_Server_SetLobbyReadyStatus(self.bIsTeamLeader)
    end
    
    if bIsUGCPIE then
        self.LobbyTeammatePlayerKeys = UGCTeamSystem.GetPlayerKeysByTeamID(UGCTeamSystem.GetTeamIDByPlayerKey(UGCGameSystem.GetPlayerKeyByPlayerController(self)), true)
        -- self.LobbyTeammatePlayerKeys = {self.PlayerKey}
    else
        self.LobbyTeammatePlayerKeys = UGCTeamSystem.GetLobbyTeamKeysByPlayerKey(UGCGameSystem.GetPlayerKeyByPlayerController(self))
    end
    UnrealNetwork.RepLazyProperty(self, "LobbyTeammatePlayerKeys")

    -- 给加入游戏的队友同步大厅信息
    if self.bIsTeamLeader then
        if not bIsUGCPIE then
            self.LobbyInfo.bTeamComplete = #UGCTeamSystem.GetLobbyTeamKeysByPlayerKey(self.PlayerKey) == #UGCTeamSystem.GetLobbyTeammateUIDsByUID(UGCGameSystem.GetUIDByPlayerController(self))
            -- UnrealNetwork.RepLazyProperty(self, "LobbyInfo.bTeamComplete")
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
            -- UnrealNetwork.RepLazyProperty(self, "LobbyInfo.bTeamComplete")
        end
    end
end

function UGCPlayerController:SetLobbyReadyStatus(bIsReady)
    UnrealNetwork.CallUnrealRPC(self, self, "RPC_Server_SetLobbyReadyStatus", bIsReady)
end

function UGCPlayerController:SetLobbyInfo(LobbyInfo)
    if UGCActorComponentUtility.HasAuthority(self) == false then
        return
    end

    print(string.format("UGCPlayerController:SetLobbyInfo ModeID=%d, bFillTeammate=%s", LobbyInfo.SelectedModeID, tostring(LobbyInfo.bFillTeammate)))

    self.LobbyInfo = LobbyInfo
    UnrealNetwork.RepLazyProperty(self, "LobbyInfo")
end

function UGCPlayerController:RPC_Server_SetLobbyReadyStatus(bIsReady)
    UGCGameSystem.GetPlayerStateByPlayerController(self):SetLobbyReadyStatus(bIsReady)
end

--[[
function UGCPlayerController:ReceiveTick(DeltaTime)
    UGCPlayerController.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]


--[[
function UGCPlayerController:ReceiveEndPlay()
    UGCPlayerController.SuperClass.ReceiveEndPlay(self) 
end
--]]


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