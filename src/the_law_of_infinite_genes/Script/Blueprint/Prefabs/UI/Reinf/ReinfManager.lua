
ReinfManager = ReinfManager or
{
    MainUI = nil;
    ComponentClass = nil;
    DefineId = nil;
    FilterType = nil;
    EquipmentType = {
        [1] = {Type='ALL', Text='所有核心'}
    }

}

function ReinfManager:RegisterComponentClass(CompClass)

    if CompClass ~= nil then
        self.ComponentClass = CompClass;
    end
end

function ReinfManager:RegisterMainUI(MainUI)
    ugcprint('注册强化界面')
    if self.MainUI == nil then
        self.MainUI = MainUI;
    end
end

function ReinfManager:UnregisterMainUI()
    self.MainUI = nil;
end

function ReinfManager:OpenMainUI(DefineID)
    if self.MainUI == nil then
        return;
    end
    self.GoodSelectedIndex = nil;
    self.MainUI:Open(DefineID);
end

function ReinfManager:CloseMainUI()
    if self.MainUI == nil then
        return;
    end
    self.TabSelectedIndex = 1;
    self.GoodSelectedIndex = nil;
    self.MainUI:Exit();
end

function ReinfManager:GetMainUI()
    return self.MainUI;
end

function ReinfManager:Reload(DefineID, FilterType)
    self.MainUI:Reload(DefineID, FilterType);
end