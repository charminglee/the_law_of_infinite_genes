
HomeManager = HomeManager or
{
    HomeMain = nil;
}

function HomeManager:RegisterComponentClass(CompClass)

    if CompClass ~= nil then
        self.ComponentClass = CompClass;
    end
end

function HomeManager:RegisterMainUI(MainUI)
    
    if self.MainUI == nil then
        self.MainUI = MainUI;
    end
end

function HomeManager:UnregisterMainUI()
    self.MainUI = nil;
    self:GetCommodityOperationManager().BuyProductResultDelegate:Remove(self.OnBuyProductResult, self);
    self.bBuyProductResultBinded = false
end

function HomeManager:OpenMainUI()
    if self.MainUI == nil then
        return;
    end
    ugcprint('open main ui')
    self.MainUI:SetVisibility(ESlateVisibility.Visible);
end

function HomeManager:CloseMainUI()
    if self.MainUI == nil then
        return;
    end
    self.MainUI:SetVisibility(ESlateVisibility.Collapsed);
end