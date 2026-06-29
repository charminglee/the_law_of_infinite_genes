---@class UGCPass_BuyElite_UIBP_C:UUserWidget
---@field AdvancedPass UGCPass_BuyEliteBig_Item_UIBP_C
---@field CloseButton UNewButton
---@field ThemeIcon UImage
---@field UltraPass UGCPass_BuyEliteBig_Item_UIBP_C
---@field BonusConfigs ULuaMapHelper<int32, FF_PassBonusArrayConfig__pf2076753310>
--Edit Below--
local UGCPass_BuyElite_UIBP = { bInitDoOnce = false } 

function UGCPass_BuyElite_UIBP:Construct()
	self.CloseButton.OnClicked:Add(self.OnCloseButtonClick, self)

    self.AdvancedPass.BonusList.OnUpdateItem:Add(self.RefreshAdvancedBonus, self)
    self.UltraPass.BonusList.OnUpdateItem:Add(self.RefreshUltraBonus, self)

    self.AdvancedPass.BuyButton.OnClicked:Add(self.BuyAdvancedPass, self)
    self.UltraPass.BuyButton.OnClicked:Add(self.BuyUltraPass, self)

    self.OasisIconPath = "/Game/Arts/UI/TableIcons/OasisBadge/Oasis_Icon_64.Oasis_Icon_64"
end

function UGCPass_BuyElite_UIBP:Destruct()
    self.CloseButton.OnClicked:Remove(self.OnCloseButtonClick, self)

    self.AdvancedPass.BonusList.OnUpdateItem:Remove(self.RefreshAdvancedBonus, self)
    self.UltraPass.BonusList.OnUpdateItem:Remove(self.RefreshUltraBonus, self)
end

function UGCPass_BuyElite_UIBP:Refresh(PassID)
    local PassConfig = PassManager:GetPassConfigData(PassID)

    self.AdvancedBonusConfig = self.BonusConfigs[PassID].AdvancedBonus:Copy()
    self.UltraBonusConfig = self.BonusConfigs[PassID].UltraBonus:Copy()
    
    self.AdvancedPassProductID = PassConfig.AdvancedPassProductID
    self.UltraPassProductID = PassConfig.UltraPassProductID
    
    local AdvancedBonusNum = #self.AdvancedBonusConfig
    if AdvancedBonusNum > 0 then
        PassManager:SetImageFromIconPath(self.AdvancedPass.BigBonusIcon, self.AdvancedBonusConfig[1].Icon)
        self.AdvancedPass.BonusDescription:SetText(self.AdvancedBonusConfig[1].Description)
        self.AdvancedPass.BonusList:Reload(AdvancedBonusNum - 1)
    end

    local UltraBonusNum = #self.UltraBonusConfig
    if UltraBonusNum > 0 then
        PassManager:SetImageFromIconPath(self.UltraPass.BigBonusIcon, self.UltraBonusConfig[1].Icon)
        self.UltraPass.BonusDescription:SetText(self.UltraBonusConfig[1].Description)
        self.UltraPass.BonusList:Reload(UltraBonusNum - 1)
    end

    self:RefreshPassPanel(self.AdvancedPass, self.AdvancedPassProductID)
    self:RefreshPassPanel(self.UltraPass, self.UltraPassProductID)
end

