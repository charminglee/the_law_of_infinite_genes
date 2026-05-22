---@class Lottery_AwardShow_UIBP_C:UUserWidget
---@field Button_Close UButton
---@field CanvasPanel_UI UCanvasPanel
---@field Lottery_AwardItemList UUGC_ReuseList2_C
---@field Lottery_DescShop_UIBP ULottery_DescShop_UIBP_C
---@field ScaleBox_IPX UScaleBox
--Edit Below--
local Lottery_AwardShow_UIBP = { bInitDoOnce = false } 

function Lottery_AwardShow_UIBP:Construct()
    self:InitBindEvent();
    self.ItemList = {};
    self.SelectedItemID = -1;
end

-- function Lottery_AwardShow_UIBP:Tick(MyGeometry, InDeltaTime)

-- end

-- function Lottery_AwardShow_UIBP:Destruct()

-- end

function Lottery_AwardShow_UIBP:InitBindEvent()
    self.Button_Close.OnClicked:Add(self.Close, self)
    self.Lottery_AwardItemList.OnAfterNewItem:Add(self.InitAward, self);
end

function Lottery_AwardShow_UIBP:Close()
    self:SetVisibility(ESlateVisibility.Collapsed);
end

function Lottery_AwardShow_UIBP:InitUI(LotteryID)
    --- 数据有重复
    self.ItemIDList = LotteryManager:GetLotteryAwardData(LotteryID);
    -- self:RemoveDuplicateData(ItemIDList);
    self.Lottery_AwardItemList:Reload(#self.ItemIDList)
    print(string.format("Lottery_AwardShow_UIBP:InitUI LotteryID: %d ItemNum: %d", LotteryID, #self.ItemIDList));
end

function Lottery_AwardShow_UIBP:RemoveDuplicateData(ItemIDList)
    self.ItemIDList = {};
    local temp = {};
    for _, ItemID in pairs(ItemIDList) do
        if temp[ItemID] == nil then
            table.insert(self.ItemIDList, ItemID);
            temp[ItemID] = true;
        end
    end
end

function Lottery_AwardShow_UIBP:InitAward(AwardItem, Index)
    AwardItem:InitUI(self.ItemIDList[Index + 1], false, true);
    self.ItemList[self.ItemIDList[Index + 1]] = AwardItem;
    if Index == 0 then
        AwardItem:Select();
        self:SelectItem(self.ItemIDList[Index + 1]);
        self.SelectedItemID = self.ItemIDList[Index + 1];
    else
        AwardItem:UnSelect();
    end
end

function Lottery_AwardShow_UIBP:SelectItem(ItemID)
    if ItemID == self.SelectedItemID then
        return;
    end
    if self.ItemList[self.SelectedItemID] then
        self.ItemList[self.SelectedItemID]:UnSelect();
    end
    if self.ItemList[ItemID] then
        self.ItemList[ItemID]:Select();
        self.SelectedItemID = ItemID;
        self.Lottery_DescShop_UIBP:RefreshUI(ItemID);
    end
end

return Lottery_AwardShow_UIBP