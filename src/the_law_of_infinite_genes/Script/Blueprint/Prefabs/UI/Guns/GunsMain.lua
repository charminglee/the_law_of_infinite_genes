---@class GunsMain_C:UAEUserWidget
---@field Button_0 UButton
---@field Button_1 UButton
---@field Button_2 UButton
---@field GunsList UGC_ReuseList2_C
---@field ItemImage UImage
---@field ItemName UTextBlock
---@field Preview UCanvasPanel
---@field TabList UGC_ReuseList2_C
---@field UTRichTextBlock_1 UUTRichTextBlock
--Edit Below--
local GunsMain = {
    bInitDoOnce = false,
    Filter = {},
    RenderVersion = 0,
}

function GunsMain:IsSameItemId(Left, Right)
    if Left == nil or Right == nil then
        return false;
    end
    if Left ~= nil and Right ~= nil then
        return Left == Right;
    end
    return Left ~= nil and Left == Right;
end

function GunsMain:ContainsItemId(ItemList, Item)
    for _, item in ipairs(ItemList or {}) do
        if self.IsSameItemId(item.ItemId, Item.ItemId) then
            return true;
        end
    end
    return false;
end

function GunsMain:Construct()
	self:LuaInit();
end

function GunsMain:Tick(MyGeometry, InDeltaTime)

end

function GunsMain:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    GunsManager:RegisterMainUI(self);
    self.bInitDoOnce = true;
    self:Listen()
end

function GunsMain:Listen()
    self.Button_0.OnClicked:Add(self.Exit, self);
    self.TabList.OnUpdateItem:Add(self.TabListUpdate, self);
    self.GunsList.OnUpdateItem:Add(self.GunsListUpdate, self);
end

function GunsMain:Exit()
    self:SetVisibility(ESlateVisibility.Collapsed);
end

function GunsMain:Open()
    ugcprint('OPen -----------------')
     self:SetVisibility(ESlateVisibility.Visible);
     self:Reload(0, GunsManager.GunsType[1].Type);
end

--- @param DefineId FItemDefineID
--- @param FilterType string
function GunsMain:Reload(DefineId, FilterType)
    FilterType = FilterType or GunsManager.GunsType[1].Type;
    self.Filter = self:FilterGuns(FilterType);
    if DefineId == nil or DefineId == 0 then
        DefineId = self.Filter[1];
    end
    GunsManager.DefineId = DefineId;
    GunsManager.FilterType = FilterType;
    self.TabList:Reload(#GunsManager.GunsType);
    self.GunsList:Reload(#self.Filter);
    self:SetPreview(DefineId);
end

function GunsMain:FilterGuns(FilterType)
    if FilterType == 'ALL' then
        local allList = {}
        local categories = {"Rifle", "SMG", "LMG", "Shotgun", "Snipe", "Pistol"}
        for _, catName in ipairs(categories) do
            local cat = ItemCfg.FirearmPurchase[catName]
            if cat then
                for _, item in ipairs(cat) do
                    allList[#allList + 1] = item
                end
            end
        end
        return allList
    end
    return ItemCfg.FirearmPurchase[FilterType] or {};
end

function GunsMain:SetPreview(Item)
    local path = UGCItemSystemV2.GetItemIconTextureV2(Item.ItemId)
    local ItemName = UGCItemSystemV2.GetItemNameV2(Item.ItemId);
    self:AsyncSetTexture(path, self.ItemImage);
    self.ItemName:SetText(ItemName);
    self.Button_1:SetVisibility(ESlateVisibility.Visible);
    self.Button_2:SetVisibility(ESlateVisibility.Collapsed);
    self.Button_1:SetIsEnabled(false);

end

function GunsMain:TabListUpdate(Item, Index)
    local tab = GunsManager.GunsType[Index + 1];
    if tab == nil then
        return;
    end
    Item:SetDAT(Index, tab.Text);
    Item:SetSelected(GunsManager.FilterType == tab.Type);
end

function GunsMain:GunsListUpdate(Item, Index)
    local defineID = self.Filter[Index + 1];
    if defineID == nil then
        Item:SetEmpty();
        return;
    end
    Item:SetDefineID(defineID);
    Item:SetSelected(GunsManager.DefineId);
end

function GunsMain:AsyncSetTexture(path, UI)
    Common.LoadObjectWithSoftPathAsync(path,
         function (PATH)
             if self == nil or PATH == nil then
                 return;
             end
             UI:SetBrushFromTexture(PATH);
         end
    );
end

return GunsMain