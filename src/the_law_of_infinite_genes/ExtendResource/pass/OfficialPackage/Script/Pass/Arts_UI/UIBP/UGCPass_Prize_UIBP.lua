---@class UGCPass_Prize_UIBP_C:UUserWidget
---@field AdvancedList ReuseList2_C
---@field BuyButton UNewButton
---@field CloseButton UNewButton
---@field NormalList ReuseList2_C
---@field ThemeIcon UImage
---@field UltraList ReuseList2_C
---@field PrizeConfig ULuaMapHelper<int32, FF_PassPrizeArrayConfig__pf2076753310>
--Edit Below--
local UGCPass_Prize_UIBP = { bInitDoOnce = false } 

function UGCPass_Prize_UIBP:Construct()
	self.CloseButton.OnClicked:Add(self.OnCloseButtonClick, self)
    self.BuyButton.OnClicked:Add(self.OnBuyButtonClick, self)

    self.NormalList.OnUpdateItem:Add(self.RefreshNormalPrize, self)
    self.AdvancedList.OnUpdateItem:Add(self.RefreshAdvancedPrize, self)
    self.UltraList.OnUpdateItem:Add(self.RefreshUltraPrize, self)
end

function UGCPass_Prize_UIBP:Destruct()
	self.CloseButton.OnClicked:Remove(self.OnCloseButtonClick, self)
    self.BuyButton.OnClicked:Remove(self.OnBuyButtonClick, self)

    self.NormalList.OnUpdateItem:Remove(self.RefreshNormalPrize, self)
    self.AdvancedList.OnUpdateItem:Remove(self.RefreshAdvancedPrize, self)
    self.UltraList.OnUpdateItem:Remove(self.RefreshUltraPrize, self)
end

function UGCPass_Prize_UIBP:Refresh(PassID)
    local PassConfig = PassManager:GetPassConfigData(PassID)
    if PassConfig then
        self.PassID = PassID
        PassManager:SetImageFromIconPath(self.ThemeIcon, PassConfig.ThemeIcon)
    else
        return
    end

    if not self.PrizeConfig[PassID] then
        PassManager:LogError(string.format("PassID %d prize not configured yet!", PassID), "UGCPass_Prize_UIBP:Refresh")
        return
    end

    if PassManager:HasAdvancedPass(PassID) then
        self.BuyButton:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.BuyButton:SetVisibility(ESlateVisibility.Visible)
    end

    self.NormalList:Reload(#self.PrizeConfig[PassID].NormalPrizeItemIDs)
    self.AdvancedList:Reload(#self.PrizeConfig[PassID].AdvancedPrizeItemIDs)
    self.UltraList:Reload(#self.PrizeConfig[PassID].UltraPrizeItemIDs)
end

local function RefreshPrize(Widget, Index, PrizeItemIDs)
    Widget:Refresh(PrizeItemIDs[Index+1])
end

function UGCPass_Prize_UIBP:RefreshNormalPrize(Widget, Index)
    RefreshPrize(Widget, Index, self.PrizeConfig[self.PassID].NormalPrizeItemIDs)
end

function UGCPass_Prize_UIBP:RefreshAdvancedPrize(Widget, Index)
    RefreshPrize(Widget, Index, self.PrizeConfig[self.PassID].AdvancedPrizeItemIDs)
end

function UGCPass_Prize_UIBP:RefreshUltraPrize(Widget, Index)
    RefreshPrize(Widget, Index, self.PrizeConfig[self.PassID].UltraPrizeItemIDs)
end

function UGCPass_Prize_UIBP:OnCloseButtonClick()
    self:SetVisibility(ESlateVisibility.Collapsed)
end

function UGCPass_Prize_UIBP:OnBuyButtonClick()
    self:SetVisibility(ESlateVisibility.Collapsed)
    PassManager:ShowBuyAdvancedPassPanel(self.PassID)
end

return UGCPass_Prize_UIBP