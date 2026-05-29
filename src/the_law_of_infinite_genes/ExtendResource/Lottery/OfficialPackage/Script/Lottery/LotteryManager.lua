---@type UKismetMathLibrary
KismetMathLibrary = KismetMathLibrary == nil and nil or KismetMathLibrary

ELotteryPanelType = ELotteryPanelType or
{
    One = 0;
    Two = 1;
}
local Delegate = UGCGameSystem.UGCRequire("common.Delegate");

LotteryManager = LotteryManager or
{
    LotteryDatas = nil,
    DropDatas = nil,
    DropGroupDatas = nil,
    LotteryAwardDatas = nil,
    LotteryExchangeDatas = nil,
    OnItemNumChangeDelegate = Delegate.New(),
    OnAddGiftPackageDelegate = Delegate.New(),
    OnDrawLotteryOnceDelegate = Delegate.New(),
    OnDrawLotteryTenTimesDelegate = Delegate.New(),
    OnExchangeProductDelegate = Delegate.New(),
}

---@class ItemConfigData
local ItemConfigData = 
{
    ItemID   = nil,
    ItemName = nil,
    ItemDesc = nil,
    ItemIcon = nil,
}

---@class ProductConfigData
local ProductConfigData = 
{
    ProductID               = nil,
    ProductName             = nil,
    ItemID                  = nil,
    ItemNum                 = nil,
    CostID                  = nil,
    AvailableForSale        = nil,
    LimitType               = nil,
    SellingPrice            = nil,
    PurchaseLimit           = nil,
    ListingTime             = nil,
    DelistingTime           = nil,
    SortPriority            = nil,
    StoreID                 = nil,
    TabID                   = nil,
    DiscountStartTime       = nil,
    DiscountEndTime         = nil,
    Discount                = nil,
    CurrencyType            = nil,
    ProductType             = nil,
}

---@class LotteryConfigData
local LotteryConfigData = 
{
    ID                              = nil,
    MaxGiftNum                      = nil,
    LotteryRule                     = nil,
    DailyDrawLimit                  = nil,
    DailyDrawGroup                  = nil,
    OverrideDropID                  = nil,
    DropGroupID                     = nil,
    DrawCostID                      = nil,
    CurrencyType                    = nil,
    TenDrawCostNum                  = nil,
    OverrideGuarantDropID           = nil,
    GuarantDropGroupID              = nil,
    IsFirstDrawDiscountOpen         = nil,
    FirstDrawDiscountCost           = nil,
    FirstDrawDiscountResetType      = nil,
    OverrideFirstDrawGuarantDropID  = nil,
    FirstDrawGuarantDropGroupID     = nil,
    FirstDrawGuarantResetType       = nil,
    OneDrawCostNum                  = nil,
    Name                            = nil,
    Icon                            = nil,
}

function LotteryManager:RegisterComponentClass(CompClass)
    if CompClass ~= nil then
        self.LotteryComponentClass = CompClass;
    end
end

--获取玩家的RankingListComponent
--生效范围：客户端&&服务端
---@param PlayerController BP_UGCPlayerController_C
---@return LotteryComponent_C
function LotteryManager:GetLotteryComponent(PlayerController)
    if PlayerController == nil and UGCGameSystem.GameState:HasAuthority() == false then
        if self.LotteryComponent == nil then
            if self.LotteryComponentClass ~= nil and UGCGameSystem.GameState ~= nil then
                local PlayerController = STExtraGameplayStatics.GetFirstPlayerController(UGCGameSystem.GameState);
                self.LotteryComponent = PlayerController:GetComponentByClass(self.LotteryComponentClass);
            else
                print("[LotteryManager:GetLotteryComponent] Cannot get local component!");
            end
        end
           
        return self.LotteryComponent;
    end

    if self.LotteryComponentClass ~= nil then
        return PlayerController:GetComponentByClass(self.LotteryComponentClass);
    else
        print("[LotteryManager:GetLotteryComponent] ComponentClass is nil!");
        return nil;
    end
end

function LotteryManager:OpenLotteryPanel()
    self:GetLotteryComponent():OpenPanel();
end

function LotteryManager:CloseLotteryPanel()
    self:GetLotteryComponent():ClosePanel();
end

