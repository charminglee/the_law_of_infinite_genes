---@class KComposeItem_C:UUserWidget
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
local KComposeItem = {
    bInitDoOnce = false,
    DefineID = nil,
    Mode = 'Primary'
}

function KComposeItem:Construct()
    self:LuaInit();
end

function KComposeItem:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);
end

function KComposeItem:SetMode(Mode)
    self.Mode = Mode or 'Primary';
end

function KComposeItem:Button_0_Clicked()
    if self.DefineID == nil then
        return;
    end

    if self.Mode == 'Material' then
        KenlComposeManager:SelectMaterial(self.DefineID);
    else
        KenlComposeManager:SelectPrimary(self.DefineID);
    end
end

---@param DefineID ItemDefineID
function KComposeItem:SetSelected(DefineID)
    local selected = DefineID ~= nil and self.DefineID ~= nil
            and DefineID.InstanceID == self.DefineID.InstanceID;
    self.Image_Select:SetVisibility(selected and ESlateVisibility.Visible or ESlateVisibility.Collapsed);
end

---@param DefineID ItemDefineID
function KComposeItem:SetDefineID(DefineID)
    self.DefineID = DefineID;
    if DefineID == nil then
        self.CanvasPanel_Icon:SetVisibility(ESlateVisibility.Collapsed);
        return;
    end

    self.CanvasPanel_Icon:SetVisibility(ESlateVisibility.Visible);
    local itemId = DefineID.TypeSpecificID;
    local quality = UGCItemSystemV2.GetItemQualityV2(itemId);
    local icon = UGCItemSystemV2.GetItemIconTextureV2(itemId);
    local qualityCfg = ItemCfg.ItemQuality[quality];
    if qualityCfg ~= nil then
        self:AsyncSetTexture({AssetPathName=qualityCfg.Bg, SubPathString=nil}, self.Image_QualityBarBg);
        self:AsyncSetTexture({AssetPathName=qualityCfg.bar, SubPathString=nil}, self.Image_QualityBar);
    end
    self:AsyncSetTexture(icon, self.Image_Icon);
end

function KComposeItem:AsyncSetTexture(Path, UI)
    if Path == nil or UI == nil then
        return;
    end
    Common.LoadObjectWithSoftPathAsync(Path,
            function(Texture)
                if self == nil or Texture == nil or UI == nil then
                    return;
                end
                UI:SetBrushFromTexture(Texture);
            end
    );
end

return KComposeItem
