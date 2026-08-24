PureManager = PureManager or {
    MainUI = nil,
    ComponentClass = nil,
    DefineId = nil,
    MaterialDefineId = nil,
    FilterType = nil,
    RefreshUI = false,
    PendingResultItemId = nil,
    EquipmentType = {
        [1] = {Type = 'ALL', Text = '所有装备'},
        [2] = {Type = 'Head', Text = '帽子'},
        [3] = {Type = 'Face', Text = '脸饰'},
        [4] = {Type = 'Body', Text = '衣服'},
        [5] = {Type = 'Legs', Text = '裤子'},
        [6] = {Type = 'Feet', Text = '鞋子'},
    }
}

function PureManager:RegisterComponentClass(CompClass)
    if CompClass ~= nil then
        self.ComponentClass = CompClass;
    end
end

function PureManager:RegisterMainUI(MainUI)
    if MainUI ~= nil then
        self.MainUI = MainUI;
    end
end

function PureManager:UnregisterMainUI(MainUI)
    if MainUI == nil or self.MainUI == MainUI then
        self.MainUI = nil;
    end
end

function PureManager:OpenMainUI(DefineID)
    if self.MainUI == nil then
        return;
    end
    self.MaterialDefineId = nil;
    self.RefreshUI = false;
    self.PendingResultItemId = nil;
    self.MainUI:Open(DefineID);
end

function PureManager:CloseMainUI()
    if self.MainUI ~= nil then
        self.MainUI:Exit();
    end
end

function PureManager:GetMainUI()
    return self.MainUI;
end

function PureManager:Reload(DefineID, FilterType)
    if self.MainUI ~= nil then
        self.MainUI:Reload(DefineID, FilterType);
    end
end

---@param DefineID ItemDefineID
---@param UseAdvanced boolean
---@return boolean
function PureManager:Request(DefineID, UseAdvanced)
    if DefineID == nil or self.ComponentClass == nil then
        return false;
    end
    local data = self:GetReforgeData(DefineID);
    if data == nil then
        return false;
    end
    self.PendingResultItemId = data.Result;
    UnrealNetwork.CallUnrealRPC(
            LocalPlayerController,
            self.ComponentClass,
            'ReforgeSubmit',
            LocalPlayerController.PlayerKey,
            DefineID,
            UseAdvanced == true
    );
    return true;
end

---@param DefineID ItemDefineID
---@return table|nil
function PureManager:GetReforgeData(DefineID)
    if DefineID == nil or DefineID.TypeSpecificID == nil then
        return nil;
    end
    local cfg = ItemCfg.Reforge;
    return cfg and cfg.ReforgeMap and cfg.ReforgeMap[DefineID.TypeSpecificID] or nil;
end

---@param DefineID ItemDefineID
---@param UseAdvanced boolean
---@return number
function PureManager:GetSuccessRate(DefineID, UseAdvanced)
    local data = self:GetReforgeData(DefineID);
    if data == nil then
        return 0;
    end
    local rate = tonumber(data.Prob) or 0;
    if UseAdvanced then
        rate = rate + (tonumber(ItemCfg.Reforge.AdvancedProbBoost) or 0);
    end
    return math.max(0, math.min(rate, 1));
end

---@param ItemDefineId ItemDefineID
function PureManager:OnItemCustomDataUpdateAfter(ItemDefineId)
    if self.PendingResultItemId == nil or ItemDefineId == nil
            or ItemDefineId.TypeSpecificID ~= self.PendingResultItemId then
        return;
    end
    self.DefineId = ItemDefineId;
    self.PendingResultItemId = nil;
    self.RefreshUI = true;
end

return PureManager
