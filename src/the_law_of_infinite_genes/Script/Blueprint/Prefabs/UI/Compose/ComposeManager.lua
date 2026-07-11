
ComposeManager = ComposeManager or
{
    MainUI = nil;
    SelectedItemId = nil;
}

function ComposeManager:RegisterComponentClass(CompClass)

    if CompClass ~= nil then
        self.ComponentClass = CompClass;
    end
end

function ComposeManager:RegisterMainUI(MainUI)
    
    if self.MainUI == nil then
        self.MainUI = MainUI;
    end
end

function ComposeManager:UnregisterMainUI()
    self.MainUI = nil;
end

function ComposeManager:OpenMainUI()
    if self.MainUI == nil then
        return;
    end
    self.MainUI:SetVisibility(ESlateVisibility.Visible);
end

function ComposeManager:CloseMainUI()
    if self.MainUI == nil then
        return;
    end
    self.MainUI:SetVisibility(ESlateVisibility.Collapsed);
end

function ComposeManager:GetMainUI()
    return self.MainUI;
end
