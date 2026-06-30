---@class GachaMain_C:UUserWidget
---@field AttributeCountList ReuseList2_C
---@field DescributeList ReuseList2_C
---@field EquipCardButton UButton
---@field ExitButton UButton
---@field LevelUpButton UButton
---@field NilPreview UCanvasPanel
---@field OuterExitButton UButton
---@field PreviewItem UImage
---@field PreviewItemName UTextBlock
---@field PreviewStar UTextBlock
---@field PreviewTop UImage
---@field PurchaseButton UButton
---@field RefreshButton UButton
---@field ResourceCoinIcon UImage
---@field SelectedPreview UCanvasPanel
---@field SellButton UButton
---@field ShopLevel UTextBlock
---@field ShopList ReuseList2_C
---@field SlotCount UTextBlock
---@field SlotList ReuseList2_C
---@field StoreCount UTextBlock
---@field StoreList ReuseList2_C
---@field UnequipCardButton UButton
--Edit Below--
local GachaMain = { 
    bInitDoOnce = false,
    SelectTag = nil,
    SelectIndex = nil,
} 
local SelectTag = {
    Shop = 1,
    Equipped = 2,
    Store = 3,
}
local MAX_CARD_SLOT_LEVEL = 12
local function SetButtonVisible(button, visible)
    if button == nil then
        return
    end
    button:SetVisibility(visible and ESlateVisibility.Visible or ESlateVisibility.Collapsed);
end
function GachaMain:Construct()
    self:LuaInit();
end

function GachaMain:Tick(MyGemetry,FGeometry)
    if self.SelectIndex ~= GachaManager.SelectIndex or self.SelectTag ~= GachaManager.SelectTag then
        GachaManager.RefreshUI = true;
    end
    if GachaManager.RefreshUI then
        GachaManager.RefreshUI = false;   
        self.SelectIndex = GachaManager.SelectIndex;
        self.SelectTag = GachaManager.SelectTag;
        GachaManager.PreviewDAT = nil;
        GachaManager.RefreshPreviewUI = false;
        self:ReloadList();
        self:SetPreview(GachaManager.PreviewDAT ~= nil);
        GachaManager.RefreshPreviewUI = false;
        return;
    end
    if GachaManager.RefreshPreviewUI then
        GachaManager.RefreshPreviewUI = false;
        self:SetPreview(GachaManager.PreviewDAT ~= nil);
    end
end

function GachaMain:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
    GachaManager:RegisterMainUI(self);
    self:Listen();
    self:ReloadList();
    self:SetPreview(false);
end

function GachaMain:Listen()
    self.ExitButton.OnClicked:Add(self.Exit, self);
    self.OuterExitButton.OnClicked:Add(self.Exit, self);
    self.RefreshButton.OnClicked:Add(self.Refresh, self);
    if self.LevelUpButton ~= nil then
        self.LevelUpButton.OnClicked:Add(self.LevelUp, self);
    end
    if self.EquipCardButton ~= nil then
        self.EquipCardButton.OnClicked:Add(self.EquipCard, self);
    end
    if self.UnequipCardButton ~= nil then
        self.UnequipCardButton.OnClicked:Add(self.UnequipCard, self);
    end
    if self.PurchaseButton ~= nil then
        self.PurchaseButton.OnClicked:Add(self.Purchase, self);
    end
    if self.SellButton ~= nil then
        self.SellButton.OnClicked:Add(self.Sell, self);
    end
    self.ShopList.OnUpdateItem:Add(self.ShopListUpdate, self);
    self.SlotList.OnUpdateItem:Add(self.SlotListUpdate, self);
    self.StoreList.OnUpdateItem:Add(self.StoreListUpdate, self);
    self.AttributeCountList.OnUpdateItem:Add(self.AttributeCountListUpdate, self);
    self.DescributeList.OnUpdateItem:Add(self.DescributeListUpdate, self);
    
end

function GachaMain:ReloadList()
    self.ShopList:Reload(6);
    self.StoreList:Reload(20);
    self.SlotList:Reload(12);
    self:RefreshInfo();
end
function GachaMain:_SelectedSlot()
    if GachaManager.SelectIndex == nil then
        return nil
    end
    return GachaManager.SelectIndex + 1
end
function GachaMain:_CardData()
    local playerState = LocalPlayerState
    local manager = playerState and playerState.PlayerDataManager
    return manager and manager._card or nil
end
function GachaMain:_UnlockedSlotCount()
    local card = self:_CardData()
    local level = card and card.shopLevel or 1
    return math.min(MAX_CARD_SLOT_LEVEL, math.max(1, level))
end
function GachaMain:_CountUsed(list)
    if list == nil then
        return 0
    end
    local count = 0
    local n = list.n or #list
    for i = 1, n do
        if list[i] ~= nil then
            count = count + 1
        end
    end
    return count
