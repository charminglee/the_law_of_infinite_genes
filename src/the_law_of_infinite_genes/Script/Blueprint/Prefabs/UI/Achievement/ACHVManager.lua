
ACHVManager = ACHVManager or
{
    MainUI = nil;
    PlayerId = nil;
}

function ACHVManager:RegisterComponentClass(CompClass)

    if CompClass ~= nil then
        self.ComponentClass = CompClass;
    end
end

function ACHVManager:RegisterMainUI(MainUI)
    
    if self.MainUI == nil then
        self.MainUI = MainUI;
    end
end

function ACHVManager:UnregisterMainUI()
    self.MainUI = nil;
end

function ACHVManager:OpenMainUI()
    if self.MainUI == nil then
        return;
    end
    self.MainUI:SetVisibility(ESlateVisibility.Visible);
end

function ACHVManager:CloseMainUI()
    if self.MainUI == nil then
        return;
    end
    self.MainUI:SetVisibility(ESlateVisibility.Collapsed);
end