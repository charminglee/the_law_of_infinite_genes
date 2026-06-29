---@class UGCPass_Common_Item_UIBP_C:UUserWidget
---@field CanClaim UCanvasPanel
---@field ClaimedIcon UImage
---@field ItemIcon UImage
---@field LockIcon UImage
---@field NumText UTextBlock
---@field QualityBackground UImage
---@field QualityBar UImage
--Edit Below--
local UGCPass_Common_Item_UIBP = { 
    bInitDoOnce = false,
} 

function UGCPass_Common_Item_UIBP:Construct()
end

function UGCPass_Common_Item_UIBP:Destruct()
end

function UGCPass_Common_Item_UIBP:Refresh(Item)
    PassManager:SetImageFromItemID(self.ItemIcon, Item.ItemID)

    if Item.Num <= 1 then
        self.NumText:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.NumText:SetVisibility(ESlateVisibility.HitTestInvisible)
        self.NumText:SetText(tostring(Item.Num))
    end

    local BackgroundPath, BarPath = PassManager:GetItemQualityPath(Item.ItemID)
    if BackgroundPath ~= "" then
        PassManager:SetImageFromIconPath(self.QualityBackground, BackgroundPath)
        self.QualityBackground:SetVisibility(ESlateVisibility.HitTestInvisible)
    else
        self.QualityBackground:SetVisibility(ESlateVisibility.Collapsed)
    end

    if BarPath ~= "" then
        PassManager:SetImageFromIconPath(self.QualityBar, BarPath)
        self.QualityBar:SetVisibility(ESlateVisibility.HitTestInvisible)
    else
        self.QualityBar:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function UGCPass_Common_Item_UIBP:Reset()
    self.LockIcon:SetVisibility(ESlateVisibility.Collapsed)
    self.ClaimedIcon:SetVisibility(ESlateVisibility.Collapsed)
    self.CanClaim:SetVisibility(ESlateVisibility.Collapsed)
end

return UGCPass_Common_Item_UIBP