end
function GachaMain:RefreshInfo()
    local card = self:_CardData()
    if card == nil then
        SetButtonVisible(self.LevelUpButton, false);
        return
    end
    local level = self:_UnlockedSlotCount()
    if self.ShopLevel ~= nil then
        self.ShopLevel:SetText(tostring(level));
    end
    if self.SlotCount ~= nil then
        self.SlotCount:SetText(tostring(level) .. "/" .. tostring(MAX_CARD_SLOT_LEVEL));
    end
    if self.StoreCount ~= nil then
        local storeMax = card.store and (card.store.n or #card.store) or 0
        self.StoreCount:SetText(tostring(self:_CountUsed(card.store)) .. "/" .. tostring(storeMax));
    end
    SetButtonVisible(self.LevelUpButton, level < MAX_CARD_SLOT_LEVEL);
end
function GachaMain:_RefreshActionButtons(hasPreview)
    local tag = GachaManager.SelectTag;
    SetButtonVisible(self.PurchaseButton, hasPreview and tag == SelectTag.Shop);
    SetButtonVisible(self.EquipCardButton, hasPreview and tag == SelectTag.Store);
    SetButtonVisible(self.UnequipCardButton, hasPreview and tag == SelectTag.Equipped);
    SetButtonVisible(self.SellButton, hasPreview and (tag == SelectTag.Store or tag == SelectTag.Equipped));
end
function GachaMain:Exit()
    GachaManager:CloseMainUI()
end

function GachaMain:Refresh()
    UnrealNetwork.CallUnrealRPC(LocalPlayerController, GachaManager.ComponentClass, "RefreshCardShop", LocalPlayerController.PlayerKey);
end

function GachaMain:LevelUp()
    UnrealNetwork.CallUnrealRPC(LocalPlayerController, GachaManager.ComponentClass, "LevelUpCardSlot", LocalPlayerController.PlayerKey);
end
function GachaMain:EquipCard()
    local slot = self:_SelectedSlot();
    if slot == nil or GachaManager.SelectTag ~= SelectTag.Store then
        return
    end
    UnrealNetwork.CallUnrealRPC(LocalPlayerController, GachaManager.ComponentClass, "EquipCard", LocalPlayerController.PlayerKey, slot);
end
function GachaMain:UnequipCard()
    local slot = self:_SelectedSlot();
    if slot == nil or GachaManager.SelectTag ~= SelectTag.Equipped then
        return
    end
    UnrealNetwork.CallUnrealRPC(LocalPlayerController, GachaManager.ComponentClass, "UnequipCard", LocalPlayerController.PlayerKey, slot);
end
function GachaMain:Purchase()
    local slot = self:_SelectedSlot();
    if slot == nil or GachaManager.SelectTag ~= SelectTag.Shop then
        return
    end
    UnrealNetwork.CallUnrealRPC(LocalPlayerController, GachaManager.ComponentClass, "APurchaseCard", LocalPlayerController.PlayerKey, slot);
end
function GachaMain:Sell()
    local slot = self:_SelectedSlot();
    if slot == nil then
        return
    end
    if GachaManager.SelectTag == SelectTag.Store then
        UnrealNetwork.CallUnrealRPC(LocalPlayerController, GachaManager.ComponentClass, "SellCardFromStore", LocalPlayerController.PlayerKey, slot);
    elseif GachaManager.SelectTag == SelectTag.Equipped then
        UnrealNetwork.CallUnrealRPC(LocalPlayerController, GachaManager.ComponentClass, "SellCardFromEquipped", LocalPlayerController.PlayerKey, slot);
    end
end
function GachaMain:ShopListUpdate(Item, Index)
    Item.Index = Index;
    Item.Tag = SelectTag.Shop;
    Item:ShopUpdate();
end
function GachaMain:SlotListUpdate(Item, Index)
    Item.Index = Index;
    Item.Tag = SelectTag.Equipped;
    Item:SlotUpdate();
end
function GachaMain:StoreListUpdate(Item, Index)
    Item.Index = Index;
    Item.Tag = SelectTag.Store;
    Item:StoreUpdate();
end

function GachaMain:AttributeCountListUpdate(Item, Index)
    Item.Index = Index;
end

function GachaMain:DescributeListUpdate(Item, Index)
    Item.Index = Index;
end
function GachaMain:SetPreview(isShow)
    local data = GachaManager.PreviewDAT;
    local cardIndex = data and data[1];
    local Fcard = cardIndex and Card.Cards[cardIndex];
    if not isShow or data == nil or Fcard == nil then
        self.SelectedPreview:SetVisibility(ESlateVisibility.Collapsed);
        self.NilPreview:SetVisibility(ESlateVisibility.Visible);
        self:_RefreshActionButtons(false);
        return;
    end
    self.SelectedPreview:SetVisibility(ESlateVisibility.Visible);
    self.NilPreview:SetVisibility(ESlateVisibility.Collapsed);
    local Texture = LoadObject(Fcard.texture);
    local ItemName = Fcard.name;
    local StarText = GachaManager:GetStarText(data[2]);
    local suit = Card.Suit[Fcard.suit];
    local ItemColor = Card.Group[suit.Group].HexColor;
    local grade = Fcard.grade;
    local QualityColor = Card.Grade[grade].HexColor;
    self.PreviewItem:SetBrushFromTexture(Texture);
    self.PreviewItem:SetColorRGBStr(ItemColor);
    self.PreviewTop:SetColorRGBStr(QualityColor);
    self.PreviewStar:SetText(StarText);
    self.PreviewItemName:SetText(ItemName);
    self:_RefreshActionButtons(true);
end



return GachaMain