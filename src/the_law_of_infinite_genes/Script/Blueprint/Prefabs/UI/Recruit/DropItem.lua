---@class DropItem_C:UUserWidget
---@field CanvasPanel_Icon UCanvasPanel
---@field Image_Icon UImage
---@field Image_QualityBar UImage
---@field Image_QualityBarBg UImage
---@field Size FVector2D
---@field DurabilityPercent float
--Edit Below--
local DropItem = {}

function DropItem:SetData(Data)
    self:SetVisibility(Data and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
    if not Data then
        return
    end
    self.CanvasPanel_Icon:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    if Data.Texture then
        self.Image_Icon:SetBrushFromTexture(Data.Texture, false)
    elseif Data.ItemID then
        local IconPath = UGCItemSystemV2.GetItemIconWithPlayerSkinV2(Data.ItemID, UGCGameSystem.GetLocalPlayerController())
        local Quality = UGCItemSystemV2.GetItemQualityV2(Data.ItemID)
        local WeakSelf = WeakObjectPtr(self)
        UGCObjectUtility.AsyncLoadObjectBySoftPath(IconPath, function(Texture)
            if WeakSelf:IsValid() then
                WeakSelf:Get().Image_Icon:SetBrushFromTexture(Texture, false)
            end
        end)
        self:SetQuality(Quality)
    end
end

function DropItem:SetQuality(Quality)
    local BackgroundPath = UGCItemSystemV2.GetQualityTexturePath(Quality)
    local BarPath = UGCItemSystemV2.GetQualityBarTexturePath(Quality)
    local WeakSelf = WeakObjectPtr(self)
    UGCObjectUtility.AsyncLoadObject(BackgroundPath, function(Texture)
        if WeakSelf:IsValid() then
            WeakSelf:Get().Image_QualityBarBg:SetBrushFromTexture(Texture, false)
        end
    end)
    UGCObjectUtility.AsyncLoadObject(BarPath, function(Texture)
        if WeakSelf:IsValid() then
            WeakSelf:Get().Image_QualityBar:SetBrushFromTexture(Texture, false)
        end
    end)
end

return DropItem
