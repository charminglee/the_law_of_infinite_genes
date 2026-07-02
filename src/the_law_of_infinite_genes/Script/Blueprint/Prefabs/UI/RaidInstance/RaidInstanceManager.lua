RaidInstanceManager = RaidInstanceManager or
{
    MainUI = nil;
    ComponentClass = nil;
}


function RaidInstanceManager:RegisterComponentClass(CompClass)

    if CompClass ~= nil then
        self.ComponentClass = CompClass;
    end
end

function RaidInstanceManager:RegisterMainUI(MainUI)
    
    if self.MainUI == nil then
        self.MainUI = MainUI;
    end
end

function RaidInstanceManager:RegisterItemInfoDialogUI(UI)
    if self.ItemInfoDialogUI == nil then
        self.ItemInfoDialogUI = UI;    
    end
end

function RaidInstanceManager:UnregisterMainUI()
    self.MainUI = nil;
    self:GetCommodityOperationManager().BuyProductResultDelegate:Remove(self.OnBuyProductResult, self);
    self.bBuyProductResultBinded = false
end

function RaidInstanceManager:OpenMainUI()
    ugcprint('main ui is:'..tostring(self.MainUI));

    if self.MainUI == nil then
        return;
    end
    self.MainUI:SetVisibility(ESlateVisibility.Visible);
end

function RaidInstanceManager:CloseMainUI()
    if self.MainUI == nil then
        return;
    end
    self.MainUI:SetVisibility(ESlateVisibility.Collapsed);
end