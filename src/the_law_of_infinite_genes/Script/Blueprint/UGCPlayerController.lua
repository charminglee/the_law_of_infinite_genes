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
    coinData = {}
}


function UGCPlayerController:GetReplicatedProperties()
    return {
        {"coinData", "Lazy"}
    }
end


function UGCPlayerController:OnRep_coinData()
    
end


function UGCPlayerController:ReceiveBeginPlay()
    UGCPlayerController.SuperClass.ReceiveBeginPlay(self)

    if not self:HasAuthority() then
        LocalPlayerController = self

    else
        self:_initCoinData()

        local delegate = ObjectExtend.CreateDelegate(
            self, 
            function()
                -- 初始武器
                local weaponId = Config.InitialWeapon.weaponId
                local bulletId = Config.InitialWeapon.bulletId
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


function UGCPlayerController:_initCoinData()
    self.coinData = {
        [ItemId.Coin_0] = 0,
        [ItemId.Coin_1] = 0,
        [ItemId.Coin_2] = 0,
        [ItemId.Coin_3] = 0,
        [ItemId.Coin_4] = 0,
    }
    UnrealNetwork.RepLazyProperty(self, "coinData")
end


---设置玩家货币数量。
---@param id number 货币的物品ID
---@param value number 设置数量
function UGCPlayerController:setCoin(id, value)
    if not self:HasAuthority() or self.coinData[id] == nil then
        return
    end
    self.coinData[id] = value
    UnrealNetwork.RepLazyProperty(self, "coinData")
end


---增加玩家货币数量。
---@param id number 货币的物品ID
---@param value number 增加数量
function UGCPlayerController:addCoin(id, value)
    if not self:HasAuthority() or self.coinData[id] == nil then
        return
    end

    local mul = 1
    -- 尸潮淘金：获得的资源点，金币×2
    if SpecialEventManager.currEvent == SpecialEvent.CorpseSurgeGoldRush then
        mul = 1 + Config.SpecialEvent[SpecialEvent.CorpseSurgeGoldRush].ResourcePointBuff
    end

    self.coinData[id] = self.coinData[id] + value * mul
    UnrealNetwork.RepLazyProperty(self, "coinData")
end


---获取玩家货币数量。
---@param id number 货币的物品ID
---@return number 货币数量
function UGCPlayerController:getCoin(id)
    return self.coinData[id]
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