---@class ComposeMain_C:UAEUserWidget
---@field Button_0 UButton
---@field Button_1 UButton
---@field CountText UTextBlock
---@field DecreaseButton UButton
---@field Goods UCanvasPanel
---@field GoodsList ReuseList2_C
---@field Increase100Button UButton
---@field Increase10Button UButton
---@field IncreaseButton UButton
---@field ItemDesc UTextBlock
---@field ItemName UTextBlock
---@field MaterialBox1 UHorizontalBox
---@field MaterialBox2 UHorizontalBox
---@field MaterialItem1 ComposeGoodsItem_C
---@field MaterialItem2 ComposeGoodsItem_C
---@field MaterialItem3 ComposeGoodsItem_C
---@field MaterialItem4 ComposeGoodsItem_C
---@field Preview UCanvasPanel
---@field SelectItem UImage
---@field SelectQuality UImage
---@field TabList ReuseList2_C
--Edit Below--
local ComposeMain = {
    bInitDoOnce = false,
    Counter = 1,
    SelectedItemId = nil,
    TabSelectedIndex = nil;
    GoodSelectedIndex = nil;
}
function ComposeMain:Construct()
	self:LuaInit();
    self.Counter:SetVisibility()
end

function ComposeMain:SetPreviewVisibility(Visible)
    if Visible then
        self.Preview:SetVisibility(ESlateVisibility.Visible);
    else
        self.Preview:SetVisibility(ESlateVisibility.Collapsed);
    end
end

