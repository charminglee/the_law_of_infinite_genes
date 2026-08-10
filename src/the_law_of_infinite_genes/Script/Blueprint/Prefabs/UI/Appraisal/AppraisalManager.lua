
AppraisalManager = AppraisalManager or
{
    MainUI = nil;
    ComponentClass = nil;
    DefineId = nil;
    FilterType = nil;
    KenlType = {
        [1] = {Type='ALL', Text='所有核心'}
    }

}

function AppraisalManager:RegisterComponentClass(CompClass)

    if CompClass ~= nil then
        self.ComponentClass = CompClass;
    end
end

function AppraisalManager:RegisterMainUI(MainUI)
    ugcprint('注册强化界面')
    if self.MainUI == nil then
        self.MainUI = MainUI;
    end
end

function AppraisalManager:UnregisterMainUI()
    self.MainUI = nil;
end

function AppraisalManager:OpenMainUI(DefineID)
    if self.MainUI == nil then
        return;
    end
    self.GoodSelectedIndex = nil;
    self.MainUI:Open(DefineID);
end

function AppraisalManager:CloseMainUI()
    if self.MainUI == nil then
        return;
    end
    self.TabSelectedIndex = 1;
    self.GoodSelectedIndex = nil;
    self.MainUI:Exit();
end

function AppraisalManager:GetMainUI()
    return self.MainUI;
end

function AppraisalManager:Reload(DefineID, FilterType)
    self.MainUI:Reload(DefineID, FilterType);
end
