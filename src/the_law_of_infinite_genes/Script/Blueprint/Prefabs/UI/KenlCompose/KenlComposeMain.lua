---@class KenlComposeMain_C:UAEUserWidget
---@field AddOn KComposePreviewItem_C
---@field After UUTRichTextBlock
---@field Appraisal UButton
---@field BackpackList UGC_ReuseList2_C
---@field Button_0 UButton
---@field Button_1 UButton
---@field Compose UButton
---@field ConsumeBox USizeBox
---@field CURP UCanvasPanel
---@field Front UUTRichTextBlock
---@field Image_6 UImage
---@field Image_8 UImage
---@field Image_9 UImage
---@field Image_12 UImage
---@field Image_13 UImage
---@field Image_14 UImage
---@field Image_17 UImage
---@field M1 KComposePreviewItem_C
---@field M2 KComposePreviewItem_C
---@field M3 KComposePreviewItem_C
---@field NEXIMAGE UImage
---@field Ontology KComposePreviewItem_C
---@field Reinf UButton
---@field RESP UCanvasPanel
---@field UTRichTextBlock_0 UUTRichTextBlock
---@field Waiting UCanvasPanel
---@field WaitList UGC_ReuseList2_C
--Edit Below--
local KenlComposeMain = {
    bInitDoOnce = false,
    Filter = {},
    MaterialFilter = {},
    MaterialData = nil,
    PreviousData = nil,
    CurrentData = nil
}

local function IsSameItem(Left, Right)
    if Left == nil or Right == nil then
        return false;
    end
    if Left.InstanceID ~= nil and Right.InstanceID ~= nil then
        return Left.InstanceID == Right.InstanceID;
    end
    return Left.TypeSpecificID == Right.TypeSpecificID;
end

local function RemoveItemFromList(ItemList, DefineID)
    if DefineID == nil then
        return;
    end

    for index = #ItemList, 1, -1 do
        if IsSameItem(ItemList[index], DefineID) then
            table.remove(ItemList, index);
        end
    end
end

function KenlComposeMain:Construct()
    self:LuaInit();
end

function KenlComposeMain:LuaInit()
    if self.bInitDoOnce then
        return;
    end

    self.bInitDoOnce = true;
    self:Listen();
    KenlComposeManager:RegisterMainUI(self);
end

function KenlComposeMain:Listen()
    self.Reinf.OnClicked:Add(self.ReinfClick, self);
    self.Appraisal.OnClicked:Add(self.AppraisalClick, self);
    self.Button_0.OnClicked:Add(self.Exit, self);
    self.Button_1.OnClicked:Add(self.Request, self);
    self.BackpackList.OnUpdateItem:Add(self.BackpackListUpdate, self);
    self.WaitList.OnUpdateItem:Add(self.WaitListUpdate, self);
end

function KenlComposeMain:Open(DefineID)
    self.PreviousData = nil;
    self.CurrentData = nil;
    self.MaterialData = nil;
    KenlComposeManager.MaterialDefineId = nil;
    KenlComposeManager.PendingFusion = false;
    self:SetVisibility(ESlateVisibility.Visible);
    self:Reload(DefineID, KenlComposeManager.EquipmentType[1].Type);
end

function KenlComposeMain:Exit()
    self:SetVisibility(ESlateVisibility.Collapsed);
end

