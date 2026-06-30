---@class UGCPlayerController_C:BP_UGCPlayerController_C
---@field PassComponent PassComponent_C
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

                if Config.Debug.AutoStartGame then
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