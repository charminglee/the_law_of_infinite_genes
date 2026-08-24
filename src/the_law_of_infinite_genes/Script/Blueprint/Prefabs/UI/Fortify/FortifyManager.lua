FortifyManager = FortifyManager or {
    MainUI = nil,
    ComponentClass = nil,
    DefineId = nil,
    MaterialDefineId = nil,
    FilterType = nil,
    RefreshUI = false,
    EquipmentType = {
        [1] = {Type = 'ALL', Text = '所有装备'},
        [2] = {Type = 'Head', Text = '帽子'},
        [3] = {Type = 'Face', Text = '脸饰'},
        [4] = {Type = 'Body', Text = '衣服'},
        [5] = {Type = 'Legs', Text = '裤子'},
        [6] = {Type = 'Feet', Text = '鞋子'},
    }
}

function FortifyManager:RegisterComponentClass(CompClass)
    if CompClass ~= nil then
        self.ComponentClass = CompClass;
    end
end

function FortifyManager:RegisterMainUI(MainUI)
    if MainUI ~= nil then
        self.MainUI = MainUI;
    end
end

function FortifyManager:UnregisterMainUI(MainUI)
    if MainUI == nil or self.MainUI == MainUI then
        self.MainUI = nil;
    end
end

function FortifyManager:OpenMainUI(DefineID)
    if self.MainUI == nil then
        return;
    end
    self.MaterialDefineId = nil;
    self.RefreshUI = false;
    self.MainUI:Open(DefineID);
end

function FortifyManager:CloseMainUI()
    if self.MainUI ~= nil then
        self.MainUI:Exit();
    end
end

function FortifyManager:GetMainUI()
    return self.MainUI;
end

function FortifyManager:Reload(DefineID, FilterType)
    if self.MainUI ~= nil then
        self.MainUI:Reload(DefineID, FilterType);
    end
end

function FortifyManager:GetMaxLevel()
    local configuredMaxLevel = ItemCfg.Strengthen
            and tonumber(ItemCfg.Strengthen.MaxLevel) or nil;
    if configuredMaxLevel ~= nil and configuredMaxLevel > 0 then
        return configuredMaxLevel;
    end

    local maxLevel = 0;
    for level, _ in pairs(ItemCfg.colorTable or {}) do
        if type(level) == 'number' and level > maxLevel then
            maxLevel = level;
        end
    end
    return maxLevel;
end

---@param DefineID ItemDefineID
---@return number
function FortifyManager:GetMaterialItemId(DefineID)
    if DefineID == nil or DefineID.TypeSpecificID == nil then
        return nil;
    end
    return ItemCfg.Strengthen and ItemCfg.Strengthen.Material or nil;
end

return FortifyManager
