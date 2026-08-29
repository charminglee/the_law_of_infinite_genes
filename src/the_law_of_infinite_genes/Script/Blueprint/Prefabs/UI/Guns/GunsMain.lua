---@class GunsMain_C:UAEUserWidget
---@field Button_0 UButton
---@field Button_1 UButton
---@field Button_2 UButton
---@field GunsList UGC_ReuseList2_C
---@field ItemImage UImage
---@field ItemName UTextBlock
---@field Preview UCanvasPanel
---@field TabList UGC_ReuseList2_C
---@field UTRichTextBlock_1 UUTRichTextBlock
--Edit Below--
local GunsMain = {
    bInitDoOnce = false,
    Filter = {},
    RenderVersion = 0,
    SelectedListItem = nil,
    PendingUnlockItemId = nil,
}

function GunsMain:Construct()
    self:LuaInit();
end

---@param ItemId integer
---@param IsUnlocked boolean
---@param Condition table
---@param OwnedCount number
---@param CanUnlock boolean
---@return string
function GunsMain:GetDescriptionText(ItemId, IsUnlocked, Condition, OwnedCount, CanUnlock)
    local detail = RichText.Font(
            UGCItemSystemV2.GetItemDetailV2(ItemId),
            {size = 18, color = 'FFFFFFFF'}
    );

    if IsUnlocked then
        return detail;
    end

    if Condition.ItemId == 0 and Condition.Count == 0 then
        return RichText.Line(
                detail,
                '',
                RichText.Font('解锁需求：无', {size = 18, color = 'FFFFFFFF'})
        );
    end

    local materialName = UGCItemSystemV2.GetItemNameV2(Condition.ItemId);
    local materialIcon = UGCItemSystemV2.GetItemIconTextureV2(Condition.ItemId);
    local countColor = CanUnlock and 'B8FFA1FF' or 'FF6B6BFF';
    local requirement = RichText.Inline(
            RichText.Font('解锁需求：', {size = 18, color = 'FFFFFFFF'}),
            RichText.Image({
                src = tostring(materialIcon.AssetPathName),
                width = 28,
                height = 28,
                baseline = -7,
            }),
            RichText.Font(' ' .. materialName .. '  ', {size = 18, color = 'FFFFFFFF'}),
            RichText.Font(
                    string.format('%s/%s', tostring(OwnedCount), tostring(Condition.Count)),
                    {size = 18, color = countColor}
            )
    );
    return RichText.Line(detail, '', requirement);
end

function GunsMain:Destruct()
    GunsManager:UnregisterMainUI(self);
end

function GunsMain:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self.Button_0.OnClicked:Add(self.Exit, self);
    self.Button_1.OnClicked:Add(self.RequestUnlock, self);
    self.TabList.OnUpdateItem:Add(self.TabListUpdate, self);
    self.GunsList.OnUpdateItem:Add(self.GunsListUpdate, self);
    GunsManager:RegisterMainUI(self);
end

function GunsMain:RequestUnlock()
    local itemData = GunsManager.DefineId;
    if LocalPlayerState.PlayerDataManager:IsGunUnlock(itemData.ItemId) then
        return;
    end
    self.PendingUnlockItemId = itemData.ItemId;
    self.Button_1:SetIsEnabled(false);
    GunsManager:RequestUnlock(itemData.ItemId);
end

function GunsMain:Open()
    self:SetVisibility(ESlateVisibility.Visible);
    self:Reload(nil, GunsManager.GunsType[1].Type);
end

function GunsMain:Exit()
    self:SetVisibility(ESlateVisibility.Collapsed);
end

