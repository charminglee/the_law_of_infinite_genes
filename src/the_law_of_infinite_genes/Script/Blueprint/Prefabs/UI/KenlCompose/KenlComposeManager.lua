
KenlComposeManager = KenlComposeManager or
{
    MainUI = nil;
    ComponentClass = nil;
    DefineId = nil;
    FilterType = nil;
    EquipmentType = {
        [1] = {Type='ALL', Text='所有核心'}
    }

}

function KenlComposeManager:RegisterComponentClass(CompClass)

    if CompClass ~= nil then
        self.ComponentClass = CompClass;
    end
end

function KenlComposeManager:RegisterMainUI(MainUI)
    ugcprint('注册强化界面')
    if self.MainUI == nil then
        self.MainUI = MainUI;
    end
end

function KenlComposeManager:UnregisterMainUI()
    self.MainUI = nil;
end

function KenlComposeManager:OpenMainUI(DefineID)
    if self.MainUI == nil then
        return;
    end
    self.GoodSelectedIndex = nil;
    self.MainUI:Open(DefineID);
end

function KenlComposeManager:CloseMainUI()
    if self.MainUI == nil then
        return;
    end
    self.TabSelectedIndex = 1;
    self.GoodSelectedIndex = nil;
    self.MainUI:Exit();
end

function KenlComposeManager:GetMainUI()
    return self.MainUI;
end

function KenlComposeManager:Reload(DefineID, FilterType)
    self.MainUI:Reload(DefineID, FilterType);
end