function KenlComposeMain:Reload(DefineID, FilterType)
    if DefineID == nil then
        return;
    end

    FilterType = FilterType or KenlComposeManager.EquipmentType[1].Type;
    KenlComposeManager.FilterType = FilterType;
    KenlComposeManager.DefineId = DefineID;

    local allItems = UGCBackpackSystemV2.GetAllItemDefineIDsV2(LocalPlayerController);
    self.Filter = self:FilterKenl(allItems, FilterType);
    self.MaterialFilter = self:BuildMaterialFilter(self.Filter, KenlComposeManager.DefineId);
    self.BackpackList:Reload(#self.Filter);
    self.WaitList:Reload(#self.MaterialFilter);
    self:SetPreview(KenlComposeManager.DefineId);
end

function KenlComposeMain:FilterKenl(ItemList, FilterType)
    local result = {};
    for _, item in ipairs(ItemList) do
        local itemType = UGCItemSystemV2.GetItemCustomizedTypeV2(item.TypeSpecificID);
        local matchType = FilterType == 'ALL' or itemType == FilterType;
        if matchType and self:HasLegalKenl(item) then
            table.insert(result, item);
        end
    end
    return result;
end

---@param DefineID ItemDefineID
function KenlComposeMain:HasLegalKenl(DefineID)
    local itemType = UGCItemSystemV2.GetItemCustomizedTypeV2(DefineID.TypeSpecificID);
    if itemType ~= ItemCfg.ItemType.Kenl then
        return false;
    end

    local data = LocalPlayerState.ItemDataManager:GetCustomData(DefineID);
    return data ~= nil and data.isIdentified == true and data.entries ~= nil;
end

function KenlComposeMain:BuildMaterialFilter(ItemList, PrimaryDefineID)
    local result = {};
    for _, item in ipairs(ItemList) do
        if not IsSameItem(item, PrimaryDefineID) then
            table.insert(result, item);
        end
    end
    return result;
end

function KenlComposeMain:SelectPrimary(DefineID)
    if DefineID == nil or IsSameItem(DefineID, KenlComposeManager.DefineId) then
        return;
    end

    self.PreviousData = nil;
    self.CurrentData = nil;
    self.MaterialData = nil;
    KenlComposeManager.MaterialDefineId = nil;
    KenlComposeManager.PendingFusion = false;
    self:Reload(DefineID, KenlComposeManager.FilterType);
end

function KenlComposeMain:SelectMaterial(DefineID)
    if DefineID == nil or IsSameItem(DefineID, KenlComposeManager.DefineId) then
        return;
    end

    KenlComposeManager.MaterialDefineId = DefineID;
    self.PreviousData = nil;
    self.WaitList:Reload(#self.MaterialFilter);
    self:SetPreview(KenlComposeManager.DefineId);
end

---@param DefineID ItemDefineID
function KenlComposeMain:SetPreview(DefineID)
    if DefineID == nil then
        return;
    end

    local data = LocalPlayerState.ItemDataManager:GetCustomData(DefineID);
    if data == nil then
        return;
    end

    self.CurrentData = Lib.Table.DeepCopy(data);
    self.Ontology:SetMode('Primary');
    self.Ontology:SetDefineID(DefineID);

    if KenlComposeManager.MaterialDefineId ~= nil then
        self.AddOn:SetMode('Material');
        self.AddOn:SetDefineID(KenlComposeManager.MaterialDefineId);
        local materialData = LocalPlayerState.ItemDataManager:GetCustomData(KenlComposeManager.MaterialDefineId);
        self.MaterialData = Lib.Table.DeepCopy(materialData or {});
    else
        self.AddOn:SetEmpty();
        self.MaterialData = nil;
    end

    local currentText = self:GetAttributeText(self.CurrentData);
    self.UTRichTextBlock_0:SetText(self:GetCombinedAttributeText(self.CurrentData, self.MaterialData));
    if self.PreviousData ~= nil then
        self.Front:SetText(self:GetAttributeText(self.PreviousData));
        self.After:SetText(currentText);
    else
        self.Front:SetText(currentText);
        self.After:SetText(RichText.Font('等待合成', {size=18, color='88FFFFFF'}));
    end
end

function KenlComposeMain:BackpackListUpdate(Item, Index)
    local defineID = self.Filter[Index + 1];
    Item:SetMode('Primary');
    Item:SetDefineID(defineID);
    Item:SetSelected(KenlComposeManager.DefineId);
end

function KenlComposeMain:WaitListUpdate(Item, Index)
    local defineID = self.MaterialFilter[Index + 1];
    Item:SetMode('Material');
    Item:SetDefineID(defineID);
    Item:SetSelected(KenlComposeManager.MaterialDefineId);
end

function KenlComposeMain:Request()
    if KenlComposeManager.DefineId == nil then
        UGCWidgetManagerSystem.ShowTipsUI('请选择主核心');
        return;
    end
    if KenlComposeManager.MaterialDefineId == nil then
        UGCWidgetManagerSystem.ShowTipsUI('请选择用于合成的核心');
        return;
    end
    if KenlComposeManager.ComponentClass == nil then
        UGCWidgetManagerSystem.ShowTipsUI('合成组件尚未初始化');
        return;
    end

    KenlComposeManager.PendingFusion = true;
    UnrealNetwork.CallUnrealRPC(
            LocalPlayerController,
            KenlComposeManager.ComponentClass,
            'FusionSubmit',
            LocalPlayerController.PlayerKey,
            KenlComposeManager.DefineId,
            KenlComposeManager.MaterialDefineId
    );
end

function KenlComposeMain:OnFusionResult(OldData, NewData)
    local consumedDefineId = KenlComposeManager.MaterialDefineId;
    local consumedData = self.MaterialData;

    self.PreviousData = Lib.Table.DeepCopy(OldData or {});
    self.CurrentData = Lib.Table.DeepCopy(NewData or {});
    self.Front:SetText(self:GetAttributeText(self.PreviousData));
    self.After:SetText(self:GetAttributeText(self.CurrentData));
    self.UTRichTextBlock_0:SetText(self:GetCombinedAttributeText(self.PreviousData, consumedData));

    KenlComposeManager.MaterialDefineId = nil;
    self.MaterialData = nil;
    self.AddOn:SetEmpty();

    local allItems = UGCBackpackSystemV2.GetAllItemDefineIDsV2(LocalPlayerController);
    self.Filter = self:FilterKenl(allItems, KenlComposeManager.FilterType);
    -- 自定义数据回包可能早于背包删除同步，先按 InstanceID 从界面列表剔除已消耗核心。
    RemoveItemFromList(self.Filter, consumedDefineId);
    self.MaterialFilter = self:BuildMaterialFilter(self.Filter, KenlComposeManager.DefineId);
    self.BackpackList:Reload(#self.Filter);
    self.WaitList:Reload(#self.MaterialFilter);
end

function KenlComposeMain:GetAttributeText(Data)
    if Data == nil or Data.entries == nil or #Data.entries == 0 then
        return RichText.Font('暂无属性', {size=18, color='88FFFFFF'});
    end

    local result = {};
    for index, entry in ipairs(Data.entries) do
        local mate = AttributeMate[entry.property];
        local attrName = mate and mate.anno or tostring(entry.property);
        table.insert(result, RichText.Inline(
                RichText.Font(string.format(' 属性%s\t\t', tostring(index)), {size=18, color='FFFFFFFF'}),
                RichText.Font(string.format('%s +%s', attrName, tostring(entry.value)), {size=18, color='B8FFA1FF'})
        ));
    end
    return table.concat(result, '\n');
end

function KenlComposeMain:GetCombinedAttributeText(PrimaryData, MaterialData)
    local result = {};
    local index = 1;

    local function AppendEntries(Data)
        if Data == nil or Data.entries == nil then
            return;
        end

        for _, entry in ipairs(Data.entries) do
            local mate = AttributeMate[entry.property];
            local attrName = mate and mate.anno or tostring(entry.property);
            table.insert(result, RichText.Inline(
                    RichText.Font(string.format(' 属性%s\t\t', tostring(index)), {size=18, color='FFFFFFFF'}),
                    RichText.Font(string.format('%s +%s', attrName, tostring(entry.value)), {size=18, color='B8FFA1FF'})
            ));
            index = index + 1;
        end
    end

    AppendEntries(PrimaryData);
    AppendEntries(MaterialData);
    if #result == 0 then
        return RichText.Font('暂无属性', {size=18, color='88FFFFFF'});
    end
    return table.concat(result, '\n');
end

function KenlComposeMain:ReinfClick()
    self:Exit();
    ReinfManager:OpenMainUI(KenlComposeManager.DefineId);
end

function KenlComposeMain:AppraisalClick()
    self:Exit();
    AppraisalManager:OpenMainUI(KenlComposeManager.DefineId);
end

return KenlComposeMain
