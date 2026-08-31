---@class RaidInstanceCardItem_C:UUserWidget
---@field CanvasPanel_Icon UCanvasPanel
---@field Image_Icon UImage
---@field Image_QualityBar UImage
---@field Image_QualityBarBg UImage
---@field Image_SuitBar UImage
---@field Level_1 UImage
---@field Level_2 UImage
---@field Level_3 UImage
---@field TextBlock_Name UTextBlock
--Edit Below--
local RaidInstanceCardItem = {
    RenderVersion = 0,
}
local STAR_ACTIVE_COLOR = "FFA700";
local STAR_INACTIVE_COLOR = "353535";
local DISABLED_COLOR = "686565";

function RaidInstanceCardItem:_SetStarLevel(star, isEquipped)
    local activeColor = isEquipped and STAR_ACTIVE_COLOR or DISABLED_COLOR;
    local inactiveColor = isEquipped and STAR_INACTIVE_COLOR or DISABLED_COLOR;
    self.Level_1:SetColorRGBStr(star >= 1 and activeColor or inactiveColor);
    self.Level_2:SetColorRGBStr(star >= 2 and activeColor or inactiveColor);
    self.Level_3:SetColorRGBStr(star >= 3 and activeColor or inactiveColor);
end

---@param cardIndex integer
---@param equippedData table|nil
function RaidInstanceCardItem:SetData(cardIndex, equippedData)
    local card = CardCfg.Cards[cardIndex];
    local suit = CardCfg.Suit[card.suit];
    local group = CardCfg.Group[suit.Group];
    local grade = CardCfg.Grade[card.grade];
    local isEquipped = equippedData ~= nil;

    self.RenderVersion = self.RenderVersion + 1;
    local renderVersion = self.RenderVersion;
    self:AsyncSetTexture({AssetPathName = card.texture, SubPathString = nil}, renderVersion);
    self.TextBlock_Name:SetText(card.name);

    if isEquipped then
        self.Image_Icon:SetColorRGBStr(group.HexColor);
        self.Image_QualityBar:SetColorRGBStr(grade.HexColor);
        self.Image_QualityBarBg:SetColorAndOpacity(grade.rgba);
        self.Image_SuitBar:SetColorRGBStr(group.HexColor);
        self.TextBlock_Name:SetColorRGBStr("FFFFFF");
    else
        self.Image_Icon:SetColorRGBStr('252525FF');
        self.Image_QualityBar:SetColorRGBStr(DISABLED_COLOR);
        self.Image_QualityBarBg:SetColorRGBStr(DISABLED_COLOR .. "4D");
        self.Image_SuitBar:SetColorRGBStr(DISABLED_COLOR);
        self.TextBlock_Name:SetColorRGBStr(DISABLED_COLOR);
    end
    self:_SetStarLevel(equippedData and equippedData[2] or 1, isEquipped);
end

function RaidInstanceCardItem:AsyncSetTexture(Path, RenderVersion)
    Common.LoadObjectWithSoftPathAsync(Path,
            function(Texture)
                if self ~= nil and Texture ~= nil and self.RenderVersion == RenderVersion then
                    self.Image_Icon:SetBrushFromTexture(Texture);
                end
            end
    );
end

return RaidInstanceCardItem