---@param ItemData table|nil
---@param FilterType string
function GunsMain:Reload(ItemData, FilterType)
    FilterType = FilterType or GunsManager.GunsType[1].Type;
    self.Filter = self:FilterGuns(FilterType);

    local selected = self:FindItem(ItemData) or self.Filter[1];
    GunsManager.DefineId = selected;
    GunsManager.FilterType = FilterType;
    self.SelectedListItem = nil;

    self.TabList:Reload(#GunsManager.GunsType);
    self.GunsList:Reload(#self.Filter);
    self:SetPreview(selected);
end

---@param ItemData table
---@param ListItem GunsItem_C
function GunsMain:SelectGun(ItemData, ListItem)
    if self.SelectedListItem ~= nil and self.SelectedListItem ~= ListItem then
        self.SelectedListItem:SetSelected(nil);
    end
    self.SelectedListItem = ListItem;
    GunsManager.DefineId = ItemData;
    ListItem:SetSelected(ItemData);
    self:SetPreview(ItemData);
end

---@param ItemData table|nil
---@return table|nil
function GunsMain:FindItem(ItemData)
    if ItemData == nil then
        return nil;
    end
    for _, item in ipairs(self.Filter) do
        if item.ItemId == ItemData.ItemId then
            return item;
        end
    end
    return nil;
end

---@param FilterType string
---@return table[]
function GunsMain:FilterGuns(FilterType)
    if FilterType ~= 'ALL' then
        return Lib.Table.Map(ItemCfg.TabItemsMap[FilterType], function(k, v)
            return { ItemId=v, Count=ItemCfg.GunPrice[v] }
        end);
    else
        local result = {};
        for index = 2, #GunsManager.GunsType do
            local category = ItemCfg.TabItemsMap[GunsManager.GunsType[index].Type];
            for _, itemId in ipairs(category) do
                table.insert(result, { ItemId=itemId, Count=ItemCfg.GunPrice[itemId] })
            end
        end
        return result;
    end
end

---@param ItemData table|nil
---@param UnlockedItemId integer|nil
function GunsMain:SetPreview(ItemData, UnlockedItemId)
    if ItemData == nil then
        self.Preview:SetVisibility(ESlateVisibility.Collapsed);
        return;
    end

    self.Preview:SetVisibility(ESlateVisibility.Visible);
    local itemId = ItemData.ItemId;
    local isUnlocked = itemId == UnlockedItemId
            or LocalPlayerState.PlayerDataManager:IsGunUnlock(itemId);
    local condition = ItemCfg.UnlockConditions[itemId];
    local ownedCount = condition.ItemId == 0
            and condition.Count
            or math.max(0, LocalPlayerState.PlayerDataManager:GetCoin(condition.ItemId));
    local canUnlock = not isUnlocked and ownedCount >= condition.Count;

    self:SetPreviewTexture(UGCItemSystemV2.GetItemIconTextureV2(itemId));
    self.ItemName:SetText(UGCItemSystemV2.GetItemNameV2(itemId));

    self.UTRichTextBlock_1:SetText(self:GetDescriptionText(
            itemId,
            isUnlocked,
            condition,
            ownedCount,
            canUnlock
    ));

    self.Button_1:SetVisibility(isUnlocked and ESlateVisibility.Collapsed or ESlateVisibility.Visible);
    self.Button_2:SetVisibility(isUnlocked and ESlateVisibility.Visible or ESlateVisibility.Collapsed);
    self.Button_1:SetIsEnabled(canUnlock and self.PendingUnlockItemId == nil);
    self.Button_2:SetIsEnabled(isUnlocked);
end

function GunsMain:TabListUpdate(Item, Index)
    local tab = GunsManager.GunsType[Index + 1];
    Item:SetDAT(Index, tab.Text);
    Item:SetSelected(GunsManager.FilterType == tab.Type);
end

function GunsMain:GunsListUpdate(Item, Index)
    local itemData = self.Filter[Index + 1];
    if itemData == nil then
        Item:SetEmpty();
        return;
    end
    Item:SetDefineID(itemData);
    Item:SetSelected(GunsManager.DefineId);
    if GunsManager.DefineId ~= nil and itemData.ItemId == GunsManager.DefineId.ItemId then
        self.SelectedListItem = Item;
    end
end

function GunsMain:SetPreviewTexture(Path)
    self.RenderVersion = self.RenderVersion + 1;
    local renderVersion = self.RenderVersion;
    Common.LoadObjectWithSoftPathAsync(Path,
            function(Texture)
                if self ~= nil and Texture ~= nil and self.RenderVersion == renderVersion then
                    self.ItemImage:SetBrushFromTexture(Texture);
                end
            end
    );
end

function GunsMain:OnGunUnlockAfter(ItemId)
    self.PendingUnlockItemId = nil;
    self:SetPreview(GunsManager.DefineId, ItemId);
end

return GunsMain
