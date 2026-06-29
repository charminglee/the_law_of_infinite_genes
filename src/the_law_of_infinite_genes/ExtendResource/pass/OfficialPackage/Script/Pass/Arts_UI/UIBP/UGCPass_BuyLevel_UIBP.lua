---@class UGCPass_BuyLevel_UIBP_C:UUserWidget
---@field CloseButton UNewButton
---@field CoinIcon UImage
---@field Currency UGC_Common_Currency_UIBP_C
---@field CurrentLevelText UTextBlock
---@field Decrease10Button UNewButton
---@field DecreaseButton UNewButton
---@field Increase10Button UNewButton
---@field IncreaseButton UNewButton
---@field PreviewList ReuseList2_C
---@field PriceText UTextBlock
---@field PurchaseButton UNewButton
---@field TargetLevelText UTextBlock
---@field ThemeIcon UImage
---@field UpgradeLevelText UTextBlock
--Edit Below--
local UGCPass_BuyLevel_UIBP = 
{ 
    bInitDoOnce = false,
    UpgradeLevel = 0,
    CurrentPrice = 0,
} 

function UGCPass_BuyLevel_UIBP:Construct()
	self.CloseButton.OnClicked:Add(self.OnCloseButtonClick, self)
    self.PurchaseButton.OnClicked:Add(self.OnPurchaseButtonClick, self)
    self.IncreaseButton.OnClicked:Add(self.OnIncreaseButtonClick, self)
    self.Increase10Button.OnClicked:Add(self.OnIncrease10ButtonClick, self)
    self.DecreaseButton.OnClicked:Add(self.OnDecreaseButtonClick, self)
    self.Decrease10Button.OnClicked:Add(self.OnDecrease10ButtonClick, self)

    self.PreviewList.OnUpdateItem:Add(self.RefreshPreviewItem, self)
end

function UGCPass_BuyLevel_UIBP:Destruct()
    self.CloseButton.OnClicked:Remove(self.OnCloseButtonClick, self)
    self.PurchaseButton.OnClicked:Remove(self.OnPurchaseButtonClick, self)
    self.IncreaseButton.OnClicked:Remove(self.OnIncreaseButtonClick, self)
    self.Increase10Button.OnClicked:Remove(self.OnIncrease10ButtonClick, self)
    self.DecreaseButton.OnClicked:Remove(self.OnDecreaseButtonClick, self)
    self.Decrease10Button.OnClicked:Remove(self.OnDecrease10ButtonClick, self)

    self.PreviewList.OnUpdateItem:Remove(self.RefreshPreviewItem, self)
end

function UGCPass_BuyLevel_UIBP:Refresh(PassID)
    self.UpgradeLevel = 0
    self.PassID = PassID
    self.bHasAdvance = PassManager:HasAdvancedPass(PassID)
    self.MaxLevel = PassManager:GetMaxLevel(PassID)
    self.LevelData = PassManager:GetPassCurrentLevelData(PassID)
    self.CurrentLevelText:SetText(tostring(self.LevelData.Level))
    self.TargetLevelText:SetText(tostring(self.LevelData.Level+self.UpgradeLevel))
    self.UpgradeLevelText:SetText(tostring(self.UpgradeLevel))

    self.PassConfig = PassManager:GetPassConfigData(PassID)
    if self.PassConfig ~= nil then
        PassManager:SetImageFromIconPath(self.ThemeIcon, self.PassConfig.ThemeIcon)
        PassManager:SetImageFromItemID(self.Currency.CoinIcon, self.PassConfig.LevelPurchaseItemID)
        PassManager:SetImageFromItemID(self.CoinIcon, self.PassConfig.LevelPurchaseItemID)

        self.PriceText:SetText(tostring(self.PassConfig.LevelPurchaseItemNum * self.UpgradeLevel))

        local VirtualItemManager = PassManager:GetVirtualItemManager()
        if VirtualItemManager then
            self.Currency.CoinNumText:SetText(tostring(VirtualItemManager:GetItemNum(self.PassConfig.LevelPurchaseItemID)))
        end
    end

    self:RefreshPreviewList()
