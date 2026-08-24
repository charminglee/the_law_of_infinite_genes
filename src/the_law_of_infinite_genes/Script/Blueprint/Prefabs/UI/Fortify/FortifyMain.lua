---@class FortifyMain_C:UAEUserWidget
---@field After UUTRichTextBlock
---@field AfterLevel UUTRichTextBlock
---@field BackpackList UGC_ReuseList2_C
---@field Button_0 UButton
---@field Button_1 UButton
---@field Button_276 UButton
---@field CurrentLevel UUTRichTextBlock
---@field FortifyPreviewItem FortifyPreviewItem_C
---@field FortifyPreviewItem_0 FortifyPreviewItem_C
---@field Front UUTRichTextBlock
---@field Image_12 UImage
---@field Image_13 UImage
---@field Image_14 UImage
---@field Image_16 UImage
---@field Image_17 UImage
---@field PureBtn UButton
---@field SuccessRate UTextBlock
---@field TabList UGC_ReuseList2_C
--Edit Below--
local FortifyMain = {
    bInitDoOnce = false,
    Filter = {},
    MaterialDefineID = nil,
    MaterialItemId = nil,
    MaterialOwnedCount = 0,
    MaterialRequiredCount = 1,
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

function FortifyMain:Construct()
    self:LuaInit();
end

function FortifyMain:Tick(MyGeometry, InDeltaTime)
    if FortifyManager.RefreshUI then
        FortifyManager.RefreshUI = false;
        self:Reload(FortifyManager.DefineId, FortifyManager.FilterType);
    end
end

function FortifyMain:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self.Button_0.OnClicked:Add(self.Exit, self);
    self.Button_1.OnClicked:Add(self.Request, self);
    self.PureBtn.OnClicked:Add(self.PureBtnClicked, self);
    self.BackpackList.OnUpdateItem:Add(self.BackpackListUpdate, self);
    self.TabList.OnUpdateItem:Add(self.TabListUpdate, self);
    FortifyManager:RegisterMainUI(self);
end

function FortifyMain:Open(DefineID)
    self:SetVisibility(ESlateVisibility.Visible);
    self:Reload(DefineID, FortifyManager.EquipmentType[1].Type);
end

function FortifyMain:Exit()
    self:SetVisibility(ESlateVisibility.Collapsed);
end

function FortifyMain:PureBtnClicked()
    local defineID = FortifyManager.DefineId;
    self:Exit();
    if PureManager ~= nil then
        PureManager:OpenMainUI(defineID);
    end
end

---@param DefineID ItemDefineID
---@param FilterType string
function FortifyMain:Reload(DefineID, FilterType)
    FilterType = FilterType or FortifyManager.EquipmentType[1].Type;
    local allItems = UGCBackpackSystemV2.GetAllItemDefineIDsV2(LocalPlayerController) or {};
    self.Filter = self:FilterEquipment(allItems, FilterType);

    local selected = DefineID;
    if not self:ContainsDefineId(self.Filter, selected) then
        selected = self.Filter[1];
    end

    FortifyManager.DefineId = selected;
    FortifyManager.FilterType = FilterType;
    self.BackpackList:Reload(#self.Filter);
    self.TabList:Reload(#FortifyManager.EquipmentType);
    self:SetPreview(selected, allItems);
end

function FortifyMain:ContainsDefineId(ItemList, DefineID)
    for _, item in ipairs(ItemList or {}) do
        if IsSameDefineId(item, DefineID) then
            return true;
        end
    end
    return false;
end

function FortifyMain:FilterEquipment(ItemList, FilterType)
    local result = {};
    local showAll = FilterType == FortifyManager.EquipmentType[1].Type;
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

function FortifyMain:GetItemCount(ItemId)
    if ItemId == nil then
        return 0;
    end
    return UGCBackpackSystemV2.GetItemCountV2(LocalPlayerController, ItemId);
end

---@param DefineID ItemDefineID
function FortifyMain:SetPreview(DefineID, AllItems)
    if not IsEquipment(DefineID) then
        self.MaterialDefineID = nil;
        self.MaterialItemId = nil;
        self.MaterialOwnedCount = 0;
        FortifyManager.MaterialDefineId = nil;
        self.FortifyPreviewItem:SetEmpty();
        self.FortifyPreviewItem_0:SetEmpty();
        self.CurrentLevel:SetText('');
        self.AfterLevel:SetText('');
        self.Front:SetText('请选择需要强化的装备');
        self.After:SetText('');
        self.SuccessRate:SetText('0%');
        self.Button_1:SetIsEnabled(false);
        return;
    end

    local data = LocalPlayerState.ItemDataManager:GetCustomData(DefineID) or {};
    local currentLevel = tonumber(data.strengthenLevel) or 0;
    local maxLevel = FortifyManager:GetMaxLevel();
    local afterLevel = math.min(currentLevel + 1, maxLevel);
    local materialItemId = ItemCfg.Strengthen.Cost.ItemId;
    local materialOwnedCount = self:GetItemCount(materialItemId);
    local materialRequiredCount = 1;
    local materialDefineID = materialItemId ~= nil
            and {TypeSpecificID = materialItemId} or nil;

    self.MaterialDefineID = materialDefineID;
    self.MaterialItemId = materialItemId;
    self.MaterialOwnedCount = materialOwnedCount;
    self.MaterialRequiredCount = materialRequiredCount;
    FortifyManager.MaterialDefineId = materialDefineID;
    self.FortifyPreviewItem:SetDefineID(DefineID, currentLevel);
    self.FortifyPreviewItem_0:SetDefineID(materialDefineID);
    self.FortifyPreviewItem_0:SetCount(materialItemId ~= nil
            and string.format('%s/%s', tostring(materialOwnedCount), tostring(materialRequiredCount))
            or nil);

    self.CurrentLevel:SetText(self:GetLevelText(currentLevel));
    if currentLevel >= maxLevel then
        self.AfterLevel:SetText(RichText.Font('已满级', {size = 18, color = 'FFFF00FF'}));
    else
        self.AfterLevel:SetText(self:GetLevelText(afterLevel));
    end
    self.Front:SetText(self:GetEquipmentAttributeText(DefineID, currentLevel));
    self.After:SetText(self:GetEquipmentAttributeText(DefineID, afterLevel));
    self.SuccessRate:SetText(currentLevel < maxLevel
            and self:GetStrengthenSuccessRateText(DefineID, afterLevel) or '0%');
    self.Button_1:SetIsEnabled(currentLevel < maxLevel
            and materialOwnedCount >= materialRequiredCount
            and FortifyManager.ComponentClass ~= nil);
end

function FortifyMain:GetLevelText(Level)
    local levelCfg = ItemCfg.colorTable[Level] or ItemCfg.colorTable[0];
    local color = levelCfg and levelCfg.HexColor or 'FFFFFFFF';
    local stage = levelCfg and levelCfg.Text or '';
    return RichText.Font(string.format('+%s %s', tostring(Level), stage), {size = 18, color = color});
end

--- @param DefineID FItemDefineID
function FortifyMain:GetEquipmentAttributeText(DefineID, Level)
    local details =  LocalPlayerState.ItemDataManager:GetBaseAttrEntryDetail(DefineID, Level);
    local tags = UGCItemSystemV2.GetItemTagsV2(DefineID.TypeSpecificID)

    ugcprint('重置')
    for k,v in ipairs(tags) do
        ugcprint(string.format('key:%s, value:%s', k, v))
    end
    if details == nil or #details == 0 then
        return RichText.Font('暂无属性配置', {size = 18, color = 'FFFFFFFF'});
    end

    local result = {};
    for _, detail in ipairs(details) do
        local meta = AttributeMate[detail.property];
        local attrName = meta and meta.anno or tostring(detail.property);
        table.insert(result, RichText.Inline(
                RichText.Font(string.format('-- %s  ', attrName), {size = 18, color = 'FFFFFFFF'}),
                RichText.Font('' .. self:FormatAttributeValue(detail.finalValue),
                        {size = 18, color = 'B8FFA1FF'}),
                RichText.Font('（基础 ' .. self:FormatAttributeValue(detail.baseValue),
                        {size = 16, color = 'FFFFFFFF'}),
                RichText.Font(' + 强化 ' .. self:FormatAttributeValue(detail.strengthenValue) .. '）',
                        {size = 16, color = 'FFD966FF'})
        ));
    end
    return table.concat(result, '\n');
end

function FortifyMain:Request()
    if FortifyManager.DefineId == nil then
        UGCWidgetManagerSystem.ShowTipsUI('请选择需要强化的装备');
        return;
    end
    local materialCount = self:GetItemCount(self.MaterialItemId);
    if self.MaterialItemId == nil or materialCount < self.MaterialRequiredCount then
        UGCWidgetManagerSystem.ShowTipsUI('强化材料不足');
        self:SetPreview(FortifyManager.DefineId);
        return;
    end
    if FortifyManager.ComponentClass == nil then
        UGCWidgetManagerSystem.ShowTipsUI('强化组件尚未初始化');
        return;
    end
    UnrealNetwork.CallUnrealRPC(
            LocalPlayerController,
            FortifyManager.ComponentClass,
            'FortifySubmit',
            LocalPlayerController.PlayerKey,
            FortifyManager.DefineId
    );
end

function FortifyMain:BackpackListUpdate(Item, Index)
    local defineID = self.Filter[Index + 1];
    if defineID == nil then
        Item:SetEmpty();
        return;
    end
    Item:SetDefineID(defineID);
    Item:SetSelected(FortifyManager.DefineId);
end

function FortifyMain:TabListUpdate(Item, Index)
    local tab = FortifyManager.EquipmentType[Index + 1];
    if tab == nil then
        return;
    end
    Item:SetDAT(Index, tab.Text);
    Item:SetSelected(FortifyManager.FilterType == tab.Type);
end

function FortifyMain:GetStrengthenSuccessRateText(DefineID, TargetLevel)
    local quality = UGCItemSystemV2.GetItemQualityV2(DefineID.TypeSpecificID) or 0;
    local probability = ItemCfg.Strengthen.ProbCurve(TargetLevel, quality);
    local percent = probability * 100;
    if math.abs(percent - math.floor(percent + 0.5)) < 0.0001 then
        return string.format('%d%%', math.floor(percent + 0.5));
    end
    return string.format('%.1f%%', percent);
end

function FortifyMain:GetStrengthenAttributeText(DefineID, Level)
    local details =  LocalPlayerState.ItemDataManager:GetBaseAttrEntryDetail(DefineID, Level);
    if details == nil or #details == 0 then
        return RichText.Font('暂无强化属性', {size = 18, color = 'FFFFFFFF'});
    end

    local result = {};
    for _, attr in ipairs(details) do
        local meta = AttributeMate[attr.property];
        local attrName = meta and meta.anno or tostring(attr.property);
        table.insert(result, RichText.Inline(
                RichText.Font(string.format('-- %s\t\t', attrName), {size = 18, color = 'FFFFFFFF'}),
                RichText.Font(string.format('+%s',tostring(attr.strengthenValue)), {size = 18, color = 'B8FFA1FF'})
        ));
    end
    return table.concat(result, '\n');
end

function FortifyMain:FormatAttributeValue(Value)
    local value = tonumber(Value) or 0;
    if math.abs(value - math.floor(value + 0.5)) < 0.0001 then
        return tostring(math.floor(value + 0.5));
    end
    return string.format('%.2f', value):gsub('0+$', ''):gsub('%.$', '');
end

return FortifyMain
