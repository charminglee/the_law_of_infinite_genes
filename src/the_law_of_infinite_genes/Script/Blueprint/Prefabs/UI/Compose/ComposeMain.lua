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
}
function ComposeMain:Construct()
	self:LuaInit();
end
function ComposeMain:Tick(MyGeometry, InDeltaTime)
    if self.SelectedItemId ~= ComposeManager.SelectedItemId then
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
end
function ComposeMain:GoodsListUpdate(Item, Index)
end
function ComposeMain:ReloadMaterial(ItemId)
    local Formula = self:GetFormula(ItemId);
    local DisplayList = {true, false, true, false, false, false};
    if Formula[3] ~= nil then
        DisplayList[2] = true;
        DisplayList[5] = true;
        if Formula[4] ~= nil then
            DisplayList[6] = true;
        end
    end
    if Formula[2] ~= nil then
        DisplayList[4] = true;
    end
    self:SetMaterialVisible(DisplayList);
end

function ComposeMain:GetFormula(ItemId)
    return {
        [1] = {ItemId=8310004, number=0},
        [2] = {ItemId=8310004, number=0},
        [3] = {ItemId=8310004, number=0},
        [4] = {ItemId=8310004, number=0},
    };
end

---@param List table
function ComposeMain:SetMaterialVisible(List)
    self.MaterialBox1:SetVisibility(List[1]);
    self.MaterialBox2:SetVisibility(List[2])
    self.MaterialItem1:SetVisibility(List[3])
    self.MaterialItem2:SetVisibility(List[4])
    self.MaterialItem3:SetVisibility(List[5])
    self.MaterialItem4:SetVisibility(List[6])
end
return ComposeMain