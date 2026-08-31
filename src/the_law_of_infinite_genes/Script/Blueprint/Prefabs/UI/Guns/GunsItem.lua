---@class GunsItem_C:UUserWidget
---@field Button_0 UButton
---@field CanvasPanel_Icon UCanvasPanel
---@field Image_Icon UImage
---@field Image_QualityBarBg UImage
---@field Image_Select UImage
---@field ItemName UTextBlock
--Edit Below--
local GunsItem = {
    bInitDoOnce = false,
    DefineID = nil,
    RenderVersion = 0,
}

function GunsItem:Construct()
    self:LuaInit();
end

function GunsItem:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);
end

function GunsItem:Button_0_Clicked()
    if self.DefineID ~= nil then
        GunsManager:GetMainUI():SelectGun(self.DefineID, self);
    end
end

function GunsItem:SetEmpty()
    self.DefineID = nil;
    self.RenderVersion = self.RenderVersion + 1;
    self:SetVisibility(ESlateVisibility.Collapsed);
end

---@param ItemData table|nil
function GunsItem:SetSelected(ItemData)
    local selected = ItemData ~= nil and self.DefineID ~= nil
            and ItemData.ItemId == self.DefineID.ItemId;
    local IsVisible = selected and ESlateVisibility.Visible or ESlateVisibility.Collapsed;
    self.Image_Select:SetVisibility(IsVisible);
    self.Image_QualityBarBg:SetVisibility(IsVisible);
end

---@param ItemData table
function GunsItem:SetDefineID(ItemData)
    self.DefineID = ItemData;
    self.RenderVersion = self.RenderVersion + 1;
    local renderVersion = self.RenderVersion;
    local itemId = ItemData.ItemId;
    local quality = UGCItemSystemV2.GetItemQualityV2(itemId);
    local qualityCfg = ItemCfg.ItemQuality[quality];

    self:SetVisibility(ESlateVisibility.Visible);
    self.CanvasPanel_Icon:SetVisibility(ESlateVisibility.Visible);
    self.Image_Null:SetVisibility(ESlateVisibility.Collapsed);
    self.ItemName:SetText(UGCItemSystemV2.GetItemNameV2(itemId));

    self:AsyncSetTexture(
            UGCItemSystemV2.GetItemIconTextureV2(itemId),
            self.Image_Icon,
            renderVersion
    );
    self:AsyncSetTexture(
            {AssetPathName = qualityCfg.Bg, SubPathString = nil},
            self.Image_QualityBarBg,
            renderVersion
    );
end

function GunsItem:AsyncSetTexture(Path, UI, RenderVersion)
    Common.LoadObjectWithSoftPathAsync(Path,
            function(Texture)
                if self ~= nil and Texture ~= nil and self.RenderVersion == RenderVersion then
                    UI:SetBrushFromTexture(Texture);
                end
            end
    );
end

return GunsItem
