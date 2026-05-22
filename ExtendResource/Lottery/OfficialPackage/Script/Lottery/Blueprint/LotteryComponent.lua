---@class LotteryComponent_C:ActorComponent
---@field LotteryMainUIPath FSoftClassPath
---@field LotteryModeOneUIPath FSoftClassPath
---@field LotteryModeTwoUIPath FSoftClassPath
---@field LotteryAwardPreviewUIPath FSoftClassPath
---@field LotteryExchangeUIPath FSoftClassPath
---@field LotteryAwardRecordUIPath FSoftClassPath
---@field LotteryExplanationUIPath FSoftClassPath
---@field LotteryDrawDisplayUIPath FSoftClassPath
---@field LotteryPurchaseItemUIPath FSoftClassPath
---@field LotteryItemGetUIPath FSoftClassPath
---@field LotteryGiftProgressTipUIPath FSoftClassPath
---@field LotteryItemTipUIPath FSoftClassPath
---@field LotteryMessageTipUIPath FSoftClassPath
---@field LotteryConfirmUIPath FSoftClassPath
---@field IsUseModeOne TEnumAsByte<ELotteryMainUIType>
---@field ShowAwardNum int32
---@field IsUseLotteryGiftProgress bool
---@field IsUseLotteryExchange bool
---@field ExchangeItemTabID int32
---@field OasisCoinIconPath FSoftObjectPath
--Edit Below--

UGCGameSystem.UGCRequire("ExtendResource.Lottery.OfficialPackage." .. "Script.Lottery.LotteryManager");
UGCGameSystem.UGCRequire("ExtendResource.Lottery.OfficialPackage." .. "Script.Common.Common");

local LotteryComponent = {
    DrawRecordLimit = 50;
}

function LotteryComponent:ReceiveBeginPlay()
    print("LotteryComponent:ReceiveBeginPlay");
    LotteryComponent.SuperClass.ReceiveBeginPlay(self);
    LotteryManager:RegisterComponentClass(GameplayStatics.GetObjectClass(self));
    LotteryManager:GetLotteryData();
    local PlayerController = self:GetOwner();
    if PlayerController:HasAuthority() == true then
        if UE.IsValid(self:GetVirtualItemManager()) then
            self.VirtualItemInited = true
            self:GetVirtualItemManager().AddItemResultDelegate:Add(self.OnAddVirtualItem, self);
            self:GetVirtualItemManager().RemoveItemResultDelegate:Add(self.OnRemoveVirtualItem, self);
        end
        if PlayerController:GetInt64PlayerKey() == 0 then
            local STExtraGMDelegatesMgr = UGCGameSystem.GetSTExtraGMDelegatesMgr();
            if STExtraGMDelegatesMgr ~= nil then
                STExtraGMDelegatesMgr.GetInstance().OnPlayerPostLoginDelegate:AddInstance(self.LoadData, self);
            end
        else
            self:LoadData();
        end
    else
        if UE.IsValid(self:GetVirtualItemManager()) then
            self.VirtualItemInited = true
            self:GetVirtualItemManager().OnVirtualItemNumUpdatedDelegate:Add(self.OnVirtualItemNumUpdate, self);
        end
        if UE.IsValid(self:GetCommodityManager()) then
            self.CommodityInited = true
            self:GetCommodityManager().BuyProductResultDelegate:Add(self.OnBuyProduct, self);
            self:GetCommodityManager().LimitProductUpdateDelegate:Add(self.OnLimitProductUpdate, self);
        end
        self:PreLoadAsset();
        self:PreLoadUI();
    end
    GMP.GlobalMessage.BindUObject(PlayerController, "UGC.GamePart.GamePartLoaded", self, self.InitGamePart);
end