function UGCPass_BuyElite_UIBP:RefreshPassPanel(PassPanel, PassProductID, BonusNum)
    local CommodityOperation = PassManager:GetCommodityOperationManager()
    if CommodityOperation == nil then
        PassManager:LogError("CommodityOperation is nil", "UGCPass_BuyElite_UIBP:Refresh")
        return
    end

    local ProductData = CommodityOperation:GetProductData(PassProductID)
    if ProductData.CurrencyType == ECurrencyType.OtherCoin then
        PassManager:SetImageFromItemID(PassPanel.CoinIcon, ProductData.CostID)
    elseif ProductData.CurrencyType == ECurrencyType.OasisCoin then
        PassManager:SetImageFromIconPath(PassPanel.CoinIcon, self.OasisIconPath)
    end

    local bCanAfford = CommodityOperation:CanAfford(PassProductID, 1)
    local CurrentPrice = UGCCommoditySystem.GetSellingPriceAfterDiscount(PassProductID)
    PassPanel.CurrentPriceText:SetText(tostring(CurrentPrice))
    PassPanel.CurrentPriceText:SetColorRGBStr(bCanAfford and "71210DFF" or "FF0000FF")

    if CurrentPrice < ProductData.SellingPrice then
        PassPanel.DiscountTab:SetVisibility(ESlateVisibility.HitTestInvisible)
        PassPanel.Discount:SetVisibility(ESlateVisibility.HitTestInvisible)
        PassPanel.DiscountText:SetText(tostring(ProductData.Discount) .. "折")
        PassPanel.OriginalPriceText:SetText(tostring(ProductData.SellingPrice))
    else
        PassPanel.DiscountTab:SetVisibility(ESlateVisibility.Collapsed)
        PassPanel.Discount:SetVisibility(ESlateVisibility.Collapsed)
    end
end

local function RefreshBonus(Widget, Config)
    PassManager:SetImageFromIconPath(Widget.BonusIcon, Config.Icon)
    Widget.DescriptionText:SetText(Config.Description)
end

function UGCPass_BuyElite_UIBP:RefreshAdvancedBonus(Widget, Index)
    RefreshBonus(Widget, self.AdvancedBonusConfig[Index+2])
end

function UGCPass_BuyElite_UIBP:RefreshUltraBonus(Widget, Index)
    RefreshBonus(Widget, self.UltraBonusConfig[Index+2])
end

function UGCPass_BuyElite_UIBP:OnCloseButtonClick()
    self:SetVisibility(ESlateVisibility.Collapsed)
end

function UGCPass_BuyElite_UIBP:BuyPass(ProductID)
    local CommodityOperation = PassManager:GetCommodityOperationManager()
    if CommodityOperation == nil then
        PassManager:LogError("CommodityOperation is nil", "UGCPass_BuyElite_UIBP:BuyAdvancedPass")
        return
    end

    if not CommodityOperation:CanAfford(ProductID, 1) then
        UGCWidgetManagerSystem.ShowTipsUI("货币不足")
        return
    end

    if not self.bBlockBuy then
        local CurrentPrice = UGCCommoditySystem.GetSellingPriceAfterDiscount(ProductID)
        CommodityOperation.BuyProductResultDelegate:Add(self.OnBuyResult, self)
        local SecondaryPanel = CommodityOperation:BuyProduct(ProductID, CurrentPrice, 1)
        if SecondaryPanel == nil then
            self.bBlockBuy = true
            self:SetVisibility(ESlateVisibility.Collapsed)
        else
            SecondaryPanel:Then(
                function (UI)
                    local Widget = UI:Get();
                    Widget.ConfirmationOperationDelegate:Add(self.OnOasisPurchasePanelOperation, self);
                end
            )
        end
    end
end

function UGCPass_BuyElite_UIBP:BuyAdvancedPass()
    self:BuyPass(self.AdvancedPassProductID)
end

function UGCPass_BuyElite_UIBP:BuyUltraPass()
    self:BuyPass(self.UltraPassProductID)
end

function UGCPass_BuyElite_UIBP:OnOasisPurchasePanelOperation(Value)
    if Value then
        self:SetVisibility(ESlateVisibility.Collapsed)
    end

    self.bBlockBuy = Value
end

function UGCPass_BuyElite_UIBP:OnBuyResult(Result)
    if Result.ProductID ~= self.AdvancedPassProductID and Result.ProductID ~= self.UltraPassProductID then
        return
    end

    if not Result.bSucceeded then
        PassManager:Log("Purchase advanced pass failed", "UGCPass_BuyElite_UIBP:OnBuyResult")
        UGCWidgetManagerSystem.ShowTipsUI("购买失败")
    end

    self.bBlockBuy = false

    local CommodityOperation = PassManager:GetCommodityOperationManager()
    CommodityOperation.BuyProductResultDelegate:Remove(self.OnBuyResult, self)
end

return UGCPass_BuyElite_UIBP