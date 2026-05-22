---@class Lottery_Currency_UIBP_C:UUserWidget
---@field AmountText UTextBlock
---@field CurrencyIcon UImage
---@field ItemID int32
---@field CurrencyIconTexture UTexture2D
--Edit Below--

local Lottery_Currency_UIBP = { bInitDoOnce = false } 

function Lottery_Currency_UIBP:Construct()
    self.CurrencyIcon:SetBrushFromTexture(self.CurrencyIconTexture);
    self.AmountText:SetText("0");
    LotteryManager.OnItemNumChangeDelegate:Add(self.Refresh, self);
end

-- function Lottery_Currency_UIBP:Tick(MyGeometry, InDeltaTime)

-- end

-- function Lottery_Currency_UIBP:Destruct()

-- end

function Lottery_Currency_UIBP:Refresh()
    local CoinNum = LotteryManager:GetPlayerOwnedItemNum(self.ItemID)
    print(string.format("[Lottery_Currency_UIBP] ItemNum: %d", CoinNum or -1));
    self.AmountText:SetText(tostring(CoinNum));
end

return Lottery_Currency_UIBP