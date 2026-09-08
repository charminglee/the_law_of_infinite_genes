---@class FirearmMain_C:UAEUserWidget
---@field ExitButton UButton
---@field FirearmList ReuseList2_C
---@field Item UImage
---@field ItemDesc UTextBlock
---@field ItemName UTextBlock
---@field NeedCost UTextBlock
---@field Nils UCanvasPanel
---@field PurchaseButton UButton
---@field ResourceCoin UTextBlock
---@field ResourceCoinIcon UImage
---@field Selected UCanvasPanel
---@field TabList ReuseList2_C
--Edit Below--
local FirearmMain = {
    bInitDoOnce = false,
    PreviewRenderVersion = 0,
}

local DefaultPreviewPath = {
    AssetPathName = '/Game/Arts/UI/Atlas/BattleUI/Tmode_HideAndSeek/Frames/ZD_HAS_Skill0_png.ZD_HAS_Skill0_png',
    SubPathString = nil,
}

function FirearmMain:Construct()
    self:LuaInit();
end

function FirearmMain:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self.ExitButton.OnClicked:Add(self.Exit, self);
    self.PurchaseButton.OnClicked:Add(self.PurchaseButtonClick, self);
    self.TabList.OnUpdateItem:Add(self.TabListUpdate, self);
    self.FirearmList.OnUpdateItem:Add(self.FirearmListUpdate, self);
    Lib.EventSystem.Listen(Event.OnCoinChangeAfter, self.OnCoinChangeAfter, self);
    FightManager:RegisterMainUI(self);
    self:RefreshAll();
end

function FirearmMain:Destruct()
    Lib.EventSystem.UnlistenByOwner(self);
    FightManager:UnregisterMainUI(self);
end

function FirearmMain:Open()
    self:SetVisibility(ESlateVisibility.Visible);
    self:RefreshAll();
    BroadcastManager:SendTip('消耗资源点可购买本局使用的枪械与弹药');
end

function FirearmMain:Exit()
    self:SetVisibility(ESlateVisibility.Collapsed);
end

function FirearmMain:RefreshAll()
    local purchaseList = FightManager:GetPurchaseList();
    self.TabList:Reload(#ItemCfg.FirearmType);
    self.FirearmList:Reload(#purchaseList);
    self:RefreshResourceCoin();
    self:RefreshDetail();
end

function FirearmMain:RefreshResourceCoin()
    self.ResourceCoin:SetText(tostring(LocalPlayerState.PlayerDataManager:GetCoin(ItemId.Coin_3)));
end

function FirearmMain:OnCoinChangeAfter(UID, CoinId, OldValue, NewValue)
    if CoinId == ItemId.Coin_3 then
        self.ResourceCoin:SetText(tostring(NewValue));
    end
end

function FirearmMain:RefreshPurchaseSelection()
    local purchaseList = FightManager:GetPurchaseList();
    self.FirearmList:Reload(#purchaseList);
    self:RefreshDetail();
end

function FirearmMain:RefreshDetail()
    local itemData = FightManager:GetSelectedPurchaseData();
    local hasSelection = itemData ~= nil and itemData.ItemId ~= nil;
    self.Nils:SetVisibility(hasSelection and ESlateVisibility.Collapsed or ESlateVisibility.Visible);
    self.Selected:SetVisibility(hasSelection and ESlateVisibility.Visible or ESlateVisibility.Collapsed);
    self.PurchaseButton:SetIsEnabled(hasSelection);

    if not hasSelection then
        self:SetPreviewTexture(DefaultPreviewPath);
        self.ItemName:SetText('');
        self.ItemDesc:SetText('');
        self.NeedCost:SetText('');
        return;
    end

    local itemId = itemData.ItemId;
    self:SetPreviewTexture(UGCItemSystemV2.GetItemIconTextureV2(itemId));
    self.ItemName:SetText(UGCItemSystemV2.GetItemNameV2(itemId) or '');
    self.ItemDesc:SetText(UGCItemSystemV2.GetItemDetailV2(itemId) or '');
    self.NeedCost:SetText(tostring(itemData.Price));
end

function FirearmMain:SetPreviewTexture(Path)
    if Path == nil or self.Item == nil then
        return;
    end
    self.PreviewRenderVersion = self.PreviewRenderVersion + 1;
    local renderVersion = self.PreviewRenderVersion;
    Common.LoadObjectWithSoftPathAsync(Path,
            function(Texture)
                if self == nil or Texture == nil or self.Item == nil
                        or self.PreviewRenderVersion ~= renderVersion then
                    return;
                end
                self.Item:SetBrushFromTexture(Texture);
            end
    );
end

function FirearmMain:PurchaseButtonClick()
    local itemData = FightManager:GetSelectedPurchaseData();
    if itemData == nil then
        return;
    end
    FightManager:OnPurchaseRequested(itemData);
end

function FirearmMain:TabListUpdate(Item, Index)
    local tabData = FightManager:GetTabData(Index);
    if tabData == nil then
        Item:SetEmpty();
        return;
    end
    Item:SetData(Index, tabData);
    Item:SetSelected(FightManager.TabSelectIndex == Index);
end

function FirearmMain:FirearmListUpdate(Item, Index)
    local itemData = FightManager:GetPurchaseList()[Index + 1];
    if itemData == nil or itemData.ItemId == nil then
        Item:SetEmpty();
        return;
    end
    Item:SetItemData(Index, itemData);
    Item:SetSelected(FightManager.PurchaseSelectIndex == Index);
end

return FirearmMain
