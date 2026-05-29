---@class Lottery_PurchasePopups_UIBP_C:UUserWidget
---@field Button_Exchange UButton
---@field Button_Exchange_Purchase_Increase UButton
---@field Button_Exchange_Purchase_Reduce UButton
---@field Button_Purchase UButton
---@field Button_Purchase_Close UButton
---@field Button_Purchase_Increase10 UButton
---@field Button_Purchase_Increase100 UButton
---@field HorizontalBox_Purchase_Limit UHorizontalBox
---@field Image_Exchange_Purchase_MoneyIcon UImage
---@field Lottery_Common_Item_Style1_UIBP ULottery_Common_Item_Style1_UIBP_C
---@field Switcher_ExchangeBut UWidgetSwitcher
---@field Text_Exchange_ItemExplain UTextBlock
---@field Text_Exchange_ItemName UTextBlock
---@field TextBlock_Exchange_Purchase_Amount UTextBlock
---@field TextBlock_Exchange_Purchase_LimitAmount UTextBlock
---@field TextBlock_Exchange_Purchase_Price UTextBlock
---@field TextBlock_Title UTextBlock
---@field TY_PopupsBg_Text UTY_PopupsBg_Text_C
---@field UGC_Common_UIPopupBG UUGC_Common_UIPopupBG_C
--Edit Below--


local Lottery_PurchasePopups_UIBP = { bInitDoOnce = false } 

function Lottery_PurchasePopups_UIBP:Construct()
    self.ExchangeNum = 0;
	self:InitBindEvent();
end

function Lottery_PurchasePopups_UIBP:InitBindEvent()
    self.Button_Exchange_Purchase_Reduce.OnClicked:Add(self.ReduceNum, self);
    self.Button_Exchange_Purchase_Increase.OnClicked:Add(self.IncreaseNum, self);
    self.Button_Purchase_Increase10.OnClicked:Add(self.IncreaseTenNum, self);
    self.Button_Purchase_Increase100.OnClicked:Add(self.IncreaseHundredNum, self);
    self.Button_Purchase_Close.OnClicked:Add(self.Close, self);
    self.Button_Exchange.OnClicked:Add(self.Exchange, self);
    self.Button_Purchase.OnClicked:Add(self.Purchase, self);
end

function Lottery_PurchasePopups_UIBP:ReduceNum()
    if self.ExchangeNum > 1 then
        local ExchangeNum = self.ExchangeNum - 1;
        self:ChangeBuyNum(ExchangeNum);
    end
end

function Lottery_PurchasePopups_UIBP:IncreaseNum()
    if self.ExchangeNum < self.LimitBuyNum then
        local ExchangeNum = self.ExchangeNum + 1;
        self:ChangeBuyNum(ExchangeNum);
    end
end

function Lottery_PurchasePopups_UIBP:IncreaseTenNum()
    if self.ExchangeNum + 10 < self.LimitBuyNum then
        local ExchangeNum = self.ExchangeNum + 10;
        self:ChangeBuyNum(ExchangeNum);
    else
        local ExchangeNum = self.LimitBuyNum;
        self:ChangeBuyNum(ExchangeNum);
    end
end

function Lottery_PurchasePopups_UIBP:IncreaseHundredNum()
    if self.ExchangeNum + 100 < self.LimitBuyNum then
        local ExchangeNum = self.ExchangeNum + 100;
        self:ChangeBuyNum(ExchangeNum);
    else
        local ExchangeNum = self.LimitBuyNum;
        self:ChangeBuyNum(ExchangeNum);
    end
end

function Lottery_PurchasePopups_UIBP:Close()
    self:SetVisibility(ESlateVisibility.Collapsed);
end

function Lottery_PurchasePopups_UIBP:Exchange()
    local ProductData = LotteryManager:GetProductConfigData(self.ProductID);
    if ProductData then
        local CurrentPrice = LotteryManager:GetDiscountPrice(self.ProductID);
        if self.FinalPrice ~= CurrentPrice then
            LotteryManager:OpenLotteryMessageUI("兑换失败，价格已更新");
        elseif LotteryManager:IsProductShelves(self.ProductID) == false then
            LotteryManager:OpenLotteryMessageUI("兑换失败，商品未上架");
        else
            if ProductData.LimitType ~= ELimitType.NotLimited then
                local ExchangeNum = LotteryManager:GetProductRedeemedTimes(self.ProductID) + self.ExchangeNum;
                if ExchangeNum > ProductData.PurchaseLimit then
                    LotteryManager:IsProductShelves("兑换失败，已达到商品兑换上限");
                else
                    LotteryManager:ExchangeProduct(self.ProductID, self.ExchangeNum);
                end
            else
                LotteryManager:ExchangeProduct(self.ProductID, self.ExchangeNum);
            end
        end
    end
    self:Close();
end

