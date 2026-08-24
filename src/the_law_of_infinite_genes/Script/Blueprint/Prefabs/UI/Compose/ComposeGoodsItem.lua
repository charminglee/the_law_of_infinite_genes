---@class ComposeGoodsItem_C:UAEUserWidget
---@field Button_0 UButton
---@field Item UImage
---@field ItemName UTextBlock
---@field quality UImage
---@field Selected USizeBox
--Edit Below--
local ComposeGoodsItem = {
    bInitDoOnce = false,
    Index = nil,
}

function ComposeGoodsItem:Construct()
    self:LuaInit();
end

function ComposeGoodsItem:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self:Listen();
end

function ComposeGoodsItem:Listen()
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);
end

function ComposeGoodsItem:Button_0_Clicked()
    ComposeManager.SelectedIndex = self.Index;
    ComposeManager.GoodSelectedIndex = self.Index;
end

function ComposeGoodsItem:SetItem(ItemId)
    local formula = ItemCfg.Formula[ItemId];

end

function ComposeGoodsItem:SetGoodItem(ItemId)
    local ItemName = UGCItemSystemV2.GetItemNameV2(ItemId);
    self.ItemName:SetText(ItemName);
    local ItemPath = UGCItemSystemV2.GetItemIconTextureV2(ItemId);
    local Texture = LoadObject(ItemPath.AssetPathName);
    self.Item:SetBrushFromTexture(Texture);
    local customType = UGCItemSystemV2.GetItemCustomizedTypeV2(ItemId);
    local Q = 1;
    if tonumber(customType) > 5 then
        Q = UGCItemSystemV2.GetItemQualityV2(ItemId);
    else
        Q = 1;
    end
    local QPath = ItemCfg.ItemQuality[Q].path;
    local QTexture = LoadObject(QPath);
    self.quality:SetBrushFromTexture(QTexture);
end

function ComposeGoodsItem:SetSelected(Visible)
    if Visible then
        self.Selected:SetVisibility(ESlateVisibility.Visible);
    else
        self.Selected:SetVisibility(ESlateVisibility.Collapsed);
    end
end

function ComposeGoodsItem:SetMaterial(dat)
    self.ItemName:SetText(tostring(dat.Count));
    local ItemId = dat.ItemId;
    local ItemPath = UGCItemSystemV2.GetItemIconTextureV2(ItemId);
    local Texture = LoadObject(ItemPath.AssetPathName);
    self.Item:SetBrushFromTexture(Texture);
    local customType = UGCItemSystemV2.GetItemCustomizedTypeV2(ItemId);
    local Q = 1;
    if tonumber(customType) > 5 then
        Q = UGCItemSystemV2.GetItemQualityV2(ItemId);
    else
        Q = 7;
    end
    local QPath = ItemCfg.ItemQuality[Q].path;
    local QTexture = LoadObject(QPath);
    self.quality:SetBrushFromTexture(QTexture);
    self.Selected:SetVisibility(ESlateVisibility.Collapsed);

end
return ComposeGoodsItem