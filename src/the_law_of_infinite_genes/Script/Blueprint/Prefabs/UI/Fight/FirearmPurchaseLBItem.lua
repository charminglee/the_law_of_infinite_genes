---@class FirearmPurchaseLBItem_C:UUserWidget
---@field border UImage
---@field Button_0 UButton
---@field Item UImage
---@field ItemName UTextBlock
---@field Normal UCanvasPanel
---@field Selected UCanvasPanel
--Edit Below--
local FirearmPurchaseLBItem = {
    bInitDoOnce = false,
    Index = nil,
    ItemData = nil,
    RenderVersion = 0,
}

function FirearmPurchaseLBItem:Construct()
    self:LuaInit();
end

function FirearmPurchaseLBItem:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);
end

function FirearmPurchaseLBItem:Button_0_Clicked()
    if self.Index ~= nil and self.ItemData ~= nil then
        FightManager:SelectPurchase(self.Index);
    end
end

function FirearmPurchaseLBItem:SetEmpty()
    self.Index = nil;
    self.ItemData = nil;
    self.RenderVersion = self.RenderVersion + 1;
    self:SetVisibility(ESlateVisibility.Collapsed);
end

function FirearmPurchaseLBItem:SetSelected(IsSelected)
    self.Selected:SetVisibility(IsSelected and ESlateVisibility.Visible or ESlateVisibility.Collapsed);
    self.Normal:SetVisibility(IsSelected and ESlateVisibility.Collapsed or ESlateVisibility.Visible);
end

---@param Index number
---@param ItemData table
function FirearmPurchaseLBItem:SetItemData(Index, ItemData)
    if ItemData == nil or ItemData.ItemId == nil then
        self:SetEmpty();
        return;
    end
    self.Index = Index;
    self.ItemData = ItemData;
    self.RenderVersion = self.RenderVersion + 1;
    local renderVersion = self.RenderVersion;
    self:SetVisibility(ESlateVisibility.Visible);

    local itemId = ItemData.ItemId;
    self.ItemName:SetText(UGCItemSystemV2.GetItemNameV2(itemId) or '');
    self:AsyncSetTexture(UGCItemSystemV2.GetItemIconTextureV2(itemId), self.Item, renderVersion);
end

function FirearmPurchaseLBItem:AsyncSetTexture(Path, UI, RenderVersion)
    if Path == nil or UI == nil then
        return;
    end
    Common.LoadObjectWithSoftPathAsync(Path,
            function(Texture)
                if self == nil or Texture == nil or UI == nil
                        or self.RenderVersion ~= RenderVersion then
                    return;
                end
                UI:SetBrushFromTexture(Texture);
            end
    );
end

return FirearmPurchaseLBItem
