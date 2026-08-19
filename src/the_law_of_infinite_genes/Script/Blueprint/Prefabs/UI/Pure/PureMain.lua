---@class PureMain_C:UAEUserWidget
---@field After UUTRichTextBlock
---@field AfterLevel UUTRichTextBlock
---@field BackpackList UGC_ReuseList2_C
---@field Button_0 UButton
---@field Button_1 UButton
---@field CurrentLevel UUTRichTextBlock
---@field FortifyBtn UButton
---@field Front UUTRichTextBlock
---@field PreviewItem PurePreviewItem_C
---@field PreviewItem_0 PurePreviewItem_C
---@field SuccessRate UTextBlock
---@field TabList UGC_ReuseList2_C
--Edit Below--
local PureMain = {
    bInitDoOnce = false,
    Filter = {},
    MaterialDefineID = nil,
}

local function IsSameDefineId(Left, Right)
    if Left == nil or Right == nil then
        return false;
    end
    if Left.InstanceID ~= nil and Right.InstanceID ~= nil then
        return Left.InstanceID == Right.InstanceID;
    end
    return Left.TypeSpecificID ~= nil and Left.TypeSpecificID == Right.TypeSpecificID;
end

local function IsEquipment(DefineID)
    if DefineID == nil or DefineID.TypeSpecificID == nil then
        return false;
    end
    local itemType = UGCItemSystemV2.GetItemCustomizedTypeV2(DefineID.TypeSpecificID);
    return ItemCfg.CustomizeType[itemType] == true;
end

local function GetQuality(DefineID)
    if DefineID == nil or DefineID.TypeSpecificID == nil then
        return 0;
    end
    return UGCItemSystemV2.GetItemQualityV2ByDefineID(DefineID)
            or UGCItemSystemV2.GetItemQualityV2(DefineID.TypeSpecificID) or 0;
end

local function NormalizeColor(Color)
    local value = tostring(Color or 'FFFFFFFF'):gsub('#', '');
    if #value == 6 then
        value = value .. 'FF';
    end
    return value;
end

function PureMain:Construct()
    self:LuaInit();
end

function PureMain:Destruct()
    PureManager:UnregisterMainUI(self);
end

function PureMain:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self.Button_0.OnClicked:Add(self.Exit, self);
    self.Button_1.OnClicked:Add(self.Request, self);
    self.FortifyBtn.OnClicked:Add(self.FortifyBtnClicked, self);
    self.BackpackList.OnUpdateItem:Add(self.BackpackListUpdate, self);
    self.TabList.OnUpdateItem:Add(self.TabListUpdate, self);
    PureManager:RegisterMainUI(self);
end

function PureMain:Open(DefineID)
    self:SetVisibility(ESlateVisibility.Visible);
    self:Reload(DefineID, PureManager.EquipmentType[1].Type);
end

function PureMain:Exit()
    self:SetVisibility(ESlateVisibility.Collapsed);
end

function PureMain:FortifyBtnClicked()
    local defineID = PureManager.DefineId;
    self:Exit();
    if FortifyManager ~= nil then
        FortifyManager:OpenMainUI(defineID);
    end
end