--获取抽奖表格数据
function LotteryManager:GetLotteryData()
    if self.LotteryDatas ~= nil then
        return self.LotteryDatas;
    end

    local LotteryTable = UGCGameSystem.GetTableData("Data/Table/UGCLottery");
    self.LotteryDatas = {};
    self.LotteryAwardDatas = {};
    local LotteryIDs = {};
    if LotteryTable then
        for Idx, Lottery in pairs(LotteryTable) do
            local LotteryData = {}
            -- 剔除ID重复的奖池
            if LotteryIDs[Lottery.ID] == nil then
                LotteryIDs[Lottery.ID] = true;
                --- 拆成基本数据类型
                LotteryData.GiftProgressRewards = {};
                for Index, Value in pairs(Lottery.GiftProgressRewards) do
                    LotteryData.GiftProgressRewards[Index] = {Progress = Value.Progress, Desc = Value.Desc, ItemList = {}}
                    for i, ItemInfo in pairs(Value.ItemList) do
                        table.insert(LotteryData.GiftProgressRewards[Index].ItemList, {ItemID = ItemInfo.ItemID, ItemCount = ItemInfo.ItemCount});
                    end
                end
                LotteryData.ID                              = Lottery["ID"];
                LotteryData.MaxGiftNum                      = Lottery["MaxGiftNum"];
                LotteryData.LotteryRule                     = Lottery["LotteryRule"];
                LotteryData.DailyDrawLimit                  = Lottery["DailyDrawLimit"];
                LotteryData.DailyDrawGroup                  = Lottery["DailyDrawGroup"];
                LotteryData.OverrideDropID                  = Lottery["OverrideDropID"];
                LotteryData.DropGroupID                     = Lottery["DropGroupID"];
                LotteryData.DrawCostID                      = Lottery["DrawCostID"];
                LotteryData.CurrencyType                    = Lottery["CurrencyType"];
                LotteryData.TenDrawCostNum                  = Lottery["TenDrawCostNum"];
                LotteryData.OverrideGuarantDropID           = Lottery["OverrideGuarantDropID"];
                LotteryData.GuarantDropGroupID              = Lottery["GuarantDropGroupID"];
                LotteryData.IsFirstDrawDiscountOpen         = Lottery["IsFirstDrawDiscountOpen"];
                LotteryData.FirstDrawDiscountCost           = Lottery["FirstDrawDiscountCost"];
                LotteryData.FirstDrawDiscountResetType      = Lottery["FirstDrawDiscountResetType"];
                LotteryData.OverrideFirstDrawGuarantDropID  = Lottery["OverrideFirstDrawGuarantDropID"];
                LotteryData.FirstDrawGuarantDropGroupID     = Lottery["FirstDrawGuarantDropGroupID"];
                LotteryData.FirstDrawGuarantResetType       = Lottery["FirstDrawGuarantResetType"];
                LotteryData.OneDrawCostNum                  = Lottery["OneDrawCostNum"];
                LotteryData.Name                            = Lottery["Name"];
                LotteryData.Icon                            = Lottery["Icon"].AssetPathName;
                
                if self.DropDatas == nil then
                    self:GetDropData();
                end
                if self.DropGroupDatas == nil then
                    self:GetDropGroupData(); 
                end
                local AwardList = {};
                if LotteryData.OverrideDropID and self.DropDatas[LotteryData.OverrideDropID] ~= nil then
                    local ItemList = self:GetDropDataByID(LotteryData.OverrideDropID);
                    table.move(ItemList, 1, #ItemList, #AwardList + 1, AwardList);
                elseif LotteryData.DropGroupID and self.DropGroupDatas[LotteryData.DropGroupID] ~= nil then
                    local ItemList = self:GetDropGroupDataByID(LotteryData.DropGroupID);
                    table.move(ItemList, 1, #ItemList, #AwardList + 1, AwardList);
                end
                
                if LotteryData.OverrideGuarantDropID and self.DropDatas[LotteryData.OverrideGuarantDropID] then
                    local ItemList = self:GetDropDataByID(LotteryData.OverrideGuarantDropID);
                    table.move(ItemList, 1, #ItemList, #AwardList + 1, AwardList);
                elseif LotteryData.GuarantDropGroupID and self.DropGroupDatas[LotteryData.GuarantDropGroupID] then
                    local ItemList = self:GetDropGroupDataByID(LotteryData.GuarantDropGroupID);
                    table.move(ItemList, 1, #ItemList, #AwardList + 1, AwardList);
                end
    
                if LotteryData.IsFirstDrawDiscountOpen then
                    if LotteryData.OverrideFirstDrawGuarantDropID and self.DropDatas[LotteryData.OverrideFirstDrawGuarantDropID] then
                        local ItemList = self:GetDropDataByID(LotteryData.OverrideFirstDrawGuarantDropID);
                        table.move(ItemList, 1, #ItemList, #AwardList + 1, AwardList);
                    elseif LotteryData.FirstDrawGuarantDropGroupID and self.DropGroupDatas[LotteryData.FirstDrawGuarantDropGroupID] then
                        local ItemList = self:GetDropGroupDataByID(LotteryData.FirstDrawGuarantDropGroupID);
                        table.move(ItemList, 1, #ItemList, #AwardList + 1, AwardList);
                    end
                end
                --- 去重
                local ItemIDList = {};
                local temp = {};
                for _, ItemID in pairs(AwardList) do
                    if temp[ItemID] == nil then
                        table.insert(ItemIDList, ItemID);
                        temp[ItemID] = true;
                    end
                end
                self.LotteryAwardDatas[LotteryData.ID] = ItemIDList;
                table.insert(self.LotteryDatas, LotteryData);
            end
        end
    end
    return self.LotteryDatas;
end

function LotteryManager:GetLotteryExchangeData()
    if self.LotteryExchangeDatas ~= nil and next(self.LotteryExchangeDatas) ~= nil then
        return self.LotteryExchangeDatas;
    end

    local ExchangeTabID = self:GetLotteryComponent().ExchangeItemTabID;
    local Table = self:GetAllProductData();
    log_tree("LotteryManager:GetLotteryExchangeData ProductData", Table);
    self.LotteryExchangeDatas = {};
    for i, Data in pairs(Table) do
        -- 页签为碎片兑换页签、可售卖、属于战斗内的商品
        if Data.TabID == ExchangeTabID and Data.AvailableForSale ~= EAvailableForSale.NotForSale and Data.StoreID == EStoreId.InGame then
            table.insert(self.LotteryExchangeDatas, Data);
        end
    end

    table.sort(self.LotteryExchangeDatas, function(a, b)
        return a.SortPriority < b.SortPriority;
    end);

    log_tree("LotteryManager:GetLotteryExchangeData LotteryExchangeDatas", self.LotteryExchangeDatas);
    return self.LotteryExchangeDatas;
end

--获取奖池奖励列表
function LotteryManager:GetLotteryAwardData(LotteryID)
    if self.LotteryAwardDatas == nil then
        self:GetLotteryData();
    end

    return self.LotteryAwardDatas[LotteryID];
end

function LotteryManager:GetDropData()
    if self.DropDatas ~= nil then
        return self.DropDatas;
    end
    self.DropDatas = {};
    local DropTable = UGCGameSystem.GetTableData("Data/Table/UGCDrop");
    if DropTable then
        for ID, Value in pairs(DropTable) do
            ID = tonumber(ID);
            self.DropDatas[ID] = {};
            if Value.DropItemInfo then
                for Index, Info in pairs(Value.DropItemInfo) do
                    table.insert(self.DropDatas[ID], Info.ItemID);
                end
            end
        end
    end
    return self.DropDatas;
end

function LotteryManager:GetDropDataByID(DropID)
    if self.DropDatas == nil then
        self:GetDropData();
    end

    return self.DropDatas[DropID];
end

function LotteryManager:GetDropGroupData()
    if self.DropGroupDatas ~= nil then
        return self.DropGroupDatas;
    end
    self.DropGroupDatas = {};
    local DropGroupTable = UGCGameSystem.GetTableData("Data/Table/UGCDropGroup");
    if DropGroupTable then
        for ID, Value in pairs(DropGroupTable) do
            ID = tonumber(ID);
            self.DropGroupDatas[ID] = {}
            if Value.DropGroupItemInfo then
                for Index, Info in pairs(Value.DropGroupItemInfo) do
                    local DropID = Info.DropID;
                    local ItemList = self:GetDropDataByID(DropID);
                    table.move(ItemList, 1, #ItemList, #self.DropGroupDatas[ID] + 1, self.DropGroupDatas[ID]);
                end
            end
        end
    end
    return self.DropGroupDatas;
end

function LotteryManager:GetDropGroupDataByID(DropGroupID)
    if self.DropGroupDatas == nil then
        self:GetDropGroupData();
    end

    return self.DropGroupDatas[DropGroupID];
end

function LotteryManager:GetLotteryInfo(LotteryID)
    return self:GetLotteryComponent():GetLotteryInfo(LotteryID);
end

--选择道具预览
--生效范围：客户端
function LotteryManager:SelectItem(ItemID)
    self:GetLotteryComponent():SelectItem(ItemID);
end

--刷新道具预览
--生效范围：客户端
function LotteryManager:RefreshAwardPreview(LotteryID)
    self:GetLotteryComponent():RefreshAwardPreview(LotteryID);
end

--获取当前奖池数据
--生效范围：客户端
function LotteryManager:GetCurLotteryData()
    local LotteryID = self:GetLotteryComponent():GetCurLotteryID();
    return self:GetLotteryConfigData(LotteryID);
end

--打开道具购买UI
--生效范围：客户端
function LotteryManager:OpenPurchaseProductUI(ProductID)
    self:GetLotteryComponent():OpenPurchaseProductUI(ProductID);
end

--打开道具兑换UI
--生效范围：客户端
function LotteryManager:OpenExchangeProductUI(ProductID)
    self:GetLotteryComponent():OpenExchangeProductUI(ProductID);
end

--判断商品是否可兑换
--生效范围：客户端
function LotteryManager:CanExchangeProduct(ProductID)
    local ProductData = self:GetProductConfigData(ProductID);
    if ProductData then
        local CurrencyID = ProductData.CostID;
        local CurrencyNum = self:GetPlayerOwnedItemNum(CurrencyID);
        local FinalPrice = LotteryManager:GetDiscountPrice(ProductID);
        if CurrencyNum >= FinalPrice then
            return true;
        else
            return false;
        end
    end
    return false;
end

--判断商品是否上架
--生效范围：客户端
function LotteryManager:IsProductShelves(ProductID)
    local ProductData = self:GetLotteryComponent():GetProductDataByID(ProductID);
    if ProductData then
        if ProductData.AvailableForSale == EAvailableForSale.NotForSale then
            return false;
        end
        if ProductData.StoreID == EStoreId.Lobby then
            return false;
        end
        local CurrentTime = UGCGameSystem.GetServerTimeSec();
        local ListingTime = ProductData.ListingTime;
        return CurrentTime >= ListingTime;
    end
    return false;
end

--获取绿洲币Icon路径
--生效范围：客户端
function LotteryManager:GetOasisCoinIconPath()
    return self:GetLotteryComponent():GetOasisCoinIconPath();
end

--显示进度礼包道具Tip
--生效范围：客户端
function LotteryManager:OpenLotteryGiftProgressTipUI(Progress, Desc, ItemID, Position)
    self:GetLotteryComponent():OpenLotteryGiftProgressTipUI(Progress, Desc, ItemID, Position);
end

--显示道具Tip
--生效范围：客户端
function LotteryManager:OpenLotteryItemTipUI(ItemID, Pos)
    self:GetLotteryComponent():OpenLotteryItemTipUI(ItemID, Pos);
end

--打开提示UI
--生效范围：客户端
function LotteryManager:OpenLotteryMessageUI(Text)
    self:GetLotteryComponent():OpenLotteryMessageUI(Text);
end

--打开二次确认UI
--生效范围：客户端
function LotteryManager:OpenLotteryConfirmUI(Text, ConfirmBtnText, ConfirmFunc)
    self:GetLotteryComponent():OpenLotteryConfirmUI(Text, ConfirmBtnText, ConfirmFunc);
end

--关闭进度礼包道具Tip
--生效范围：客户端
function LotteryManager:CloseLotteryGiftProgressTipUI()
    self:GetLotteryComponent():CloseLotteryGiftProgressTipUI();
end

--关闭道具Tip
--生效范围：客户端
function LotteryManager:CloseLotteryItemTipUI()
    self:GetLotteryComponent():CloseLotteryItemTipUI();
end

--关闭提示UI
--生效范围：客户端
function LotteryManager:CloseLotteryMessageUI()
    self:GetLotteryComponent():CloseLotteryMessageUI();
end

--关闭二次确认UI
--生效范围：客户端
function LotteryManager:CloseLotteryConfirmUI()
    self:GetLotteryComponent():CloseLotteryConfirmUI();
end

--领取进度礼包
--生效范围：客户端
function LotteryManager:GetProgressItem(LotteryID, Progress)
    self:GetLotteryComponent():GetProgressItem(LotteryID, Progress);
end

--存储跳过动画设置
--生效范围：客户端
function LotteryManager:WriteSkipAnim(IsSkipAnim)
    self:GetLotteryComponent():WriteSkipAnim(IsSkipAnim);
end

--获取跳过动画设置
--生效范围：客户端
function LotteryManager:GetSkipAnim()
    return self:GetLotteryComponent():GetSkipAnim();
end

--获取进度礼包领取状态
--生效范围：客户端
function LotteryManager:CheckGiftProgressGet(LotteryID, Progress)
    return self:GetLotteryComponent():CheckGiftProgressGet(LotteryID, Progress);
end

--判断是否有首抽保底
--生效范围：客户端
function LotteryManager:HasFirstDrawGuarant(LotteryID) 
    return self:GetLotteryComponent():HasFirstDrawGuarant(LotteryID);
end

--判断是否有首抽折扣
--生效范围：客户端
function LotteryManager:CheckHasFirstDrawDiscount(LotteryID) 
    local LotteryData = self:GetLotteryConfigData(LotteryID);
    return self:GetLotteryComponent():CheckHasFirstDrawDiscount(LotteryID, LotteryData.FirstDrawDiscountResetType);
end

function LotteryManager:GetLegalStr(Str, Len)
    local hasIllegalChar, unitLen, retStr, isTruncate = FuncUtil:CheckName(Str, true, Len, 1);
    return retStr;
end

function LotteryManager:GetDiscountPrice(ProductID)
    return UGCCommoditySystem.GetSellingPriceAfterDiscount(ProductID);
end

function LotteryManager:GetOasisIconPath()
    return KismetSystemLibrary.BreakSoftObjectPath(self:GetLotteryComponent().OasisCoinIconPath);
end

function LotteryManager:IsPermanentDiscount(EndTime)
    local Date = os.date("*t", EndTime);
    return Date.year >= 3000;
end

--获取到截止日期的剩余天数
--生效范围：客户端&&服务端
function LotteryManager:GetRemainingDays(EndTime)
    local RemainingSec = EndTime - UGCGameSystem.GetServerTimeSec();
    return RemainingSec > 0 and math.floor(RemainingSec / 3600 / 24) or 0; 
end

function LotteryManager:BuyProduct(ProductID, Price, Num)
    self:GetLotteryComponent():BuyProduct(ProductID, Price, Num);
end

function LotteryManager:ExchangeProduct(ProductID, Num)
    self:GetLotteryComponent():ExchangeProduct(ProductID, Num);
end

function LotteryManager:PurchaseProduct(ProductID, Price, Num)
    self:GetLotteryComponent():PurchaseProduct(ProductID, Price, Num);
end

function LotteryManager:OpenLotteryAwardRecord()
    self:GetLotteryComponent():OpenLotteryAwardRecord();
end

function LotteryManager:OpenLotteryAwardPreview()
    self:GetLotteryComponent():OpenLotteryAwardPreview();
end

function LotteryManager:OpenLotteryExchange()
    self:GetLotteryComponent():OpenLotteryExchange();
end

function LotteryManager:OpenLotteryExplanation(LotteryExplanation)
    self:GetLotteryComponent():OpenLotteryExplanation(LotteryExplanation);
end

function LotteryManager:CloseLotteryDrawDisplayUI()
    self:GetLotteryComponent():CloseLotteryDrawDisplayUI();
end

function LotteryManager:CanAfford(ProductID, Num)
    return self:GetLotteryComponent():CanAfford(ProductID, Num);
end

function LotteryManager:GetCommodityOperationManager()
    if self.CommodityOperationManager == nil then
        self.CommodityOperationManager = UGCBlueprintFunctionLibrary.GetGamePartGlobalActor(UGCGameSystem.GameState, "CommodityOperationManager");
    end
    return self.CommodityOperationManager;
end

function LotteryManager:GetVirtualItemManager()
    if self.VirtualItemManager == nil then
        self.VirtualItemManager = UGCBlueprintFunctionLibrary.GetGamePartGlobalActor(UGCGameSystem.GameState, "VirtualItemManager");
    end
    return self.VirtualItemManager;
end

function LotteryManager:GetAllProductData()
    local CommodityOperationManager = self:GetCommodityOperationManager();
    if CommodityOperationManager then
        return CommodityOperationManager:GetAllProductData();
    end
    return {};
end

--抽奖一次
--生效范围：客户端
function LotteryManager:DrawOnce(LotteryID)
    self:GetLotteryComponent():DrawOnce(LotteryID);
end

--抽奖十次
--生效范围：客户端
function LotteryManager:DrawTenth(LotteryID)
    self:GetLotteryComponent():DrawTenth(LotteryID);
end

----------------------------------------- API接口 -----------------------------------------
---打开/关闭抽奖主界面
---生效范围：客户端
---@param bVisible boolean
function LotteryManager:SetLotteryPanelVisible(bVisible)
    if bVisible then
        self:GetLotteryComponent():OpenPanel();
    else
        self:GetLotteryComponent():ClosePanel();
    end
end

---获取指定物品配置数据
---生效范围：客户端&&服务端
---@param ItemID number
---@return ItemConfigData
function LotteryManager:GetItemConfigData(ItemID)
    local VirtualItemManager = self:GetVirtualItemManager();
    if VirtualItemManager then
        return VirtualItemManager:GetItemData(ItemID);
    end
    return nil;
end

---获取指定商品配置数据
---生效范围：客户端&&服务端
---@param ProductID number
---@return ProductConfigData
function LotteryManager:GetProductConfigData(ProductID)
    local CommodityOperationManager = self:GetCommodityOperationManager();
    if CommodityOperationManager then
        return CommodityOperationManager:GetProductData(ProductID);
    end
    return nil;
end

---获取指定奖池配置数据
---生效范围：客户端&&服务端
---@param LotteryID number
---@return LotteryConfigData
function LotteryManager:GetLotteryConfigData(LotteryID)
    if self.LotteryDatas == nil then
        self:GetLotteryData();
    end
    for Index, LotteryData in pairs(self.LotteryDatas) do
        if LotteryID == LotteryData.ID then
            return LotteryData;
        end
    end
end

---切换奖池页签
---生效范围：客户端
---@param LotteryID number
function LotteryManager:SwitchLotteryTab(LotteryID)
    self:GetLotteryComponent():SelectLottery(LotteryID);
end

---获取玩家在指定奖池当天已抽奖的次数
---生效范围：客户端&&服务端
---@param LotteryID number
---@param PlayerController BP_UGCPlayerController_C
---@return number
function LotteryManager:GetPlayerTodayDraws(LotteryID, PlayerController)
    return self:GetLotteryComponent(PlayerController):GetTodayDrawTimes(LotteryID);
end

---获取玩家在指定奖池的已抽奖总次数
---生效范围：客户端&&服务端
---@param LotteryID number
---@param PlayerController BP_UGCPlayerController_C
---@return number
function LotteryManager:GetPlayerTotalDraws(LotteryID, PlayerController)
    return self:GetLotteryComponent(PlayerController):GetTotalDrawTimes(LotteryID);
end

---获取道具数量
---生效范围：客户端&&服务端
---@param ItemID number
---@param PlayerController BP_UGCPlayerController_C
---@return number
function LotteryManager:GetPlayerOwnedItemNum(ItemID, PlayerController)
    local VirtualItemManager = self:GetVirtualItemManager();
    if VirtualItemManager then
        return VirtualItemManager:GetItemNum(ItemID, PlayerController);
    end
    return 0;
end

---获取商品被兑换的总次数
---生效范围：客户端&&服务端
---@param ProductID number
---@param PlayerController BP_UGCPlayerController_C
---@return number
function LotteryManager:GetProductRedeemedTimes(ProductID, PlayerController)
    local CommodityOperationManager = self:GetCommodityOperationManager();
    if CommodityOperationManager then
        return CommodityOperationManager:GetLimitPurchasedTimes(ProductID, PlayerController);
    end
    return 0;
end

---判断商品是否售罄
---生效范围：客户端&&服务端
---@param ProductID number
---@param PlayerController BP_UGCPlayerController_C
---@return boolean
function LotteryManager:IsProductSoldOut(ProductID, PlayerController)
    local ProductData = self:GetProductConfigData(ProductID);
    if ProductData then
        if ProductData.LimitType == ELimitType.NotLimited then
            return false;
        end
        local CurBuyNum = self:GetProductRedeemedTimes(ProductID, PlayerController);
        return CurBuyNum >= ProductData.PurchaseLimit;
    end
    return true;
end

---判断商品是否下架
---生效范围：客户端&&服务端
---@param ProductID number
---@return boolean
function LotteryManager:IsProductExpired(ProductID)
    local ProductData = self:GetProductConfigData(ProductID);
    if ProductData then
        if ProductData == EAvailableForSale.PermanentSale then
            return false;
        elseif ProductData == EAvailableForSale.NotForSale then
            return true;
        end
        local DelistingTime = ProductData.DelistingTime;
        local CurrentTime = UGCGameSystem.GetServerTimeSec();
        return CurrentTime > DelistingTime;
    end
    return true;
end

---通过抽奖组ID获取奖池ID列表
---生效范围：客户端&&服务端
---@param DrawGroup number
---@return any
function LotteryManager:GetLotteryIDByDrawGroup(DrawGroup)
    local LotteryIDList = {};
    if DrawGroup == 0 then
        return LotteryIDList;
    end
    if self.LotteryDatas == nil then
        self:GetLotteryData();
    end
    for Index, Data in pairs(self.LotteryDatas) do
        if Data.DailyDrawGroup == DrawGroup then
            table.insert(LotteryIDList, Data.ID);
        end
    end
    return LotteryIDList;
end

---获取商品对应的道具ID
---生效范围：客户端&&服务端
---@param ProductID number
---@return number
function LotteryManager:GetItemIDByProduct(ProductID)
    local ProductID = self:GetProductConfigData(ProductID);
    if ProductID then
        return ProductID.ItemID;
    end
    return -1;
end

---获取买赠礼包配置数据
---生效范围：客户端&&服务端
---@param LotteryID number
---@return any
function LotteryManager:GetGiftPackageConfigData(LotteryID)
    local GiftPackageConfig = {};
    local LotteryData = self:GetLotteryConfigData(LotteryID);
    for Index, Value in pairs(LotteryData.GiftProgressRewards) do
        GiftPackageConfig[Index] = {Progress = Value.Progress, ItemList = {}}
        for i, ItemInfo in pairs(Value.ItemList) do
            table.insert(GiftPackageConfig[Index].ItemList, {ItemID = ItemInfo.ItemID, ItemNum = ItemInfo.ItemCount});
        end
    end
    return GiftPackageConfig;
end

---领取买赠礼包
---生效范围：客户端&&服务端
---@param LotteryID number
---@param ProgressLevel number
---@param PlayerController BP_UGCPlayerController_C
function LotteryManager:AddGiftPackage(LotteryID, ProgressLevel, PlayerController)
    self:GetLotteryComponent(PlayerController):AddGiftPackage(LotteryID, ProgressLevel, PlayerController);
end

---兑换指定商品
---生效范围：客户端
---@param ProductID number
---@param Num number
function LotteryManager:RedeemProduct(ProductID, Num)
    self:GetLotteryComponent():ExchangeProduct(ProductID, Num);
end

---抽奖一次
---生效范围：客户端&&服务端
---@param LotteryID number
---@param PlayerController BP_UGCPlayerController_C
function LotteryManager:DrawLotteryOnce(LotteryID, PlayerController)
    self:GetLotteryComponent(PlayerController):DrawLotteryOnce(LotteryID, PlayerController);
end

---抽奖十次
---生效范围：客户端&&服务端
---@param LotteryID number
---@param PlayerController BP_UGCPlayerController_C
function LotteryManager:DrawLotteryTenTimes(LotteryID, PlayerController)
    self:GetLotteryComponent(PlayerController):DrawLotteryTenTimes(LotteryID, PlayerController);
end