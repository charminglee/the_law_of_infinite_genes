---@class ReinfMain_C:UAEUserWidget
---@field After UUTRichTextBlock
---@field Appraisal UButton
---@field BackpackList UGC_ReuseList2_C
---@field Button_0 UButton
---@field Button_1 UButton
---@field Compose UButton
---@field Front UUTRichTextBlock
---@field Image_6 UImage
---@field Image_7 UImage
---@field Image_9 UImage
---@field Image_12 UImage
---@field Image_13 UImage
---@field Image_14 UImage
---@field Image_17 UImage
---@field M1 ReinfPreviewItem_C
---@field M2 ReinfPreviewItem_C
---@field M3 ReinfPreviewItem_C
---@field Reinf UButton
---@field ReinfPreviewItem ReinfPreviewItem_C
---@field TabList UGC_ReuseList2_C
---@field UTRichTextBlock_0 UUTRichTextBlock
--Edit Below--
local ReinfMain = {
    bInitDoOnce = false,
    Filter = {},
}

function ReinfMain:Construct()
	self:LuaInit();
end

function ReinfMain:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self:Listen();
    ReinfManager:RegisterMainUI(self);
end

function ReinfMain:Open(DefineID, FilterType)
    self:SetVisibility(ESlateVisibility.Visible);
    self:Reload(DefineID, FilterType);
end

function ReinfMain:Reload(DefineID, FilterType)
    if FilterType == nil then
        FilterType = ReinfManager.KenlType[1].Type;
    end
    ReinfManager.FilterType = FilterType;
    ReinfManager.DefineId = DefineID;
    local AllItem = UGCBackpackSystemV2.GetAllItemDefineIDsV2(LocalPlayerController);
    self.Filter = self:FilterKenl(AllItem, FilterType)
    self.BackpackList:Reload(#self.Filter);
    self.TabList:Reload(#ReinfManager.KenlType);
    self:SetPreview(DefineID);
end

function ReinfMain:FilterKenl(ItemList, FilterType)
    local result = {};
    for key, item in ipairs(ItemList) do
        local itemId = item.TypeSpecificID;
        local itemType = UGCItemSystemV2.GetItemCustomizedTypeV2(itemId);
        local has_all = false
        if FilterType == ReinfManager.KenlType[1].Type then
            has_all = true;
        end
        local has_Kenl = self:HasLegalKenl(item);
        if has_all and has_Kenl then
            table.insert(result, item);
        else
            if itemType == FilterType then
                table.insert(result, item)
            end
        end
    end
    return result;
end

--- @param DefineId ItemDefineID
function ReinfMain:HasLegalKenl(DefineId)
    if DefineId.TypeSpecificID == ItemCfg.ItemType.Kenl then
        local dat = LocalPlayerState.ItemDataManager:GetCustomData(DefineId);
        if dat.isIdentified then
            return true
        end
    end
    return false;
end

--- @param DefineID ItemDefineID
function ReinfMain:SetPreview(DefineID)
    local Dat = LocalPlayerState.ItemDataManager:GetCustomData(DefineID.TypeSpecificID);
    self.ReinfPreviewItem:SetDefineID(DefineID);
end

function ReinfMain:Listen()
    self.Button_0.OnClicked:Add(self.Exit, self);
    self.Appraisal.OnClicked:Add(self.AppraisalClick, self);
    self.Compose.OnClicked:Add(self.ComposeClick, self);
    self.TabList.OnUpdateItem:Add(self.TabListUpdate, self);
    self.BackpackList.OnUpdateItem:Add(self.BackpackListUpdate, self);
end

function ReinfMain:Exit()
    self:SetVisibility(ESlateVisibility.Collapsed);
end

function ReinfMain:AppraisalClick()
    self:Exit()
    AppraisalManager:OpenMainUI(ReinfManager.DefineId);
end

function ReinfMain:ComposeClick()
    self:Exit();
    KenlComposeManager:OpenMainUI(ReinfManager.DefineId);
end

function ReinfMain:TabListUpdate(Item, Index)
    Item.Index = Index;
    Item:SetDAT(Index, ReinfManager.KenlType[Index+1].Text);
    if ReinfManager.FilterType == ReinfManager.KenlType[Index+1].Type then
        Item:SetSelected(true);
    else
        Item:SetSelected(false);
    end
end

function ReinfMain:BackpackListUpdate(Item, Index)
    local DefineID = self.Filter[Index+1];
    Item:SetDefineID(DefineID);
    Item:SetSelected(ReinfManager.DefineId);
end
return ReinfMain