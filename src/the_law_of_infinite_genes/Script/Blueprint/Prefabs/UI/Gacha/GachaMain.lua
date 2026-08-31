---@class GachaMain_C:UUserWidget
---@field CountPreviewText UUTRichTextBlock
---@field EquipCardButton UButton
---@field ExitButton UButton
---@field LevelUpButton UButton
---@field NilPreview UCanvasPanel
---@field OuterExitButton UButton
---@field PreviewItem UImage
---@field PreviewItemName UTextBlock
---@field PreviewStar UTextBlock
---@field PreviewText UUTRichTextBlock
---@field PreviewTop UImage
---@field PurchaseButton UButton
---@field RefreshButton UButton
---@field ResourceCoin UTextBlock
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
    PreviewRenderVersion = 0,
} 
local SelectTag = {
    Shop = 1,
    Equipped = 2,
    Store = 3,
}
local DEFAULT_ATTRIBUTE_TEXT_COLOR = 'FFFFFFFF'
local function SetButtonVisible(button, visible)
    if button == nil then
        return
    end
    button:SetVisibility(visible and ESlateVisibility.Visible or ESlateVisibility.Collapsed);
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
    self:RefreshCountPreviewEmptyState();
    self:SetPreview(false);
    self:ReloadList();
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
end

function GachaMain:ReloadList()
    self.ShopList:Reload(CardCfg.Common.ShopSlotCount);
    self.StoreList:Reload(CardCfg.Common.StoreSlotCount);
    self.SlotList:Reload(CardCfg.Common.EquippedSlotCount);
    self:RefreshInfo();
    self:RefreshCountPreviewText();
end
local function GetRichTextColor(HexColor)
    local color = HexColor or DEFAULT_ATTRIBUTE_TEXT_COLOR;
    if #color == 6 then
        return color .. "FF";
    end
    return color;
end
local function BuildRichText(textList)
    local result = {};
    for _, data in ipairs(textList) do
        table.insert(result, RichText.Font(data.Text, {
            size = 18,
            color = GetRichTextColor(data.HexColor),
        }));
    end
    return table.concat(result, "\n");
end
function GachaMain:_SelectedSlot()
    if GachaManager.SelectIndex == nil then
        return nil
    end
    return GachaManager.SelectIndex + 1
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
    local manager = LocalPlayerState.PlayerDataManager
    local maxSlotLv = CardCfg.Common.MaxCardSlotLevel
    local shopLevel = manager:GetCardShopLevel()
    local unlockedSlotCount = manager:GetUnlockedCardSlotCount()
    local equippedSlotCount = self:_CountUsed(manager:GetAllEquippedCards())
    if self.ShopLevel ~= nil then
        self.ShopLevel:SetText("Lv." .. tostring(shopLevel));
    end
    if self.SlotCount ~= nil then
        self.SlotCount:SetText(tostring(equippedSlotCount) .. "/" .. tostring(unlockedSlotCount));
    end
    if self.StoreCount ~= nil then
        local store = manager:GetAllStoreCards()
        local storeSlotCount = CardCfg.Common.StoreSlotCount
        self.StoreCount:SetText(tostring(self:_CountUsed(store)) .. "/" .. tostring(storeSlotCount));
    end
    self:SetResourceCoin(manager:GetCoin(ItemId.Coin_3));
    SetButtonVisible(self.LevelUpButton, unlockedSlotCount < maxSlotLv);
end
function GachaMain:SetResourceCoin(Value)
    self.ResourceCoin:SetText(tostring(Value));
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
        elseif attr.ReloadTime ~= nil and property == attr.ReloadTime then
            return "换弹时间";
        elseif attr.ShootSpeedScale ~= nil and property == attr.ShootSpeedScale then
            return "射击速度";
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
    local Fcard = cardIndex and CardCfg.Cards[cardIndex];
    if Fcard == nil then
        return list;
    end
    local grade = CardCfg.Grade[Fcard.grade];
    local suit = CardCfg.Suit and CardCfg.Suit[Fcard.suit];
    local group = suit and CardCfg.Group and CardCfg.Group[suit.Group];
    AddAttributeText(list, Fcard.name, grade.HexColor);
    AddAttributeText(list, "卡牌价格：" .. tostring(grade.cost), DEFAULT_ATTRIBUTE_TEXT_COLOR);
    local star = data[2] or 1;
    local bonusList = Fcard.bonus and (Fcard.bonus[star] or Fcard.bonus[1]);
    if bonusList ~= nil then
        for _, entry in ipairs(bonusList) do
            AddAttributeText(list, self:_AttributeLine(entry), DEFAULT_ATTRIBUTE_TEXT_COLOR);
        end
    end
    if group ~= nil then
        AddAttributeText(list, group.name, group.HexColor);
    end
    local comboList = suit and suit.Combo;
    if comboList ~= nil then
        local comboKeys = {};
        for comboIndex in pairs(comboList) do
            table.insert(comboKeys, comboIndex);
        end
        table.sort(comboKeys);
        for _, comboIndex in ipairs(comboKeys) do
            local combo = CardCfg.Combo and CardCfg.Combo[comboIndex];
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
            local combo = CardCfg.Combo and CardCfg.Combo[comboIndex];
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
    local manager = LocalPlayerState.PlayerDataManager;
    local count = CardCfg.Common.EquippedSlotCount;
    for i = 1, count do
        local data = manager:GetEquippedCard(i);
        local cardIndex = data and data[1];
        local Fcard = cardIndex and CardCfg.Cards[cardIndex];
        if Fcard ~= nil then
            local star = data[2] or 1;
            local bonusList = Fcard.bonus and (Fcard.bonus[star] or Fcard.bonus[1]);
            self:_AddAttributeEntryListTotal(totals, bonusList);
            local suitId = Fcard.suit;
            if suitId ~= nil then
                suitCounts[suitId] = (suitCounts[suitId] or 0) + 1;
                if star >= CardCfg.Common.MaxCardStar then
                    suitFullStarCounts[suitId] = (suitFullStarCounts[suitId] or 0) + 1;
                end
            end
        end
    end
    for _, suitId in ipairs(self:_SortedNumberKeys(suitCounts)) do
        local suitCount = suitCounts[suitId];
        local suit = CardCfg.Suit and CardCfg.Suit[suitId];
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
                local group = suit.Group and CardCfg.Group and CardCfg.Group[suit.Group];
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
function GachaMain:RefreshCountPreviewText()
    local textList = self:BuildAttributeCountTextList();
    if #textList == 0 then
        self:RefreshCountPreviewEmptyState();
        return;
    end
    self.CountPreviewText:SetText(BuildRichText(textList));