---@param DefineID ItemDefineID
---@param FilterType string
function PureMain:Reload(DefineID, FilterType)
    FilterType = FilterType or PureManager.EquipmentType[1].Type;
    local allItems = UGCBackpackSystemV2.GetAllItemDefineIDsV2(LocalPlayerController) or {};
    self.Filter = self:FilterEquipment(allItems, FilterType);

    local selected = DefineID ~= nil and totable(DefineID) or nil;
    if not self:ContainsDefineId(self.Filter, selected) then
        selected = self.Filter[1];
    end

    PureManager.DefineId = selected ~= nil and totable(selected) or nil;
    PureManager.FilterType = FilterType;
    self.BackpackList:Reload(#self.Filter);
    self.TabList:Reload(#PureManager.EquipmentType);
    self:SetPreview(selected, allItems);
end

function PureMain:ContainsDefineId(ItemList, DefineID)
    for _, item in ipairs(ItemList or {}) do
        if IsSameDefineId(item, DefineID) then
            return true;
        end
    end
    return false;
end

function PureMain:FilterEquipment(ItemList, FilterType)
    local result = {};
    local showAll = FilterType == PureManager.EquipmentType[1].Type;
    for _, item in ipairs(ItemList or {}) do
        if IsEquipment(item) then
            local itemType = UGCItemSystemV2.GetItemCustomizedTypeV2(item.TypeSpecificID);
            if showAll or itemType == FilterType then
                table.insert(result, item);
            end
        end
    end
    return result;
end

function PureMain:FindMaterial(ItemList, MaterialItemId)
    for _, item in ipairs(ItemList or {}) do
        if item.TypeSpecificID == MaterialItemId then
            return item;
        end
    end
    return nil;
end

---@param DefineID ItemDefineID
function PureMain:SetPreview(DefineID, AllItems)
    if not IsEquipment(DefineID) then
        self.MaterialDefineID = nil;
        PureManager.MaterialDefineId = nil;
        self.PreviewItem:SetEmpty();
        self.PreviewItem_0:SetEmpty();
        self.CurrentLevel:SetText('');
        self.AfterLevel:SetText('');
        self.Front:SetText('请选择需要精炼的装备');
        self.After:SetText('');
        self.SuccessRate:SetText('0%');
        self.Button_1:SetIsEnabled(false);
        return;
    end

    local data = {};
    if LocalPlayerState ~= nil and LocalPlayerState.ItemDataManager ~= nil then
        data = LocalPlayerState.ItemDataManager:GetCustomData(DefineID) or {};
    end
    local strengthenLevel = tonumber(data.strengthenLevel) or 0;
    local currentQuality = GetQuality(DefineID);
    local maxQuality = PureManager:GetMaxQuality();
    local afterQuality = math.min(currentQuality + 1, maxQuality);
    local materialItemId = PureManager:GetMaterialItemId(DefineID);
    local materialDefineID = self:FindMaterial(AllItems, materialItemId);

    self.MaterialDefineID = materialDefineID;
    PureManager.MaterialDefineId = materialDefineID;
    self.PreviewItem:SetDefineID(DefineID, strengthenLevel, currentQuality);
    self.PreviewItem_0:SetDefineID(materialDefineID or {TypeSpecificID = materialItemId});
    self.PreviewItem_0:SetCount(materialDefineID ~= nil and '1/1' or '0/1');

    self.CurrentLevel:SetText(self:GetQualityText(currentQuality));
    if currentQuality >= maxQuality then
        self.AfterLevel:SetText(RichText.Font('已满品质', {size = 18, color = 'FFFF00FF'}));
    else
        self.AfterLevel:SetText(self:GetQualityText(afterQuality));
    end
    self.Front:SetText(self:GetEquipmentAttributeText(DefineID, currentQuality, strengthenLevel));
    self.After:SetText(self:GetEquipmentAttributeText(DefineID, afterQuality, strengthenLevel));

    local successRate = currentQuality < maxQuality and PureManager:GetSuccessRate(currentQuality) or 0;
    self.SuccessRate:SetText(string.format('%d%%', math.floor(successRate * 100 + 0.5)));
    self.Button_1:SetIsEnabled(currentQuality < maxQuality and materialDefineID ~= nil);
end

function PureMain:GetQualityText(Quality)
    local cfg = ItemCfg.ItemQuality[Quality] or ItemCfg.ItemQuality[0] or {};
    return RichText.Font(cfg.name or tostring(Quality), {
        size = 18,
        color = NormalizeColor(cfg.color),
    });
end

function PureMain:GetEquipmentAttributeText(DefineID, Quality, StrengthenLevel)
    local result = {
        self:GetQualityText(Quality),
        RichText.Font(string.format('强化 +%s', tostring(StrengthenLevel or 0)), {
            size = 18,
            color = 'FFFFFFFF',
        }),
    };
    local itemName = UGCItemSystemV2.GetItemNameV2(DefineID.TypeSpecificID);
    local attrCfg = ItemCfg.EquipmentAttribute[itemName];
    if attrCfg == nil or attrCfg.Base == nil then
        table.insert(result, RichText.Font('暂无属性配置', {size = 18, color = 'FFFFFFFF'}));
        return table.concat(result, '\n');
    end

    local factor = attrCfg.Factor and attrCfg.Factor[Quality] or 1;
    for _, attr in ipairs(attrCfg.Base) do
        local meta = AttributeMate[attr.property];
        local attrName = meta and meta.anno or tostring(attr.property);
        local value = math.floor((tonumber(attr.value) or 0) * factor);
        table.insert(result, RichText.Inline(
                RichText.Font(string.format('-- %s\t\t', attrName), {size = 18, color = 'FFFFFFFF'}),
                RichText.Font(tostring(value), {size = 18, color = 'B8FFA1FF'})
        ));
    end
    return table.concat(result, '\n');
end

---仅转交给 PureManager 注册的 UI 请求回调，不直接调用 RPC 或数据层。
function PureMain:Request()
    if PureManager.DefineId == nil or self.MaterialDefineID == nil then
        return;
    end
    PureManager:Request(PureManager.DefineId, self.MaterialDefineID);
end

function PureMain:BackpackListUpdate(Item, Index)
    local defineID = self.Filter[Index + 1];
    if defineID == nil then
        Item:SetEmpty();
        return;
    end
    Item:SetDefineID(defineID);
    Item:SetSelected(PureManager.DefineId);
end

function PureMain:TabListUpdate(Item, Index)
    local tab = PureManager.EquipmentType[Index + 1];
    if tab == nil then
        return;
    end
    Item:SetDAT(Index, tab.Text);
    Item:SetSelected(PureManager.FilterType == tab.Type);
end

return PureMain
