KenlComposeManager = KenlComposeManager or {
    MainUI = nil,
    ComponentClass = nil,
    DefineId = nil,
    MaterialDefineId = nil,
    FilterType = nil,
    PendingFusion = false,
    EquipmentType = {
        [1] = { Type = 'ALL', Text = '所有核心' }
    }
}

function KenlComposeManager:RegisterComponentClass(CompClass)
    if CompClass ~= nil then
        self.ComponentClass = CompClass;
    end
end

function KenlComposeManager:RegisterMainUI(MainUI)
    if MainUI ~= nil then
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
    DefineID = Lib.ToItemDefineId(DefineID, ItemCfg.ItemType.Kenl);
    if DefineID == nil then
        return;
    end

    self.DefineId = DefineID;
    self.MaterialDefineId = nil;
    self.PendingFusion = false;
    self.MainUI:Open(self.DefineId);
end

function KenlComposeManager:CloseMainUI()
    if self.MainUI ~= nil then
        self.MainUI:Exit();
    end
end

function KenlComposeManager:GetMainUI()
    return self.MainUI;
end

function KenlComposeManager:Reload(DefineID, FilterType)
    if self.MainUI ~= nil then
        self.MainUI:Reload(DefineID, FilterType);
    end
end

function KenlComposeManager:SelectPrimary(DefineID)
    if self.MainUI ~= nil then
        self.MainUI:SelectPrimary(DefineID);
    end
end

function KenlComposeManager:SelectMaterial(DefineID)
    if self.MainUI ~= nil then
        self.MainUI:SelectMaterial(DefineID);
    end
end

function KenlComposeManager:OnFusionResult(ItemDefineId, OldData, NewData)
    if not self.PendingFusion or self.MainUI == nil then
        return;
    end

    local currentId = self.DefineId and self.DefineId.InstanceID;
    local updatedId = ItemDefineId and ItemDefineId.InstanceID;
    if currentId ~= nil and updatedId ~= nil and currentId ~= updatedId then
        return;
    end

    self.PendingFusion = false;
    self.MainUI:OnFusionResult(OldData, NewData);
end
