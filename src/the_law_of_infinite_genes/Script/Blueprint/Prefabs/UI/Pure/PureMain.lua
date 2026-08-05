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
---@field Image_12 UImage
---@field Image_13 UImage
---@field Image_14 UImage
---@field Image_17 UImage
---@field Image_18 UImage
---@field PreviewItem PurePreviewItem_C
---@field PreviewItem_0 PurePreviewItem_C
---@field SuccessRate UTextBlock
---@field TabList UGC_ReuseList2_C
--Edit Below--
local PureMain = {
    bInitDoOnce = false,
    Filter = nil,
    FilterType = nil,
    DefineID = nil,

}

function PureMain:Construct()
    self:LuaInit();
end

function PureMain:Open(DefineID)
    self:SetVisibility(ESlateVisibility.Visible);
    self:Reload(DefineID, PureManager.EquipmentType[1].Type);
end

function PureMain:Reload(DefineID, FilterType)
    local AllItem = UGCBackpackSystemV2.GetAllItemDefineIDsV2(LocalPlayerController);
    if FilterType == nil then
        FilterType = PureManager.EquipmentType[1].Type;
    end
    PureManager.DefineId = DefineID;
    PureManager.FilterType = FilterType
    self.Filter = self:FilterEquipment(AllItem, FilterType);
    self.BackpackList:Reload(#self.Filter);
    self.TabList:Reload(#PureManager.EquipmentType)
    self:SetPreview(DefineID);
end

--- @param DefineID ItemDefineID
function PureMain:SetPreview(DefineID)
    --local ItemId = DefineID.TypeSpecificID;
    self.PreviewItem:SetDefineID(DefineID);
    self.PreviewItem_0:SetDefineID({TypeSpecificID=8310004})
end

function PureMain:FilterEquipment(ItemList, FilterType)
    local result = {};
    for key, item in ipairs(ItemList) do
        local itemId = item.TypeSpecificID;
        local itemType = UGCItemSystemV2.GetItemCustomizedTypeV2(itemId);
        local has_all = false
        if FilterType == PureManager.EquipmentType[1].Type then
            has_all = true;
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

function PureMain:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self:Listen();
    PureManager:RegisterMainUI(self);
end

function PureMain:Listen()
    self.Button_0.OnClicked:Add(self.Exit, self);
    self.BackpackList.OnUpdateItem:Add(self.BackpackListUpdate, self);
    self.TabList.OnUpdateItem:Add(self.TabListUpdate, self)
    self.FortifyBtn.OnClicked:Add(self.FortifyBtnClicked, self);
end

function PureMain:Exit()
    self:SetVisibility(ESlateVisibility.Collapsed);
end

function PureMain:FortifyBtnClicked()
    self:Exit();
    FortifyManager:OpenMainUI(PureManager.DefineID);
end
function PureMain:BackpackListUpdate(Item, Index)
    local DefineID = self.Filter[Index+1];
    Item:SetDefineID(DefineID);
    Item:SetSelected(PureManager.DefineId);
end

function PureMain:TabListUpdate(Item, Index)
    Item.Index = Index;
    Item:SetDAT(Index, PureManager.EquipmentType[Index+1].Text);
    if PureManager.FilterType == PureManager.EquipmentType[Index+1].Type then
        Item:SetSelected(true);
    else
        Item:SetSelected(false);
    end
end

return PureMain