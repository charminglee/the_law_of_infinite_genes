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
    DescribeTextList = {},
    AttributeCountTextList = {},
} 
local SelectTag = {
    Shop = 1,
    Equipped = 2,
    Store = 3,
}
local MAX_CARD_SLOT_LEVEL = 12
local DEFAULT_ATTRIBUTE_TEXT_COLOR = 'FFFFFF'
local function SetButtonVisible(button, visible)
    if button == nil then
        return
    end
    button:SetVisibility(visible and ESlateVisibility.Visible or ESlateVisibility.Collapsed);
end
local function ReloadReuseList(list, count)
    if list == nil then
        return
    end
    list:Reload(count);
end
local function AddAttributeText(list, text, HexColor)
    if text == nil then
        return
    end
    table.insert(list, {
        Text = text,
        HexColor = HexColor or DEFAULT_ATTRIBUTE_TEXT_COLOR,
    });
end
local function AddAttributeTotal(totals, entry)
    if entry == nil or entry.property == nil or type(entry.value) ~= "number" then
        return
    end
    totals[entry.property] = (totals[entry.property] or 0) + entry.value;
end
local function TrimNumberText(value)
    local text = string.format("%.2f", value);
    text = string.gsub(text, "0+$", "");
    text = string.gsub(text, "%.$", "");
    return text;
end
local function FormatAttributeValue(value)
    if type(value) ~= "number" then
        return tostring(value);
    end
    local sign = value > 0 and "+" or "";
    if value ~= 0 and math.abs(value) < 1 then
        return sign .. TrimNumberText(value * 100) .. "%";
    end
    return sign .. TrimNumberText(value);
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
    self:RefreshAttributeCountList();
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
function GachaMain:_AttributeName(property)
    if property == nil then
        return "未知属性";
    end
    local meta = AttributeMate and AttributeMate[property];
    if meta ~= nil and meta.anno ~= nil then
        return meta.anno;
    end
    local attr = Attribute;
    if attr ~= nil then
        if attr.DodgeChance ~= nil and property == attr.DodgeChance then
            return "闪避率";
        elseif attr.SeckillChance ~= nil and property == attr.SeckillChance then
            return "秒杀率";
        elseif attr.Recoilless ~= nil and property == attr.Recoilless then
            return "无后坐力";
        elseif attr.ReloadTime ~= nil and property == attr.ReloadTime then
            return "换弹时间";
        elseif attr.BurstShootCDWrapper ~= nil and property == attr.BurstShootCDWrapper then
            return "连发间隔";
        end
    end
    return tostring(property);
end
function GachaMain:_AttributeLine(entry, prefix)
    if entry == nil then
        return nil;
    end
    return (prefix or "") .. self:_AttributeName(entry.property) .. " " .. FormatAttributeValue(entry.value);
end
function GachaMain:BuildAttributeTextList(data)
    local list = {};
    local cardIndex = data and data[1];
    local Fcard = cardIndex and Card.Cards[cardIndex];
    if Fcard == nil then
        return list;
    end
    local suit = Card.Suit and Card.Suit[Fcard.suit];
    local group = suit and Card.Group and Card.Group[suit.Group];
    if group ~= nil then
        AddAttributeText(list, group.name, group.HexColor);
    end
    local star = data[2] or 1;
    local bonusList = Fcard.bonus and (Fcard.bonus[star] or Fcard.bonus[1]);
    if bonusList ~= nil then
        for _, entry in ipairs(bonusList) do
            AddAttributeText(list, self:_AttributeLine(entry), DEFAULT_ATTRIBUTE_TEXT_COLOR);
        end
    end
    local comboList = suit and suit.Combo;
    if comboList ~= nil then
        local comboKeys = {};
        for comboIndex in pairs(comboList) do
            table.insert(comboKeys, comboIndex);
        end
        table.sort(comboKeys);
        for _, comboIndex in ipairs(comboKeys) do
            local combo = Card.Combo and Card.Combo[comboIndex];
            local title = combo and combo.name or ("[" .. tostring(comboIndex) .. "]套效果");
            AddAttributeText(list, title, combo and combo.HexColor or DEFAULT_ATTRIBUTE_TEXT_COLOR);
            for _, entry in ipairs(comboList[comboIndex]) do
                AddAttributeText(list, self:_AttributeLine(entry, "  "), DEFAULT_ATTRIBUTE_TEXT_COLOR);
            end
        end
    end
    return list;
