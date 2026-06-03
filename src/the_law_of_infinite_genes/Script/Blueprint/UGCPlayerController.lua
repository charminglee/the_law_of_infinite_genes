---@class UGCPlayerController_C:BP_UGCPlayerController_C
---@field HomeComponent HomeComponent_C
---@field RankingListComponent RankingListComponent_C
---@field ShopV2Component ShopV2Component_C
---@field LotteryComponent LotteryComponent_C
--Edit Below--

local UGCPlayerController = {}


local GameState = UGCGameSystem.GetGameState()


function UGCPlayerController:ReceiveBeginPlay()
    UGCPlayerController.SuperClass.ReceiveBeginPlay(self)
    if not self:HasAuthority() then
        return
    end

    local delegate = ObjectExtend.CreateDelegate(
        self, 
        function()
            -- 开局传送
            if GameState.isWaiting then
                local levelStart = UGCActorComponentUtility.GetActorByActorInstancePath("UGCmap.LevelStart_8")
                local loc = levelStart:K2_GetActorLocation()
                UGCPlayerControllerSystem.TeleportTo(self, loc.X, loc.Y, loc.Z)
            end

            -- 初始武器
            local weaponId = 8310018
            local bulletId = 301001
            if UGCBackpackSystemV2.GetWarehouseItemCount(self, weaponId) == 0 then
                UGCBackpackSystemV2.AddItemV2(self, weaponId, 1)
                UGCBackpackSystemV2.AddItemV2(self, bulletId, 100)
                UGCBackpackSystemV2.AddItemV2(self, bulletId, 100)
                UGCBackpackSystemV2.AddItemV2(self, bulletId, 100)
            end
            
            -- 启动刷怪
            local spawnerManager = UGCActorComponentUtility.GetActorByActorInstancePath("UGCmap.MobSpawnerManager_10")
            spawnerManager:StartSpawnerManager()
        end
    )
    KismetSystemLibrary.K2_SetTimerDelegateForLua(delegate, self, 2, false)    
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


--[[
function UGCPlayerController:GetReplicatedProperties()
    return
end
--]]


--[[
function UGCPlayerController:GetAvailableServerRPCs()
    return
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