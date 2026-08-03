---@class FortifyMain_C:UAEUserWidget
---@field BackpackList UGC_ReuseList2_C
---@field Button_0 UButton
--Edit Below--
local FortifyMain = {
    bInitDoOnce = false,
    Filter = nil,
    DefineID = nil,
}

function FortifyMain:Construct()
    self:LuaInit();
end

function FortifyMain:Open(DefineID)
    self:SetVisibility(ESlateVisibility.Visible);
    self:Reload(DefineID);
end

function FortifyMain:Reload(DefineID)
    self.DefineID = DefineID;
    local AllItem = UGCBackpackSystemV2.GetAllItemDefineIDsV2(LocalPlayerController);
    self.Filter = self:FilterEquipment(AllItem);
    self.BackpackList:Reload(#self.Filter);
end

function FortifyMain:FilterEquipment(ItemList)
    local result = {};
    for key, item in ipairs(ItemList) do
        local itemId = item.TypeSpecificID;
        if ItemCfg.CustomizeType[UGCItemSystemV2.GetItemCustomizedTypeV2(itemId)] then
            table.insert(result, item);
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
end

function FortifyMain:Exit()
    self:SetVisibility(ESlateVisibility.Collapsed);
end

function FortifyMain:BackpackListUpdate(Item, Index)
    local DefineID = self.Filter[Index+1];
    Item:SetDefineID(DefineID);
    Item:SetSelected(self.DefineID);
end

return FortifyMain