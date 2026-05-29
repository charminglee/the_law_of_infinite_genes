---@class Lottery_Button_One_UIBP_C:UUserWidget
---@field BtnBuyOnce UButton
---@field CanvasPanel_OncePriceBefor UCanvasPanel
---@field Image_MoneyIcon01 UImage
---@field Text_BuyOncePrice UTextBlock
---@field Text_OncePriceBefor UTextBlock
--Edit Below--

UGCGameSystem.UGCRequire("ExtendResource.Lottery.OfficialPackage." .. "Script.Lottery.LotteryManager")

local Lottery_Button_One_UIBP = { bInitDoOnce = false } 

function Lottery_Button_One_UIBP:Construct()
	self:InitBindEvent();
end

-- function Lottery_Button_One_UIBP:Tick(MyGeometry, InDeltaTime)

-- end

-- function Lottery_Button_One_UIBP:Destruct()

-- end

function Lottery_Button_One_UIBP:InitBindEvent()
    self.BtnBuyOnce.OnClicked:Add(self.DrawOnce, self)
end

function Lottery_Button_One_UIBP:DrawOnce()
    if self.LotteryID == nil then
        return;
    end
    -- 抽一次奖
    LotteryManager:DrawOnce(self.LotteryID);
end

---@param LotteryData LotteryData
function Lottery_Button_One_UIBP:InitUI(LotteryID)
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
    -- 是否有折扣，有则显示原价，没有则隐藏
    self:RefreshDrawDiscount();
end

function Lottery_Button_One_UIBP:RefreshDrawDiscount()
    local LotteryData = LotteryManager:GetLotteryConfigData(self.LotteryID);
    if LotteryData.IsFirstDrawDiscountOpen and LotteryManager:CheckHasFirstDrawDiscount(LotteryData.ID, LotteryData.FirstDrawDiscountResetType) and LotteryData.OneDrawCostNum > LotteryData.FirstDrawDiscountCost then
        self.Text_OncePriceBefor:SetText(LotteryData.OneDrawCostNum);
        self.Text_BuyOncePrice:SetText(LotteryData.FirstDrawDiscountCost);
        self.CanvasPanel_OncePriceBefor:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
    else
        self.Text_BuyOncePrice:SetText(LotteryData.OneDrawCostNum);
        self.CanvasPanel_OncePriceBefor:SetVisibility(ESlateVisibility.Collapsed);
    end
end

return Lottery_Button_One_UIBP