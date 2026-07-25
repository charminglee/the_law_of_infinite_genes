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
-- -- 大厅队友PlayerKey更新时的委托 
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