---@class UGCPlayerController_C:BP_UGCPlayerController_C
---@field FightComponent FightComponent_C
---@field ACHVComponent CHVComponent_C
---@field StoreComponent StoreComponent_C
---@field HomeComponent HomeComponent_C
---@field RankingListComponent RankingListComponent_C
---@field ShopV2Component ShopV2Component_C
---@field LotteryComponent LotteryComponent_C
--Edit Below--
local UGCPlayerController = {
    Coin_0 = 0,
    Coin_1 = 0,
    Coin_2 = 0,
    Coin_3 = 0,
    Coin_4 = 0,
}


function UGCPlayerController:GetReplicatedProperties()
    return
    "Coin_0",
    "Coin_1",
    "Coin_2",
    "Coin_3",
    "Coin_4"
end


function UGCPlayerController:ReceiveBeginPlay()
    self.SuperClass.ReceiveBeginPlay(self)

    if not self:HasAuthority() then
        LocalPlayerController = self

    else
        local delegate = ObjectExtend.CreateDelegate(
            self, 
            function()
                -- 初始武器
                local weaponId = 8310018
                local bulletId = 301001
                if UGCBackpackSystemV2.GetWarehouseItemCount(self, weaponId) == 0 then
                    UGCBackpackSystemV2.AddItemV2(self, weaponId, 1)
                    UGCBackpackSystemV2.AddItemV2(self, bulletId, 100)
                    UGCBackpackSystemV2.AddItemV2(self, bulletId, 100)
                    UGCBackpackSystemV2.AddItemV2(self, bulletId, 100)
                end

                -- 测试
                GameState:StartGame()
            end
        )
        KismetSystemLibrary.K2_SetTimerDelegateForLua(delegate, self, 2, false)

        local delegate = ObjectExtend.CreateDelegate(
            self, 
            function()
                SpecialEventManager.TriggerSpecialEvent(SpecialEvent.PutridMiasma)
                ugcprint("Cost_1: "..tostring(self.Cost_1))
            end
        )
        KismetSystemLibrary.K2_SetTimerDelegateForLua(delegate, self, 10, false)
    end
end


function UGCPlayerController:OnRep_Coin_0()
    
end


function UGCPlayerController:OnRep_Coin_1()
    
end


function UGCPlayerController:OnRep_Coin_2()
    
end


function UGCPlayerController:OnRep_Coin_3()
    
end


function UGCPlayerController:OnRep_Coin_4()
    
end


---设置玩家货币数量。
---@param type number 币种（0-4）
---@param value number 设置数量
function UGCPlayerController:SetCoin(type, value)
    if not self:HasAuthority() then
        return
    end
end


---增加玩家货币数量。
---@param type number 币种（0-4）
---@param value number 增加数量
function UGCPlayerController:AddCoin(type, value)
    if not self:HasAuthority() then
        return
    end
end


---获取玩家货币数量。
---@param type number 币种（0-4）
---@return number 货币数量
function UGCPlayerController:GetCoin(type)
    if type == 0 then
        return self.Coin_0
    elseif type == 1 then
        return self.Coin_1
    elseif type == 2 then
        return self.Coin_2
    elseif type == 3 then
        return self.Coin_3
    elseif type == 4 then
        return self.Coin_4
    end
    return -1
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