end
function GachaMain:RefreshCountPreviewEmptyState()
    self.CountPreviewText:SetVisibility(ESlateVisibility.Visible);
    self.CountPreviewText:SetText(RichText.Font("暂无属性加成", {
        size = 18,
        color = "88FFFFFF",
    }));
end
function GachaMain:RefreshPreviewText(data)
    self.PreviewText:SetText(BuildRichText(self:BuildAttributeTextList(data)));
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
function GachaMain:HandleItemDrop(sourceItem, targetItem)
    if sourceItem.Data == nil or targetItem.Data ~= nil then
        return false;
    end
    local fromSlot = sourceItem.Index + 1;
    local toSlot = targetItem.Index + 1;
    local manager = LocalPlayerState.PlayerDataManager;
    if sourceItem.Tag == SelectTag.Store and targetItem.Tag == SelectTag.Equipped then
        if toSlot > manager:GetUnlockedCardSlotCount() or manager:GetEquippedCard(toSlot) ~= nil then
            return false;
        end
        UnrealNetwork.CallUnrealRPC(LocalPlayerController, GachaManager.ComponentClass, "EquipCard",
                LocalPlayerController.PlayerKey, fromSlot, toSlot);
        return true;
    end
    if sourceItem.Tag == SelectTag.Equipped and targetItem.Tag == SelectTag.Store then
        if manager:GetStoreCard(toSlot) ~= nil then
            return false;
        end
        UnrealNetwork.CallUnrealRPC(LocalPlayerController, GachaManager.ComponentClass, "UnequipCard",
                LocalPlayerController.PlayerKey, fromSlot, toSlot);
        return true;
    end
    if sourceItem.Tag == SelectTag.Shop and targetItem.Tag == SelectTag.Store then
        if manager:GetStoreCard(toSlot) ~= nil then
            return false;
        end
        UnrealNetwork.CallUnrealRPC(LocalPlayerController, GachaManager.ComponentClass, "APurchaseCard",
                LocalPlayerController.PlayerKey, fromSlot, toSlot);
        return true;
    end
    return false;
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
    local data = LocalPlayerState.PlayerDataManager:GetShopCard(Index + 1);
    Item:SetData(Index, SelectTag.Shop, data, false, false);
end
function GachaMain:SlotListUpdate(Item, Index)
    local manager = LocalPlayerState.PlayerDataManager;
    local slot = Index + 1;
    local data = manager:GetEquippedCard(slot);
    local isUnlocked = slot <= manager:GetUnlockedCardSlotCount();
    Item:SetData(Index, SelectTag.Equipped, data, isUnlocked, not isUnlocked);
end
function GachaMain:StoreListUpdate(Item, Index)
    local data = LocalPlayerState.PlayerDataManager:GetStoreCard(Index + 1);
    Item:SetData(Index, SelectTag.Store, data, true, false);
end

function GachaMain:SetPreview(isShow)
    local data = GachaManager.PreviewDAT;
    local cardIndex = data and data[1];
    local Fcard = cardIndex and CardCfg.Cards[cardIndex];
    if not isShow or data == nil or Fcard == nil then
        self.PreviewRenderVersion = self.PreviewRenderVersion + 1;
        self.SelectedPreview:SetVisibility(ESlateVisibility.Collapsed);
        self.NilPreview:SetVisibility(ESlateVisibility.Visible);
        self:_RefreshActionButtons(false);
        self:RefreshPreviewText(nil);
        return;
    end
    self.SelectedPreview:SetVisibility(ESlateVisibility.Visible);
    self.NilPreview:SetVisibility(ESlateVisibility.Collapsed);
    local ItemName = Fcard.name;
    local StarText = GachaManager:GetStarText(data[2]);
    local suit = CardCfg.Suit[Fcard.suit];
    local ItemColor = CardCfg.Group[suit.Group].HexColor;
    local grade = Fcard.grade;
    local QualityColor = CardCfg.Grade[grade].HexColor;
    self:AsyncSetPreviewTexture({AssetPathName = Fcard.texture, SubPathString = nil});
    self.PreviewItem:SetColorRGBStr(ItemColor);
    self.PreviewTop:SetColorRGBStr(QualityColor);
    self.PreviewStar:SetText(StarText);
    self.PreviewItemName:SetText(ItemName);
    self:RefreshPreviewText(data);
    self:_RefreshActionButtons(true);
end

function GachaMain:AsyncSetPreviewTexture(Path)
    self.PreviewRenderVersion = self.PreviewRenderVersion + 1;
    local renderVersion = self.PreviewRenderVersion;
    Common.LoadObjectWithSoftPathAsync(Path,
            function(Texture)
                if self ~= nil and Texture ~= nil
                        and self.PreviewRenderVersion == renderVersion then
                    self.PreviewItem:SetBrushFromTexture(Texture);
                end
            end
    );
end



return GachaMain
