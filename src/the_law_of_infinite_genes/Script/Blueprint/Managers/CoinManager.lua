---@class CoinManager_C:BaseManager_C
--Edit Below--
local CoinManager = {
    coinData = {}
}


function CoinManager:GetReplicatedProperties()
    return {
        {"coinData", "Lazy"}
    }
end


function CoinManager:OnRep_coinData()
    ugcprint_concat("CoinManager:OnRep_coinData")
end


function CoinManager:ReceiveBeginPlay()
    CoinManager.SuperClass.ReceiveBeginPlay(self)
    self:_InitCoinData()
end


--[[
function CoinManager:ReceiveTick(DeltaTime)
    CoinManager.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]


--[[
function CoinManager:ReceiveEndPlay()
    CoinManager.SuperClass.ReceiveEndPlay(self) 
end
--]]


function CoinManager:_InitCoinData()
    if not self:HasAuthority() then
        return
    end
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
function CoinManager:SetCoin(id, value)
    if not self:HasAuthority() or self.coinData[id] == nil then
        return
    end
    self.coinData[id] = value
    UnrealNetwork.RepLazyProperty(self, "coinData")
end


---增加玩家货币数量。
---@param id number 货币的物品ID
---@param value number 增加数量
function CoinManager:AddCoin(id, value)
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
function CoinManager:GetCoin(id)
    return self.coinData[id]
end


return CoinManager