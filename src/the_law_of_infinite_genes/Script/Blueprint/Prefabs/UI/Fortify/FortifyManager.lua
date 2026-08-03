
FortifyManager = FortifyManager or
{
    MainUI = nil;
    ComponentClass = nil;
    DefineId = nil;
    FilterType = nil;
    EquipmentType = {
        [1] = {Type='ALL', Text='所有装备'},
        [2] = {Type='Head', Text = '帽子'},
        [3]= {Type='Face', Text = '脸饰'},
        [4]= {Type='Body', Text = '衣服'},
        [5]= {Type='Legs', Text = '裤子'},
        [6]= {Type='Feet', Text = '鞋子'},
    }
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
    self.MainUI:Open(DefineID);
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

function FortifyManager:Reload(DefineID, FilterType)
    self.MainUI:Reload(DefineID, FilterType);
end