end

function UGCPass_BuyLevel_UIBP:RefreshPreviewList()
    if self.UpgradeLevel <= 0 then
        self.PreviewList:Reload(0)
        return
    end

    self.PreviewList:Reload(self.bHasAdvance and 2 * self.UpgradeLevel or self.UpgradeLevel)
end

function UGCPass_BuyLevel_UIBP:RefreshPreviewItem(Widget, Index)
    Index = Index + 1
    local AwardIndex = Index
    if self.bHasAdvance then
        AwardIndex = math.floor(Index / 2) + (Index % 2)
    end

    AwardIndex = AwardIndex + self.LevelData.Level

    local Awards = PassManager:GetPassAwardConfigData(self.PassID)
    if not self.bHasAdvance or Index % 2 ~= 0 then
        Widget:Refresh(Awards[AwardIndex].NormalItem)
    else
        Widget:Refresh(Awards[AwardIndex].AdvancedItem)
    end
end

function UGCPass_BuyLevel_UIBP:ChangeLevel(Count)
    local ChangeLevel = self.LevelData.Level + self.UpgradeLevel + Count
    
    if ChangeLevel > self.MaxLevel then
        self.UpgradeLevel = self.MaxLevel - self.LevelData.Level
    elseif ChangeLevel < self.LevelData.Level then
        self.UpgradeLevel = 0
    else
        self.UpgradeLevel = self.UpgradeLevel + Count
    end

    self.UpgradeLevelText:SetText(tostring(self.UpgradeLevel))
    self.TargetLevelText:SetText(tostring(self.LevelData.Level+self.UpgradeLevel))

    self.CurrentPrice = self.PassConfig.LevelPurchaseItemNum * self.UpgradeLevel
    self.PriceText:SetText(tostring(self.CurrentPrice))

    local VirtualItemManager = PassManager:GetVirtualItemManager()
    if VirtualItemManager then
        local CoinNum = VirtualItemManager:GetItemNum(self.PassConfig.LevelPurchaseItemID)
        self.PriceText:SetColorRGBStr(CoinNum < self.CurrentPrice and "FF0000" or "023AA0FF")
    end

    self:RefreshPreviewList()
end

function  UGCPass_BuyLevel_UIBP:OnCloseButtonClick()
    self:SetVisibility(ESlateVisibility.Collapsed)
end

function UGCPass_BuyLevel_UIBP:OnPurchaseButtonClick()
    local VirtualItemManager = PassManager:GetVirtualItemManager()
    if VirtualItemManager == nil then
        PassManager:LogError("VirtualItemManager is nil", "UGCPass_BuyLevel_UIBP:OnPurchaseButtonClick")
        return
    end

    if self.CurrentPrice <= 0 then
        return
    end

    local CoinNum = VirtualItemManager:GetItemNum(self.PassConfig.LevelPurchaseItemID)
    if CoinNum < self.CurrentPrice then
        UGCWidgetManagerSystem.ShowTipsUI("货币不足")
        return
    end

    PassManager:UpgradeLevel(self.PassID, self.LevelData.Level + self.UpgradeLevel)
    self:SetVisibility(ESlateVisibility.Collapsed)
end

function UGCPass_BuyLevel_UIBP:OnIncrease10ButtonClick()
    self:ChangeLevel(10)
end

function UGCPass_BuyLevel_UIBP:OnIncreaseButtonClick()
    self:ChangeLevel(1)
end

function UGCPass_BuyLevel_UIBP:OnDecrease10ButtonClick()
    self:ChangeLevel(-10)
end

function UGCPass_BuyLevel_UIBP:OnDecreaseButtonClick()
    self:ChangeLevel(-1)
end

return UGCPass_BuyLevel_UIBP