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
    Filter = nil,
    FilterType = nil,
    DefineID = nil,

}

function FortifyMain:Construct()
    self:LuaInit();
end

function FortifyMain:Open(DefineID)
    self:SetVisibility(ESlateVisibility.Visible);
    self:Reload(DefineID, FortifyManager.EquipmentType[1].Type);
end

function FortifyMain:Reload(DefineID, FilterType)
    local AllItem = UGCBackpackSystemV2.GetAllItemDefineIDsV2(LocalPlayerController);
    ugcprint('刷新数据')
    ugcprint_concat(AllItem);
    if FilterType == nil then
        FilterType = EquipmentType[1].Type;
    end
    FortifyManager.DefineId = DefineID;
    FortifyManager.FilterType = FilterType
    self.Filter = self:FilterEquipment(AllItem, FilterType);
    self.BackpackList:Reload(#self.Filter);
    self.TabList:Reload(#FortifyManager.EquipmentType)
    self:SetPreview(DefineID);
    --local imageT = RichText.Link('点击这里', {size='24', color='FFAAAAFF', under_line='1'})
    --ugcprint(imageT)
    self.Front:SetText(
        '请点击<a2 src="/Engine/EngineFonts/Roboto.Roboto" size="30" color="A9FF00FF" flag="1">这里</>'
    )
end

--- @param DefineID ItemDefineID
function FortifyMain:SetPreview(DefineID)
    --local ItemId = DefineID.TypeSpecificID;
    self.FortifyPreviewItem:SetDefineID(DefineID);
    self.FortifyPreviewItem_0:SetDefineID({TypeSpecificID=8310004})
end

function FortifyMain:FilterEquipment(ItemList, FilterType)
    local result = {};
    ugcprint(FilterType)
    for key, item in ipairs(ItemList) do
        local itemId = item.TypeSpecificID;
        local itemType = UGCItemSystemV2.GetItemCustomizedTypeV2(itemId);
        local has_all = false
        if FilterType == FortifyManager.EquipmentType[1].Type then
            has_all = true;
            ugcprint('全部')
        end
        local has_equipment = ItemCfg.CustomizeType[itemType];
        if has_all and has_equipment then
            table.insert(result, item);
        else
            if itemType == FilterType then
                table.insert(result, item)
            end
        end
    end
    return result;
end

function FortifyMain:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self:Listen();
    FortifyManager:RegisterMainUI(self);
end

function FortifyMain:Listen()
    self.Button_0.OnClicked:Add(self.Exit, self);
    self.BackpackList.OnUpdateItem:Add(self.BackpackListUpdate, self);
    self.TabList.OnUpdateItem:Add(self.TabListUpdate, self)
    self.PureBtn.OnClicked:Add(self.PureBtnClicked, self);
    self.Front.OnHyperlinkClicked:Add(self.OnHyperlinkClicked, self)

end

function FortifyMain:Exit()
    self:SetVisibility(ESlateVisibility.Collapsed);
end
function FortifyMain:OnHyperlinkClicked(meta)
    self:TestC(meta)
end

function FortifyMain:TestC(meta)
    ugcprint(tostring(meta.Metadata.flag));
    ugcprint_concat(meta, '  ');
end
function FortifyMain:PureBtnClicked()
    self:Exit()
    PureManager:OpenMainUI(FortifyManager.DefineID);
end

function FortifyMain:BackpackListUpdate(Item, Index)
    local DefineID = self.Filter[Index+1];
    Item:SetDefineID(DefineID);
    Item:SetSelected(FortifyManager.DefineId);
end

function FortifyMain:TabListUpdate(Item, Index)
    Item.Index = Index;
    Item:SetDAT(Index, FortifyManager.EquipmentType[Index+1].Text);
    if FortifyManager.FilterType == FortifyManager.EquipmentType[Index+1].Type then
        Item:SetSelected(true);
    else
        Item:SetSelected(false);
    end
end

return FortifyMain