GunsManager = GunsManager or {
    MainUI = nil,
    ComponentClass = nil,
    DefineId = nil,
    MaterialDefineId = nil,
    FilterType = nil,
    RefreshUI = false,
    GunsType = {
        [1] = { Type = 'ALL', Text = '所有装备' },
        [2] = { Type = 'Rifle', Text = '步枪' },
        [3] = { Type = 'SMG', Text = '冲锋枪' },
        [4] = { Type = 'LMG', Text = '轻机枪' },
        [5] = { Type = 'Shotgun', Text = '霰弹枪' },
        [6] = { Type = 'Snipe', Text = '狙击枪' },
        [7] = { Type = 'Pistol', Text = '手枪' }
    }
}

function GunsManager:RegisterComponentClass(CompClass)
    if CompClass ~= nil then
        self.ComponentClass = CompClass;
    end
end

function GunsManager:RegisterMainUI(MainUI)
    if MainUI ~= nil then
        self.MainUI = MainUI;
    end
end

function GunsManager:UnregisterMainUI(MainUI)
    if MainUI == nil or self.MainUI == MainUI then
        self.MainUI = nil;
    end
end

function GunsManager:OpenMainUI()
    if self.MainUI == nil then
        return;
    end
    self.MaterialDefineId = nil;
    self.RefreshUI = false;
    self.MainUI:Open();
end

function GunsManager:CloseMainUI()
    if self.MainUI ~= nil then
        self.MainUI:Exit();
    end
end

function GunsManager:GetMainUI()
    return self.MainUI;
end

function GunsManager:Reload(DefineID, FilterType)
    if self.MainUI ~= nil then
        self.MainUI:Reload(DefineID, FilterType);
    end
end



return GunsManager
