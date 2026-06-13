
FightManager = FightManager or
{
    MainUI = nil;
    LBPurchaseListSelectedIndex = nil;
    LTabListSelectedIndex = 0;
}

function FightManager:RegisterComponentClass(CompClass)

    if CompClass ~= nil then
        self.ComponentClass = CompClass;
    end
end

function FightManager:RegisterMainUI(MainUI)
    
    if self.MainUI == nil then
        self.MainUI = MainUI;
    end
end

function FightManager:UnregisterMainUI()
    self.MainUI = nil;
    self:GetCommodityOperationManager().BuyProductResultDelegate:Remove(self.OnBuyProductResult, self);
    self.bBuyProductResultBinded = false
end

function FightManager:OpenMainUI()
    ugcprint('main ui is:'..tostring(self.MainUI));

    if self.MainUI == nil then
        return;
    end
    self.TabSelectIndex = 0;
    self.BackpackSelectIndex = -1;
    self.MainUI:SetVisibility(ESlateVisibility.Visible);
end

function FightManager:CloseMainUI()
    if self.MainUI == nil then
        return;
    end
    self.MainUI:SetVisibility(ESlateVisibility.Collapsed);
    self.LBPurchaseListSelectedIndex = nil;
    self.LTabListSelectedIndex = 0;
end

function FightManager:GetMainUI()
    return self.MainUI;
end
