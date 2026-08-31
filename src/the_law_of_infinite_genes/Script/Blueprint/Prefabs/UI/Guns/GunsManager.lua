
GunsManager = GunsManager or {
    MainUI = nil,
    ComponentClass = nil,
    DefineId = nil,
    FilterType = nil,
    GunsType = {
            {Type = 'ALL', Text = '所有装备'},
            {Type = 'Ammo', Text = '子弹'},
            {Type = 'Rifle', Text = '步枪'},
            {Type = 'SMG', Text = '冲锋枪'},
            {Type = 'LMG', Text = '轻机枪'},
            {Type = 'Shotgun', Text = '霰弹枪'},
            {Type = 'Snipe', Text = '狙击枪'},
            {Type = 'Pistol', Text = '手枪'},
    },
}

function GunsManager:RegisterComponentClass(CompClass)
    self.ComponentClass = CompClass;
end

function GunsManager:RegisterMainUI(MainUI)
    self.MainUI = MainUI;
end

function GunsManager:UnregisterMainUI(MainUI)
    if self.MainUI == MainUI then
        self.MainUI = nil;
    end
end

function GunsManager:OpenMainUI()
    self.MainUI:Open();
end

function GunsManager:CloseMainUI()
    self.MainUI:Exit();
end

function GunsManager:GetMainUI()
    return self.MainUI;
end

function GunsManager:Reload(ItemData, FilterType)
    self.MainUI:Reload(ItemData, FilterType);
end

---@param ItemId integer
function GunsManager:RequestUnlock(ItemId)
    UnrealNetwork.CallUnrealRPC(
            LocalPlayerController,
            self.ComponentClass,
            'GunsActivateSubmit',
            LocalPlayerController.PlayerKey,
            ItemId
    );
end

function GunsManager:OnGunUnlockAfter(ItemId)
    if self.MainUI ~= nil then
        self.MainUI:OnGunUnlockAfter(ItemId);
    end
end

return GunsManager
