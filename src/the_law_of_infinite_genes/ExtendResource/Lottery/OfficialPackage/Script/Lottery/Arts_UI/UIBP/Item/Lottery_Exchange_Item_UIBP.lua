---@class Lottery_Exchange_Item_UIBP_C:UUserWidget
---@field Button_Exchange_Gray UButton
---@field Button_Exchange_Purchase UButton
---@field Button_Removed UButton
---@field Button_SoldOut UButton
---@field Canvas_Exchange_Discount_Gray UCanvasPanel
---@field Canvas_Exchange_Item_Discount UCanvasPanel
---@field CanvasPanel_Exchange_LimitPurchase UCanvasPanel
---@field CanvasPanel_Label UCanvasPanel
---@field CanvasPanel_Surplus UCanvasPanel
---@field Image_Exchange_MoneyIcon_Gray UImage
---@field Image_ExchangeShop_Item_MoneyIcon UImage
---@field Lottery_Common_Item_Style2_UIBP ULottery_Common_Item_Style2_UIBP_C
---@field Text_Exchange_FinalPrice_Gray UTextBlock
---@field Text_Exchange_Item_FinalPrice UTextBlock
---@field Text_Exchange_Item_OriginalPrice UTextBlock
---@field TextBlock_Exchange_Item_Limit UTextBlock
---@field TextBlock_ExchangeShop_OriginalPrice_Gray UTextBlock
---@field TextBlock_Item_Limit_Time UTextBlock
---@field TextBlock_Label UTextBlock
---@field TextBlock_SurplusTime UTextBlock
---@field WidgetSwitcher_Exchange UWidgetSwitcher
---@field WidgetSwitcher_Label UWidgetSwitcher
--Edit Below--
local Lottery_Exchange_Item_UIBP = { bInitDoOnce = false } 


function Lottery_Exchange_Item_UIBP:Construct()
	self:InitBindEvent();
    self.CanvasPanel_Label:SetVisibility(ESlateVisibility.Collapsed);
end

function Lottery_Exchange_Item_UIBP:InitBindEvent()
    self.Button_Exchange_Purchase.OnClicked:Add(self.OpenExchangeProductUI, self);
    self.Button_Exchange_Gray.OnClicked:Add(self.OpenExchangeProductUI, self);
end

function Lottery_Exchange_Item_UIBP:OpenExchangeProductUI()
    LotteryManager:OpenExchangeProductUI(self.ProductID);
end

-- function Lottery_Exchange_Item_UIBP:Tick(MyGeometry, InDeltaTime)

-- end

-- function Lottery_Exchange_Item_UIBP:Destruct()

-- end