end
function GachaMain:_ComboActive(comboIndex, count, fullStarCount)
    if comboIndex == 1 then
        return count >= 4;
    elseif comboIndex == 2 then
        return count >= 8;
    elseif comboIndex == 3 then
        return count >= 12;
    elseif comboIndex == 4 then
        return count >= 12 and fullStarCount >= count;
    end
    return false;
end
function GachaMain:_AddAttributeEntryListTotal(totals, entryList)
    if entryList == nil then
        return
    end
    for _, entry in ipairs(entryList) do
        AddAttributeTotal(totals, entry);
    end
end
function GachaMain:_SortedAttributeKeys(totals)
    local keys = {};
    for property in pairs(totals) do
        table.insert(keys, property);
    end
    table.sort(keys, function(a, b)
        local aMeta = AttributeMate and AttributeMate[a];
        local bMeta = AttributeMate and AttributeMate[b];
        local aIndex = aMeta and aMeta.index or 9999;
        local bIndex = bMeta and bMeta.index or 9999;
        if aIndex ~= bIndex then
            return aIndex < bIndex;
        end
        return tostring(a) < tostring(b);
    end);
    return keys;
end
function GachaMain:_SortedNumberKeys(source)
    local keys = {};
    if source == nil then
        return keys;
    end
    for key in pairs(source) do
        table.insert(keys, key);
    end
    table.sort(keys);
    return keys;
end
function GachaMain:_AddActiveSuitText(list, activeSuitList)
    if activeSuitList == nil or #activeSuitList <= 0 then
        return
    end
    AddAttributeText(list, "\229\183\178\230\191\128\230\180\187\229\165\151\232\163\133", DEFAULT_ATTRIBUTE_TEXT_COLOR);
    for _, activeSuit in ipairs(activeSuitList) do
        AddAttributeText(list, activeSuit.SuitName, activeSuit.SuitColor);
        for _, comboIndex in ipairs(activeSuit.ComboKeys) do
            local combo = Card.Combo and Card.Combo[comboIndex];
            local title = combo and combo.name or ("[" .. tostring(comboIndex) .. "]\229\165\151\230\149\136\230\158\156");
            AddAttributeText(list, title, combo and combo.HexColor or DEFAULT_ATTRIBUTE_TEXT_COLOR);
            local entryList = activeSuit.ComboList and activeSuit.ComboList[comboIndex];
            if entryList ~= nil then
                for _, entry in ipairs(entryList) do
                    AddAttributeText(list, self:_AttributeLine(entry, "  "), DEFAULT_ATTRIBUTE_TEXT_COLOR);
                end
            end
        end
    end
