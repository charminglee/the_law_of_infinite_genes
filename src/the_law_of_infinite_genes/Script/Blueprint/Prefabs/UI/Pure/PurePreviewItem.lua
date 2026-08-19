---@class PurePreviewItem_C:UUserWidget
---@field CanvasPanel_Icon UCanvasPanel
---@field Image_Icon UImage
---@field Image_QualityBar UImage
---@field Image_QualityBarBg UImage
---@field Image_Select UImage
---@field TextBlock_Fortify UTextBlock
---@field TextBlock_Num UTextBlock
--Edit Below--
local PurePreviewItem = {
    bInitDoOnce = false,
    DefineID = nil,
    RenderVersion = 0,
}

function PurePreviewItem:Construct()
    self:LuaInit();
end

function PurePreviewItem:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self:SetEmpty();
end

function PurePreviewItem:SetEmpty()
    self.DefineID = nil;
    self.RenderVersion = self.RenderVersion + 1;
    self.CanvasPanel_Icon:SetVisibility(ESlateVisibility.Collapsed);
    self.Image_Select:SetVisibility(ESlateVisibility.Collapsed);
    self.TextBlock_Num:SetVisibility(ESlateVisibility.Collapsed);
end

---@param DefineID ItemDefineID
---@param DisplayLevel number|nil
---@param QualityOverride number|nil
function PurePreviewItem:SetDefineID(DefineID, DisplayLevel, QualityOverride)
    if DefineID == nil or DefineID.TypeSpecificID == nil then
        self:SetEmpty();
        return;
    end

    self.DefineID = DefineID;
    self.RenderVersion = self.RenderVersion + 1;
    local renderVersion = self.RenderVersion;
    self.CanvasPanel_Icon:SetVisibility(ESlateVisibility.Visible);
    self.Image_Select:SetVisibility(ESlateVisibility.Collapsed);

    local itemId = DefineID.TypeSpecificID;
    local quality = QualityOverride
            or UGCItemSystemV2.GetItemQualityV2ByDefineID(DefineID)
            or UGCItemSystemV2.GetItemQualityV2(itemId) or 0;
    local qualityCfg = ItemCfg.ItemQuality[quality] or ItemCfg.ItemQuality[0];
    if qualityCfg ~= nil then
        self:AsyncSetTexture({AssetPathName = qualityCfg.Bg, SubPathString = nil}, self.Image_QualityBarBg, renderVersion);
        self:AsyncSetTexture({AssetPathName = qualityCfg.bar, SubPathString = nil}, self.Image_QualityBar, renderVersion);
    end
    self:AsyncSetTexture(UGCItemSystemV2.GetItemIconTextureV2(itemId), self.Image_Icon, renderVersion);

    if DisplayLevel ~= nil then
        self.TextBlock_Fortify:SetVisibility(ESlateVisibility.Visible);
        self.TextBlock_Fortify:SetText(string.format('+%s', tostring(DisplayLevel)));
        local levelCfg = ItemCfg.colorTable[DisplayLevel] or ItemCfg.colorTable[0];
        if levelCfg ~= nil then
            self.TextBlock_Fortify:SetColorRGBStr(levelCfg.HexColor);
        end
    else
        self.TextBlock_Fortify:SetVisibility(ESlateVisibility.Collapsed);
    end
    self.TextBlock_Num:SetVisibility(ESlateVisibility.Collapsed);
end

function PurePreviewItem:SetCount(Text)
    if Text == nil or Text == '' then
        self.TextBlock_Num:SetVisibility(ESlateVisibility.Collapsed);
        return;
    end
    self.TextBlock_Num:SetText(tostring(Text));
    self.TextBlock_Num:SetVisibility(ESlateVisibility.Visible);
end

function PurePreviewItem:AsyncSetTexture(Path, UI, RenderVersion)
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

return PurePreviewItem