---@param ProductData FUGCProductData
function Lottery_Exchange_Item_UIBP:Init(ProductID)
    self.ProductID = ProductID;
    local ProductData = LotteryManager:GetProductConfigData(ProductID);
    local ItemID = ProductData.ItemID;
    -- 道具信息
    self.Lottery_Common_Item_Style2_UIBP:InitUI(ItemID, true, false);
    -- 限购
    if ProductData.LimitType == ELimitType.NotLimited then
        self.TextBlock_Item_Limit_Time:SetVisibility(ESlateVisibility.Collapsed);
        self.TextBlock_Exchange_Item_Limit:SetVisibility(ESlateVisibility.Collapsed);  
    else
        local Text = "";
        local CurBuyNum = LotteryManager:GetProductRedeemedTimes(ProductID);
        if ProductData.LimitType == ELimitType.DailyLimit then
            Text = "每日限购";
        elseif ProductData.LimitType == ELimitType.WeeklyLimit then
            Text = "每周限购";
        elseif ProductData.LimitType == ELimitType.PermanentLimit then
            Text = "永久限购";
        end
        self.TextBlock_Item_Limit_Time:SetText(Text);
        local LimitBuyNum = ProductData.PurchaseLimit;
        self.TextBlock_Exchange_Item_Limit:SetText(string.format("%d/%d", CurBuyNum, LimitBuyNum));
        self.TextBlock_Item_Limit_Time:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
        self.TextBlock_Exchange_Item_Limit:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
    end

    local ItemIcon;
    --- 显示货币类型
    if ProductData.CurrencyType == ECurrencyType.OtherCoin then
        local CurrencyItemInfo = LotteryManager:GetItemConfigData(ProductData.CostID);
        ItemIcon = CurrencyItemInfo.ItemIcon;
    elseif ProductData.CurrencyType == ECurrencyType.OasisCoin then
        ItemIcon = LotteryManager:GetOasisIconPath();
    end

    if ItemIcon then
        Common.LoadObjectAsync(ItemIcon, 
            function (IconTexture)
                if self ~= nil and UE.IsValid(self) then
                    self.Image_ExchangeShop_Item_MoneyIcon:SetBrushFromTexture(IconTexture);
                    self.Image_Exchange_MoneyIcon_Gray:SetBrushFromTexture(IconTexture);
                end
            end
        );
    end

    local Discount = false;
    --- 判断商品状态
    local CanExchange = LotteryManager:CanExchangeProduct(ProductID);
    local IsSoldOut = LotteryManager:IsProductSoldOut(ProductID);
    local IsExpired = LotteryManager:IsProductExpired(ProductID);
    if IsExpired then
        -- 下架
        self.WidgetSwitcher_Exchange:SetActiveWidgetIndex(2);
    elseif IsSoldOut then
        -- 售罄
        self.WidgetSwitcher_Exchange:SetActiveWidgetIndex(3);
    else
        -- 价格
        if CanExchange then
            -- 可兑换
            self.WidgetSwitcher_Exchange:SetActiveWidgetIndex(0);

            local DiscountPrice = LotteryManager:GetDiscountPrice(ProductID);
            self.Text_Exchange_Item_FinalPrice:SetText(tostring(DiscountPrice));
            if ProductData.SellingPrice ~= DiscountPrice then
                -- 有折扣
                self.Canvas_Exchange_Item_Discount:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
                self.Text_Exchange_Item_OriginalPrice:SetText(tostring(ProductData.SellingPrice));
                self.CanvasPanel_Label:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
                self.TextBlock_Label:SetText(tostring(ProductData.Discount) .. "折");
                Discount = true;
            else
                -- 无折扣
                self.CanvasPanel_Label:SetVisibility(ESlateVisibility.Collapsed);
                self.Canvas_Exchange_Item_Discount:SetVisibility(ESlateVisibility.Collapsed);
            end
        else
            -- 碎片不足
            self.WidgetSwitcher_Exchange:SetActiveWidgetIndex(1);

            local DiscountPrice = LotteryManager:GetDiscountPrice(ProductID);
            self.Text_Exchange_FinalPrice_Gray:SetText(tostring(DiscountPrice));
            if ProductData.SellingPrice ~= DiscountPrice then
                -- 有折扣
                self.Canvas_Exchange_Discount_Gray:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
                self.TextBlock_ExchangeShop_OriginalPrice_Gray:SetText(tostring(ProductData.SellingPrice));
                self.CanvasPanel_Label:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
                self.TextBlock_Label:SetText(tostring(ProductData.Discount) .. "折");
                Discount = true;
            else
                -- 无折扣
                self.CanvasPanel_Label:SetVisibility(ESlateVisibility.Collapsed);
                self.Canvas_Exchange_Discount_Gray:SetVisibility(ESlateVisibility.Collapsed);
            end
        end
        self:SetExpiredInfo(ProductID, Discount);
    end
end

function Lottery_Exchange_Item_UIBP:SetExpiredInfo(ProductID, HasDiscount)
    --- 显示倒计时（单位：天）
    --- 优先显示折扣剩余时间
    local ProductData = LotteryManager:GetLotteryConfigData(ProductID);
    if ProductData then
        if HasDiscount == true and LotteryManager:IsPermanentDiscount(ProductData.DiscountEndTime) == false then
            local RemainingDays = LotteryManager:GetRemainingDays(ProductData.DiscountEndTime);
            self.CanvasPanel_Surplus:SetVisibility(ESlateVisibility.HitTestInvisible);
            self.TextBlock_SurplusTime:SetText(string.format("折扣剩%d天", RemainingDays)); 
        elseif ProductData.AvailableForSale == EAvailableForSale.LimitedTimeSale then
            local RemainingDays = LotteryManager:GetRemainingDays(ProductData.DelistingTime);
            self.CanvasPanel_Surplus:SetVisibility(ESlateVisibility.HitTestInvisible);
            self.TextBlock_SurplusTime:SetText(string.format("剩%d天下架", RemainingDays));
        else
            self.CanvasPanel_Surplus:SetVisibility(ESlateVisibility.Collapsed);
        end
    end
end

---刷新限购商品的购买数量
function Lottery_Exchange_Item_UIBP:RefreshPurchaseTime()
    local ProductData = LotteryManager:GetProductConfigData(self.ProductID);
    if ProductData then
        if ProductData.LimitType ~= ELimitType.NotLimited then
            local CurBuyNum = LotteryManager:GetProductRedeemedTimes(self.ProductID);
            local LimitBuyNum = ProductData.PurchaseLimit;
            self.TextBlock_Exchange_Item_Limit:SetText(string.format("%d/%d", CurBuyNum, LimitBuyNum));
            print(string.format("[Lottery_Exchange_Item_UIBP] RefreshPurchaseTime CurBuyNum: %d LimitBuyNum: %d", CurBuyNum or -1, LimitBuyNum or -1));
        end
    end
end

return Lottery_Exchange_Item_UIBP