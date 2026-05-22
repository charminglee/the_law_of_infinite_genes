---@class Lottery_Exchange_Main_UIBP_C:UUserWidget
---@field Button_ExchangeClose UButton
---@field Lottery_Currency_01 ULottery_Currency_UIBP_C
---@field Lottery_Exchange_List UUGC_ReuseList2_C
---@field ScaleBox_IPX UScaleBox
---@field TextBlock_Exchange_Tips UTextBlock
---@field TextBlock_Title UTextBlock
--Edit Below--


local Lottery_Exchange_Main_UIBP = { bInitDoOnce = false } 

function Lottery_Exchange_Main_UIBP:Construct()
    self:InitBindEvent();
    self.ExchangeItem = {};
end

-- function Lottery_Exchange_Main_UIBP:Tick(MyGeometry, InDeltaTime)

-- end

-- function Lottery_Exchange_Main_UIBP:Destruct()

-- end

function Lottery_Exchange_Main_UIBP:InitBindEvent()
    self.Button_ExchangeClose.OnClicked:Add(self.Close, self);
    self.Lottery_Exchange_List.OnAfterNewItem:Add(self.InitItem, self);
end

function Lottery_Exchange_Main_UIBP:Close()
    self:SetVisibility(ESlateVisibility.Collapsed);
end

---@param Item Lottery_Exchange_Item_UIBP_C
---@param Index int32
function Lottery_Exchange_Main_UIBP:InitItem(Item, Index)
    print(string.format("Lottery_Exchange_Main_UIBP:InitItem Index: %d", Index));
    local ProductID = self.ItemList[Index + 1];
    self.ExchangeItem[ProductID] = Item;
    Item:Init(ProductID);
end

function Lottery_Exchange_Main_UIBP:GetExchangeProduct()
    local ItemList = LotteryManager:GetLotteryExchangeData();
    self.ItemList = {};
    for Index, Data in pairs(ItemList) do
        -- 判断是否上架
        if LotteryManager:IsProductShelves(Data.ProductID) then
            print(string.format("Lottery_Exchange_Main_UIBP:GetExchangeProduct ProductID: %d", Data.ProductID));
            table.insert(self.ItemList, Data.ProductID);
        end
    end
    print(string.format("Lottery_Exchange_Main_UIBP:InitData Num: %d", #self.ItemList));
end

function Lottery_Exchange_Main_UIBP:InitUI()
    self:GetExchangeProduct();
    self.Lottery_Exchange_List:Reload(#self.ItemList);
    self.Lottery_Currency_01:Refresh();
end

--- 重新获取可购买的商品(商品上架)
function Lottery_Exchange_Main_UIBP:RefreshExchangeInfo()
    print("[Lottery_Exchange_Main_UIBP]: RefreshExchangeInfo");
    self:GetExchangeProduct();
    self.Lottery_Exchange_List:Reload(#self.ItemList);
end

function Lottery_Exchange_Main_UIBP:RefreshPurchaseLimitInfo()
    print("[Lottery_Exchange_Main_UIBP]: RefreshPurchaseLimitInfo");
    -- 刷新兑换道具的状态
    for ProductID, Item in pairs(self.ExchangeItem) do
        Item:RefreshPurchaseTime();
    end
end

return Lottery_Exchange_Main_UIBP
