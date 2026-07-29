
StoreManager = StoreManager or
{
    MainUI = nil;
    ItemInfoDialogUI = nil;
    TabSelectIndex = 0;
    MaxStoreBackpackSize = 100;
    BackpackSelectIndex = -1;
    StoreBackpackTabSelectIndex = 0;
    StoreStrengthenChoseItemIndex = 0;
    StoreRefinedChoseItemIndex = 0;
    BackpackList = {
    [1] = {
        {
            ItemId = 8310021,
            Count = 1,
            Quality = 3,
            StrengthenLevel = 2,
            RefineAttrs = {
                { AttrId = 1, Value = 10 },
                { AttrId = 2, Value = 5 },
                { AttrId = 3, Value = 3 },
                { AttrId = 4, Value = 1 },
            },
        },
        {
            ItemId = 8310026,
            Count = 1,
            Quality = 4,
            StrengthenLevel = 5,
            RefineAttrs = {
                { AttrId = 1, Value = 18 },
                { AttrId = 2, Value = 8 },
                { AttrId = 3, Value = 6 },
                { AttrId = 4, Value = 2 },
            },
        },
        {
            ItemId = 8310031,
            Count = 1,
            Quality = 5,
            StrengthenLevel = 8,
            RefineAttrs = {
                { AttrId = 1, Value = 25 },
                { AttrId = 2, Value = 12 },
                { AttrId = 3, Value = 9 },
                { AttrId = 4, Value = 4 },
            },
        },
    },

    [2] = {
    },

    [3] = {
        { ItemId = 8310014, Count = 12, Quality = 1 },
        { ItemId = 8310015, Count = 28, Quality = 1 },
        { ItemId = 8310016, Count = 9, Quality = 2 },
        { ItemId = 8310017, Count = 36, Quality = 1 },
    },

    [4] = {
    },
}
}

function StoreManager:RegisterComponentClass(CompClass)

    if CompClass ~= nil then
        self.ComponentClass = CompClass;
    end
end

function StoreManager:RegisterMainUI(MainUI)
    
    if self.MainUI == nil then
        self.MainUI = MainUI;
    end
end

function StoreManager:RegisterItemInfoDialogUI(UI)
    if self.ItemInfoDialogUI == nil then
        self.ItemInfoDialogUI = UI;    
    end
end

function StoreManager:UnregisterMainUI()
    self.MainUI = nil;
    self:GetCommodityOperationManager().BuyProductResultDelegate:Remove(self.OnBuyProductResult, self);
    self.bBuyProductResultBinded = false
end

function StoreManager:OpenMainUI()
    ugcprint('main ui is:'..tostring(self.MainUI));

    if self.MainUI == nil then
        return;
    end
    self.TabSelectIndex = 0;
    self.BackpackSelectIndex = -1;
    self.MainUI:SetVisibility(ESlateVisibility.Visible);
end

function StoreManager:OpenStoreItemInfoDialog()
    if self.ItemInfoDialogUI == nil then
        return;
    end
    self.ItemInfoDialogUI:SetVisibility(ESlateVisibility.Visible);
end

function StoreManager:CloseMainUI()
    if self.MainUI == nil then
        return;
    end
    self.MainUI:SetVisibility(ESlateVisibility.Collapsed);
end

function StoreManager:GetMainUI()
    return self.MainUI;
end

function StoreManager:SetTabSelectIndex(Index)
    self.MainUI:SetTabSelectIndex(Index);
end