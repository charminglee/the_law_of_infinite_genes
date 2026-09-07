---@class KComposePreviewItem_C:UUserWidget
---@field Button_0 UButton
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
local KComposePreviewItem = {
    bInitDoOnce = false,
    DefineID = nil,
    Mode = nil,
    RenderVersion = 0
}

function KComposePreviewItem:Construct()
    self:LuaInit();
end

function KComposePreviewItem:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);
end

function KComposePreviewItem:SetMode(Mode)
    self.Mode = Mode;
end

function KComposePreviewItem:Button_0_Clicked()
    if self.DefineID == nil then
        return;
    end

    if self.Mode == 'Material' then
        KenlComposeManager:SelectMaterial(self.DefineID);
    elseif self.Mode == 'Primary' then
        KenlComposeManager:SelectPrimary(self.DefineID);
    end
end

function KComposePreviewItem:SetEmpty()
    self.DefineID = nil;
    self.RenderVersion = self.RenderVersion + 1;
    local renderVersion = self.RenderVersion;

    -- 空核心也保留完整槽位：显示空物品图标和默认品质框。
    self.CanvasPanel_Icon:SetVisibility(ESlateVisibility.Visible);
    self.Image_Icon:SetVisibility(ESlateVisibility.Collapsed);
    if self.Image_Null ~= nil then
        self.Image_Null:SetVisibility(ESlateVisibility.Visible);
    end
    self.Image_QualityBarBg:SetVisibility(ESlateVisibility.Visible);
    self.Image_QualityBar:SetVisibility(ESlateVisibility.Visible);
    if self.Image_Select ~= nil then
        self.Image_Select:SetVisibility(ESlateVisibility.Collapsed);
    end

    local emptyQualityCfg = ItemCfg.ItemQuality[0];
    if emptyQualityCfg ~= nil then
        self:AsyncSetTexture(
                {AssetPathName=emptyQualityCfg.Bg, SubPathString=nil},
                self.Image_QualityBarBg,
                renderVersion
        );
        self:AsyncSetTexture(
                {AssetPathName=emptyQualityCfg.bar, SubPathString=nil},
                self.Image_QualityBar,
                renderVersion
        );
    end
end

---@param DefineID ItemDefineID
function KComposePreviewItem:SetSelected(DefineID)
    if self.Image_Select == nil then
        return;
    end
    local selected = DefineID ~= nil and self.DefineID ~= nil
            and DefineID.InstanceID == self.DefineID.InstanceID;
    self.Image_Select:SetVisibility(selected and ESlateVisibility.Visible or ESlateVisibility.Collapsed);
end

---@param DefineID ItemDefineID
function KComposePreviewItem:SetDefineID(DefineID)
    if DefineID == nil then
        self:SetEmpty();
        return;
    end

    DefineID = Lib.ToItemDefineId(DefineID, ItemCfg.ItemType.Kenl);
    self.DefineID = DefineID;
    self.RenderVersion = self.RenderVersion + 1;
    local renderVersion = self.RenderVersion;
    self.CanvasPanel_Icon:SetVisibility(ESlateVisibility.Visible);
    self.Image_Icon:SetVisibility(ESlateVisibility.Visible);
    if self.Image_Null ~= nil then
        self.Image_Null:SetVisibility(ESlateVisibility.Collapsed);
    end
    self.Image_QualityBarBg:SetVisibility(ESlateVisibility.Visible);
    self.Image_QualityBar:SetVisibility(ESlateVisibility.Visible);
    local itemId = DefineID.TypeSpecificID;
    local quality = UGCItemSystemV2.GetItemQualityV2(itemId);
    local icon = UGCItemSystemV2.GetItemIconTextureV2(itemId);
    local qualityCfg = ItemCfg.ItemQuality[quality];
    if qualityCfg ~= nil then
        self:AsyncSetTexture({AssetPathName=qualityCfg.Bg, SubPathString=nil}, self.Image_QualityBarBg, renderVersion);
        self:AsyncSetTexture({AssetPathName=qualityCfg.bar, SubPathString=nil}, self.Image_QualityBar, renderVersion);
    end
    self:AsyncSetTexture(icon, self.Image_Icon, renderVersion);
end

function KComposePreviewItem:AsyncSetTexture(Path, UI, RenderVersion)
    if Path == nil or UI == nil then
        return;
    end
    Common.LoadObjectWithSoftPathAsync(Path,
            function(Texture)
                if self == nil or Texture == nil or UI == nil
                        or (RenderVersion ~= nil and self.RenderVersion ~= RenderVersion) then
                    return;
                end
                UI:SetBrushFromTexture(Texture);
            end
    );
end

return KComposePreviewItem