--[[
function LotteryComponent:ReceiveTick(DeltaTime)
    LotteryComponent.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

function LotteryComponent:ReceiveEndPlay()
    LotteryComponent.SuperClass.ReceiveEndPlay(self);
    local PlayerController = self:GetOwner();
    if PlayerController:HasAuthority() == true then
        if self.RefreshTodayDrawTimesTimer then
            if Timer.IsTimerExistByName("RefreshTodayDrawTimesTimer") then
                Timer.RemoveTimerByName("RefreshTodayDrawTimesTimer");
            end
            self.RefreshTodayDrawTimesTimer = nil;
        end
        if UE.IsValid(self:GetVirtualItemManager()) then
            self:GetVirtualItemManager().AddItemResultDelegate:Remove(self.OnAddVirtualItem, self);
            self:GetVirtualItemManager().RemoveItemResultDelegate:Remove(self.OnRemoveVirtualItem, self);
        end
    else
        if UE.IsValid(self:GetCommodityManager()) then
            self:GetCommodityManager().BuyProductResultDelegate:Remove(self.OnBuyProduct, self);
            self:GetCommodityManager().LimitProductUpdateDelegate:Remove(self.OnLimitProductUpdate, self);
        end
        if UE.IsValid(self:GetVirtualItemManager()) then
            self:GetVirtualItemManager().OnVirtualItemNumUpdatedDelegate:Remove(self.OnVirtualItemNumUpdate, self);
        end
    end
end

function LotteryComponent:GetReplicatedProperties()
    return {"LotterySkipAnim", "Lazy"}, {"IsDrawing", "Lazy"}, {"LotteryDrawInfo", "Lazy"},  {"LotteryGroupDrawInfo", "Lazy"},  {"LotteryGiftProgressInfo", "Lazy"};
end

function LotteryComponent:GetAvailableServerRPCs()
    return
    "Server_DrawOnce",
    "Server_DrawTenth",
    "Server_GetLotteryInfos",
    "Server_ExchangeProduct",
    "Server_AddExchangeRecord",
    "Server_GetProgressReward",
    "Server_ChangeSkipAnim";
end

--初始化GamePart
--生效范围：客户端&&服务端
---@param GamePartName string
function LotteryComponent:InitGamePart(GamePartName)
    print(string.format("[LotteryComponent:InitGamePart] GamePartName: %s", GamePartName or ""));
    local PlayerController = self:GetOwner();
    if GamePartName == "VirtualItemManager" then
        if self.VirtualItemManager == nil then
            self.VirtualItemManager = UGCBlueprintFunctionLibrary.GetGamePartGlobalActor(UGCGameSystem.GameState, "VirtualItemManager");
        end
        print(string.format("[LotteryComponent:InitGamePart] VirtualItemManager Is Nil: %s", self:GetVirtualItemManager() == nil));
        if UE.IsValid(self:GetVirtualItemManager()) and self.VirtualItemInited == nil then
            self.VirtualItemInited = true
            if PlayerController:HasAuthority() == true then
                self:GetVirtualItemManager().AddItemResultDelegate:Add(self.OnAddVirtualItem, self);
                self:GetVirtualItemManager().RemoveItemResultDelegate:Add(self.OnRemoveVirtualItem, self);
            else
                self:GetVirtualItemManager().OnVirtualItemNumUpdatedDelegate:Add(self.OnVirtualItemNumUpdate, self);
            end
        end
    elseif GamePartName == "CommodityOperationManager" then
        if self.CommodityManager == nil then
            self.CommodityManager = UGCBlueprintFunctionLibrary.GetGamePartGlobalActor(UGCGameSystem.GameState, "CommodityOperationManager");
        end
        print(string.format("[LotteryComponent:InitGamePart] CommodityManager Is Nil: %s", self.CommodityManager == nil));
        if PlayerController:HasAuthority() == false and self.CommodityInited == nil then
            self.CommodityInited = true
            if UE.IsValid(self:GetCommodityManager()) then
                self:GetCommodityManager().BuyProductResultDelegate:Add(self.OnBuyProduct, self);
                self:GetCommodityManager().LimitProductUpdateDelegate:Add(self.OnLimitProductUpdate, self);
            end
        end
    end
end

--初始化抽奖数据
--生效范围：服务端
function LotteryComponent:LoadData()
    print("LotteryComponent:LoadData");
    local PlayerData = self:ReadPlayerData();
    self.LotteryDrawInfo = PlayerData.Lottery.Lottery;
    self.LotteryGroupDrawInfo = PlayerData.Lottery.LotteryGroup;
    self.LotteryGiftProgressInfo = PlayerData.Lottery.LotteryGiftProgress;
    _G.DOREPONCE(self, "LotteryDrawInfo");
    _G.DOREPONCE(self, "LotteryGroupDrawInfo");
    _G.DOREPONCE(self, "LotteryGiftProgressInfo");

    self.LotterySkipAnim = PlayerData.Lottery.LotterySkipAnim;
    _G.DOREPONCE(self, "LotterySkipAnim");

    self:CheckTodayDrawTimes()
    ---开启一个计时器用来重置每日抽奖次数
    self.RefreshTodayDrawTimesTimer = Timer.InsertTimer(
        1,
        function ()
            -- 超过零点后刷新抽奖次数，首抽折扣刷新
            local ServerTime = UGCGameSystem.GetServerTimeSec();
            local CurDate = os.date("*t", ServerTime);
            local TodayTimeStamp = os.time({year=CurDate.year, month=CurDate.month, day=CurDate.day, hour=0, min=0, sec=0});
            local NeedReset = false
            local HasReset = false
            if CurDate.hour == 0 and CurDate.min == 0 and CurDate.sec == 0 then
                NeedReset = true
            end
            print(string.format("[RefreshTodayDrawTimesTimer] ServerTime: %d", ServerTime or -1));
            local PlayerData = self:ReadPlayerData();
            local LotteryDrawInfo = PlayerData.Lottery.Lottery;
            for LotteryID, Data in pairs(LotteryDrawInfo) do
                if NeedReset or Data.TodayTimeStamp ~= TodayTimeStamp then
                    Data.TodayDrawTimes = 0;
                    Data.TodayTimeStamp = TodayTimeStamp;
                    if not HasReset then
                        HasReset = true
                    end
                end
            end
            local LotteryGroupDrawInfo = PlayerData.Lottery.LotteryGroup;
            for LotteryGroupID, Data in pairs(LotteryGroupDrawInfo) do
                if NeedReset or Data.TodayTimeStamp ~= TodayTimeStamp then
                    Data.TodayDrawTimes = 0;
                    Data.TodayTimeStamp = TodayTimeStamp;
                    if not HasReset then
                        HasReset = true
                    end
                end
            end
            if HasReset then
                self.LotteryDrawInfo = PlayerData.Lottery.Lottery;
                self.LotteryGroupDrawInfo = PlayerData.Lottery.LotteryGroup;
                _G.DOREPONCE(self, "LotteryDrawInfo");
                _G.DOREPONCE(self, "LotteryGroupDrawInfo");
            end
        end,
        true,
        "RefreshTodayDrawTimesTimer"
    );
end

function LotteryComponent:CheckTodayDrawTimes()
    local ServerTime = UGCGameSystem.GetServerTimeSec();
    local CurDate = os.date("*t", ServerTime);
    local TodayTimeStamp = os.time({year=CurDate.year, month=CurDate.month, day=CurDate.day, hour=0, min=0, sec=0});
    local HasReset = false
    print(string.format("LotteryComponent:CheckTodayDrawTimes ServerTime: %d", ServerTime or -1));
    local PlayerData = self:ReadPlayerData();
    local LotteryDrawInfo = PlayerData.Lottery.Lottery;
    for LotteryID, Data in pairs(LotteryDrawInfo) do
        if Data.TodayTimeStamp ~= TodayTimeStamp then
            Data.TodayDrawTimes = 0;
            Data.TodayTimeStamp = TodayTimeStamp;
            if not HasReset then
                HasReset = true
            end
        end
    end
    local LotteryGroupDrawInfo = PlayerData.Lottery.LotteryGroup;
    for LotteryGroupID, Data in pairs(LotteryGroupDrawInfo) do
        if Data.TodayTimeStamp ~= TodayTimeStamp then
            Data.TodayDrawTimes = 0;
            Data.TodayTimeStamp = TodayTimeStamp;
            if not HasReset then
                HasReset = true
            end
        end
    end
    if HasReset then
        local Success = self:WritePlayerData(PlayerData);
        if Success then
            self.LotteryDrawInfo = PlayerData.Lottery.Lottery;
            self.LotteryGroupDrawInfo = PlayerData.Lottery.LotteryGroup;
            _G.DOREPONCE(self, "LotteryDrawInfo");
            _G.DOREPONCE(self, "LotteryGroupDrawInfo");
        end
    end
end

--预加载资源
--生效范围：客户端
function LotteryComponent:PreLoadAsset()
    local Path = UGCGameSystem.GetUGCResourcesFullPath('Asset/Data/Table/UGCLottery.UGCLottery');
    Common.LoadObjectAsync(Path, 
        function (Object)
            print("[LotteryComponent] Preload UGCLottery Table Success!");
        end
    );
    Path = UGCGameSystem.GetUGCResourcesFullPath('Asset/Data/Table/UGCDrop.UGCDrop');
    Common.LoadObjectAsync(Path, 
        function (Object)
            print("[LotteryComponent] Preload UGCDrop Table Success!");
        end
    );
    Path = UGCGameSystem.GetUGCResourcesFullPath('Asset/Data/Table/UGCDropGroup.UGCDropGroup');
    Common.LoadObjectAsync(Path, 
        function (Object)
            print("[LotteryComponent] Preload UGCDropGroup Table Success!");
        end
    );
    Path = "/Game/WwiseEvent/UI_hall/Play_UI_hall_Shopping_Get.Play_UI_hall_Shopping_Get";
    Common.LoadObjectAsync(Path, 
    function (Object)
        print("[LotteryComponent] Preload Item Get Sound Success!");
    end
    );

    --- 预加载所有Image
    local ImageList = {};
    for Index, Data in pairs(LotteryManager.LotteryDatas) do
        --- 奖池Image
        local LotteryIcon = Data.Icon;
        if LotteryIcon ~= nil then
            ImageList[LotteryIcon] = true;
        end
        -- 抽奖道具Image
        local ItemID  = self:GetItemIDByProduct(Data.DrawCostID);
        local ItemInfo = self:GetObjectDataByID(ItemID);
        if ItemInfo and ItemInfo.ItemIcon then
            ImageList[ItemInfo.ItemIcon] = true;
        end
        -- 掉落道具Image
        local DropItemList = LotteryManager:GetLotteryAwardData(Data.ID);
        for _, ItemID in pairs(DropItemList) do
            local ItemInfo = self:GetObjectDataByID(ItemID);
            if ItemInfo and ItemInfo.ItemIcon then
                ImageList[ItemInfo.ItemIcon] = true;
            end
        end
    end
    for ImagePath, _ in pairs(ImageList) do
        Common.LoadObjectAsync(ImagePath, 
        function (Object)
                print(string.format("[LotteryComponent] Preload ItemIcon: %s Success!", ImagePath));
            end
        );
    end
end

--预加载UI
--生效范围：客户端
function LotteryComponent:PreLoadUI()
    print("LotteryComponent:PreLoadUI");
    local PlayerController = self:GetOwner();
    Common.LoadObjectWithSoftPathAsync(self.LotteryMainUIPath, function(Object)
        if self ~= nil and Object ~= nil then
            self.LotteryMainUI = UserWidget.NewWidgetObjectBP(PlayerController, Object);
            self.LotteryMainUI:AddToViewport(10000);
            self.LotteryMainUI:SetVisibility(ESlateVisibility.Collapsed);
            self:InitLotteryMainUI();
        end
    end)
    Common.LoadObjectWithSoftPathAsync(self.LotteryModeOneUIPath, function(Object)
        if self ~= nil and Object ~= nil then
            self.LotteryModeOneUI = UserWidget.NewWidgetObjectBP(PlayerController, Object);
            self.LotteryModeOneUI:AddToViewport(10000);
            self.LotteryModeOneUI:SetVisibility(ESlateVisibility.Collapsed);
            self:InitLotteryMainUI();
        end
    end)
    Common.LoadObjectWithSoftPathAsync(self.LotteryModeTwoUIPath, function(Object)
        if self ~= nil and Object ~= nil then
            self.LotteryModeTwoUI = UserWidget.NewWidgetObjectBP(PlayerController, Object);
            self.LotteryModeTwoUI:AddToViewport(10000);
            self.LotteryModeTwoUI:SetVisibility(ESlateVisibility.Collapsed);
            self:InitLotteryMainUI();
        end
    end)
    Common.LoadObjectWithSoftPathAsync(self.LotteryAwardPreviewUIPath, function(Object)
        if self ~= nil and Object ~= nil then
            self.LotteryAwardPreviewUI = UserWidget.NewWidgetObjectBP(PlayerController, Object);
            self.LotteryAwardPreviewUI:AddToViewport(11000);
            self.LotteryAwardPreviewUI:SetVisibility(ESlateVisibility.Collapsed);
        end
    end)
    Common.LoadObjectWithSoftPathAsync(self.LotteryExchangeUIPath, function(Object)
        if self ~= nil and Object ~= nil then
            self.LotteryExchangeUI = UserWidget.NewWidgetObjectBP(PlayerController, Object);
            self.LotteryExchangeUI:AddToViewport(11000);
            self.LotteryExchangeUI:SetVisibility(ESlateVisibility.Collapsed);
        end
    end)
    Common.LoadObjectWithSoftPathAsync(self.LotteryAwardRecordUIPath, function(Object)
        if self ~= nil and Object ~= nil then
            self.LotteryAwardRecordUI = UserWidget.NewWidgetObjectBP(PlayerController, Object);
            self.LotteryAwardRecordUI:AddToViewport(11000);
            self.LotteryAwardRecordUI:SetVisibility(ESlateVisibility.Collapsed);
        end
    end)
    Common.LoadObjectWithSoftPathAsync(self.LotteryExplanationUIPath, function(Object)
        if self ~= nil and Object ~= nil then
            self.LotteryExplanationUI = UserWidget.NewWidgetObjectBP(PlayerController, Object);
            self.LotteryExplanationUI:AddToViewport(11000);
            self.LotteryExplanationUI:SetVisibility(ESlateVisibility.Collapsed);
        end
    end)
    Common.LoadObjectWithSoftPathAsync(self.LotteryDrawDisplayUIPath, function(Object)
        if self ~= nil and Object ~= nil then
            self.LotteryDrawDisplayUI = UserWidget.NewWidgetObjectBP(PlayerController, Object);
            self.LotteryDrawDisplayUI:AddToViewport(11000);
            self.LotteryDrawDisplayUI:SetVisibility(ESlateVisibility.Collapsed);
        end
    end)
    Common.LoadObjectWithSoftPathAsync(self.LotteryPurchaseItemUIPath, function(Object)
        if self ~= nil and Object ~= nil then
            self.LotteryPurchaseItemUI = UserWidget.NewWidgetObjectBP(PlayerController, Object);
            self.LotteryPurchaseItemUI:AddToViewport(12000);
            self.LotteryPurchaseItemUI:SetVisibility(ESlateVisibility.Collapsed);
        end
    end)
    Common.LoadObjectWithSoftPathAsync(self.LotteryItemGetUIPath, function(Object)
        if self ~= nil and Object ~= nil then
            self.LotteryItemGetUI = UserWidget.NewWidgetObjectBP(PlayerController, Object);
            self.LotteryItemGetUI:AddToViewport(15000);
            self.LotteryItemGetUI:SetVisibility(ESlateVisibility.Collapsed);
        end
    end)
    Common.LoadObjectWithSoftPathAsync(self.LotteryGiftProgressTipUIPath, function(Object)
        if self ~= nil and Object ~= nil then
            self.LotteryGiftProgressTipUI = UserWidget.NewWidgetObjectBP(PlayerController, Object);
            self.LotteryGiftProgressTipUI:AddToViewport(15000);
            self.LotteryGiftProgressTipUI:SetVisibility(ESlateVisibility.Collapsed);
        end
    end)
    Common.LoadObjectWithSoftPathAsync(self.LotteryItemTipUIPath, function(Object)
        if self ~= nil and Object ~= nil then
            self.LotteryItemTipUI = UserWidget.NewWidgetObjectBP(PlayerController, Object);
            self.LotteryItemTipUI:AddToViewport(15000);
            self.LotteryItemTipUI:SetVisibility(ESlateVisibility.Collapsed);
        end
    end)
    Common.LoadObjectWithSoftPathAsync(self.LotteryMessageTipUIPath, function(Object)
        if self ~= nil and Object ~= nil then
            self.LotteryMessageTipUI = UserWidget.NewWidgetObjectBP(PlayerController, Object);
            self.LotteryMessageTipUI:AddToViewport(15000);
            self.LotteryMessageTipUI:SetVisibility(ESlateVisibility.Collapsed);
        end
    end)
    Common.LoadObjectWithSoftPathAsync(self.LotteryConfirmUIPath, function(Object)
        if self ~= nil and Object ~= nil then
            self.LotteryConfirmUI = UserWidget.NewWidgetObjectBP(PlayerController, Object);
            self.LotteryConfirmUI:AddToViewport(15000);
            self.LotteryConfirmUI:SetVisibility(ESlateVisibility.Collapsed);
        end
    end)
end

function LotteryComponent:OnRep_LotteryDrawInfo()
    if self.LotteryMainUI then
        local LotteryID = self.LotteryMainUI.SelectedLotteryID;
        local IsUseLotteryGroup, GroupID = self:IsUseLotteryGroup(LotteryID);
        if not IsUseLotteryGroup then
            local LotteryData = LotteryManager:GetLotteryConfigData(LotteryID);
            --- 刷新进度礼包的总抽取数量和礼包状态
            if self.IsUseLotteryGiftProgress then
                local TotalDrawTimes = self:GetTotalDrawTimes(LotteryID);
                print(string.format("累计开启次数: %d", TotalDrawTimes));
                self.LotteryMainUI:RefreshTotalDrawTimes(TotalDrawTimes);
                self.LotteryMainUI:RefreshGiftProgress();
            end
            --- 刷新每日抽奖数量
            if LotteryData then
                if LotteryData.DailyDrawLimit > 0 then
                    local TodayDrawTimes = self:GetTodayDrawTimes(LotteryID);
                    print(string.format("今日开启次数: %d", TodayDrawTimes));
                    self.LotteryMainUI:RefreshTodayDrawTimes(TodayDrawTimes);
                end
                if LotteryData.IsFirstDrawDiscountOpen and self.LotteryMainUI then
                    self.LotteryMainUI:RefreshDrawDiscount()
                end
            end
        end
    end
end

function LotteryComponent:OnRep_LotteryGroupDrawInfo()
    if self.LotteryMainUI then
        local LotteryID = self.LotteryMainUI.SelectedLotteryID;
        local IsUseLotteryGroup, GroupID = self:IsUseLotteryGroup(LotteryID);
        if IsUseLotteryGroup then
            local LotteryData = LotteryManager:GetLotteryConfigData(LotteryID);
            --- 刷新进度礼包的总抽取数量和礼包状态
            if self.IsUseLotteryGiftProgress then
                local TotalDrawTimes = self:GetTotalDrawTimes(LotteryID);
                print(string.format("累计开启次数: %d", TotalDrawTimes));
                self.LotteryMainUI:RefreshTotalDrawTimes(TotalDrawTimes);
                self.LotteryMainUI:RefreshGiftProgress();
            end
            --- 刷新每日抽奖数量
            if LotteryData then
                if LotteryData.DailyDrawLimit > 0 then
                    local TodayDrawTimes = self:GetTodayDrawTimes(LotteryID);
                    print(string.format("今日开启次数: %d", TodayDrawTimes));
                    self.LotteryMainUI:RefreshTodayDrawTimes(TodayDrawTimes);
                end
                if LotteryData.IsFirstDrawDiscountOpen and self.LotteryMainUI then
                    self.LotteryMainUI:RefreshDrawDiscount()
                end
            end
        end
    end
end

function LotteryComponent:OnRep_LotteryGiftProgressInfo()
    if self.LotteryMainUI then
        --- 刷新进度礼包的总抽取数量和礼包状态
        if self.IsUseLotteryGiftProgress then
            self.LotteryMainUI:RefreshGiftProgress();
        end
    end
end

--展示单抽结果
--生效范围：客户端
---@param LotteryID number
---@param ItemList any
function LotteryComponent:Client_DisplayOneDraw(LotteryID, DropRecord, DrawTime)
    self.IsDrawing = false;
    self:Client_WriteOneLotteryRecord(LotteryID, DropRecord, DrawTime)
    local ItemList = {}
    for ItemID, ItemNum in pairs(DropRecord.ItemList) do
        table.insert(ItemList, {ItemID = ItemID, ItemNum = ItemNum});
    end
    LotteryManager.OnDrawLotteryOnceDelegate(ItemList);
    if self.LotteryDrawDisplayUI then
        self.LotteryDrawDisplayUI:ShowOneDraw(LotteryID, ItemList);
        self.LotteryDrawDisplayUI:SetVisibility(ESlateVisibility.Visible);
    end
end

function LotteryComponent:Client_WriteOneLotteryRecord(LotteryID, DropRecord, DrawTime)
    local PlayerController = self:GetOwner()
    if PlayerController:HasAuthority() then
        return
    end
    local DropItemInfo = {ID = -1, Num = 0};
    for ItemID, ItemNum in pairs(DropRecord.ItemList) do
        DropItemInfo.ID = ItemID;
        DropItemInfo.Num = ItemNum;
    end
    DropItemInfo.DropType = DropRecord.DropType;
    DropItemInfo.IsDrawTenth = DropRecord.IsDrawTenth;

    local ServerTimeSec = DrawTime
    local CurDate = os.date("*t", ServerTimeSec);
    local TodayTimeStamp = os.time({year=CurDate.year, month=CurDate.month, day=CurDate.day, hour=0, min=0, sec=0});

    -- 先判断是不是抽奖组
    local LotteryData = LotteryManager:GetLotteryConfigData(LotteryID);
    if LotteryData then
        local LotteryGroupID = LotteryData.DailyDrawGroup;
        if LotteryGroupID == 0 then
            -- 不使用奖池组, 按LotteryID记录
            if self.LotteryDrawInfo[LotteryID] == nil then
                self.LotteryDrawInfo[LotteryID] = {
                    LotteryRecords = {},
                    TotalDrawTimes = 0,
                    TodayDrawTimes = 0,
                    TodayTimeStamp = TodayTimeStamp,
                }
            else
                if TodayTimeStamp ~= self.LotteryDrawInfo[LotteryID].TodayTimeStamp then
                    self.LotteryDrawInfo[LotteryID].TodayTimeStamp = TodayTimeStamp;
                    self.LotteryDrawInfo[LotteryID].TodayDrawTimes = 0;
                end
            end

            -- 单个奖池最多保留五十条抽奖记录
            table.insert(self.LotteryDrawInfo[LotteryID].LotteryRecords, {ItemInfo = DropItemInfo, DrawTime = ServerTimeSec});
            if #self.LotteryDrawInfo[LotteryID].LotteryRecords > self.DrawRecordLimit then
                -- 超出五十条则移除最早的记录
                table.remove(self.LotteryDrawInfo[LotteryID].LotteryRecords, 1);
            end
            self.LotteryDrawInfo[LotteryID].TotalDrawTimes = self.LotteryDrawInfo[LotteryID].TotalDrawTimes + 1;
            self.LotteryDrawInfo[LotteryID].TodayDrawTimes = self.LotteryDrawInfo[LotteryID].TodayDrawTimes + 1;

            if self.IsUseLotteryGiftProgress then
                for Index, Value in pairs(LotteryData.GiftProgressRewards) do
                    if self.LotteryGiftProgressInfo[LotteryID] == nil then
                        self.LotteryGiftProgressInfo[LotteryID] = {};
                    end

                    local TotalDrawTimes = self.LotteryDrawInfo[LotteryID].TotalDrawTimes;
                    if TotalDrawTimes >= Value.Progress and self.LotteryGiftProgressInfo[LotteryID][Value.Progress] == nil then
                        self.LotteryGiftProgressInfo[LotteryID][Value.Progress] = false;
                    end
                end
                self:OnRep_LotteryGiftProgressInfo()
            end
            self:OnRep_LotteryDrawInfo()
        else
            -- 使用奖池组，按LotteryGroup记录，也需要存到Lottery里方便读取当前奖池的抽取次数
            if self.LotteryGroupDrawInfo[LotteryGroupID] == nil then
                self.LotteryGroupDrawInfo[LotteryGroupID] = {
                    LotteryRecords = {},
                    TotalDrawTimes = 0,
                    TodayDrawTimes = 0,
                    TodayTimeStamp = TodayTimeStamp,
                }
            else
                if TodayTimeStamp ~= self.LotteryGroupDrawInfo[LotteryGroupID].TodayTimeStamp then
                    self.LotteryGroupDrawInfo[LotteryGroupID].TodayTimeStamp = TodayTimeStamp;
                    self.LotteryGroupDrawInfo[LotteryGroupID].TodayDrawTimes = 0;
                end
            end
            if self.LotteryDrawInfo[LotteryID] == nil then
                self.LotteryDrawInfo[LotteryID] = {
                    LotteryRecords = {},
                    TotalDrawTimes = 0,
                    TodayDrawTimes = 0,
                    TodayTimeStamp = TodayTimeStamp,
                }
            else
                if TodayTimeStamp ~= self.LotteryDrawInfo[LotteryID].TodayTimeStamp then
                    self.LotteryDrawInfo[LotteryID].TodayTimeStamp = TodayTimeStamp;
                    self.LotteryDrawInfo[LotteryID].TodayDrawTimes = 0;
                end
            end

            table.insert(self.LotteryGroupDrawInfo[LotteryGroupID].LotteryRecords, {ItemInfo = DropItemInfo, DrawTime = ServerTimeSec});
            self.LotteryGroupDrawInfo[LotteryGroupID].TotalDrawTimes = self.LotteryGroupDrawInfo[LotteryGroupID].TotalDrawTimes + 1;
            self.LotteryGroupDrawInfo[LotteryGroupID].TodayDrawTimes = self.LotteryGroupDrawInfo[LotteryGroupID].TodayDrawTimes + 1;

            table.insert(self.LotteryDrawInfo[LotteryID].LotteryRecords, {ItemInfo = {Num = DropItemInfo.Num, IsDrawTenth = DropItemInfo.IsDrawTenth, DropType = DropItemInfo.DropType, ID = DropItemInfo.ID}, DrawTime = ServerTimeSec});
            self.LotteryDrawInfo[LotteryID].TotalDrawTimes = self.LotteryDrawInfo[LotteryID].TotalDrawTimes + 1;
            self.LotteryDrawInfo[LotteryID].TodayDrawTimes = self.LotteryDrawInfo[LotteryID].TodayDrawTimes + 1;

            if #self.LotteryGroupDrawInfo[LotteryGroupID].LotteryRecords > self.DrawRecordLimit then
                -- 超出五十条则移除最早的记录
                table.remove(self.LotteryGroupDrawInfo[LotteryGroupID].LotteryRecords, 1);
            end

            if #self.LotteryDrawInfo[LotteryID].LotteryRecords > self.DrawRecordLimit then
                -- 超出五十条则移除最早的记录
                table.remove(self.LotteryDrawInfo[LotteryID].LotteryRecords, 1);
            end
            --- 如果是奖池组的话，这里需要更新同一个奖池组内的所有奖池组数据
            if self.IsUseLotteryGiftProgress then
                local LotteryIDList = LotteryManager:GetLotteryIDByDrawGroup(LotteryGroupID);
                for _, GroupLotteryID in pairs(LotteryIDList) do
                    local GroupLotteryData = LotteryManager:GetLotteryConfigData(GroupLotteryID);
                    if GroupLotteryData then
                        for _, Value in pairs(GroupLotteryData.GiftProgressRewards) do
                            if self.LotteryGiftProgressInfo[GroupLotteryID] == nil then
                                self.LotteryGiftProgressInfo[GroupLotteryID] = {};
                            end
                            local TotalDrawTimes = self.LotteryGroupDrawInfo[LotteryGroupID].TotalDrawTimes;
                            if TotalDrawTimes >= Value.Progress and self.LotteryGiftProgressInfo[GroupLotteryID][Value.Progress] == nil then
                                self.LotteryGiftProgressInfo[GroupLotteryID][Value.Progress] = false;
                            end
                        end
                    end
                end
                self:OnRep_LotteryGiftProgressInfo()
            end
            self:OnRep_LotteryGroupDrawInfo()
        end
    end
end

--展示十连结果
--生效范围：客户端
---@param LotteryID number
---@param ItemList any
function LotteryComponent:Client_DisplayTenDraw(LotteryID, TenDropRecord, DrawTime)
    self.IsDrawing = false;
    self:Client_WriteTenLotteryRecord(LotteryID, TenDropRecord, DrawTime)
    local ItemList = {}
    for Index, DropRecord in pairs(TenDropRecord) do
        for ItemID, ItemNum in pairs(DropRecord.ItemList) do
            table.insert(ItemList, {ItemID = ItemID, ItemNum = ItemNum});
        end
    end
    self:DrawLotteryTenTimesDelegate(ItemList);
    if self.LotteryDrawDisplayUI then
        self.LotteryDrawDisplayUI:ShowTenDraw(LotteryID, ItemList);
        self.LotteryDrawDisplayUI:SetVisibility(ESlateVisibility.Visible);
    end
end

function LotteryComponent:Client_WriteTenLotteryRecord(LotteryID, TenDropRecord, DrawTime)
    local PlayerController = self:GetOwner()
    if PlayerController:HasAuthority() then
        return
    end
    -- 先判断是不是抽奖组
    local LotteryData = LotteryManager:GetLotteryConfigData(LotteryID);
    local ServerTimeSec = DrawTime;
    local CurDate = os.date("*t", ServerTimeSec);
    local TodayTimeStamp = os.time({year=CurDate.year, month=CurDate.month, day=CurDate.day, hour=0, min=0, sec=0});
    if LotteryData then
        local LotteryGroupID = LotteryData.DailyDrawGroup;
        if LotteryGroupID == 0 then
            -- 不使用奖池组, 按LotteryID记录
            if self.LotteryDrawInfo[LotteryID] == nil then
                self.LotteryDrawInfo[LotteryID] = {
                    LotteryRecords = {},
                    TotalDrawTimes = 0,
                    TodayDrawTimes = 0,
                    TodayTimeStamp = TodayTimeStamp,
                }
            else
                if TodayTimeStamp ~= self.LotteryDrawInfo[LotteryID].TodayTimeStamp then
                    self.LotteryDrawInfo[LotteryID].TodayTimeStamp = TodayTimeStamp;
                    self.LotteryDrawInfo[LotteryID].TodayDrawTimes = 0;
                end
            end

            for Index, DropRecord in pairs(TenDropRecord) do
                local DropItemInfo = {ID = -1, Num = 0};
                for ItemID, ItemNum in pairs(DropRecord.ItemList) do
                    DropItemInfo.ID = ItemID;
                    DropItemInfo.Num = ItemNum;
                end
                DropItemInfo.DropType = DropRecord.DropType;
                DropItemInfo.IsDrawTenth = DropRecord.IsDrawTenth;
                table.insert(self.LotteryDrawInfo[LotteryID].LotteryRecords, {ItemInfo = DropItemInfo, DrawTime = ServerTimeSec});
                self.LotteryDrawInfo[LotteryID].TotalDrawTimes = self.LotteryDrawInfo[LotteryID].TotalDrawTimes + 1;
                self.LotteryDrawInfo[LotteryID].TodayDrawTimes = self.LotteryDrawInfo[LotteryID].TodayDrawTimes + 1;

                if #self.LotteryDrawInfo[LotteryID].LotteryRecords > self.DrawRecordLimit then
                    -- 超出五十条则移除最早的记录
                    table.remove(self.LotteryDrawInfo[LotteryID].LotteryRecords, 1);
                end
            end
            if self.IsUseLotteryGiftProgress then
                for Index, Value in pairs(LotteryData.GiftProgressRewards) do
                    if self.LotteryGiftProgressInfo[LotteryID] == nil then
                        self.LotteryGiftProgressInfo[LotteryID] = {};
                    end
                    --- 因为数据还没写入到Component, 所以不能调用GetTotalDrawTimes获取
                    local TotalDrawTimes = self.LotteryDrawInfo[LotteryID].TotalDrawTimes;
                    if TotalDrawTimes >= Value.Progress and self.LotteryGiftProgressInfo[LotteryID][Value.Progress] == nil then
                        self.LotteryGiftProgressInfo[LotteryID][Value.Progress] = false;
                    end
                end
                self:OnRep_LotteryGiftProgressInfo()
            end
            self:OnRep_LotteryDrawInfo()
        else
            -- 使用奖池组，按LotteryGroup记录，也需要存到Lottery里方便读取当前奖池的抽取次数
            if self.LotteryGroupDrawInfo[LotteryGroupID] == nil then
                self.LotteryGroupDrawInfo[LotteryGroupID] = {
                    LotteryRecords = {},
                    TotalDrawTimes = 0,
                    TodayDrawTimes = 0,
                    TodayTimeStamp = TodayTimeStamp,
                }
            else
                if TodayTimeStamp ~= self.LotteryGroupDrawInfo[LotteryGroupID].TodayTimeStamp then
                    self.LotteryGroupDrawInfo[LotteryGroupID].TodayTimeStamp = TodayTimeStamp;
                    self.LotteryGroupDrawInfo[LotteryGroupID].TodayDrawTimes = 0;
                end
            end
            if self.LotteryDrawInfo[LotteryID] == nil then
                self.LotteryDrawInfo[LotteryID] = {
                    LotteryRecords = {},
                    TotalDrawTimes = 0,
                    TodayDrawTimes = 0,
                    TodayTimeStamp = TodayTimeStamp,
                }
            else
                if TodayTimeStamp ~= self.LotteryDrawInfo[LotteryID].TodayTimeStamp then
                    self.LotteryDrawInfo[LotteryID].TodayTimeStamp = TodayTimeStamp;
                    self.LotteryDrawInfo[LotteryID].TodayDrawTimes = 0;
                end
            end
            for Index, DropRecord in pairs(TenDropRecord) do
                local DropItemInfo = {ID = -1, Num = 0};
                for ItemID, ItemNum in pairs(DropRecord.ItemList) do
                    DropItemInfo.ID = ItemID;
                    DropItemInfo.Num = ItemNum;
                end
                DropItemInfo.DropType = DropRecord.DropType;
                DropItemInfo.IsDrawTenth = DropRecord.IsDrawTenth;

                table.insert(self.LotteryGroupDrawInfo[LotteryGroupID].LotteryRecords, {ItemInfo = DropItemInfo, DrawTime = ServerTimeSec});
                self.LotteryGroupDrawInfo[LotteryGroupID].TotalDrawTimes = self.LotteryGroupDrawInfo[LotteryGroupID].TotalDrawTimes + 1;
                self.LotteryGroupDrawInfo[LotteryGroupID].TodayDrawTimes = self.LotteryGroupDrawInfo[LotteryGroupID].TodayDrawTimes + 1;
    
                table.insert(self.LotteryDrawInfo[LotteryID].LotteryRecords, {ItemInfo = {Num = DropItemInfo.Num, IsDrawTenth = DropItemInfo.IsDrawTenth, DropType = DropItemInfo.DropType, ID = DropItemInfo.ID}, DrawTime = ServerTimeSec});
                self.LotteryDrawInfo[LotteryID].TotalDrawTimes = self.LotteryDrawInfo[LotteryID].TotalDrawTimes + 1;
                self.LotteryDrawInfo[LotteryID].TodayDrawTimes = self.LotteryDrawInfo[LotteryID].TodayDrawTimes + 1;

                if #self.LotteryGroupDrawInfo[LotteryGroupID].LotteryRecords > self.DrawRecordLimit then
                    -- 超出五十条则移除最早的记录
                    table.remove(self.LotteryGroupDrawInfo[LotteryGroupID].LotteryRecords, 1);
                end
    
                if #self.LotteryDrawInfo[LotteryID].LotteryRecords > self.DrawRecordLimit then
                    -- 超出五十条则移除最早的记录
                    table.remove(self.LotteryDrawInfo[LotteryID].LotteryRecords, 1);
                end
            end
            --- 如果是奖池组的话，这里需要更新同一个奖池组内的所有奖池组数据
            if self.IsUseLotteryGiftProgress then
                local LotteryIDList = LotteryManager:GetLotteryIDByDrawGroup(LotteryGroupID);
                for _, GroupLotteryID in pairs(LotteryIDList) do
                    local GroupLotteryData = LotteryManager:GetLotteryConfigData(GroupLotteryID);
                    for _, Value in pairs(GroupLotteryData.GiftProgressRewards) do
                        if self.LotteryGiftProgressInfo[GroupLotteryID] == nil then
                            self.LotteryGiftProgressInfo[GroupLotteryID] = {};
                        end
                        local TotalDrawTimes = self.LotteryGroupDrawInfo[LotteryGroupID].TotalDrawTimes;
                        -- print(string.format("GroupLotteryID: %d TotalDrawTimes: %d Progress: %d", GroupLotteryID, TotalDrawTimes, Value.Progress));
                        if TotalDrawTimes >= Value.Progress and self.LotteryGiftProgressInfo[GroupLotteryID][Value.Progress] == nil then
                            self.LotteryGiftProgressInfo[GroupLotteryID][Value.Progress] = false;
                        end
                    end
                end
                self:OnRep_LotteryGiftProgressInfo()
            end
            self:OnRep_LotteryDrawInfo()
        end
    end
end

function LotteryComponent:OnRep_IsDrawing()
    print_dev(string.format("LotteryComponent:OnRep_IsDrawing: %s", tostring(self.IsDrawing or 0)))
end
----------------------------------------- 抽奖相关 -----------------------------------------
--抽奖一次
--生效范围：客户端
---@param LotteryID number
function LotteryComponent:DrawOnce(LotteryID)
    local PlayerController = self:GetOwner();
    if PlayerController:HasAuthority() == true then
        return;
    end
    print("LotteryComponent:DrawOnce");
    ---上次抽奖结算后才能再次抽奖
    if self.IsDrawing == true then
        return;
    end
    local LotteryData = LotteryManager:GetLotteryConfigData(LotteryID);
    if LotteryData then
        local CostNum = self:GetDrawCostNum(LotteryID, false);
        local TodayDrawTimes = self:GetTodayDrawTimes(LotteryID);
        if LotteryData.DailyDrawLimit > 0 and TodayDrawTimes >= LotteryData.DailyDrawLimit then
            -- 抽奖次数达到上限
            self:OpenLotteryMessageUI("已到达此商品今日开启上限");
            -- 关闭获得界面
            if self.LotteryDrawDisplayUI then
                self.LotteryDrawDisplayUI:SetVisibility(ESlateVisibility.Collapsed);
            end
            return;
        end
        -- 3. 货币不足，跳充值界面
        local CurCurencyNum = self:GetItemNum(self:GetItemIDByProduct(LotteryData.DrawCostID));
        print(string.format("CurCurencyNum: %d CostNum: %d", CurCurencyNum, CostNum));
        if CurCurencyNum < CostNum then
            -- 直接弹出抽奖券购买窗口
            self:OpenPurchaseProductUI(LotteryData.DrawCostID);
        else
            ---记录当前抽奖的价格
            self.DrawCostNum = CostNum;
            self:OpenLotteryConfirmUI("是否进行一次抽奖", "启动1次", function()
                ---比较价格
                self:CloseLotteryConfirmUI();
                local CurCostNum = self:GetDrawCostNum(LotteryID, false);
                print(string.format("CostNum: %d CurCostNum: %d", self.DrawCostNum, CurCostNum));
                if self.DrawCostNum == CurCostNum then
                    self.IsDrawing = true;
                    UnrealNetwork.CallUnrealRPC(PlayerController, self, "Server_DrawOnce", LotteryID);
                else
                    self:OpenLotteryMessageUI("抽奖价格刷新, 请重试");
                end
            end);
        end
    end
end

--抽奖十次
--生效范围：客户端
---@param LotteryID number
function LotteryComponent:DrawTenth(LotteryID)
    local PlayerController = self:GetOwner();
    if PlayerController:HasAuthority() == true then
        return;
    end
    print("LotteryComponent:DrawTenth");
    --- 上次抽奖结算后才能再次抽奖
    if self.IsDrawing == true then
        return;
    end
    local LotteryData = LotteryManager:GetLotteryConfigData(LotteryID);
    if LotteryData then
        local CostNum = self:GetDrawCostNum(LotteryID, true);
        if LotteryData.DailyDrawLimit > 0 then
            local TodayDrawTimes = self:GetTodayDrawTimes(LotteryID);
            if TodayDrawTimes >= LotteryData.DailyDrawLimit or TodayDrawTimes + 10 > LotteryData.DailyDrawLimit then
                -- 抽奖次数达到上限
                self:OpenLotteryMessageUI("已到达此商品今日开启上限");
                -- 关闭获得界面
                if self.LotteryDrawDisplayUI then
                    self.LotteryDrawDisplayUI:SetVisibility(ESlateVisibility.Collapsed);
                end
                return;
            end
        end
        -- 3. 货币不足，跳充值界面
        local CurCurencyNum = self:GetItemNum(self:GetItemIDByProduct(LotteryData.DrawCostID));
        if CurCurencyNum < CostNum then
            -- 直接弹出抽奖券购买窗口
            self:OpenPurchaseProductUI(LotteryData.DrawCostID);
        else
            self:OpenLotteryConfirmUI("是否进行十次抽奖", "启动本轮", function()
                self:CloseLotteryConfirmUI();
                self.IsDrawing = true;
                UnrealNetwork.CallUnrealRPC(PlayerController, self, "Server_DrawTenth", LotteryID);
            end);
        end
    end
end

--抽奖一次
--生效范围：服务端
---@param LotteryID number
function LotteryComponent:Server_DrawOnce(LotteryID)
    print("LotteryComponent: Server_DrawOnce Excute");
    local PlayerController = self:GetOwner();
    if PlayerController:HasAuthority() == false then
        return;
    end
    -- 计算消耗的货币
    local CostNum = self:GetDrawCostNum(LotteryID, false);
    -- 检查是否可以抽奖(抽奖次数限制，货币是否充足)
    if self:CheckCanDraw(LotteryID, CostNum) == false then
        return;
    end
    -- 扣款
    self:UseCurrencyToDraw(LotteryID, CostNum, false);
end

--抽奖十次
--生效范围：服务端
---@param LotteryID number
function LotteryComponent:Server_DrawTenth(LotteryID)
    print("LotteryComponent: Server_DrawTenth Excute");
    local PlayerController = self:GetOwner();
    if PlayerController:HasAuthority() == false then
        return;
    end

    local CostNum = self:GetDrawCostNum(LotteryID, true);
    -- 检查是否可以抽奖(抽奖次数限制，货币是否充足)
    if self:CheckCanDraw(LotteryID, CostNum) == false then
        return;
    end
    -- 扣款
    self:UseCurrencyToDraw(LotteryID, CostNum, true);
    print("LotteryComponent: Server_DrawTenth Done");
end

--进行一次掉落
--生效范围：服务端
---@param LotteryID number
---@return any
function LotteryComponent:DoOneDrop(LotteryID)
    print("LotteryComponent:DoOneDrop");
    ---@type FUGCLotteryData
    local DropRecords = {};
    local LotteryData = LotteryManager:GetLotteryConfigData(LotteryID);
    local PlayerController = self:GetOwner();
    if LotteryData then
        local DropResult;
        local DropType = "";
        if self:HasFirstDrawGuarant(LotteryID) then
            DropResult = self:DoDrop(LotteryData.OverrideFirstDrawGuarantDropID, LotteryData.FirstDrawGuarantDropGroupID);
            DropType = "首次抽取保底";
        else
            DropResult = self:DoDrop(LotteryData.OverrideDropID, LotteryData.DropGroupID);
            DropType = "普通掉落";
        end
        if DropResult then
            table.insert(DropRecords, {ItemList = DropResult, DropType = DropType});
            local OneRecord = {
                ItemList = DropResult,
                DropType = DropType,
                IsDrawTenth = false,
            }
            -- 写入数据
            self:WriteOneLotteryRecord(LotteryID, OneRecord, self.DrawRecordLimit);
        end
    end
    return DropRecords;
end

--进行十次掉落
--生效范围：服务端
---@param LotteryID number
---@return any
function LotteryComponent:DoTenDrop(LotteryID)
    print("LotteryComponent:DoTenDrop");
    local DropRecords = {};
    local TempLotteryRecord = {};
    local LotteryData = LotteryManager:GetLotteryConfigData(LotteryID);
    if LotteryData then
        for i = 1, 10 do
            ---@type LotteryData
            local OneResult;
            local DropType = "";
            if self:IsGuarantDrop(LotteryData.OverrideGuarantDropID, LotteryData.GuarantDropGroupID, LotteryData.ID, TempLotteryRecord) then
                -- 十连保底
                print("LotteryComponent: GuarantDrop!!!")
                OneResult = self:DoDrop(LotteryData.OverrideGuarantDropID, LotteryData.GuarantDropGroupID);
                DropType = "十连保底";
            else
                -- 普通掉落
                print("LotteryComponent: NormalDrop")
                OneResult = self:DoDrop( LotteryData.OverrideDropID, LotteryData.DropGroupID);
                DropType = "普通掉落";
            end
            if OneResult then
                local OneRecord = {
                    ItemList = OneResult,
                    DropType = DropType,
                    IsDrawTenth = true,
                };
                table.insert(DropRecords, OneRecord);

                local DropItemInfo = {ID = -1};
                for ItemID, ItemNum in pairs(OneResult) do
                    DropItemInfo.ID = ItemID;
                end
                table.insert(TempLotteryRecord, {ItemInfo = DropItemInfo});
            end
        end
        -- 写入数据
        self:WriteTenLotteryRecord(LotteryID, DropRecords, self.DrawRecordLimit);
    end
    return DropRecords;
end

--获取抽奖消耗道具数量
--生效范围：客户端&&服务端
---@param LotteryID number
---@param IsDrawTenth boolean
---@return number
function LotteryComponent:GetDrawCostNum(LotteryID, IsDrawTenth)
    local LotteryData = LotteryManager:GetLotteryConfigData(LotteryID);
    if LotteryData then
        if IsDrawTenth then
            return LotteryData.TenDrawCostNum;
        else
            -- 判断是否有折扣
            if self:CheckHasFirstDrawDiscount(LotteryID, LotteryData.FirstDrawDiscountResetType) then
                print(string.format("存在首抽折扣 CostNum: %d", LotteryData.FirstDrawDiscountCost));
                return LotteryData.FirstDrawDiscountCost;
            else
                print(string.format("不存在首抽折扣 CostNum: %d", LotteryData.OneDrawCostNum));
                return LotteryData.OneDrawCostNum;
            end
        end
    end

    return 0;
end

--判断是否有首抽折扣
--生效范围：客户端&&服务端
---@param LotteryID number
---@param ResetType ELotteryResetType
---@return boolean
function LotteryComponent:CheckHasFirstDrawDiscount(LotteryID, ResetType)
    local LotteryData = LotteryManager:GetLotteryConfigData(LotteryID)
    if LotteryData then
        if LotteryData.IsFirstDrawDiscountOpen == false then
            return;
        end
        print(string.format("检查是否存在首抽折扣 LotteryID: %d, ResetType: %d NotReset: %d DailyReset: %d MonthlyReset: %d WeeklyReset: %d", LotteryID, ResetType, ELotteryResetType.NotReset, ELotteryResetType.DailyReset, ELotteryResetType.MonthlyReset, ELotteryResetType.WeeklyReset));
        --  如果是抽奖组的话应该仅读取当前奖池的抽奖记录
        local Records = self:GetLotteryRecords(LotteryID, false);
        if next(Records) == nil then
            return true;
        end
        -- 这里应该取最近的单抽记录，而不是最近的一次记录(十连不影响首抽折扣或保底)
        local LatestRecord;
        for i=#Records, 1, -1 do
            local Record = Records[i];
            if Record.ItemInfo.IsDrawTenth == false then
                LatestRecord = Record;
                break;
            end
        end
        if LatestRecord == nil then
            --- 没有找到单抽记录，折扣还在
            return true;
        end
        -- 抽奖时记录的是标准时间
        local LatestDrawTime = LatestRecord.DrawTime;
        -- 转换成本地时间
        local CurTimeStamp = UGCGameSystem.GetServerTimeSec();
        -- 用本地时间
        local CurDate = os.date("*t", CurTimeStamp);
        if ResetType == ELotteryResetType.NotReset then
            -- 获取抽奖记录，未抽取过则返回true，否则返回false
            if next(Records) == nil then
                return true; 
            else
                return false;
            end
        elseif ResetType == ELotteryResetType.DailyReset then
            -- 获取抽奖记录，最新一次抽取在今天零点前则返回true, 否则返回false
            local ResetTimeStamp;
            -- 刷新时间是今天凌晨零点
            ResetTimeStamp = os.time({year=CurDate.year, month=CurDate.month, day=CurDate.day, hour=0});
            print(string.format("刷新时间是今天凌晨零点: %d 当前时间: %d 抽奖时间: %d", ResetTimeStamp, CurTimeStamp, LatestDrawTime));
            if ResetTimeStamp > LatestDrawTime then
                return true;
            else
                return false;
            end
        elseif ResetType == ELotteryResetType.MonthlyReset then
            -- 获取抽奖记录，最新一次抽取在当月第一天零点之前则返回true, 否则返回false
            local ResetTimeStamp;
            -- 刷新时间是本月1号凌晨零点
            ResetTimeStamp = os.time({year=CurDate.year, month=CurDate.month, day=1, hour=0});
            print(string.format("刷新时间是本月1号凌晨零点: %d 当前时间: %d", ResetTimeStamp, CurTimeStamp));
            if ResetTimeStamp > LatestDrawTime then
                return true;
            else
                return false;
            end
        elseif ResetType == ELotteryResetType.WeeklyReset then
            -- 获取抽奖记录，最新一次抽取在本周一零点之前则返回true, 否则返回false
            -- 周日时值为0
            local WeekDay = tonumber(os.date("%w", CurTimeStamp));
            local Offset = (WeekDay - 1) % 7;
            local ResetTimeStamp;
            -- 刷新时间是本周一零点
            ResetTimeStamp = os.time({year=CurDate.year, month=CurDate.month, day=CurDate.day - Offset, hour=0});
            print(string.format("刷新时间是本周一零点: %d 当前时间: %d", ResetTimeStamp, CurTimeStamp));
            if ResetTimeStamp > LatestDrawTime then
                return true;    
            else
                return false;
            end
        end
    end
    return false;
end

--判断是否有首次抽奖保底
--生效范围：服务端&&客户端
---@param LotteryID number
---@return boolean
function LotteryComponent:HasFirstDrawGuarant(LotteryID)
    print("LotteryComponent:HasFirstDrawGuarant");
    local LotteryData = LotteryManager:GetLotteryConfigData(LotteryID);
    if LotteryData then
        local FirstDrawGuarantResetType = LotteryData.FirstDrawGuarantResetType;
        local DropID = LotteryData.OverrideFirstDrawGuarantDropID;
        local DropGroupID = LotteryData.FirstDrawGuarantDropGroupID;
        -- 判断是否配置DropID/DropGroupID
        local illegal, _ = self:IsUseDropGroup(DropID, DropGroupID);
        if illegal == nil then
            return false;
        end
        -- 保底和折扣逻辑复用，需要传入保底重置类型
        return self:CheckHasFirstDrawDiscount(LotteryID, FirstDrawGuarantResetType);
    end
    return false;
end

--判断奖池是否配置十连保底
--生效范围：服务端
---@param GuarantDropID number
---@param GuarantDropGroupID number
---@return boolean
function LotteryComponent:IsUseGuarantDrop(GuarantDropID, GuarantDropGroupID)
    if GuarantDropID == nil and GuarantDropGroupID == nil then
        print("LotteryComponent DropID and DropGroupID nil !")
        return false;
    else
        local isLegal, _ = self:IsUseDropGroup(GuarantDropID, GuarantDropGroupID);
        if isLegal == nil then
            print("LotteryComponent DropID and DropGroupID illegal !")
            return false;
        else
            return true;
        end
    end
end

--判断这次抽奖是否是保底掉落
--生效范围：服务端
---@param GuarantDropID number
---@param GuarantDropGroupID number
---@param LotteryID number
---@param TempLotteryRecord any
---@return boolean
function LotteryComponent:IsGuarantDrop(GuarantDropID, GuarantDropGroupID, LotteryID, TempLotteryRecord)
    local PlayerController = self:GetOwner();
    if PlayerController:HasAuthority() == false then
        return;
    end

    -- 判断表格配置是否正确
    if self:IsUseGuarantDrop(GuarantDropID, GuarantDropGroupID) == false then
        return false;
    else
        local GuarantDropOrDropGroupID, useGroup = self:IsUseDropGroup(GuarantDropID, GuarantDropGroupID);
        -- 获取前九次抽奖记录，判断掉落道具是否是保底掉落中的道具，不是则进行保底掉落，否则进行普通掉落
        local PlayerData = self:ReadPlayerData();
        local Records = {};
        local Temp;
        local IsUseGroup, GroupID = self:IsUseLotteryGroup(LotteryID);
        if IsUseGroup then
            if PlayerData.Lottery.LotteryGroup[GroupID] then
                Temp = PlayerData.Lottery.LotteryGroup[GroupID].LotteryRecords;
                for k, v in pairs(Temp) do
                    table.insert(Records, v);
                end
            end
        else
            if PlayerData.Lottery.Lottery[LotteryID] then
                Temp = PlayerData.Lottery.Lottery[LotteryID].LotteryRecords;
                for k, v in pairs(Temp) do
                    table.insert(Records, v);
                end
            end
        end

        if TempLotteryRecord then
            for _, LotteryRecord in pairs(TempLotteryRecord) do
                table.insert(Records, LotteryRecord);
            end
        end

        if next(Records) == nil then
            return false;
        end

        local count = 1;
        for i=#Records, 1, -1 do
            if self:IsGuarantItem(Records[i].ItemInfo.ID, GuarantDropOrDropGroupID, useGroup) then
                return false;
            end
            count = count + 1;
            if count > 9 then
                return true;
            end
        end
    end

    return false;
end

--判断道具是否是保底掉落里的道具
--生效范围：客户端&&服务端
---@param ItemID number
---@param GuarantDropOrDropGroupID number
---@param UseGroup boolean
---@return boolean
function LotteryComponent:IsGuarantItem(ItemID, GuarantDropOrDropGroupID, UseGroup)
    print(string.format("LotteryComponent:IsGuarantItem ItemID: %d DropID: %d", ItemID, GuarantDropOrDropGroupID));
    local DropGroupTable = LotteryManager:GetDropGroupData();
    local DropTable = LotteryManager:GetDropData();
    if UseGroup then
        if DropGroupTable and DropGroupTable[GuarantDropOrDropGroupID] then
            for Index, ID in pairs(DropGroupTable[GuarantDropOrDropGroupID]) do
                if ItemID == ID then
                    return true;
                end
            end
        end
    else
        if DropTable and DropTable[GuarantDropOrDropGroupID] then
            for Index, ID in pairs(DropTable[GuarantDropOrDropGroupID]) do
                if ItemID == ID then
                    return true;
                end
            end
        end
    end

    return false;
end

--判断是否使用掉落组
--生效范围：客户端&&服务端
---@param DropID number
---@param DropGroupID number
---@return number, boolean
function LotteryComponent:IsUseDropGroup(DropID, DropGroupID)
    print(string.format("LotteryComponent:IsUseDropGroup DropID: %d, DropGroupID: %d", DropID, DropGroupID));
    local DropGroupTable = LotteryManager:GetDropGroupData();
    local DropTable = LotteryManager:GetDropData();
    if DropTable and DropTable[DropID] then
        return DropID, false;
    end

    if DropGroupTable and DropGroupTable[DropGroupID] then
        return DropGroupID, true;
    end
end

--执行掉落
--生效范围：服务端
---@param DropID number
---@param DropGroupID number
---@return any
function LotteryComponent:DoDrop(DropID, DropGroupID)
    local ID, useGroup = self:IsUseDropGroup(DropID, DropGroupID);
    local result;
    if useGroup then
        result = UGCDropSystem.DropItemsByGroup(ID);
    else
        result = UGCDropSystem.DropItems(ID);
    end

    return result;
end

--消耗道具抽奖
--生效范围：服务端
---@param LotteryID number
---@param CostNum number
---@param IsDrawTenth boolean
function LotteryComponent:UseCurrencyToDraw(LotteryID, CostNum, IsDrawTenth)
    local PlayerController = self:GetOwner();
    if PlayerController:HasAuthority() == false then
        return;
    end
    -- 判断是否是绿洲币
    local LotteryData = LotteryManager:GetLotteryConfigData(LotteryID);
    if LotteryData then
        local DrawCostID = self:GetItemIDByProduct(LotteryData.DrawCostID);
        ---消耗虚拟物品
        self:RemoveVirtualItem(DrawCostID, CostNum, function(Result)
            log_tree("[LotteryComponent] UseCurrencyToDraw Result", Result);
            local Succeeded = Result.bSucceeded;
            local PlayerKey = Result.PlayerKey;
            if Succeeded and PlayerKey == PlayerController:GetInt64PlayerKey() then
                if IsDrawTenth then
                    self:DoTenDrop(LotteryID);
                else
                    self:DoOneDrop(LotteryID);
                end
            end
        end)
    end
end

--写入抽奖记录
--生效范围：服务端
---@param LotteryID number
---@param DropRecord any
---@param DrawRecordLimit number
function LotteryComponent:WriteOneLotteryRecord(LotteryID, DropRecord, DrawRecordLimit)
    local PlayerController = self:GetOwner();
    if PlayerController:HasAuthority() == false then
        return;
    end

    local DropItemInfo = {ID = -1, Num = 0};
    for ItemID, ItemNum in pairs(DropRecord.ItemList) do
        DropItemInfo.ID = ItemID;
        DropItemInfo.Num = ItemNum;
    end
    DropItemInfo.DropType = DropRecord.DropType;
    DropItemInfo.IsDrawTenth = DropRecord.IsDrawTenth;

    local PlayerData = self:ReadPlayerData();
    -- 临时加八小时保持和客户端获取到的时间一致
    local ServerTimeSec = UGCGameSystem.GetServerTimeSec();
    local CurDate = os.date("*t", ServerTimeSec);
    local TodayTimeStamp = os.time({year=CurDate.year, month=CurDate.month, day=CurDate.day, hour=0, min=0, sec=0});
    print(string.format("服务器拿到的当前抽奖时间: %d", ServerTimeSec));

    -- 先判断是不是抽奖组
    local LotteryData = LotteryManager:GetLotteryConfigData(LotteryID);
    if LotteryData then
        local LotteryGroupID = LotteryData.DailyDrawGroup;
        if LotteryGroupID == 0 then
            -- 不使用奖池组, 按LotteryID记录
            if PlayerData.Lottery.Lottery[LotteryID] == nil then
                PlayerData.Lottery.Lottery[LotteryID] = {
                    LotteryRecords = {},
                    TotalDrawTimes = 0,
                    TodayDrawTimes = 0,
                    TodayTimeStamp = TodayTimeStamp,
                }
            else
                if TodayTimeStamp ~= PlayerData.Lottery.Lottery[LotteryID].TodayTimeStamp then
                    PlayerData.Lottery.Lottery[LotteryID].TodayTimeStamp = TodayTimeStamp;
                    PlayerData.Lottery.Lottery[LotteryID].TodayDrawTimes = 0;
                end
            end

            -- 单个奖池最多保留五十条抽奖记录
            table.insert(PlayerData.Lottery.Lottery[LotteryID].LotteryRecords, {ItemInfo = DropItemInfo, DrawTime = ServerTimeSec});
            if #PlayerData.Lottery.Lottery[LotteryID].LotteryRecords > DrawRecordLimit then
                -- 超出五十条则移除最早的记录
                table.remove(PlayerData.Lottery.Lottery[LotteryID].LotteryRecords, 1);
            end
            PlayerData.Lottery.Lottery[LotteryID].TotalDrawTimes = PlayerData.Lottery.Lottery[LotteryID].TotalDrawTimes + 1;
            PlayerData.Lottery.Lottery[LotteryID].TodayDrawTimes = PlayerData.Lottery.Lottery[LotteryID].TodayDrawTimes + 1;

            if self.IsUseLotteryGiftProgress then
                for Index, Value in pairs(LotteryData.GiftProgressRewards) do
                    if PlayerData.Lottery.LotteryGiftProgress[LotteryID] == nil then
                        PlayerData.Lottery.LotteryGiftProgress[LotteryID] = {};
                    end

                    local TotalDrawTimes = PlayerData.Lottery.Lottery[LotteryID].TotalDrawTimes;
                    if TotalDrawTimes >= Value.Progress and PlayerData.Lottery.LotteryGiftProgress[LotteryID][Value.Progress] == nil then
                        PlayerData.Lottery.LotteryGiftProgress[LotteryID][Value.Progress] = false;
                    end
                end
                self.LotteryGiftProgressInfo = PlayerData.Lottery.LotteryGiftProgress;
            end
            self.LotteryDrawInfo = PlayerData.Lottery.Lottery
        else    
            -- 使用奖池组，按LotteryGroup记录，也需要存到Lottery里方便读取当前奖池的抽取次数
            if PlayerData.Lottery.LotteryGroup[LotteryGroupID] == nil then
                PlayerData.Lottery.LotteryGroup[LotteryGroupID] = {
                    LotteryRecords = {},
                    TotalDrawTimes = 0,
                    TodayDrawTimes = 0,
                    TodayTimeStamp = TodayTimeStamp,
                }
            else
                if TodayTimeStamp ~= PlayerData.Lottery.LotteryGroup[LotteryGroupID].TodayTimeStamp then
                    PlayerData.Lottery.LotteryGroup[LotteryGroupID].TodayTimeStamp = TodayTimeStamp;
                    PlayerData.Lottery.LotteryGroup[LotteryGroupID].TodayDrawTimes = 0;
                end
            end
            if PlayerData.Lottery.Lottery[LotteryID] == nil then
                PlayerData.Lottery.Lottery[LotteryID] = {
                    LotteryRecords = {},
                    TotalDrawTimes = 0,
                    TodayDrawTimes = 0,
                    TodayTimeStamp = TodayTimeStamp,
                }
            else
                if TodayTimeStamp ~= PlayerData.Lottery.Lottery[LotteryID].TodayTimeStamp then
                    PlayerData.Lottery.Lottery[LotteryID].TodayTimeStamp = TodayTimeStamp;
                    PlayerData.Lottery.Lottery[LotteryID].TodayDrawTimes = 0;
                end
            end

            table.insert(PlayerData.Lottery.LotteryGroup[LotteryGroupID].LotteryRecords, {ItemInfo = DropItemInfo, DrawTime = ServerTimeSec});
            PlayerData.Lottery.LotteryGroup[LotteryGroupID].TotalDrawTimes = PlayerData.Lottery.LotteryGroup[LotteryGroupID].TotalDrawTimes + 1;
            PlayerData.Lottery.LotteryGroup[LotteryGroupID].TodayDrawTimes = PlayerData.Lottery.LotteryGroup[LotteryGroupID].TodayDrawTimes + 1;

            table.insert(PlayerData.Lottery.Lottery[LotteryID].LotteryRecords, {ItemInfo = {Num = DropItemInfo.Num, IsDrawTenth = DropItemInfo.IsDrawTenth, DropType = DropItemInfo.DropType, ID = DropItemInfo.ID}, DrawTime = ServerTimeSec});
            PlayerData.Lottery.Lottery[LotteryID].TotalDrawTimes = PlayerData.Lottery.Lottery[LotteryID].TotalDrawTimes + 1;
            PlayerData.Lottery.Lottery[LotteryID].TodayDrawTimes = PlayerData.Lottery.Lottery[LotteryID].TodayDrawTimes + 1;


            if #PlayerData.Lottery.LotteryGroup[LotteryGroupID].LotteryRecords > DrawRecordLimit then
                -- 超出五十条则移除最早的记录
                table.remove(PlayerData.Lottery.LotteryGroup[LotteryGroupID].LotteryRecords, 1);
            end

            if #PlayerData.Lottery.Lottery[LotteryID].LotteryRecords > DrawRecordLimit then
                -- 超出五十条则移除最早的记录
                table.remove(PlayerData.Lottery.Lottery[LotteryID].LotteryRecords, 1);
            end
        
            --- 如果是奖池组的话，这里需要更新同一个奖池组内的所有奖池组数据
            if self.IsUseLotteryGiftProgress then
                local LotteryIDList = LotteryManager:GetLotteryIDByDrawGroup(LotteryGroupID);
                for _, GroupLotteryID in pairs(LotteryIDList) do
                    local GroupLotteryData = LotteryManager:GetLotteryConfigData(GroupLotteryID);
                    if GroupLotteryData then
                        for _, Value in pairs(GroupLotteryData.GiftProgressRewards) do
                            if PlayerData.Lottery.LotteryGiftProgress[GroupLotteryID] == nil then
                                PlayerData.Lottery.LotteryGiftProgress[GroupLotteryID] = {};
                            end
    
                            local TotalDrawTimes = PlayerData.Lottery.LotteryGroup[LotteryGroupID].TotalDrawTimes;
                            if TotalDrawTimes >= Value.Progress and PlayerData.Lottery.LotteryGiftProgress[GroupLotteryID][Value.Progress] == nil then
                                PlayerData.Lottery.LotteryGiftProgress[GroupLotteryID][Value.Progress] = false;
                            end
                        end
                    end
                end
                self.LotteryGiftProgressInfo = PlayerData.Lottery.LotteryGiftProgress;
            end

            self.LotteryDrawInfo = PlayerData.Lottery.Lottery;
            self.LotteryGroupDrawInfo = PlayerData.Lottery.LotteryGroup;
        end

        local VirtualItemList = {[DropItemInfo.ID] = DropItemInfo.Num};
        self:AddVirtualItems(VirtualItemList);
    end

    local Success = self:WritePlayerData(PlayerData);
    if Success then
        local ItemList = {[1] = {ItemID = DropItemInfo.ID, ItemNum = DropItemInfo.Num}};
        self:DrawLotteryOnceDelegate(ItemList);
        UnrealNetwork.CallUnrealRPC(PlayerController, self, "Client_DisplayOneDraw", LotteryID, DropRecord, ServerTimeSec);
    else
        --避免数据写入失败后无法再次抽奖
        self.IsDrawing = false;
        _G.DOREPONCE(self, "IsDrawing");
    end
end

--写入抽奖记录
--生效范围：服务端
---@param LotteryID number
---@param TenDropRecord any
---@param DrawRecordLimit number
function LotteryComponent:WriteTenLotteryRecord(LotteryID, TenDropRecord, DrawRecordLimit)
    local PlayerController = self:GetOwner();
    if PlayerController:HasAuthority() == false then
        return;
    end

    local ItemList = {};
    local PlayerData = self:ReadPlayerData();
    -- 先判断是不是抽奖组
    local LotteryData = LotteryManager:GetLotteryConfigData(LotteryID);
    local ServerTimeSec = UGCGameSystem.GetServerTimeSec();
    local CurDate = os.date("*t", ServerTimeSec);
    print(string.format("服务器拿到的当前抽奖时间: %d", ServerTimeSec));
    local TodayTimeStamp = os.time({year=CurDate.year, month=CurDate.month, day=CurDate.day, hour=0, min=0, sec=0});
    if LotteryData then
        local LotteryGroupID = LotteryData.DailyDrawGroup;
        if LotteryGroupID == 0 then
            -- 不使用奖池组, 按LotteryID记录
            if PlayerData.Lottery.Lottery[LotteryID] == nil then
                PlayerData.Lottery.Lottery[LotteryID] = {
                    LotteryRecords = {},
                    TotalDrawTimes = 0,
                    TodayDrawTimes = 0,
                    TodayTimeStamp = TodayTimeStamp,
                }
            else
                if TodayTimeStamp ~= PlayerData.Lottery.Lottery[LotteryID].TodayTimeStamp then
                    PlayerData.Lottery.Lottery[LotteryID].TodayTimeStamp = TodayTimeStamp;
                    PlayerData.Lottery.Lottery[LotteryID].TodayDrawTimes = 0;
                end
            end

            local VirtualItemList = {};
            for Index, DropRecord in pairs(TenDropRecord) do
                local DropItemInfo = {ID = -1, Num = 0};
                for ItemID, ItemNum in pairs(DropRecord.ItemList) do
                    DropItemInfo.ID = ItemID;
                    DropItemInfo.Num = ItemNum;
                end
                DropItemInfo.DropType = DropRecord.DropType;
                DropItemInfo.IsDrawTenth = DropRecord.IsDrawTenth;
                table.insert(ItemList, {ItemID = DropItemInfo.ID, ItemNum = DropItemInfo.Num});
                if VirtualItemList[DropItemInfo.ID] == nil then
                    VirtualItemList[DropItemInfo.ID] = DropItemInfo.Num;
                else
                    VirtualItemList[DropItemInfo.ID] = VirtualItemList[DropItemInfo.ID] + DropItemInfo.Num;
                end
            
                table.insert(PlayerData.Lottery.Lottery[LotteryID].LotteryRecords, {ItemInfo = DropItemInfo, DrawTime = ServerTimeSec});
                PlayerData.Lottery.Lottery[LotteryID].TotalDrawTimes = PlayerData.Lottery.Lottery[LotteryID].TotalDrawTimes + 1;
                PlayerData.Lottery.Lottery[LotteryID].TodayDrawTimes = PlayerData.Lottery.Lottery[LotteryID].TodayDrawTimes + 1;

                if #PlayerData.Lottery.Lottery[LotteryID].LotteryRecords > DrawRecordLimit then
                    -- 超出五十条则移除最早的记录
                    table.remove(PlayerData.Lottery.Lottery[LotteryID].LotteryRecords, 1);
                end
            end
            self:AddVirtualItems(VirtualItemList);

            if self.IsUseLotteryGiftProgress then
                for Index, Value in pairs(LotteryData.GiftProgressRewards) do
                    if PlayerData.Lottery.LotteryGiftProgress[LotteryID] == nil then
                        PlayerData.Lottery.LotteryGiftProgress[LotteryID] = {};
                    end
                    --- 因为数据还没写入到Component, 所以不能调用GetTotalDrawTimes获取
                    local TotalDrawTimes = PlayerData.Lottery.Lottery[LotteryID].TotalDrawTimes;
                    if TotalDrawTimes >= Value.Progress and PlayerData.Lottery.LotteryGiftProgress[LotteryID][Value.Progress] == nil then
                        PlayerData.Lottery.LotteryGiftProgress[LotteryID][Value.Progress] = false;
                    end
                end
                self.LotteryGiftProgressInfo = PlayerData.Lottery.LotteryGiftProgress;
            end
            self.LotteryDrawInfo = PlayerData.Lottery.Lottery;
        else
            -- 使用奖池组，按LotteryGroup记录，也需要存到Lottery里方便读取当前奖池的抽取次数
            if PlayerData.Lottery.LotteryGroup[LotteryGroupID] == nil then
                PlayerData.Lottery.LotteryGroup[LotteryGroupID] = {
                    LotteryRecords = {},
                    TotalDrawTimes = 0,
                    TodayDrawTimes = 0,
                    TodayTimeStamp = TodayTimeStamp,
                }
            else
                if TodayTimeStamp ~= PlayerData.Lottery.LotteryGroup[LotteryGroupID].TodayTimeStamp then
                    PlayerData.Lottery.LotteryGroup[LotteryGroupID].TodayTimeStamp = TodayTimeStamp;
                    PlayerData.Lottery.LotteryGroup[LotteryGroupID].TodayDrawTimes = 0;
                end
            end
            if PlayerData.Lottery.Lottery[LotteryID] == nil then
                PlayerData.Lottery.Lottery[LotteryID] = {
                    LotteryRecords = {},
                    TotalDrawTimes = 0,
                    TodayDrawTimes = 0,
                    TodayTimeStamp = TodayTimeStamp,
                }
            else
                if TodayTimeStamp ~= PlayerData.Lottery.Lottery[LotteryID].TodayTimeStamp then
                    PlayerData.Lottery.Lottery[LotteryID].TodayTimeStamp = TodayTimeStamp;
                    PlayerData.Lottery.Lottery[LotteryID].TodayDrawTimes = 0;
                end
            end

            local VirtualItemList = {};
            for Index, DropRecord in pairs(TenDropRecord) do
                local DropItemInfo = {ID = -1, Num = 0};
                for ItemID, ItemNum in pairs(DropRecord.ItemList) do
                    DropItemInfo.ID = ItemID;
                    DropItemInfo.Num = ItemNum;
                end
                DropItemInfo.DropType = DropRecord.DropType;
                DropItemInfo.IsDrawTenth = DropRecord.IsDrawTenth;
                table.insert(ItemList, {ItemID = DropItemInfo.ID, ItemNum = DropItemInfo.Num});
                if VirtualItemList[DropItemInfo.ID] == nil then
                    VirtualItemList[DropItemInfo.ID] = DropItemInfo.Num;
                else
                    VirtualItemList[DropItemInfo.ID] = VirtualItemList[DropItemInfo.ID] + DropItemInfo.Num;
                end

                table.insert(PlayerData.Lottery.LotteryGroup[LotteryGroupID].LotteryRecords, {ItemInfo = DropItemInfo, DrawTime = ServerTimeSec});
                PlayerData.Lottery.LotteryGroup[LotteryGroupID].TotalDrawTimes = PlayerData.Lottery.LotteryGroup[LotteryGroupID].TotalDrawTimes + 1;
                PlayerData.Lottery.LotteryGroup[LotteryGroupID].TodayDrawTimes = PlayerData.Lottery.LotteryGroup[LotteryGroupID].TodayDrawTimes + 1;
    
                table.insert(PlayerData.Lottery.Lottery[LotteryID].LotteryRecords, {ItemInfo = {Num = DropItemInfo.Num, IsDrawTenth = DropItemInfo.IsDrawTenth, DropType = DropItemInfo.DropType, ID = DropItemInfo.ID}, DrawTime = ServerTimeSec});
                PlayerData.Lottery.Lottery[LotteryID].TotalDrawTimes = PlayerData.Lottery.Lottery[LotteryID].TotalDrawTimes + 1;
                PlayerData.Lottery.Lottery[LotteryID].TodayDrawTimes = PlayerData.Lottery.Lottery[LotteryID].TodayDrawTimes + 1;

                if #PlayerData.Lottery.LotteryGroup[LotteryGroupID].LotteryRecords > DrawRecordLimit then
                    -- 超出五十条则移除最早的记录
                    table.remove(PlayerData.Lottery.LotteryGroup[LotteryGroupID].LotteryRecords, 1);
                end
    
                if #PlayerData.Lottery.Lottery[LotteryID].LotteryRecords > DrawRecordLimit then
                    -- 超出五十条则移除最早的记录
                    table.remove(PlayerData.Lottery.Lottery[LotteryID].LotteryRecords, 1);
                end
            end
            self:AddVirtualItems(VirtualItemList);

            --- 如果是奖池组的话，这里需要更新同一个奖池组内的所有奖池组数据
            if self.IsUseLotteryGiftProgress then
                local LotteryIDList = LotteryManager:GetLotteryIDByDrawGroup(LotteryGroupID);
                for _, GroupLotteryID in pairs(LotteryIDList) do
                    local GroupLotteryData = LotteryManager:GetLotteryConfigData(GroupLotteryID);
                    for _, Value in pairs(GroupLotteryData.GiftProgressRewards) do
                        if PlayerData.Lottery.LotteryGiftProgress[GroupLotteryID] == nil then
                            PlayerData.Lottery.LotteryGiftProgress[GroupLotteryID] = {};
                        end

                        --- 因为数据还没写入到Component, 所以不能调用GetTotalDrawTimes获取
                        local TotalDrawTimes = PlayerData.Lottery.LotteryGroup[LotteryGroupID].TotalDrawTimes;
                        -- print(string.format("GroupLotteryID: %d TotalDrawTimes: %d Progress: %d", GroupLotteryID, TotalDrawTimes, Value.Progress));
                        if TotalDrawTimes >= Value.Progress and PlayerData.Lottery.LotteryGiftProgress[GroupLotteryID][Value.Progress] == nil then
                            PlayerData.Lottery.LotteryGiftProgress[GroupLotteryID][Value.Progress] = false;
                        end
                    end
                end
                -- 更新进度礼包
                self.LotteryGiftProgressInfo = PlayerData.Lottery.LotteryGiftProgress;
            end

            self.LotteryDrawInfo = PlayerData.Lottery.Lottery;
            self.LotteryGroupDrawInfo = PlayerData.Lottery.LotteryGroup;
        end
    end

    local Success = self:WritePlayerData(PlayerData);
    if Success then
        self:DrawLotteryTenTimesDelegate(ItemList);
        UnrealNetwork.CallUnrealRPC(PlayerController, self, "Client_DisplayTenDraw", LotteryID, TenDropRecord, ServerTimeSec);
    else
        --避免数据写入失败后无法再次抽奖
        self.IsDrawing = false;
        _G.DOREPONCE(self, "IsDrawing");
    end
end

--写入持久化数据
---生效范围: 服务端
---@param PlayerData any
---@return boolean
function LotteryComponent:WritePlayerData(PlayerData)
    local PlayerController = self:GetOwner();
    if PlayerController:HasAuthority() == false then
        return;
    end

    local UID = PlayerController:GetInt64UID();
    local bSuccess = UGCPlayerStateSystem.SavePlayerArchiveData(UID, PlayerData);

    if bSuccess == true then
        self.LotteryPlayerData = PlayerData;
        print(string.format("LotteryComponent:Write UID: %d PlayerData Success", UID));
    else
        print(string.format("LotteryComponent:Write UID: %d PlayerData Failed", UID));
    end

    return bSuccess;
end

--读取持久化数据
---生效范围: 服务端
---@return any
function LotteryComponent:ReadPlayerData()
    print("LotteryComponent:ReadPlayerData")
    local PlayerController = self:GetOwner();
    if PlayerController:HasAuthority() == false then
        return;
    end
    if self.LotteryPlayerData == nil then
        local UID = PlayerController:GetInt64UID();
        local PlayerData = UGCPlayerStateSystem.GetPlayerArchiveData(UID);

        if PlayerData == nil then
            PlayerData = {
                Lottery = {
                    Lottery = {},
                    LotteryGroup = {},
                    LotteryGiftProgress = {},
                    LotterySkipAnim = false;
                },
            }
            UGCPlayerStateSystem.SavePlayerArchiveData(UID, PlayerData);
        else
            local NeedSave = false;
            if PlayerData.Lottery == nil then
                PlayerData.Lottery = {
                    Lottery = {},
                    LotteryGroup = {},
                    LotteryGiftProgress = {},
                    LotterySkipAnim = false;
                };
            end
            UGCPlayerStateSystem.SavePlayerArchiveData(UID, PlayerData);
        end
        self.LotteryPlayerData = PlayerData;
    end
    return self.LotteryPlayerData
end

--获取总抽奖次数, 同个奖池组的奖池共享进度礼包的进度
--生效范围：客户端&&服务端
---@param LotteryID number
---@return number
function LotteryComponent:GetTotalDrawTimes(LotteryID)
    local IsUseLotteryGroup, GroupID = self:IsUseLotteryGroup(LotteryID);
    if IsUseLotteryGroup then
        local DrawInfo = self.LotteryGroupDrawInfo;
        if DrawInfo[GroupID] then
            print(string.format("LotteryComponent:GetTotalDrawTimes LotteryGroupID: %d, TotalDrawTimes: %d",GroupID, DrawInfo[GroupID].TotalDrawTimes));
            return DrawInfo[GroupID].TotalDrawTimes;
        end
    else
        local DrawInfo = self.LotteryDrawInfo;
        if DrawInfo[LotteryID] then
            print(string.format("LotteryComponent:GetTotalDrawTimes LotteryID: %d, TotalDrawTimes: %d",LotteryID, DrawInfo[LotteryID].TotalDrawTimes));
            return DrawInfo[LotteryID].TotalDrawTimes;
        end
    end

    return 0;
end

--获取今日抽奖次数
--生效范围：客户端&&服务端
---@param LotteryID number
---@return number
function LotteryComponent:GetTodayDrawTimes(LotteryID)
    local IsUseLotteryGroup, GroupID = self:IsUseLotteryGroup(LotteryID);
    if IsUseLotteryGroup then
        local DrawInfo = self.LotteryGroupDrawInfo;
        if DrawInfo[GroupID] then
            print(string.format("LotteryComponent:GetTodayDrawTimes LotteryGroupID: %d, TotalDrawTimes: %d",GroupID, DrawInfo[GroupID].TodayDrawTimes));
            return DrawInfo[GroupID].TodayDrawTimes;
        end
    else
        local DrawInfo = self.LotteryDrawInfo;
        if DrawInfo[LotteryID] then
            print(string.format("LotteryComponent:GetTodayDrawTimes LotteryID: %d, TotalDrawTimes: %d",LotteryID, DrawInfo[LotteryID].TodayDrawTimes));
            return DrawInfo[LotteryID].TodayDrawTimes;
        end
    end

    return 0;
end

--读取抽奖记录
--生效范围：客户端&&服务端
---@param LotteryID number
---@param CheckLotteryGroup boolean
---@return any
function LotteryComponent:GetLotteryRecords(LotteryID, CheckLotteryGroup)
    if CheckLotteryGroup then
        local IsUseLotteryGroup, GroupID = self:IsUseLotteryGroup(LotteryID);
        if IsUseLotteryGroup then
            local LotteryGroup = self.LotteryGroupDrawInfo;
            if LotteryGroup[GroupID] then
                return LotteryGroup[GroupID].LotteryRecords;
            end
        else
            local Lottery = self.LotteryDrawInfo;
            if Lottery[LotteryID] then
                return Lottery[LotteryID].LotteryRecords;
            end
        end
    else
        local Lottery = self.LotteryDrawInfo;
        if Lottery[LotteryID] then
            return Lottery[LotteryID].LotteryRecords;
        end
    end

    return {};
end

--判断是否属于奖池组
--生效范围：客户端&&服务端
---@param LotteryID number
---@return boolean, number
function LotteryComponent:IsUseLotteryGroup(LotteryID)
    print(string.format("LotteryComponent:IsUseLotteryGroup LotteryID: %d", LotteryID));
    local LotteryData = LotteryManager:GetLotteryConfigData(LotteryID);
    if LotteryData and LotteryData.DailyDrawGroup then
        if LotteryData.DailyDrawGroup == 0 then
            return false, LotteryID;
        else
            return true, LotteryData.DailyDrawGroup;
        end
    end
    return false, LotteryID;
end

--判断是否可以抽奖
--生效范围：服务端
---@param LotteryID number
---@param CostCurrencyNum number
---@return boolean
function LotteryComponent:CheckCanDraw(LotteryID, CostCurrencyNum)
    local PlayerController = self:GetOwner();
    if PlayerController:HasAuthority() == false then
        return;
    end

    local LotteryData = LotteryManager:GetLotteryConfigData(LotteryID);
    if LotteryData then
        local LotteryDailyDrawLimit = LotteryData.DailyDrawLimit;   
        local CostCurrencyID = self:GetItemIDByProduct(LotteryData.DrawCostID);
        local CurCurencyNum = self:GetItemNum(CostCurrencyID);
        if CostCurrencyNum > CurCurencyNum then
            return false;
        end
        local TodayDrawTimes = self:GetTodayDrawTimes(LotteryID);
        if LotteryDailyDrawLimit > 0 and TodayDrawTimes >= LotteryDailyDrawLimit then
            return false;
        end
        return true;
    end
    return false;
end

--获取抽奖数据
--生效范围：客户端&&服务端
---@param LotteryID number
---@return any
function LotteryComponent:GetLotteryInfo(LotteryID)
    local IsUseLotteryGroup, GroupID = self:IsUseLotteryGroup(LotteryID);
    if IsUseLotteryGroup then
        local LotteryGroup = self.LotteryGroupDrawInfo;
        return LotteryGroup[GroupID];
    else
        local Lottery = self.LotteryDrawInfo;
        return Lottery[LotteryID]
    end

    return nil;
end

--获取当前奖池ID
--生效范围：客户端
function LotteryComponent:GetCurLotteryID()
    if self.LotteryMainUI then
        return self.LotteryMainUI.SelectedLotteryID;
    end
    return -1;
end

--兑换道具
--生效范围：客户端
---@param ProductID number
---@param ExchangeNum number
function LotteryComponent:ExchangeProduct(ProductID, ExchangeNum)
    print("LotteryComponent:ExchangeProduct");
    local PlayerController = self:GetOwner();
    if PlayerController:HasAuthority() == true then
        return;
    end
    local ProductData = self:GetProductDataByID(ProductID);
    if ProductData then
        -- 防止连续点击
        if self.IsBuying == true then
            return;
        end
        local Price = LotteryManager:GetDiscountPrice(ProductID);
        --- 判断是绿洲币还是非绿洲币
        if ProductData.CurrencyType == ECurrencyType.OtherCoin then
            --- 判断能否支付
            local CanAfford = self:CanAfford(ProductID, ExchangeNum);
            if CanAfford then
                self:BuyProduct(ProductID, Price, ExchangeNum);
            else
                -- 碎片不足
                self:OpenLotteryConfirmUI("碎片不足，可前往活动获取", "前往获取", function()
                    self:CloseLotteryConfirmUI();
                    self:ClosePurchaseUI();
                    self:CloseLotteryExchange();
                    -- 打开抽奖
                    self:OpenPanel();
                end);
            end
        else
            self:BuyProduct(ProductID, Price, 1);
        end
    end
end

--购买商品
--生效范围：客户端
---@param ProductID number
---@param Price number
---@param PurchasNum number
function LotteryComponent:PurchaseProduct(ProductID, Price, PurchasNum)
    print("LotteryComponent:PurchaseProduct");
    local PlayerController = self:GetOwner();
    if PlayerController:HasAuthority() == true then
        return;
    end
    local ProductData = self:GetProductDataByID(ProductID);
    if ProductData then
        -- 防止连续点击
        if self.IsBuying == true then
            return;
        end
        --- 判断是绿洲币还是非绿洲币
        if ProductData.CurrencyType == ECurrencyType.OtherCoin then
            --- 判断能否支付
            local CanAfford = self:CanAfford(ProductID, PurchasNum);
            if CanAfford then
                self:BuyProduct(ProductID, Price, PurchasNum);
            else
                -- 碎片不足
                self:OpenLotteryMessageUI("购买失败，货币不足");
            end
        else
            self:BuyProduct(ProductID, Price, 1);
        end
    end
end

--领取进度礼包
--生效范围：客户端
---@param LotteryID number
---@param Progress number
function LotteryComponent:GetProgressItem(LotteryID, Progress)
    local PlayerController = self:GetOwner();
    local LotteryGiftProgressInfo = self.LotteryGiftProgressInfo;
    if LotteryGiftProgressInfo[LotteryID] and LotteryGiftProgressInfo[LotteryID][Progress] then
        return;
    end

    UnrealNetwork.CallUnrealRPC(PlayerController, self, "Server_GetProgressReward", LotteryID, Progress);
end

function LotteryComponent:Server_GetProgressReward(LotteryID, Progress)
    local PlayerController = self:GetOwner();
    if PlayerController:HasAuthority() == false then
        return;
    end
    local LotteryData = LotteryManager:GetLotteryConfigData(LotteryID);
    if LotteryData then
        local PlayerData = self:ReadPlayerData();
        if PlayerData.Lottery.LotteryGiftProgress[LotteryID] and PlayerData.Lottery.LotteryGiftProgress[LotteryID][Progress] == true then
            -- 已领取过
            self:AddGiftPackageDelegate(false);
            UnrealNetwork.CallUnrealRPC(PlayerController, self, "AddGiftPackageDelegate", false);
            return false;
        end
        local IsUseGroup, GroupID = self:IsUseLotteryGroup(LotteryID);
        local DrawTimes = 0;
        if IsUseGroup then
            if PlayerData.Lottery.LotteryGroup[GroupID] then
                DrawTimes = PlayerData.Lottery.LotteryGroup[GroupID].TotalDrawTimes;
            end
        else
            if PlayerData.Lottery.Lottery[LotteryID] then
                DrawTimes = PlayerData.Lottery.Lottery[LotteryID].TotalDrawTimes;
            end
        end
        if DrawTimes >= Progress then
            -- 进度达成，可以领取奖励
            if PlayerData.Lottery.LotteryGiftProgress[LotteryID] and PlayerData.Lottery.LotteryGiftProgress[LotteryID][Progress] == false then
                local ItemList = {};
                for Index, Value in pairs(LotteryData.GiftProgressRewards) do
                    if Progress == Value.Progress then
                        for i, ItemInfo in pairs(Value.ItemList) do
                            if ItemList[ItemInfo.ItemID] then
                                ItemList[ItemInfo.ItemID] = ItemList[ItemInfo.ItemID] + ItemInfo.ItemCount;
                            else
                                ItemList[ItemInfo.ItemID] = ItemInfo.ItemCount;
                            end
                        end
                    end
                end
                self:AddVirtualItems(ItemList);
                PlayerData.Lottery.LotteryGiftProgress[LotteryID][Progress] = true;
                self.LotteryGiftProgressInfo = PlayerData.Lottery.LotteryGiftProgress;

                local Success = self:WritePlayerData(PlayerData);
                if Success then
                    _G.DOREPONCE(self, "LotteryGiftProgressInfo");
                    UnrealNetwork.CallUnrealRPC(PlayerController, self, "Client_GetProgressReward", LotteryID, Progress, ItemList);
                end
                self:AddGiftPackageDelegate(Success);
                UnrealNetwork.CallUnrealRPC(PlayerController, self, "AddGiftPackageDelegate", Success);
                return Success;
            end
        end
    end
    self:AddGiftPackageDelegate(false);
    UnrealNetwork.CallUnrealRPC(PlayerController, self, "AddGiftPackageDelegate", false);
    return false;
end

function LotteryComponent:Client_GetProgressReward(LotteryID, Progress, ItemList)
    local GetItemList = {};
    for ID, Num in pairs(ItemList) do
        table.insert(GetItemList, {ItemID = ID, ItemNum = Num});
    end
    -- 打开获得道具界面
    self:OpenGetItemUI(GetItemList);
    -- 更新进度礼包
    if self.LotteryMainUI then
        self.LotteryMainUI:GetGiftProgress(LotteryID, Progress); 
    end
end

--设置跳过动画
--生效范围：客户端
---@param IsSkipAnim boolean
function LotteryComponent:WriteSkipAnim(IsSkipAnim)
    local PlayerController = self:GetOwner();
    if PlayerController:HasAuthority() == true then
        return;
    end

    local PlayerKey = PlayerController:GetInt64PlayerKey();
    UnrealNetwork.CallUnrealRPC(PlayerController, self, "Server_ChangeSkipAnim", IsSkipAnim);
end

function LotteryComponent:Server_ChangeSkipAnim(IsSkipAnim)
    local PlayerController = self:GetOwner();
    if PlayerController:HasAuthority() == false then
        return;
    end
    local PlayerData = self:ReadPlayerData();
    PlayerData.Lottery.LotterySkipAnim = IsSkipAnim;
    self.LotterySkipAnim = IsSkipAnim;
    _G.DOREPONCE(self, "LotterySkipAnim");
    self:WritePlayerData(PlayerData);
end

--获取跳过动画设置
--生效范围：客户端&&服务端
---@return boolean
function LotteryComponent:GetSkipAnim()
    return self.LotterySkipAnim;
end

--同步跳过动画设置
--生效范围：客户端
function LotteryComponent:OnRep_LotterySkipAnim()
end

--获取进度礼包领取状态
--生效范围：客户端&&服务端
---@param LotteryID number
---@param Progress number
---@return boolean
function LotteryComponent:CheckGiftProgressGet(LotteryID, Progress)
    local LotteryGiftProgressInfo = self.LotteryGiftProgressInfo;
    if LotteryGiftProgressInfo[LotteryID] and LotteryGiftProgressInfo[LotteryID][Progress] == true then
        return true;
    end

    return false;
end

----------------------------------------- UI相关 -----------------------------------------
--初始化抽奖主界面
--生效范围：客户端
function LotteryComponent:InitLotteryMainUI()
    print("LotteryComponent:InitLotteryMainUI");
    local PlayerController = self:GetOwner();
    if PlayerController:HasAuthority() == true then
        return;
    end

    if self.LotteryMainUI and self.LotteryModeOneUI and self.LotteryModeTwoUI then
        self.LotteryMainUI:InitData(self.IsUseModeOne, self.IsUseLotteryExchange, self.IsUseLotteryGiftProgress, self.ShowAwardNum);
        self.LotteryMainUI:CreatePanel(self.LotteryModeOneUI, self.LotteryModeTwoUI);
    end
end

--打开抽奖主界面
--生效范围：客户端
function LotteryComponent:OpenPanel()
    print("LotteryComponent:OpenPanel");
    local PlayerController = self:GetOwner();
    if PlayerController:HasAuthority() == true then
        return;
    end
    if self.LotteryMainUI then
        LotteryManager.OnItemNumChangeDelegate();
        self.LotteryMainUI:InitCurrencyBar()
        self.LotteryMainUI:SetVisibility(ESlateVisibility.Visible);

        -- 用本地时间
        local CurrentTime = os.date("*t", UGCGameSystem.GetServerTimeSec());
        -- 下一次刷新时间是明天的零点
        self.NextRefreshTime = os.time({year=CurrentTime.year, month=CurrentTime.month, day=CurrentTime.day, hour=0});
        self.NextRefreshTime = self.NextRefreshTime + 24 * 60 * 60;
        -- 兑换道具每小时刷新一次
        self.ProductRefreshTime = os.time({year=CurrentTime.year, month=CurrentTime.month, day=CurrentTime.day, hour=CurrentTime.hour}) + 60 * 60 + 1;

        self.RefreshTimer = Timer.InsertTimer(
            1, 
            function ()
                -- 超过零点后刷新抽奖次数，首抽折扣刷新
                local ServerTime = UGCGameSystem.GetServerTimeSec();
                local CurrentTime = os.date("*t", ServerTime);

                print(string.format("[LotteryComponent] 计时器 ServerTime: %d NextRefreshTime: %d ProductRefreshTime: %d", ServerTime, self.NextRefreshTime, self.ProductRefreshTime));
                if ServerTime >= self.NextRefreshTime then
                    -- 计算下一次刷新时间
                    -- 下一次刷新时间是明天的零点
                    self.NextRefreshTime = os.time({year=CurrentTime.year, month=CurrentTime.month, day=CurrentTime.day, hour=0});
                    self.NextRefreshTime = self.NextRefreshTime + 24 * 60 * 60;

                    -- 如果存在每日抽奖次数限制则刷新
                    local TodayDrawTimes = self:GetTodayDrawTimes(self.LotteryMainUI.SelectedLotteryID);
                    self:RefreshTodayDrawTimes(TodayDrawTimes);
                    -- 如果存在首抽折扣且可重置则刷新
                    self.LotteryMainUI:RefreshDrawDiscount();
                end

                -- 刷新兑换道具
                if ServerTime >= self.ProductRefreshTime and self.LotteryExchangeUI then
                    -- 重新获取合法商品列表
                    self.LotteryExchangeUI:RefreshExchangeInfo();
                    self.ProductRefreshTime = os.time({year=CurrentTime.year, month=CurrentTime.month, day=CurrentTime.day, hour=CurrentTime.hour}) + 60 * 60 + 1;
                end
            end,
            true,
            "RefreshTimer"
        );
    end
end

--关闭抽奖主界面
--生效范围：客户端
function LotteryComponent:ClosePanel()
    local PlayerController = self:GetOwner();
    if PlayerController:HasAuthority() == true then
        return;
    end
    print("LotteryComponent:ClosePanel");
    if self.LotteryMainUI then
        -- 关闭抽奖界面
        self.LotteryMainUI:SetVisibility(ESlateVisibility.Collapsed);
        self.LotteryMainUI:ScrollToStart();
        -- 每次关闭时选中第一个奖池，避免打开时闪烁
        self.LotteryMainUI.SelectedLotteryID = -1;
        if LotteryManager and LotteryManager.LotteryDatas and LotteryManager.LotteryDatas[1] then
            self:SelectLottery(LotteryManager.LotteryDatas[1].ID);
        end

        if self.RefreshTimer ~= nil then
            Timer.RemoveTimer(self.RefreshTimer);
            self.RefreshTimer = nil;
        end
    end
end

--选择奖池
--生效范围：客户端
---@param LotteryID number
function LotteryComponent:SelectLottery(LotteryID)
    print("LotteryComponent:SelectLottery");
    local PlayerController = self:GetOwner();
    if PlayerController:HasAuthority() == true then
        return;
    end
    if self.LotteryMainUI then
        self.LotteryMainUI:SelectLottery(LotteryID);
    end
end

--刷新总抽奖次数
--生效范围：客户端
---@param TotalDrawTimes number
function LotteryComponent:RefreshTotalDrawTimes(TotalDrawTimes)
    self.LotteryMainUI:RefreshTotalDrawTimes(TotalDrawTimes);
end

--刷新今日抽奖次数
--生效范围：客户端
---@param TotalDrawTimes number
function LotteryComponent:RefreshTodayDrawTimes(TotalDrawTimes)
    self.LotteryMainUI:RefreshTodayDrawTimes(TotalDrawTimes);
end

--选择道具
--生效范围：客户端
---@param ItemID number
function LotteryComponent:SelectItem(ItemID)
    if self.LotteryAwardPreviewUI then
        self.LotteryAwardPreviewUI:SelectItem(ItemID);
    end
end

--刷新对应奖池的道具预览
--生效范围：客户端
---@param LotteryID number
function LotteryComponent:RefreshAwardPreview(LotteryID)
    if self.LotteryMainUI and self.LotteryAwardPreviewUI then
        self.LotteryAwardPreviewUI:InitUI(LotteryID);
    end
end

--打开当前奖池的道具预览
--生效范围：客户端
function LotteryComponent:OpenLotteryAwardPreview()
    if self.LotteryAwardPreviewUI then
        self.LotteryAwardPreviewUI:InitUI(self.LotteryMainUI.SelectedLotteryID);
        self:SelectItem(self.LotteryAwardPreviewUI.ItemIDList[1]);
        self.LotteryAwardPreviewUI:SetVisibility(ESlateVisibility.Visible);
    end
end

--打开商品兑换界面
--生效范围：客户端
function LotteryComponent:OpenLotteryExchange()
    if self.LotteryExchangeUI then
        self.LotteryExchangeUI:InitUI();
        self.LotteryExchangeUI:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
    end
end

--关闭商品兑换界面
--生效范围：客户端
function LotteryComponent:CloseLotteryExchange()
    if self.LotteryExchangeUI then
        self.LotteryExchangeUI:SetVisibility(ESlateVisibility.Collapsed);
    end
end

--打开抽奖记录界面
--生效范围：客户端
function LotteryComponent:OpenLotteryAwardRecord()
    if self.LotteryMainUI and self.LotteryAwardRecordUI then
        local PlayerController = self:GetOwner();
        self.LotteryAwardRecordUI:InitUI(self:GetLotteryRecords(self.LotteryMainUI.SelectedLotteryID, true));
        self.LotteryAwardRecordUI:ScrollToStart();
        self.LotteryAwardRecordUI:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
    end
end

--打开抽奖说明界面
--生效范围：客户端
---@param LotteryExplanation string
function LotteryComponent:OpenLotteryExplanation(LotteryExplanation)
    if self.LotteryExplanationUI then
        self.LotteryExplanationUI:InitUI(LotteryExplanation);
        self.LotteryExplanationUI:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
    end
end

--根据商品类型打开对应商品兑换界面
--生效范围：客户端
---@param ProductID number
function LotteryComponent:OpenExchangeProductUI(ProductID)
    local ProductData = self:GetProductDataByID(ProductID);
    if ProductData then
        if ProductData.CurrencyType == ECurrencyType.OasisCoin then
            local Price = LotteryManager:GetDiscountPrice(ProductID);
            self:BuyProduct(ProductID, Price, 1);
        else
            if self.LotteryPurchaseItemUI then
                self.LotteryPurchaseItemUI:ExchangeProduct(ProductID);
                self.LotteryPurchaseItemUI:SetVisibility(ESlateVisibility.Visible);
            end
        end
    end
end

--根据商品类型打开对应商品购买界面
--生效范围：客户端
---@param ProductID number
function LotteryComponent:OpenPurchaseProductUI(ProductID)
    local ProductData = self:GetProductDataByID(ProductID);
    if ProductData then
        if ProductData.CurrencyType == ECurrencyType.OasisCoin then
            local Price = LotteryManager:GetDiscountPrice(ProductID);
            self:BuyProduct(ProductID, Price, 1);
        else
            if self.LotteryPurchaseItemUI then
                self.LotteryPurchaseItemUI:BuyProduct(ProductID);
                self.LotteryPurchaseItemUI:SetVisibility(ESlateVisibility.Visible);
            end
        end
    end
end

--关闭商品购买界面
--生效范围：客户端
function LotteryComponent:ClosePurchaseUI()
    if self.LotteryPurchaseItemUI then
        self.LotteryPurchaseItemUI:SetVisibility(ESlateVisibility.Collapsed);
    end
end

--打开道具获得界面
--生效范围：客户端
---@param ItemList any
function LotteryComponent:OpenGetItemUI(ItemList)
    if self.LotteryItemGetUI then
        self.LotteryItemGetUI:InitUI(ItemList);
        self.LotteryItemGetUI:SetVisibility(ESlateVisibility.Visible);
    end
end

--关闭道具获得界面
--生效范围：客户端
function LotteryComponent:CloseGetItemUI()
    if self.LotteryItemGetUI then
        self.LotteryItemGetUI:SetVisibility(ESlateVisibility.Collapsed);
    end
end

--获取绿洲币路径
--生效范围：客户端
---@return string
function LotteryComponent:GetOasisCoinIconPath()
    return self.OasisCoinIconPath.AssetPathName;
end

--打开进度礼包提示界面
--生效范围：客户端
---@param Progress number
---@param Desc string
---@param ItemID number
---@param Position any
function LotteryComponent:OpenLotteryGiftProgressTipUI(Progress, Desc, ItemID, Position)
    if self.LotteryGiftProgressTipUI then
        self.LotteryGiftProgressTipUI:ShowAwardItemTip(Progress, Desc, ItemID, Position);
        self.LotteryGiftProgressTipUI:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
    end
end

--关闭进度礼包提示界面
--生效范围：客户端
function LotteryComponent:CloseLotteryGiftProgressTipUI()
    if self.LotteryGiftProgressTipUI then
        self.LotteryGiftProgressTipUI:SetVisibility(ESlateVisibility.Collapsed);
    end
end

--打开道具提示界面
--生效范围：客户端
---@param ItemID number
---@param Pos any
function LotteryComponent:OpenLotteryItemTipUI(ItemID, Pos)
    if self.LotteryItemTipUI then
        self.LotteryItemTipUI:ShowItemTip(ItemID, Pos);
        self.LotteryItemTipUI:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
    end
end

--关闭道具提示界面
--生效范围：客户端
function LotteryComponent:CloseLotteryItemTipUI()
    if self.LotteryItemTipUI then
        self.LotteryItemTipUI:SetVisibility(ESlateVisibility.Collapsed);
    end
end

--打开消息界面
--生效范围：客户端
---@param Text string
function LotteryComponent:OpenLotteryMessageUI(Text)
    if self.LotteryMessageTipUI then
        self.LotteryMessageTipUI:ShowMessageTip(Text);
        self.LotteryMessageTipUI:SetVisibility(ESlateVisibility.Visible);
    end
end

--关闭消息界面
--生效范围：客户端
function LotteryComponent:CloseLotteryMessageUI()
    if self.LotteryMessageTipUI then
        self.LotteryMessageTipUI:SetVisibility(ESlateVisibility.Collapsed);
    end
end

--打开二次确认界面
--生效范围：客户端
---@param Text string
---@param ConfirmBtnText string
---@param ConfirmFunc function
function LotteryComponent:OpenLotteryConfirmUI(Text, ConfirmBtnText, ConfirmFunc)
    if self.LotteryConfirmUI then
        self.LotteryConfirmUI:Show(Text, ConfirmBtnText, ConfirmFunc);
        self.LotteryConfirmUI:SetVisibility(ESlateVisibility.Visible);
    end
end

--关闭二次确认界面
--生效范围：客户端
function LotteryComponent:CloseLotteryConfirmUI()
    if self.LotteryConfirmUI then
        self.LotteryConfirmUI:SetVisibility(ESlateVisibility.Collapsed);
    end
end

--关闭抽奖结果界面
--生效范围：客户端
function LotteryComponent:CloseLotteryDrawDisplayUI()
    if self.LotteryDrawDisplayUI then
        self.LotteryDrawDisplayUI:SetVisibility(ESlateVisibility.Collapsed);
    end
end

--刷新进度礼包领取状态
--生效范围：客户端
function LotteryComponent:RefreshGiftProgress()
    --- 如果礼包有解锁，则刷新礼包状态
    if self.LotteryMainUI and self.IsUseLotteryGiftProgress then
        self.LotteryMainUI:RefreshGiftProgress();
    end
end

----------------------------------------- GamePart接口相关 -----------------------------------------
--添加道具 
--生效范围：服务端
---@param AwardList any
---@return boolean
function LotteryComponent:AddVirtualItems(AwardList)
    local PlayerController = self:GetOwner();
    if PlayerController:HasAuthority() == false then
        return false;
    end
    if UE.IsValid(self:GetVirtualItemManager()) then
        return self:GetVirtualItemManager():AddVirtualItems(PlayerController, AwardList);
    end
    return false;
end

--添加道具回调
--生效范围：服务端
---@param Result any
function LotteryComponent:OnAddVirtualItem(Result)
    log_tree("[LotteryComponent] OnAddVirtualItem:", Result);
    local PlayerController = self:GetOwner();
    local bSucceeded = Result.bSucceeded;
    local ItemList = Result.ItemList;
end

--消耗道具
--生效范围：服务端
---@param ItemID number
---@param Num number
---@param Callback function
function LotteryComponent:RemoveVirtualItem(ItemID, Num, Callback)
    local PlayerController = self:GetOwner();
    if PlayerController:HasAuthority() == false then
        return;
    end
    if UE.IsValid(self:GetVirtualItemManager()) then
        self:GetVirtualItemManager():RemoveItem(PlayerController, ItemID, Num, Callback);
    end
end

--消耗道具回调
--生效范围：服务端
---@param Result any
function LotteryComponent:OnRemoveVirtualItem(Result)
    log_tree("[LotteryComponent] OnRemoveVirtualItem:", Result);
    local PlayerController = self:GetOwner();
    local bSucceeded = Result.bSucceeded;
    local PlayerKey = Result.PlayerKey;
    local ItemID = Result.ItemID;
    local Num = Result.Num;
end

function LotteryComponent:OnVirtualItemNumUpdate()
    ---虚拟物品数量更新，刷新Topmenu
    LotteryManager.OnItemNumChangeDelegate();
end

--获取已拥有的道具数量
--生效范围：客户端&&服务端
---@param ItemID number
---@return number
function LotteryComponent:GetItemNum(ItemID)
    if UE.IsValid(self:GetVirtualItemManager()) then
        local PlayerController = self:GetOwner();
        return self:GetVirtualItemManager():GetItemNum(ItemID, PlayerController);
    end
    return 0;
end

--获取道具配置
--生效范围：客户端&&服务端
---@param ItemID number
---@return any
function LotteryComponent:GetObjectDataByID(ItemID)
    if UE.IsValid(self:GetVirtualItemManager()) then
        return self:GetVirtualItemManager():GetItemData(ItemID);
    end
    return nil;
end

--发起商品购买
--生效范围：客户端
---@param ProductID number
---@param CurrentPrice number
---@param Num number
function LotteryComponent:BuyProduct(ProductID, CurrentPrice, Num)
    if UE.IsValid(self:GetCommodityManager()) then
        self.IsBuying = true;
        self:GetCommodityManager():BuyProduct(ProductID, CurrentPrice, Num);
    end
end

--商品购买回调
--生效范围：客户端
---@param Result any
function LotteryComponent:OnBuyProduct(Result)
    log_tree("[LotteryComponent] OnBuyProduct:", Result);
    self.IsBuying = false;
    local bSucceeded = Result.bSucceeded;
    local PlayerKey = Result.PlayerKey;
    local ProductID = Result.ProductID;
    local Num = math.floor(Result.Num);
    local Validation = Result.Validation or -1;
    if bSucceeded then
        local ProductData = self:GetProductDataByID(ProductID);
        ---打开获得道具界面
        local ItemList = {[1] = {ItemID = ProductData.ItemID, ItemNum = Num * ProductData.ItemNum}};
        self:OpenGetItemUI(ItemList);
    else
        print(string.format("购买商品失败, 错误码: %d", Validation));
    end
end

--商品购买数量更新回调
--生效范围：客户端&&服务端
function LotteryComponent:OnLimitProductUpdate()
    print("LotteryComponent:OnLimitProductUpdate");
    ---刷新限购状态
    if self.LotteryExchangeUI then
        ---需要存到DS上发给客户端
        self.LotteryExchangeUI:RefreshPurchaseLimitInfo();
    end
end

--检查是否买得起指定数量的商品
--生效范围：客户端&&服务端
---@param ProductID number
---@param Num number
---@param PlayerController BP_UGCPlayerController_C
---@return boolean
function LotteryComponent:CanAfford(ProductID, Num, PlayerController)
    if UE.IsValid(self:GetCommodityManager()) then
        return self:GetCommodityManager():CanAfford(ProductID, Num, PlayerController);
    end
    return false;
end

--获取限购商品的购买次数
--生效范围：客户端&&服务端
---@param ProductID number @商品的ID
---@param PlayerController BP_UGCPlayerController_C @玩家控制器，客户端可以不传
---@return number
function LotteryComponent:GetLimitPurchasedTimes(ProductID, PlayerController)
    if UE.IsValid(self:GetCommodityManager()) then
        return self:GetCommodityManager():GetLimitPurchasedTimes(ProductID, PlayerController);
    end
    return 0;
end

--获取全部商品配置
--生效范围：客户端&&服务端
---@return any
function LotteryComponent:GetAllProductData()
    if UE.IsValid(self:GetCommodityManager()) then
        return self:GetCommodityManager():GetAllProductData();
    end
    return {};
end

--获取商品配置
--生效范围：客户端&&服务端
---@param ProductID number
---@return any
function LotteryComponent:GetProductDataByID(ProductID)
    if UE.IsValid(self:GetCommodityManager()) then
        return self:GetCommodityManager():GetProductData(ProductID);
    end
    return nil;
end

--获取商品对应的道具ID
--生效范围：客户端&&服务端
---@param ProductID number
---@return number
function LotteryComponent:GetItemIDByProduct(ProductID)
    local ProductID = self:GetProductDataByID(ProductID);
    if ProductID then
        return ProductID.ItemID;
    end
    return -1;
end

function LotteryComponent:GetVirtualItemManager()
    if self.VirtualItemManager == nil and UGCGamePartSystem.IsGamePartLoaded("VirtualItemManager") then
        self.VirtualItemManager = UGCGamePartSystem.GetGamePartGlobalActor("VirtualItemManager");
    end
    return self.VirtualItemManager;
end

function LotteryComponent:GetCommodityManager()
    if self.CommodityManager == nil and UGCGamePartSystem.IsGamePartLoaded("CommodityOperationManager") then
        self.CommodityManager = UGCGamePartSystem.GetGamePartGlobalActor("CommodityOperationManager");
    end
    return self.CommodityManager;
end

----------------------------------------- API接口相关 -----------------------------------------
--抽奖一次
--生效范围：客户端&&服务端
---@param LotteryID number
---@param PlayerController BP_UGCPlayerController_C
function LotteryComponent:DrawLotteryOnce(LotteryID, PlayerController)
    if PlayerController == nil then
        PlayerController = self:GetOwner();
    end
    if PlayerController:HasAuthority() == true then
        self:Server_DrawOnce(LotteryID);
    else
        UnrealNetwork.CallUnrealRPC(PlayerController, self, "Server_DrawOnce", LotteryID);
    end
end

--抽奖一次回调
--生效范围：客户端&&服务端
---@param ItemList any
function LotteryComponent:DrawLotteryOnceDelegate(ItemList)
    print("[LotteryComponent] DrawLotteryOnceDelegate");
    log_tree("DrawLotteryOnceDelegate ItemList:", ItemList);
    LotteryManager.OnDrawLotteryOnceDelegate(ItemList);
end

--抽奖十次
--生效范围：客户端&&服务端
---@param LotteryID number
---@param PlayerController BP_UGCPlayerController_C
function LotteryComponent:DrawLotteryTenTimes(LotteryID, PlayerController)
    if PlayerController == nil then
        PlayerController = self:GetOwner();
    end
    if PlayerController:HasAuthority() == true then
        self:Server_DrawTenth(LotteryID);
    else
        UnrealNetwork.CallUnrealRPC(PlayerController, self, "Server_DrawTenth", LotteryID);
    end
end

--抽奖一次回调
--生效范围：客户端&&服务端
---@param ItemList any
function LotteryComponent:DrawLotteryTenTimesDelegate(ItemList)
    print("[LotteryComponent] DrawLotteryTenTimesDelegate");
    log_tree("DrawLotteryTenTimesDelegate ItemList:", ItemList);
    LotteryManager.OnDrawLotteryTenTimesDelegate(ItemList);
end

--领取买赠礼包
--生效范围：客户端&&服务端
---@param LotteryID number
---@param ProgressLevel number
---@param PlayerController BP_UGCPlayerController_C
function LotteryComponent:AddGiftPackage(LotteryID, ProgressLevel, PlayerController)
    if PlayerController == nil then
        PlayerController = self:GetOwner();
    end
    if PlayerController:HasAuthority() == true then
        self:Server_GetProgressReward(LotteryID, ProgressLevel);
    else
        UnrealNetwork.CallUnrealRPC(PlayerController, self, "Server_GetProgressReward", LotteryID, ProgressLevel);
    end
end

--领取买赠礼包回调
--生效范围：客户端&&服务端
---@param Success boolean
function LotteryComponent:AddGiftPackageDelegate(Success)
    print(string.format("[LotteryComponent] AddGiftPackageDelegate Success: %s", Success or false));
    LotteryManager.OnAddGiftPackageDelegate(Success);
end

return LotteryComponent
