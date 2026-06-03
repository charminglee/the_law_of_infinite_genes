
StoreManager = StoreManager or
{
    MainUI = nil;
    TabSelectIndex = 0;
    MaxStoreBackpackSize = 100;
    BackpackSelectIndex = -1;
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