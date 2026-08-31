---@class GachaItem_C:UUserWidget
---@field Add UImage
---@field Button_0 UButton
---@field CanvasPanel_Icon UCanvasPanel
---@field Image_Icon UImage
---@field Image_QualityBar UImage
---@field Image_QualityBarBg UImage
---@field Image_Select UImage
---@field Image_SuitBar UImage
---@field Level_1 UImage
---@field Level_2 UImage
---@field Level_3 UImage
---@field Lock UImage
---@field TextBlock_Name UTextBlock
--Edit Below--
local GachaItem = {
    bInitDoOnce = false,
    Index = nil,
    Tag = nil,
    Data = nil,
    RenderVersion = 0,
}
local STAR_ACTIVE_COLOR = "FFA700";
local STAR_INACTIVE_COLOR = "3C3C3C";
function GachaItem:Construct()
    self:LuaInit();
end
function GachaItem:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self.Button_0.OnClicked:Add(self.ItemClicked, self);
end
function GachaItem:ItemClicked()
    if self.Data == nil then
        return;
    end
    GachaManager.SelectIndex = self.Index;
    GachaManager.SelectTag = self.Tag;
    GachaManager.RefreshUI = true;
end
function GachaItem:_IsSelected()
    return self.Data ~= nil
            and GachaManager.SelectIndex == self.Index
            and GachaManager.SelectTag == self.Tag;
end
function GachaItem:_SetStarLevel(star)
    self.Level_1:SetColorRGBStr(star >= 1 and STAR_ACTIVE_COLOR or STAR_INACTIVE_COLOR);
    self.Level_2:SetColorRGBStr(star >= 2 and STAR_ACTIVE_COLOR or STAR_INACTIVE_COLOR);
    self.Level_3:SetColorRGBStr(star >= 3 and STAR_ACTIVE_COLOR or STAR_INACTIVE_COLOR);
end
function GachaItem:_SetEmpty(showAdd, showLock)
    self.Data = nil;
    self.RenderVersion = self.RenderVersion + 1;
    self.Image_Select:SetVisibility(ESlateVisibility.Collapsed);
    self.CanvasPanel_Icon:SetVisibility(ESlateVisibility.Visible);
    self.Image_Icon:SetVisibility(ESlateVisibility.Collapsed);
    self.Add:SetVisibility(showAdd and ESlateVisibility.Visible or ESlateVisibility.Collapsed);
    self.Lock:SetVisibility(showLock and ESlateVisibility.Visible or ESlateVisibility.Collapsed);
    self.Image_QualityBar:SetVisibility(ESlateVisibility.Collapsed);
    self.Image_QualityBarBg:SetColorRGBStr("00000099");
    self.Image_SuitBar:SetVisibility(ESlateVisibility.Collapsed);
    self.TextBlock_Name:SetVisibility(ESlateVisibility.Collapsed);
    self.Level_1:SetVisibility(ESlateVisibility.Collapsed);
    self.Level_2:SetVisibility(ESlateVisibility.Collapsed);
    self.Level_3:SetVisibility(ESlateVisibility.Collapsed);
    if GachaManager.SelectIndex == self.Index and GachaManager.SelectTag == self.Tag then
        GachaManager.PreviewDAT = nil;
    end
end
---@param data table
function GachaItem:_SetCard(data)
    local card = CardCfg.Cards[data[1]];
    if card == nil then
        self:_SetEmpty();
        return;
    end
    local suit = CardCfg.Suit[card.suit];
    local group = CardCfg.Group[suit.Group];
    local grade = CardCfg.Grade[card.grade];
    self.Data = data;
    self.RenderVersion = self.RenderVersion + 1;
    local renderVersion = self.RenderVersion;
    self.CanvasPanel_Icon:SetVisibility(ESlateVisibility.Visible);
    self.Image_Icon:SetVisibility(ESlateVisibility.Visible);
    self.Add:SetVisibility(ESlateVisibility.Collapsed);
    self.Lock:SetVisibility(ESlateVisibility.Collapsed);
    self.Image_QualityBar:SetVisibility(ESlateVisibility.Visible);
    self.Image_SuitBar:SetVisibility(ESlateVisibility.Visible);
    self.TextBlock_Name:SetVisibility(ESlateVisibility.Visible);
    self.Level_1:SetVisibility(ESlateVisibility.Visible);
    self.Level_2:SetVisibility(ESlateVisibility.Visible);
    self.Level_3:SetVisibility(ESlateVisibility.Visible);
    self:AsyncSetTexture({AssetPathName = card.texture, SubPathString = nil}, self.Image_Icon, renderVersion);
    self.Image_Icon:SetColorRGBStr(group.HexColor);
    self.Image_QualityBar:SetColorRGBStr(grade.HexColor);
    self.Image_QualityBarBg:SetColorAndOpacity(grade.rgba);
    self.Image_SuitBar:SetColorRGBStr(group.HexColor);
    self.TextBlock_Name:SetText(card.name);
    self:_SetStarLevel(data[2] or 1);
    local isSelected = self:_IsSelected();
    self.Image_Select:SetVisibility(isSelected and ESlateVisibility.Visible or ESlateVisibility.Collapsed);
    if isSelected then
        GachaManager:SetPreviewDAT(data);
    end
end
---@param index integer
---@param tag integer
---@param data table|nil
---@param showAdd boolean
---@param showLock boolean
function GachaItem:SetData(index, tag, data, showAdd, showLock)
    self.Index = index;
    self.Tag = tag;
    if data == nil then
        self:_SetEmpty(showAdd, showLock);
        return;
    end
    self:_SetCard(data);
end
function GachaItem:AsyncSetTexture(Path, UI, RenderVersion)
    Common.LoadObjectWithSoftPathAsync(Path,
            function(Texture)
                if self ~= nil and Texture ~= nil and self.RenderVersion == RenderVersion then
                    UI:SetBrushFromTexture(Texture);
                end
            end
    );
end
return GachaItem
