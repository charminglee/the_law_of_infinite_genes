---@class GachaItem_C:UUserWidget
---@field Button_0 UButton
---@field Empty UCanvasPanel
---@field ItemImage UImage
---@field ItemName UTextBlock
---@field Lock UCanvasPanel
---@field NilItem UCanvasPanel
---@field NotSelected UCanvasPanel
---@field Quality UImage
---@field Selected UCanvasPanel
---@field Star UTextBlock
---@field ValidItem UCanvasPanel
local GachaItem = { 
    bInitDoOnce = false,
    Index=nil, 
    Tag=nil,
}; 

function GachaItem:Construct()
	self:LuaInit();
end

function GachaItem:LuaInit()
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true;
    self:Listen();
end

function GachaItem:Listen()
    self.Button_0.OnClicked:Add(self.ItemClicked, self);
end

function GachaItem:ItemClicked()
    GachaManager.SelectIndex = self.Index;
    GachaManager.SelectTag = self.Tag;
    GachaManager.RefreshUI = true;
end

function GachaItem:_Collapse()
    self.NilItem:SetVisibility(ESlateVisibility.Collapsed);
    self.ValidItem:SetVisibility(ESlateVisibility.Collapsed);
    self.Empty:SetVisibility(ESlateVisibility.Collapsed);
    self.Selected:SetVisibility(ESlateVisibility.Collapsed);
    self.NotSelected:SetVisibility(ESlateVisibility.Collapsed);
    self.Lock:SetVisibility(ESlateVisibility.Collapsed);
end

function GachaItem:_IsSelected()
    return GachaManager.SelectIndex == self.Index and GachaManager.SelectTag == self.Tag
end

function GachaItem:_ShowEmpty(emptyState)
    self:_Collapse();
    emptyState:SetVisibility(ESlateVisibility.Visible);
    if self:_IsSelected() then
        GachaManager.PreviewDAT = nil;
    end
end

function GachaItem:_ShowCard(data, emptyState)
    local cardIndex = data[1];
    local Fcard = CardCfg.Cards[cardIndex];
    if Fcard == nil then
        self:_ShowEmpty(emptyState);
        return false;
    end

    local Texture = LoadObject(Fcard.texture);
    local ItemName = Fcard.name;
    local StarText = GachaManager:GetStarText(data[2]);
    local suit = CardCfg.Suit[Fcard.suit];
    local ItemColor = CardCfg.Group[suit.Group].HexColor;
    local grade = Fcard.grade;
    local QualityColor = CardCfg.Grade[grade].HexColor;

    self.ItemImage:SetBrushFromTexture(Texture);
    self.ItemImage:SetColorRGBStr(ItemColor);
    self.ItemName:SetText(ItemName);
    self.Quality:SetColorRGBStr(QualityColor);
    self.Star:SetText(StarText);
    self.ValidItem:SetVisibility(ESlateVisibility.Visible);
    return true;
end

function GachaItem:_ApplySelection(data)
    if self:_IsSelected() then
        self.Selected:SetVisibility(ESlateVisibility.Visible);
        GachaManager:SetPreviewDAT(data);
    else
        self.NotSelected:SetVisibility(ESlateVisibility.Visible);
    end
end

function GachaItem:ShopUpdate()
    local data = LocalPlayerState.PlayerDataManager:GetShopCard(self.Index+1);
    if data == nil then
        self:_ShowEmpty(self.NilItem);
        return;
    end

    self:_Collapse();
    if self:_ShowCard(data, self.NilItem) then
        self:_ApplySelection(data);
    end
end

function GachaItem:StoreUpdate()
    local data = LocalPlayerState.PlayerDataManager:GetStoreCard(self.Index+1);
    if data == nil then
        self:_ShowEmpty(self.Empty);
        return;
    end

    self:_Collapse();
    if self:_ShowCard(data, self.Empty) then
        self:_ApplySelection(data);
    end
end

function GachaItem:SlotUpdate()
    local slotCount = LocalPlayerState.PlayerDataManager:GetUnlockedCardSlotCount();
    if self.Index + 1 > slotCount then
        self:_ShowEmpty(self.Lock);
        return;
    end

    local data = LocalPlayerState.PlayerDataManager:GetEquippedCard(self.Index+1);
    if data == nil then
        self:_ShowEmpty(self.Empty);
        return;
    end

    self:_Collapse();
    if self:_ShowCard(data, self.Empty) then
        self:_ApplySelection(data);
    end
end

return GachaItem