function Lottery_PurchasePopups_UIBP:Purchase()
    local ProductData = LotteryManager:GetProductConfigData(self.ProductID);
    if ProductData then
        local CurrentPrice = LotteryManager:GetDiscountPrice(self.ProductID);
        if self.FinalPrice ~= CurrentPrice then
            LotteryManager:OpenLotteryMessageUI("购买失败，价格已更新");
        elseif LotteryManager:IsProductShelves(self.ProductID) == false then
            LotteryManager:OpenLotteryMessageUI("购买失败，商品未上架");
        else
            local CanAfford = LotteryManager:CanAfford(self.ProductID, self.ExchangeNum);
            if ProductData.LimitType ~= ELimitType.NotLimited then
                local ExchangeNum = LotteryManager:GetProductRedeemedTimes(self.ProductID) + self.ExchangeNum;
                if ExchangeNum > ProductData.PurchaseLimit then
                    LotteryManager:OpenLotteryMessageUI("购买失败，已达到商品购买上限");
                else
                    LotteryManager:PurchaseProduct(self.ProductID, CurrentPrice, self.ExchangeNum);
                end
            else
                LotteryManager:PurchaseProduct(self.ProductID, CurrentPrice, self.ExchangeNum);
            end
        end
    end
    self:Close();
end

function Lottery_PurchasePopups_UIBP:ChangeBuyNum(ExchangeNum)
    if ExchangeNum == self.ExchangeNum then
        return; 
    end

    self.ExchangeNum = ExchangeNum;
    self.TextBlock_Exchange_Purchase_Amount:SetText(tostring(self.ExchangeNum));
    local TotalPrice = self.FinalPrice * self.ExchangeNum;
    self.TextBlock_Exchange_Purchase_Price:SetText(tostring(TotalPrice));

    -- 获取当前货币数量
    local CurCurrencyNum = LotteryManager:GetPlayerOwnedItemNum(self.CurrencyID);
    if CurCurrencyNum >= TotalPrice then
        self.TextBlock_Exchange_Purchase_Price:SetColorRGBStr("0B0B0CFF");
    else
        self.TextBlock_Exchange_Purchase_Price:SetColorRGBStr("D7B21FFF");
    end
end

-- function Lottery_PurchasePopups_UIBP:Tick(MyGeometry, InDeltaTime)

-- end

-- function Lottery_PurchasePopups_UIBP:Destruct()

-- end

---@param ProductData FUGCProductData
function Lottery_PurchasePopups_UIBP:InitUI(ProductID)
    self.ExchangeNum = 0;
    self.ProductID = ProductID;
    local ProductData = LotteryManager:GetProductConfigData(ProductID);
    if ProductData then
        local ItemID = ProductData.ItemID;
        self.Lottery_Common_Item_Style1_UIBP:InitUI(ItemID, false, false);
        local ItemInfo = LotteryManager:GetItemConfigData(ItemID);
        if ItemInfo then
            if ItemInfo.ItemDesc then
                self.Text_Exchange_ItemExplain:SetText(tostring(ItemInfo.ItemDesc));
            end
        end
        self.Text_Exchange_ItemName:SetText(tostring(ProductData.ProductName));

        if ProductData.LimitType == ELimitType.NotLimited then
            self.LimitBuyNum = 999;
            self.HorizontalBox_Purchase_Limit:SetVisibility(ESlateVisibility.Collapsed);
        else
            self.HorizontalBox_Purchase_Limit:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
            local CurBuyNum = LotteryManager:GetProductRedeemedTimes(ProductID);
            self.LimitBuyNum = ProductData.PurchaseLimit - CurBuyNum;
            self.TextBlock_Exchange_Purchase_LimitAmount:SetText(string.format("%d/%d", CurBuyNum, ProductData.PurchaseLimit));
        end

        self.CurrencyID = ProductData.CostID;
        local CurrencyInfo = LotteryManager:GetItemConfigData(self.CurrencyID);
        if CurrencyInfo and CurrencyInfo.ItemIcon then
            Common.LoadObjectAsync(CurrencyInfo.ItemIcon, 
                function (IconTexture)
                    if self ~= nil and UE.IsValid(self) then
                        self.Image_Exchange_Purchase_MoneyIcon:SetBrushFromTexture(IconTexture);
                    end
                end
            );
        end
    end
    self.FinalPrice = LotteryManager:GetDiscountPrice(ProductID);
    self:ChangeBuyNum(1);
end

function Lottery_PurchasePopups_UIBP:BuyProduct(ProductID)
    self.Switcher_ExchangeBut:SetActiveWidgetIndex(1);
    self:InitUI(ProductID);
end

function Lottery_PurchasePopups_UIBP:ExchangeProduct(ProductID)
    self.Switcher_ExchangeBut:SetActiveWidgetIndex(0);
    self:InitUI(ProductID);
end

return Lottery_PurchasePopups_UIBP