end
function GachaMain:BuildAttributeCountTextList()
    local list = {};
    local totals = {};
    local suitCounts = {};
    local suitFullStarCounts = {};
    local activeSuitList = {};
    local card = self:_CardData();
    local equipped = card and card.equipped;
    if equipped == nil then
        return list;
    end
    local count = equipped.n or #equipped;
    for i = 1, count do
        local data = equipped[i];
        local cardIndex = data and data[1];
        local Fcard = cardIndex and Card.Cards[cardIndex];
        if Fcard ~= nil then
            local star = data[2] or 1;
            local bonusList = Fcard.bonus and (Fcard.bonus[star] or Fcard.bonus[1]);
            self:_AddAttributeEntryListTotal(totals, bonusList);
            local suitId = Fcard.suit;
            if suitId ~= nil then
                suitCounts[suitId] = (suitCounts[suitId] or 0) + 1;
                if star >= 3 then
                    suitFullStarCounts[suitId] = (suitFullStarCounts[suitId] or 0) + 1;
                end
            end
        end
    end
    for _, suitId in ipairs(self:_SortedNumberKeys(suitCounts)) do
        local suitCount = suitCounts[suitId];
        local suit = Card.Suit and Card.Suit[suitId];
        local comboList = suit and suit.Combo;
        if comboList ~= nil then
            local activeComboKeys = {};
            for _, comboIndex in ipairs(self:_SortedNumberKeys(comboList)) do
                local entryList = comboList[comboIndex];
                if self:_ComboActive(comboIndex, suitCount, suitFullStarCounts[suitId] or 0) then
                    self:_AddAttributeEntryListTotal(totals, entryList);
                    table.insert(activeComboKeys, comboIndex);
                end
            end
            if #activeComboKeys > 0 then
                local group = suit.Group and Card.Group and Card.Group[suit.Group];
                table.insert(activeSuitList, {
                    SuitName = group and group.name or ("\229\165\151\232\163\133" .. tostring(suitId)),
                    SuitColor = group and group.HexColor or DEFAULT_ATTRIBUTE_TEXT_COLOR,
                    ComboKeys = activeComboKeys,
                    ComboList = comboList,
                });
            end
        end
    end
    self:_AddActiveSuitText(list, activeSuitList);
    local keys = self:_SortedAttributeKeys(totals);
    if #keys > 0 and #list > 0 then
        AddAttributeText(list, "\230\128\187\229\177\158\230\128\167", DEFAULT_ATTRIBUTE_TEXT_COLOR);
    end
    for _, property in ipairs(keys) do
        AddAttributeText(list, self:_AttributeName(property) .. " " .. FormatAttributeValue(totals[property]), DEFAULT_ATTRIBUTE_TEXT_COLOR);
    end
    return list;
end
function GachaMain:RefreshAttributeCountList()
    self.AttributeCountTextList = self:BuildAttributeCountTextList();
    ReloadReuseList(self.AttributeCountList, #self.AttributeCountTextList);
end
function GachaMain:_RefreshDescribeTextList(data)
    self.DescribeTextList = self:BuildAttributeTextList(data);
    ReloadReuseList(self.DescributeList, #self.DescribeTextList);
end
function GachaMain:_UpdateAttributeTextItem(Item, Index, textList)
    Item.Index = Index;
    local data = textList and textList[Index + 1];
    if data == nil then
        if Item.SetText ~= nil then
            Item:SetText("", DEFAULT_ATTRIBUTE_TEXT_COLOR);
        end
        return;
    end
    if Item.SetText ~= nil then
        Item:SetText(data.Text, data.HexColor or DEFAULT_ATTRIBUTE_TEXT_COLOR);
    elseif Item.Text ~= nil then
        Item.Text:SetText(data.Text);
        Item.Text:SetColorRGBStr(data.HexColor or DEFAULT_ATTRIBUTE_TEXT_COLOR);
    end
end
function GachaMain:Exit()
    GachaManager:CloseMainUI()
end

function GachaMain:Refresh()
    ugcprint('客户端点击商店刷新')
    ugcprint('compclass is:'..tostring(GachaManager.ComponentClass));
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
    self:_UpdateAttributeTextItem(Item, Index, self.AttributeCountTextList);
end

function GachaMain:DescributeListUpdate(Item, Index)
    self:_UpdateAttributeTextItem(Item, Index, self.DescribeTextList);
end
function GachaMain:SetPreview(isShow)
    local data = GachaManager.PreviewDAT;
    local cardIndex = data and data[1];
    local Fcard = cardIndex and Card.Cards[cardIndex];
    if not isShow or data == nil or Fcard == nil then
        self.SelectedPreview:SetVisibility(ESlateVisibility.Collapsed);
        self.NilPreview:SetVisibility(ESlateVisibility.Visible);
        self:_RefreshActionButtons(false);
        self:_RefreshDescribeTextList(nil);
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
    self:_RefreshDescribeTextList(data);
    self:_RefreshActionButtons(true);
end



return GachaMain
