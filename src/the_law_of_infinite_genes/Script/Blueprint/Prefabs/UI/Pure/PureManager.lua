PureManager = PureManager or {
    MainUI = nil,
    DefineId = nil,
    MaterialDefineId = nil,
    FilterType = nil,
    RequestHandler = nil,
    EquipmentType = {
        [1] = {Type = 'ALL', Text = '所有装备'},
        [2] = {Type = 'Head', Text = '帽子'},
        [3] = {Type = 'Face', Text = '脸饰'},
        [4] = {Type = 'Body', Text = '衣服'},
        [5] = {Type = 'Legs', Text = '裤子'},
        [6] = {Type = 'Feet', Text = '鞋子'},
    }
}

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

---注册精炼请求回调。这里只保留 UI 接口，不直接调用 RPC 或数据层。
---@param Handler function|nil
function PureManager:SetRequestHandler(Handler)
    self.RequestHandler = Handler;
end

---@param DefineID ItemDefineID
---@param MaterialDefineID ItemDefineID
---@return boolean
function PureManager:Request(DefineID, MaterialDefineID)
    if type(self.RequestHandler) ~= 'function' then
        return false;
    end
    self.RequestHandler(DefineID, MaterialDefineID);
    return true;
end

function PureManager:GetMaxQuality()
    local maxQuality = 0;
    for quality, _ in pairs(ItemCfg.ItemQuality or {}) do
        if type(quality) == 'number' and quality > maxQuality then
            maxQuality = quality;
        end
    end
    return maxQuality;
end

---@param DefineID ItemDefineID
---@return number|nil
function PureManager:GetMaterialItemId(DefineID)
    if DefineID == nil or DefineID.TypeSpecificID == nil then
        return nil;
    end
    local quality = UGCItemSystemV2.GetItemQualityV2ByDefineID(DefineID)
            or UGCItemSystemV2.GetItemQualityV2(DefineID.TypeSpecificID) or 0;
    local materialKey = string.format('EquipmentMaterial_%s', tostring(quality));
    if ItemId == nil then
        return 8310004;
    end
    return ItemId[materialKey] or ItemId.EquipmentMaterial_0 or 8310004;
end

---@param Quality number
---@return number
function PureManager:GetSuccessRate(Quality)
    local cfg = ItemCfg.Reforge or {};
    local rates = cfg.SuccessRate or cfg.Rate;
    local rate = nil;
    if type(rates) == 'table' then
        rate = rates[Quality] or rates[Quality + 1];
    elseif type(rates) == 'number' then
        rate = rates;
    end
    rate = tonumber(rate) or 0.8;
    return math.max(0, math.min(rate, 1));
end

return PureManager
