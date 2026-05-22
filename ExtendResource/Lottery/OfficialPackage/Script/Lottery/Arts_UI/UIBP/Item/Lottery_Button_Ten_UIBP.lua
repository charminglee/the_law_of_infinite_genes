---@class Lottery_Button_Ten_UIBP_C:UUserWidget
---@field Button_Round UButton
---@field CanvasPanel_OncePriceBefor UCanvasPanel
---@field Image_MoneyIcon01 UImage
---@field Text_BuyOncePrice UTextBlock
---@field Text_OncePriceBefor UTextBlock
--Edit Below--


local Lottery_Button_Ten_UIBP = { bInitDoOnce = false } 

function Lottery_Button_Ten_UIBP:Construct()
    self:InitBindEvent();
end

-- function Lottery_Button_Ten_UIBP:Tick(MyGeometry, InDeltaTime)

-- end

-- function Lottery_Button_Ten_UIBP:Destruct()

-- end

function Lottery_Button_Ten_UIBP:InitBindEvent()
    self.Button_Round.OnClicked:Add(self.DrawTenth, self)
end

function Lottery_Button_Ten_UIBP:DrawTenth()
    if self.LotteryID == nil then
        return;
    end
    -- 抽十次奖
    LotteryManager:DrawTenth(self.LotteryID);
end

---@param LotteryData LotteryData
function Lottery_Button_Ten_UIBP:InitUI(LotteryID)
    self.LotteryID = LotteryID;
    local LotteryData = LotteryManager:GetLotteryConfigData(LotteryID);
    local ItemID = LotteryManager:GetItemIDByProduct(LotteryData.DrawCostID);;
    local ItemInfo = LotteryManager:GetItemConfigData(ItemID);
    if ItemInfo and ItemInfo.ItemIcon then
        -- 设置消耗货币的Icon
        Common.LoadObjectAsync(ItemInfo.ItemIcon, 
            function (IconTexture)
                if self ~= nil and UE.IsValid(self) then
                    self.Image_MoneyIcon01:SetBrushFromTexture(IconTexture);
                end
            end
        );
    end
    self.Text_BuyOncePrice:SetText(LotteryData.TenDrawCostNum);
    self.CanvasPanel_OncePriceBefor:SetVisibility(ESlateVisibility.Collapsed);
    -- end
end

return Lottery_Button_Ten_UIBP