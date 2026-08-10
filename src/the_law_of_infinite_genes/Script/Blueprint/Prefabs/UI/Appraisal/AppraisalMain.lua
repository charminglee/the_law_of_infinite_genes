---@class AppraisalMain_C:UAEUserWidget
---@field AppraisalPreviewItem ppraisalPreviewItem_C
---@field BackpackList UGC_ReuseList2_C
---@field Button_0 UButton
---@field Button_1 UButton
---@field ConsumeBox USizeBox
---@field ConsumeText UUTRichTextBlock
---@field Front UUTRichTextBlock
---@field Image_14 UImage
---@field TabList UGC_ReuseList2_C
---@field UTRichTextBlock_0 UUTRichTextBlock
--Edit Below--
local AppraisalMain = {
    bInitDoOnce = false,
    Filter = {}
}


function AppraisalMain:Construct()
	self:LuaInit();
end

function AppraisalMain:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self:Listen();
    AppraisalManager:RegisterMainUI(self);
end

function AppraisalMain:Listen()
    self.Button_0.OnClicked:Add(self.Exit, self);
    self.TabList.OnUpdateItem:Add(self.TabListUpdate, self);
    self.BackpackList.OnUpdateItem:Add(self.BackpackListUpdate, self);
    self.Button_1.OnClicked:Add(self.Request, self);
end

function AppraisalMain:Open(DefineID, FilterType)
    self:SetVisibility(ESlateVisibility.Visible);
    self:Reload(DefineID, FilterType);
end

function AppraisalMain:Exit()
    self:SetVisibility(ESlateVisibility.Collapsed);
end

--- 发送请求
function AppraisalMain:Request()

end

function AppraisalMain:TabListUpdate(Item, Index)
    Item.Index = Index;
    Item:SetDAT(Index, AppraisalManager.KenlType[Index+1].Text);
    if AppraisalManager.FilterType == AppraisalManager.KenlType[Index+1].Type then
        Item:SetSelected(true);
    else
        Item:SetSelected(false);
    end
end

function AppraisalMain:BackpackListUpdate(Item, Index)
    local DefineID = self.Filter[Index+1];
    Item:SetDefineID(DefineID);
    Item:SetSelected(AppraisalManager.DefineId);
end

--- 刷新界面数据 FilterType空值默认处理为全部
function AppraisalMain:Reload(DefineID, FilterType)
    if FilterType == nil then
        FilterType = AppraisalManager.KenlType[1].Type;
    end
    AppraisalManager.FilterType = FilterType;
    AppraisalManager.DefineId = DefineID;
    local AllItem = UGCBackpackSystemV2.GetAllItemDefineIDsV2(LocalPlayerController);
    self.Filter = self:FilterKenl(AllItem, FilterType)
    self.BackpackList:Reload(#self.Filter);
    self.TabList:Reload(#AppraisalManager.KenlType);
    self:SetPreview(DefineID);
end

function AppraisalMain:FilterKenl(ItemList, FilterType)
    local result = {};
    for key, item in ipairs(ItemList) do
        local itemId = item.TypeSpecificID;
        local itemType = UGCItemSystemV2.GetItemCustomizedTypeV2(itemId);
        local has_all = false
        if FilterType == AppraisalManager.KenlType[1].Type then
            has_all = true;
        end
        local has_Kenl = itemType == ItemCfg.ItemType.Kenl;
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

--- @param DefineID ItemDefineID
function AppraisalMain:SetPreview(DefineID)
    local Dat = LocalPlayerState.ItemDataManager:GetCustomData(DefineID.TypeSpecificID);
    self.AppraisalPreviewItem:SetDefineID(DefineID);
    if Dat.isIdentified then
        self.UTRichTextBlock_0:SetText('已鉴定的核心');
        self.Front:SetText(self:GetAttributeText(Dat));
        self.ConsumeBox:SetVisibility(ESlateVisibility.Collapsed);
        self.Button_1:SetVisibility(ESlateVisibility.Collapsed);
    else
        self.ConsumeText:SetText('100金币');
        self.Front:SetText('核心属性未鉴定');
        self.UTRichTextBlock_0:SetText('核心属性未鉴定');
        self.ConsumeBox:SetVisibility(ESlateVisibility.Visible);
        self.Button_1:SetVisibility(ESlateVisibility.Visible);
    end
end

function AppraisalMain:GetAttributeText(Dat)
    local result = {
        RichText.Font('核心属性', {size=20, color='FFFFFFFF'})
    }
    local flag = 1;
    for k, v in ipairs(Dat.entries) do
        local attrName = AttributeMate[v.property].anno;
        table.insert(result, RichText.Inline(
                RichText.Font(string.format('-- 属性%s', tostring(flag)), {size=18, color='FFFFFFFF'}),
                RichText.Font(string.format('%s +%s', attrName, tostring(v.value)), {size=18, color='B8FFA1FF'})
        ))
        flag = flag + 1;
    end
    return table.concat(result, '\n');
end

return AppraisalMain