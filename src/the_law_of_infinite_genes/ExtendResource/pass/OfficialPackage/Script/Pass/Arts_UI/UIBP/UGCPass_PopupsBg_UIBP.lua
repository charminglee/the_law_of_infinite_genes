---@class UGCPass_PopupsBg_UIBP_C:UUserWidget
---@field CancelButton UNewButton
---@field ConfirmButton UNewButton
---@field DescriptionText UUTRichTextBlock
--Edit Below--
local UGCPass_PopupsBg_UIBP = { bInitDoOnce = false } 

function UGCPass_PopupsBg_UIBP:Construct()
	self.CancelButton.OnClicked:Add(self.OnCancelClick, self)
    self.ConfirmButton.OnClicked:Add(self.OnConfirmClick, self)
end

function UGCPass_PopupsBg_UIBP:Destruct()
	self.CancelButton.OnClicked:Remove(self.OnCancelClick, self)
    self.ConfirmButton.OnClicked:Remove(self.OnConfirmClick, self)
end

function UGCPass_PopupsBg_UIBP:Refresh(ProductID)
    self.ProductID = ProductID

    local CommodityOperation = PassManager:GetCommodityOperationManager()
    local VirtualItemManager = PassManager:GetVirtualItemManager()

    local ProductData = CommodityOperation:GetProductData(ProductID)
    local ItemData = VirtualItemManager:GetItemData(ProductData.ItemID)
    local CoinName = ""
    local CurrentPrice = UGCCommoditySystem.GetSellingPriceAfterDiscount(ProductID)

    if ProductData.CurrencyType == ECurrencyType.OasisCoin then
        CoinName = "绿洲币"
    elseif ProductData.CurrencyType == ECurrencyType.OtherCoin then
        CoinName = VirtualItemManager:GetItemData(ProductData.CostID).ItemName
    end

    self.DescriptionText:SetText(string.format("%s不足, 是否消耗%d个%s购买%d个%s?", ItemData.ItemName, CurrentPrice, CoinName, ProductData.ItemNum, ItemData.ItemName))
end

function UGCPass_PopupsBg_UIBP:OnCancelClick()
    self:SetVisibility(ESlateVisibility.Collapsed)
end

function UGCPass_PopupsBg_UIBP:OnConfirmClick()
    self:SetVisibility(ESlateVisibility.Collapsed)

    local CommodityOperation = PassManager:GetCommodityOperationManager()
    if CommodityOperation:CanAfford(self.ProductID, 1) then
        if not self.bBlockBuy then
            local CurrentPrice = UGCCommoditySystem.GetSellingPriceAfterDiscount(self.ProductID)
            CommodityOperation.BuyProductResultDelegate:Add(self.OnBuyResult, self)
            local SecondaryPanel = CommodityOperation:BuyProduct(self.ProductID, CurrentPrice, 1)
            if SecondaryPanel == nil then
                self.bBlockBuy = true
            else
                SecondaryPanel:Then(
                    function (UI)
                        local Widget = UI:Get();
                        Widget.ConfirmationOperationDelegate:Add(self.OnOasisPurchasePanelOperation, self);
                    end
                )
            end
        end
    else
        UGCWidgetManagerSystem.ShowTipsUI("货币不足")
    end
end

function UGCPass_PopupsBg_UIBP:OnBuyResult(Result)
    if Result.ProductID ~= self.ProductID then
        return
    end

    if not Result.bSucceeded then
        PassManager:Log("Purchase skip task product failed", "UGCPass_PopupsBg_UIBP:OnBuyResult")
        UGCWidgetManagerSystem.ShowTipsUI("购买失败")
    end

    self.bBlockBuy = false

    local CommodityOperation = PassManager:GetCommodityOperationManager()
    CommodityOperation.BuyProductResultDelegate:Remove(self.OnBuyResult, self)
end

function UGCPass_PopupsBg_UIBP:OnOasisPurchasePanelOperation(Value)
    self.bBlockBuy = Value
end

return UGCPass_PopupsBg_UIBP