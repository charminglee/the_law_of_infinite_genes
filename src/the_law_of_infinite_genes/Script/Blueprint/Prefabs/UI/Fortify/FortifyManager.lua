
FortifyManager = FortifyManager or
{
    MainUI = nil;
    ComponentClass = nil;
}

function FortifyManager:RegisterComponentClass(CompClass)

    if CompClass ~= nil then
        self.ComponentClass = CompClass;
    end
end

function FortifyManager:RegisterMainUI(MainUI)
    ugcprint('注册强化界面')
    if self.MainUI == nil then
        self.MainUI = MainUI;
    end
end

function FortifyManager:UnregisterMainUI()
    self.MainUI = nil;
end

function FortifyManager:OpenMainUI(DefineID)
    if self.MainUI == nil then
        return;
    end
    self.GoodSelectedIndex = nil;
    self.MainUI:Open(DefineID)
end

function FortifyManager:CloseMainUI()
    if self.MainUI == nil then
        return;
    end
    self.TabSelectedIndex = 1;
    self.GoodSelectedIndex = nil;
    self.MainUI:Exit();
end

function FortifyManager:GetMainUI()
    return self.MainUI;
end

function FortifyManager:Reload(DefineID)
    self.MainUI:Reload(DefineID);
end