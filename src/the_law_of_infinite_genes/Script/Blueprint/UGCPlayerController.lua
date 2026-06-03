---@class UGCPlayerController_C:BP_UGCPlayerController_C
---@field HomeComponent HomeComponent_C
---@field RankingListComponent RankingListComponent_C
---@field ShopV2Component ShopV2Component_C
---@field LotteryComponent LotteryComponent_C
--Edit Below--
local UGCPlayerController = {}

function UGCPlayerController:ReceiveBeginPlay()
    UGCPlayerController.SuperClass.ReceiveBeginPlay(self)
    if not self:HasAuthority() then
        return
    end

    -- 初始武器
    local weaponId = 8310018
    local bulletId = 301001
    if not UGCBackPackSystem.IsAttachItemType(weaponId) then
        local delegate = ObjectExtend.CreateDelegate(
            self, 
            function()
                local pawn = self:GetPlayerCharacterSafety()
                UGCBackPackSystem.AddItem(pawn, weaponId, 1)
                UGCBackPackSystem.AddItem(pawn, bulletId, 100)
                UGCBackPackSystem.AddItem(pawn, bulletId, 100)
                UGCBackPackSystem.AddItem(pawn, bulletId, 100)
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

-- [Editor Generated Lua] function define Begin:
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



-- [Editor Generated Lua] function define End;

return UGCPlayerController