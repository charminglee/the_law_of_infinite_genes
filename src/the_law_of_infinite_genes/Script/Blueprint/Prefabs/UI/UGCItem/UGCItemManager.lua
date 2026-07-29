UGCItemManager = UGCItemManager or {
    SelectedIndexMap = {},
    DataMap = {},
    ListWidgetMap = {},
    OwnerWidgetMap = {},
    ReloadCountMap = {},
}

UGCItemManager.UseList = UGCItemManager.UseList or {
    Backpack = "BackpackList",
    Store = "StoreList",
    EquipSlot = "EquipSlotList",
    Strengthen = "StrengthenList",
    Refined = "RefinedList",
    Resultant = "ResultantList",
}

function UGCItemManager:GetListKey(UseListFlag)
    if UseListFlag == nil then
        return "__Default";
    end
    return tostring(UseListFlag);
end

function UGCItemManager:RegisterList(UseListFlag, OwnerWidget, ListWidget, ReloadCount)
    local ListKey = self:GetListKey(UseListFlag);
    self.OwnerWidgetMap[ListKey] = OwnerWidget;
    self.ListWidgetMap[ListKey] = ListWidget;
    self.ReloadCountMap[ListKey] = ReloadCount;
end

function UGCItemManager:UnregisterList(UseListFlag)
    local ListKey = self:GetListKey(UseListFlag);
    self.OwnerWidgetMap[ListKey] = nil;
    self.ListWidgetMap[ListKey] = nil;
    self.ReloadCountMap[ListKey] = nil;
    self.DataMap[ListKey] = nil;
    self.SelectedIndexMap[ListKey] = nil;
end

function UGCItemManager:SetListData(UseListFlag, DataList)
    local ListKey = self:GetListKey(UseListFlag);
    self.DataMap[ListKey] = DataList or {};
end

function UGCItemManager:GetListData(UseListFlag)
    local ListKey = self:GetListKey(UseListFlag);
    return self.DataMap[ListKey] or {};
end

function UGCItemManager:GetItemData(UseListFlag, Index)
    local DataList = self:GetListData(UseListFlag);
    if DataList == nil or Index == nil then
        return nil;
    end

    return DataList[Index + 1] or DataList[Index];
end

function UGCItemManager:SetSelectedIndex(UseListFlag, Index)
    local ListKey = self:GetListKey(UseListFlag);
    self.SelectedIndexMap[ListKey] = Index;
end

function UGCItemManager:GetSelectedIndex(UseListFlag)
    local ListKey = self:GetListKey(UseListFlag);
    return self.SelectedIndexMap[ListKey];
end

function UGCItemManager:ClearSelectedIndex(UseListFlag)
    local ListKey = self:GetListKey(UseListFlag);
    self.SelectedIndexMap[ListKey] = nil;
end

function UGCItemManager:IsSelected(UseListFlag, Index)
    return self:GetSelectedIndex(UseListFlag) == Index;
end

function UGCItemManager:BindItem(ItemWidget, OwnerWidget, UseListFlag, Index, ItemData)
    if ItemWidget == nil then
        return;
    end

    if ItemWidget.SetListContext ~= nil then
        ItemWidget:SetListContext(OwnerWidget, UseListFlag, Index);
    else
        ItemWidget.OwnerWidget = OwnerWidget;
        ItemWidget.UseListFlag = UseListFlag;
        ItemWidget.Index = Index;
        ItemWidget.index = Index;
    end

    local Data = ItemData;
    if Data == nil then
        Data = self:GetItemData(UseListFlag, Index);
    end

    if Data ~= nil and ItemWidget.SetItemData ~= nil then
        ItemWidget:SetItemData(Data);
    elseif ItemWidget.SetNoneItem ~= nil then
        ItemWidget:SetNoneItem();
    end

    if ItemWidget.SetSelectedVisible ~= nil then
        ItemWidget:SetSelectedVisible(self:IsSelected(UseListFlag, Index));
    end
end

function UGCItemManager:ReloadList(UseListFlag)
    local ListKey = self:GetListKey(UseListFlag);
    local ListWidget = self.ListWidgetMap[ListKey];
    if ListWidget ~= nil and ListWidget.Reload ~= nil then
        ListWidget:Reload(self:GetReloadCount(UseListFlag));
        return true;
    end

    local OwnerWidget = self.OwnerWidgetMap[ListKey];
    if OwnerWidget ~= nil and UseListFlag ~= nil then
        local OwnerListWidget = OwnerWidget[UseListFlag];
        if OwnerListWidget ~= nil and OwnerListWidget.Reload ~= nil then
            OwnerListWidget:Reload(self:GetReloadCount(UseListFlag));
            return true;
        end
    end

    return false;
end

function UGCItemManager:GetReloadCount(UseListFlag)
    local ListKey = self:GetListKey(UseListFlag);
    local ReloadCount = self.ReloadCountMap[ListKey];
    if ReloadCount ~= nil then
        return ReloadCount;
    end

    local DataList = self:GetListData(UseListFlag);
    return #DataList;
end

function UGCItemManager:OnItemClicked(ItemWidget)
    if ItemWidget == nil then
        return false;
    end

    local UseListFlag = ItemWidget.UseListFlag;
    local Index = ItemWidget.GetIndex ~= nil and ItemWidget:GetIndex() or ItemWidget.Index or ItemWidget.index;
    local ItemData = ItemWidget.GetItemData ~= nil and ItemWidget:GetItemData() or ItemWidget.ItemData;
    local OwnerWidget = ItemWidget.OwnerWidget or ItemWidget.ParentWidget or ItemWidget.parent or ItemWidget.Parent or self.OwnerWidgetMap[self:GetListKey(UseListFlag)];

    self:SetSelectedIndex(UseListFlag, Index);

    if type(ItemWidget.ClickCallback) == "function" then
        ItemWidget.ClickCallback(ItemWidget, Index, ItemData, UseListFlag);
        self:ReloadList(UseListFlag);
        return true;
    end

    if OwnerWidget ~= nil then
        if type(OwnerWidget.OnUGCItemClicked) == "function" then
            OwnerWidget.OnUGCItemClicked(OwnerWidget, UseListFlag, Index, ItemData, ItemWidget);
            self:ReloadList(UseListFlag);
            return true;
        end
        if type(OwnerWidget.OnListItemClicked) == "function" then
            OwnerWidget.OnListItemClicked(OwnerWidget, UseListFlag, Index, ItemData, ItemWidget);
            self:ReloadList(UseListFlag);
            return true;
        end
        if type(OwnerWidget.OnItemClicked) == "function" then
            OwnerWidget.OnItemClicked(OwnerWidget, Index, ItemData, UseListFlag, ItemWidget);
            self:ReloadList(UseListFlag);
            return true;
        end
        if type(OwnerWidget.RefreshSelect) == "function" then
            OwnerWidget.RefreshSelect(OwnerWidget, Index);
            self:ReloadList(UseListFlag);
            return true;
        end
    end

    self:ReloadList(UseListFlag);
    return true;
end

return UGCItemManager
