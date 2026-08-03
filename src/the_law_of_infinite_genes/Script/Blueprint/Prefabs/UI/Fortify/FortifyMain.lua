---@class FortifyMain_C:UAEUserWidget
---@field BackpackList UGC_ReuseList2_C
---@field Button_0 UButton
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
    if FilterType == nil then
        FilterType = EquipmentType[1].Type;
    end
    FortifyManager.DefineId = DefineID;
    FortifyManager.FilterType = FilterType
    self.Filter = self:FilterEquipment(AllItem, FilterType);
    self.BackpackList:Reload(#self.Filter);
    self.TabList:Reload(#FortifyManager.EquipmentType)
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
end

function FortifyMain:Exit()
    self:SetVisibility(ESlateVisibility.Collapsed);
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