function ComposeMain:Tick(MyGeometry, InDeltaTime)
    if self.SelectedItemId ~= ComposeManager.SelectedItemId then
    end
    if self.GoodSelectedIndex == nil then
        self:SetPreviewVisibility(false);
    end
    if self.TabSelectedIndex ~= ComposeManager.TabSelectedIndex then
        self.TabSelectedIndex = ComposeManager.TabSelectedIndex;
        self.TabList:Reload(#ItemCfg.ItemDef);
        self.GoodsList:Reload(#ItemCfg.ItemTable[self.TabSelectedIndex]);
    end
    if self.GoodSelectedIndex ~= ComposeManager.GoodSelectedIndex then
        self:SetPreviewVisibility(true);
        self.GoodSelectedIndex = ComposeManager.GoodSelectedIndex;
        self.GoodsList:Reload(#ItemCfg.ItemTable[self.TabSelectedIndex]);
        local ItemId = ItemCfg.ItemTable[self.TabSelectedIndex][self.GoodSelectedIndex+1]
        self:ReloadMaterial(ItemId);
        self:RefreshPreview(ItemId);
    end
end
function ComposeMain:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self:Listen();
    ComposeManager:RegisterMainUI(self);
end
function ComposeMain:Listen()
    self.Button_0.OnClicked:Add(self.Exit, self);
    self.Button_1.OnClicked:Add(self.ComposeClicked, self);
    self.DecreaseButton.OnClicked:Add(self.DecreaseButtonClicked, self);
    self.Increase10Button.OnClicked:Add(self.Increase10ButtonClicked, self);
    self.Increase100Button.OnClicked:Add(self.Increase100ButtonClicked, self);
    self.IncreaseButton.OnClicked:Add(self.IncreaseButtonClicked, self);
    self.TabList.OnUpdateItem:Add(self.TabListUpdate, self);
    self.GoodsList.OnUpdateItem:Add(self.GoodsListUpdate, self);
end
function ComposeMain:Exit()
    ComposeManager:CloseMainUI();
end
function ComposeMain:ComposeClicked()
end
function ComposeMain:DecreaseButtonClicked()
end
function ComposeMain:Increase10ButtonClicked()
end
function ComposeMain:Increase100ButtonClicked()
end
function ComposeMain:IncreaseButtonClicked()
end
function ComposeMain:TabListUpdate(Item, Index)
    Item.Index = Index+1;
    Item.ItemName:SetText(ItemCfg.ItemDef[Index+1]);
    if Index+1 == self.TabSelectedIndex then
        Item:SetSelected(true);
    else
        Item:SetSelected(false);
    end
end
function ComposeMain:GoodsListUpdate(Item, Index)
    Item.Index = Index;
    local ItemId = ItemCfg.ItemTable[self.TabSelectedIndex][Index+1];
    Item:SetGoodItem(ItemId);
    if self.GoodSelectedIndex == Index then
        Item:SetSelected(true);
    else
        Item:SetSelected(false);
    end
end

function ComposeMain:HasContent(val)
    return val ~= nil;
end

function ComposeMain:ReloadMaterial(ItemId)
    local Formula = self:GetFormula(ItemId);
    local DisplayList = {
        group = {false, false},
        item = {false, false, false, false},
    };
    local Item1 = ItemCfg.Formula[ItemId][1];
    local Item2 = ItemCfg.Formula[ItemId][2];
    local Item3 = ItemCfg.Formula[ItemId][3];
    local Item4 = ItemCfg.Formula[ItemId][4];

    DisplayList.item[1] = self:HasContent(Item1);
    DisplayList.item[2] = self:HasContent(Item2);
    DisplayList.item[3] = self:HasContent(Item3);
    DisplayList.item[4] = self:HasContent(Item4);

    DisplayList.group[1] = DisplayList.item[1] or DisplayList.item[2];
    DisplayList.group[2] = DisplayList.item[3] or DisplayList.item[4];
    UGCLog.Log(DisplayList);
    self:SetMaterialVisible(DisplayList);
    self:SetMaterialItem(self.MaterialItem1, Item1);
    self:SetMaterialItem(self.MaterialItem2, Item2);
    self:SetMaterialItem(self.MaterialItem3, Item3);
    self:SetMaterialItem(self.MaterialItem4, Item4);
end

function ComposeMain:RefreshPreview(ItemId)
    local ItemName = UGCItemSystemV2.GetItemNameV2(ItemId);
    self.ItemName:SetText(ItemName);
    local ItemPath = UGCItemSystemV2.GetItemIconTextureV2(ItemId);
    local Texture = LoadObject(ItemPath.AssetPathName);
    self.SelectItem:SetBrushFromTexture(Texture);
    local customType = UGCItemSystemV2.GetItemCustomizedTypeV2(ItemId);
    local Q = 1;
    if tonumber(customType) > 5 then
        Q = UGCItemSystemV2.GetItemQualityV2(ItemId);
    else
        Q = 1;
    end
    local QPath = ItemCfg.ItemQuality[Q].path;
    local QTexture = LoadObject(QPath);
    self.SelectQuality:SetBrushFromTexture(QTexture);
    local Detail = UGCItemSystemV2.GetItemDetailV2(ItemId);
    self.ItemDesc:SetText(Detail);
end

function ComposeMain:SetMaterialItem(item, dat)
    if dat == nil then
        return;
    end
    item:SetMaterial(dat);
end

function ComposeMain:GetFormula(ItemId)
    local f = ItemCfg.Formula[ItemId]
    if f ~= nil then
        return f
    else
        return {}
    end
end

---@param List table
function ComposeMain:SetMaterialVisible(List)
    self.MaterialBox1:SetVisibility(self:TransformBool(List.group[1]));
    self.MaterialBox2:SetVisibility(self:TransformBool(List.group[2]));

    self.MaterialItem1:SetVisibility(self:TransformBool(List.item[1]));
    self.MaterialItem2:SetVisibility(self:TransformBool(List.item[2]));
    self.MaterialItem3:SetVisibility(self:TransformBool(List.item[3]));
    self.MaterialItem4:SetVisibility(self:TransformBool(List.item[4]));
end

function ComposeMain:TransformBool(Bool)
    if Bool then
        return ESlateVisibility.Visible;
    else
        return ESlateVisibility.Collapsed;
    end
end
return ComposeMain