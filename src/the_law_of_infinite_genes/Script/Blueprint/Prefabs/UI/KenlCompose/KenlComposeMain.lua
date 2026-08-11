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
---@field REINST_KComposePreviewItem_C_1 KComposePreviewItem_C
---@field REINST_KComposePreviewItem_C_2 KComposePreviewItem_C
---@field RESP UCanvasPanel
---@field UTRichTextBlock_0 UUTRichTextBlock
---@field Waiting UCanvasPanel
---@field WaitList UGC_ReuseList2_C
--Edit Below--
local KenlComposeMain = {
    bInitDoOnce = false,
    Filter = {},
}
function KenlComposeMain:Construct()
	self:LuaInit();
end
function KenlComposeMain:Open(DefineId)
    self:SetVisibility(ESlateVisibility.Visible);
    self:Reload(DefineID, FilterType);
end

function KenlComposeMain:Reload(DefineID, FilterType)
    if FilterType == nil then
        FilterType = KenlComposeManager.KenlType[1].Type;
    end
    KenlComposeManager.FilterType = FilterType;
    KenlComposeManager.DefineId = DefineID;
    local AllItem = UGCBackpackSystemV2.GetAllItemDefineIDsV2(LocalPlayerController);
    self.Filter = self:FilterKenl(AllItem, FilterType)
    self.BackpackList:Reload(#self.Filter);
    self.TabList:Reload(#KenlComposeManager.KenlType);
    self:SetPreview(DefineID);
end

function KenlComposeMain:FilterKenl(ItemList, FilterType)
    local result = {};
    for key, item in ipairs(ItemList) do
        local itemId = item.TypeSpecificID;
        local itemType = UGCItemSystemV2.GetItemCustomizedTypeV2(itemId);
        local has_all = false
        if FilterType == KenlComposeManager.KenlType[1].Type then
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
function KenlComposeMain:HasLegalKenl(DefineId)
    if DefineId.TypeSpecificID == ItemCfg.ItemType.Kenl then
        local dat = LocalPlayerState.ItemDataManager:GetCustomData(DefineId);
        if dat.isIdentified then
            return true
        end
    end
    return false;
end

--- @param DefineID ItemDefineID
function KenlComposeMain:SetPreview(DefineID)
    local Dat = LocalPlayerState.ItemDataManager:GetCustomData(DefineID.TypeSpecificID);
    self.ReinfPreviewItem:SetDefineID(DefineID);
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
    self.BackpackList.OnUpdateItem:Add(self.BackpackListUpdate, self);
    self.WaitList.OnUpdateItem:Add(self.WaitListUpdate, self);
end
function KenlComposeMain:Exit()
    self:SetVisibility(ESlateVisibility.Collapsed);
end
function KenlComposeMain:ReinfClick()
    self:Exit();
    ReinfManager:OpenMainUI(KenlComposeManager.DefineId);
end
function KenlComposeMain:AppraisalClick()
    self:Exit();
    AppraisalManager:OpenMainUI(KenlComposeManager.DefineId);
end

function KenlComposeMain:BackpackListUpdate(Item, Index)
    local DefineID = self.Filter[Index+1];
    Item:SetDefineID(DefineID);
    Item:SetSelected(ReinfManager.DefineId);
end

function KenlComposeMain:WaitListUpdate(Item, Index)
    local DefineID = self.Filter[Index+1];
    Item:SetDefineID(DefineID);
    Item:SetSelected(ReinfManager.DefineId);
end

return KenlComposeMain