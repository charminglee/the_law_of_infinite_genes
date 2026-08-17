---@class FortifyItem_C:UUserWidget
---@field Button_0 UButton
---@field CanvasPanel_0 UCanvasPanel
---@field CanvasPanel_Icon UCanvasPanel
---@field Image_Icon UImage
---@field Image_Null UImage
---@field Image_QualityBar UImage
---@field Image_QualityBarBg UImage
---@field Image_Select UImage
---@field TextBlock_Fortify UTextBlock
---@field TextBlock_Num UTextBlock
---@field Size FVector2D
---@field DurabilityPercent float
--Edit Below--
local FortifyItem = {
    bInitDoOnce = false,
    DefineID = nil,
    RenderVersion = 0,
}

function FortifyItem:Construct()
    self:LuaInit();
end

function FortifyItem:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);
end

function FortifyItem:Button_0_Clicked()
    if self.DefineID ~= nil then
        FortifyManager:Reload(self.DefineID, FortifyManager.FilterType);
    end
end

function FortifyItem:SetEmpty()
    self.DefineID = nil;
    self.RenderVersion = self.RenderVersion + 1;
    self.CanvasPanel_Icon:SetVisibility(ESlateVisibility.Collapsed);
    self.Image_Select:SetVisibility(ESlateVisibility.Collapsed);
end

---@param DefineID ItemDefineID
function FortifyItem:SetSelected(DefineID)
    local selected = DefineID ~= nil and self.DefineID ~= nil
            and DefineID.InstanceID ~= nil and DefineID.InstanceID == self.DefineID.InstanceID;
    self.Image_Select:SetVisibility(selected and ESlateVisibility.Visible or ESlateVisibility.Collapsed);
end

---@param DefineID ItemDefineID
function FortifyItem:SetDefineID(DefineID)
    if DefineID == nil or DefineID.TypeSpecificID == nil then
        self:SetEmpty();
        return;
    end

    self.DefineID = DefineID;
    self.RenderVersion = self.RenderVersion + 1;
    local renderVersion = self.RenderVersion;
    self.CanvasPanel_Icon:SetVisibility(ESlateVisibility.Visible);
    self.Image_Null:SetVisibility(ESlateVisibility.Collapsed);
    self.Image_Icon:SetVisibility(ESlateVisibility.Visible);
    self.TextBlock_Num:SetVisibility(ESlateVisibility.Collapsed);

    local itemId = DefineID.TypeSpecificID;
    local quality = UGCItemSystemV2.GetItemQualityV2(itemId) or 0;
    local qualityCfg = ItemCfg.ItemQuality[quality] or ItemCfg.ItemQuality[0];
    if qualityCfg ~= nil then
        self:AsyncSetTexture({AssetPathName = qualityCfg.Bg, SubPathString = nil}, self.Image_QualityBarBg, renderVersion);
        self:AsyncSetTexture({AssetPathName = qualityCfg.bar, SubPathString = nil}, self.Image_QualityBar, renderVersion);
    end
    self:AsyncSetTexture(UGCItemSystemV2.GetItemIconTextureV2(itemId), self.Image_Icon, renderVersion);

    local data = LocalPlayerState.ItemDataManager:GetCustomData(DefineID) or {};
    local level = tonumber(data.strengthenLevel) or 0;
    self.TextBlock_Fortify:SetText(string.format('+%s', tostring(level)));
    local levelCfg = ItemCfg.colorTable[level] or ItemCfg.colorTable[0];
    if levelCfg ~= nil then
        self.TextBlock_Fortify:SetColorRGBStr(levelCfg.HexColor);
    end
end

function FortifyItem:AsyncSetTexture(Path, UI, RenderVersion)
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

return FortifyItem
