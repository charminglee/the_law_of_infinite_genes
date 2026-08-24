---@class PureMain_C:UAEUserWidget
---@field After UUTRichTextBlock
---@field AfterLevel UUTRichTextBlock
---@field BackpackList UGC_ReuseList2_C
---@field Button_0 UButton
---@field Button_1 UButton
---@field Button_277 UButton
---@field CurrentLevel UUTRichTextBlock
---@field FortifyBtn UButton
---@field Front UUTRichTextBlock
---@field JINSHINUMBER UTextBlock
---@field NewCheckBox_0 UNewCheckBox
---@field PreviewItem PurePreviewItem_C
---@field PreviewItem_0 PurePreviewItem_C
---@field PurePreviewItem_C_0 PurePreviewItem_C
---@field SuccessRate UTextBlock
---@field TabList UGC_ReuseList2_C
--Edit Below--
local PureMain = {
    bInitDoOnce = false,
    Filter = {},
    MaterialDefineID = nil,
    MaterialRequirements = {},
    PendingSourceDefineId = nil,
    RequestRefreshCountdown = nil,
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

local function GetAdvancedItemId()
    return ItemId and ItemId.Advanced_1 or 8310188;
end

function PureMain:Construct()
    self:LuaInit();
end

function PureMain:Destruct()
    PureManager:UnregisterMainUI(self);
end

function PureMain:Tick(MyGeometry, InDeltaTime)
    if PureManager.RefreshUI then
        PureManager.RefreshUI = false;
        self.RequestRefreshCountdown = nil;
        self.PendingSourceDefineId = nil;
        self:Reload(PureManager.DefineId, PureManager.FilterType);
        return;
    end

    if self.RequestRefreshCountdown == nil then
        return;
    end
    self.RequestRefreshCountdown = self.RequestRefreshCountdown - (tonumber(InDeltaTime) or 0);
    if self.RequestRefreshCountdown > 0 then
        return;
    end

    self.RequestRefreshCountdown = nil;
    local preferred = self:FindItemByTypeSpecificID(PureManager.PendingResultItemId)
            or self.PendingSourceDefineId;
    self.PendingSourceDefineId = nil;
    PureManager.PendingResultItemId = nil;
    self:Reload(preferred, PureManager.FilterType);
end

function PureMain:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self.Button_0.OnClicked:Add(self.Exit, self);
    self.Button_1.OnClicked:Add(self.Request, self);
    self.FortifyBtn.OnClicked:Add(self.FortifyBtnClicked, self);
    self.NewCheckBox_0.OnCheckStateChanged:Add(self.OnAdvancedChanged, self);
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

function PureMain:OnAdvancedChanged(IsChecked)
    if IsChecked == true and self:GetItemCount(GetAdvancedItemId()) <= 0 then
        self.NewCheckBox_0:SetIsChecked(false);
        UGCWidgetManagerSystem.ShowTipsUI('宇宙晶石不足');
        return;
    end
    self:SetPreview(PureManager.DefineId);
end

---@param DefineID ItemDefineID
---@param FilterType string
function PureMain:Reload(DefineID, FilterType)
    FilterType = FilterType or PureManager.EquipmentType[1].Type;
    local allItems = UGCBackpackSystemV2.GetAllItemDefineIDsV2(LocalPlayerController) or {};
    self.Filter = self:FilterEquipment(allItems, FilterType);

    local selected = self:FindDefineId(self.Filter, DefineID) or self.Filter[1];
    PureManager.DefineId = selected ~= nil and totable(selected) or nil;
    PureManager.FilterType = FilterType;
    self.BackpackList:Reload(#self.Filter);
    self.TabList:Reload(#PureManager.EquipmentType);
    self:SetPreview(selected);
end

function PureMain:FindDefineId(ItemList, DefineID)
    for _, item in ipairs(ItemList or {}) do
        if IsSameDefineId(item, DefineID) then
            return item;
        end
    end
    return nil;
end

function PureMain:FindItemByTypeSpecificID(ItemId)
    if ItemId == nil then
        return nil;
    end
    local allItems = UGCBackpackSystemV2.GetAllItemDefineIDsV2(LocalPlayerController) or {};
    for _, item in ipairs(allItems) do
        if item.TypeSpecificID == ItemId then
            return item;
        end
    end
    return nil;
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

function PureMain:GetItemCount(ItemId)
    if ItemId == nil then
        return 0;
    end
    return tonumber(UGCBackpackSystemV2.GetItemCountV2(LocalPlayerController, ItemId)) or 0;
end

function PureMain:SetMaterialPreview(Widget, Requirement)
    if Widget == nil then
        return;
    end
    if Requirement == nil or Requirement.ItemId == nil then
        Widget:SetEmpty();
        return;
    end
    local owned = self:GetItemCount(Requirement.ItemId);
    local required = tonumber(Requirement.Value) or 0;
    Widget:SetDefineID({TypeSpecificID = Requirement.ItemId});
    Widget:SetCount(string.format('%s/%s', tostring(owned), tostring(required)));
end

---@param DefineID ItemDefineID
function PureMain:SetPreview(DefineID)
    self.MaterialRequirements = {};
    local advancedCount = self:GetItemCount(GetAdvancedItemId());
    self.JINSHINUMBER:SetText(tostring(advancedCount));
    if not IsEquipment(DefineID) then
        self.MaterialDefineID = nil;
        PureManager.MaterialDefineId = nil;
        self.PreviewItem:SetEmpty();
        self.PreviewItem_0:SetEmpty();
        self.PurePreviewItem_C_0:SetEmpty();
        self.CurrentLevel:SetText('');
        self.AfterLevel:SetText('');
        self.Front:SetText('请选择需要精炼的装备');
        self.After:SetText('');
        self.SuccessRate:SetText('0%');
        self.Button_1:SetIsEnabled(false);
        return;
    end

    local manager = LocalPlayerState and LocalPlayerState.ItemDataManager or nil;
    local strengthenLevel = manager and manager:GetStrengthenLevel(DefineID) or 0;
    local currentQuality = GetQuality(DefineID);
    local reforgeData = PureManager:GetReforgeData(DefineID);

    self.PreviewItem:SetDefineID(DefineID, strengthenLevel, currentQuality);
    self.CurrentLevel:SetText(self:GetQualityText(currentQuality));
    self.Front:SetText(self:GetEquipmentAttributeText(DefineID, strengthenLevel));

    if reforgeData == nil or reforgeData.Result == nil then
        self.MaterialDefineID = nil;
        PureManager.MaterialDefineId = nil;
        self.PreviewItem_0:SetEmpty();
        self.PurePreviewItem_C_0:SetEmpty();
        self.AfterLevel:SetText(RichText.Font('已完成全部精炼', {size = 18, color = 'FFFF00FF'}));
        self.After:SetText(RichText.Font('当前装备没有下一阶段', {size = 18, color = 'FFFFFFFF'}));
        self.SuccessRate:SetText('0%');
        self.Button_1:SetIsEnabled(false);
        return;
    end

    local resultDefineId = {TypeSpecificID = reforgeData.Result};
    local resultQuality = GetQuality(resultDefineId);
    self.AfterLevel:SetText(self:GetQualityText(resultQuality));
    self.After:SetText(self:GetEquipmentAttributeText(resultDefineId, strengthenLevel));

    self.MaterialRequirements = reforgeData.Requirement or {};
    self:SetMaterialPreview(self.PreviewItem_0, self.MaterialRequirements[1]);
    self:SetMaterialPreview(self.PurePreviewItem_C_0, self.MaterialRequirements[2]);

    local useAdvanced = self.NewCheckBox_0:IsChecked() == true;
    local successRate = PureManager:GetSuccessRate(DefineID, useAdvanced);
    self.SuccessRate:SetText(string.format('%d%%', math.floor(successRate * 100 + 0.5)));

    local canSubmit = PureManager.ComponentClass ~= nil;
    for _, requirement in ipairs(self.MaterialRequirements) do
        if self:GetItemCount(requirement.ItemId) < (tonumber(requirement.Value) or 0) then
            canSubmit = false;
            break;
        end
    end
    if useAdvanced and advancedCount <= 0 then
        canSubmit = false;
    end
    self.Button_1:SetIsEnabled(canSubmit);
end

function PureMain:GetQualityText(Quality)
    local cfg = ItemCfg.ItemQuality[Quality] or ItemCfg.ItemQuality[0] or {};
    return RichText.Font(cfg.name or tostring(Quality), {
        size = 18,
        color = NormalizeColor(cfg.color),
    });
end

function PureMain:GetEquipmentAttributeText(DefineID, StrengthenLevel)
    local manager = LocalPlayerState and LocalPlayerState.ItemDataManager or nil;
    local details = manager and manager:GetBaseAttrEntryDetail(DefineID, StrengthenLevel) or nil;
    local quality = GetQuality(DefineID);
    local result = {
        RichText.Font(tostring(UGCItemSystemV2.GetItemNameV2(DefineID.TypeSpecificID) or ''), {
            size = 18,
            color = 'FFFFFFFF',
        }),
        self:GetQualityText(quality),
        RichText.Font(string.format('强化 +%s', tostring(StrengthenLevel or 0)), {
            size = 18,
            color = 'FFFFFFFF',
        }),
    };
    if details == nil or #details == 0 then
        table.insert(result, RichText.Font('暂无属性配置', {size = 18, color = 'FFFFFFFF'}));
        return table.concat(result, '\n');
    end

    for _, detail in ipairs(details) do
        local meta = AttributeMate[detail.property];
        local attrName = meta and meta.anno or tostring(detail.property);
        table.insert(result, RichText.Inline(
                RichText.Font(string.format('-- %s  ', attrName), {size = 18, color = 'FFFFFFFF'}),
                RichText.Font(self:FormatAttributeValue(detail.finalValue), {size = 18, color = 'B8FFA1FF'}),
                RichText.Font('（基础 ' .. self:FormatAttributeValue(detail.initialValue),
                        {size = 16, color = 'FFFFFFFF'}),
                RichText.Font(' + 强化 ' .. self:FormatAttributeValue(detail.strengthenValue) .. '）',
                        {size = 16, color = 'FFD966FF'})
        ));
    end
    return table.concat(result, '\n');
end

function PureMain:Request()
    local defineId = PureManager.DefineId;
    local reforgeData = PureManager:GetReforgeData(defineId);
    if defineId == nil or reforgeData == nil then
        UGCWidgetManagerSystem.ShowTipsUI('当前装备无法继续精炼');
        return;
    end
    for _, requirement in ipairs(reforgeData.Requirement or {}) do
        if self:GetItemCount(requirement.ItemId) < (tonumber(requirement.Value) or 0) then
            UGCWidgetManagerSystem.ShowTipsUI('精炼材料不足');
            return;
        end
    end
    local useAdvanced = self.NewCheckBox_0:IsChecked() == true;
    if useAdvanced and self:GetItemCount(GetAdvancedItemId()) <= 0 then
        UGCWidgetManagerSystem.ShowTipsUI('宇宙晶石不足');
        return;
    end
    if PureManager.ComponentClass == nil then
        UGCWidgetManagerSystem.ShowTipsUI('精炼组件尚未初始化');
        return;
    end

    self.PendingSourceDefineId = totable(defineId);
    self.RequestRefreshCountdown = 0.75;
    self.Button_1:SetIsEnabled(false);
    if not PureManager:Request(defineId, useAdvanced) then
        self.RequestRefreshCountdown = nil;
        self:SetPreview(defineId);
        UGCWidgetManagerSystem.ShowTipsUI('精炼请求发送失败');
    end
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

function PureMain:FormatAttributeValue(Value)
    local value = tonumber(Value) or 0;
    if math.abs(value - math.floor(value + 0.5)) < 0.0001 then
        return tostring(math.floor(value + 0.5));
    end
    return string.format('%.2f', value):gsub('0+$', ''):gsub('%.$', '');
end

return PureMain
