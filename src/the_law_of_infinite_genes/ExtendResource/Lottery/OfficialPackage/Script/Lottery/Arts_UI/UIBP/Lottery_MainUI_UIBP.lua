---@class Lottery_MainUI_UIBP_C:UUserWidget
---@field CanvasPanel_Page UCanvasPanel
---@field CanvasPanel_Tab UCanvasPanel
---@field LotteryTabMenu UUGC_ReuseList2_C
---@field NewButton_Close UNewButton
---@field ScaleBox_IPX UScaleBox
--Edit Below--


local Lottery_MainUI_UIBP = { bInitDoOnce = false } 

function Lottery_MainUI_UIBP:Construct()
    self:BindEvent();
    self:InitTabMenu();
    self.SelectedLotteryID = -1;
end

-- function Lottery_MainUI_UIBP:Tick(MyGeometry, InDeltaTime)

-- end

function Lottery_MainUI_UIBP:Destruct()
    LotteryManager:CloseLotteryPanel();
end

function Lottery_MainUI_UIBP:InitData(IsUseModeOne, IsUseLotteryExchange, IsUseLotteryGiftProgress, ShowAwardNum)
    -- 读表获取抽奖表格数据
    self.IsUseModeOne = IsUseModeOne;
    self.LotteryExchange = IsUseLotteryExchange;
    self.LotteryGiftProgress = IsUseLotteryGiftProgress;
    self.ShowAwardNum = ShowAwardNum;
end

function Lottery_MainUI_UIBP:BindEvent()
    -- 关闭按钮
	self.NewButton_Close.OnClicked:Add(self.Close, self);
    -- 抽奖奖池Tab
    self.LotteryTabMenu.OnUpdateItem:Add(self.InitTabMenuItem, self);
end

function Lottery_MainUI_UIBP:Close()
    LotteryManager:CloseLotteryPanel();
end

function Lottery_MainUI_UIBP:InitTabMenu()
    self.LotteryDatas = LotteryManager:GetLotteryData();
    self.LotteryTab = {};
    self.LotteryTabMenu:Reload(#self.LotteryDatas);
end

---@param item Lottery_Turntable_TabBut_UIBP_C
---@param index uint32
function Lottery_MainUI_UIBP:InitTabMenuItem(Item, Index)
    print(string.format("Lottery_MainUI_UIBP:InitTabMenuItem Index: %d LotteryCount: %d", Index, #self.LotteryDatas));
    Item:Init(self.LotteryDatas[Index + 1].ID);
    self.LotteryTab[self.LotteryDatas[Index + 1].ID] = Item;

    -- OnScroll时也会触发
    if self.SelectedLotteryID == -1 then
        -- 刚打开时默认选择第一个奖池
        if Index == 0 then
            self:SelectLottery(self.LotteryDatas[Index + 1].ID);
            self.SelectedLotteryID = self.LotteryDatas[Index + 1].ID;
        else
            Item:UnSelect();
        end
    else
        -- 滑动时只切换选中态就行
        if self.SelectedLotteryID and self.SelectedLotteryID == self.LotteryDatas[Index + 1].ID then
            Item:Select();
        else
            Item:UnSelect();
        end
    end
end

function Lottery_MainUI_UIBP:CreatePanel(LotteryModeOneUI, LotteryModeTwoUI)
    if self.IsUseModeOne == ELotteryMainUIType.Default or self.IsUseModeOne == ELotteryMainUIType.TwoDimensionBg then
        if self.LotteryModeOneUI ~= nil then
            return;
        end
        self.LotteryModeOneUI = LotteryModeOneUI;
        -- 挂到MainUI上
        UIUtil.AttachTo(self.CanvasPanel_Page, self.LotteryModeOneUI, 0, { Minimum = { X = 0, Y = 0 }, Maximum = { X = 1, Y = 1 } }, { Left = 0, Right = -1.5, Bottom = 0, Top = 0 });
        GlobalBattleUIFunctionLibrary.ApplyAllUGCButtonsSetting(self.LotteryModeOneUI);
    elseif self.IsUseModeOne == ELotteryMainUIType.ShowAward or ELotteryMainUIType.ThreeDimensionBg then
        if self.LotteryModeTwoUI ~= nil then
            return;  
        end
        self.LotteryModeTwoUI = LotteryModeTwoUI;
        -- 挂到MainUI上
        UIUtil.AttachTo(self.CanvasPanel_Page, self.LotteryModeTwoUI, 0, { Minimum = { X = 0, Y = 0 }, Maximum = { X = 1, Y = 1 } }, { Left = 0, Right = -1.5, Bottom = 0, Top = 0 });
        GlobalBattleUIFunctionLibrary.ApplyAllUGCButtonsSetting(self.LotteryModeTwoUI);
    end
end

---@param Visibility ESlateVisibility
function Lottery_MainUI_UIBP:ShowPanel(Visibility)
    if self.IsUseModeOne == ELotteryMainUIType.Default or self.IsUseModeOne == ELotteryMainUIType.TwoDimensionBg then
        if self.LotteryModeOneUI then
            self.LotteryModeOneUI:SetVisibility(Visibility);
        end
    elseif self.IsUseModeOne == ELotteryMainUIType.ShowAward or ELotteryMainUIType.ThreeDimensionBg then
        if self.LotteryModeTwoUI then
            self.LotteryModeTwoUI:SetVisibility(Visibility);
        end
    end
end

---@param LotteryData LotteryData
function Lottery_MainUI_UIBP:SelectLottery(LotteryID)
    print(string.format("Lottery_MainUI_UIBP:SelectLottery LotteryID: %d SelectLotteryID: %d", LotteryID, self.SelectedLotteryID));
    if LotteryID == self.SelectedLotteryID then
        -- 刷新货币，奖池信息不用刷新
        self:RefreshExchangeCurrencyNum();
        return;
    end
    for Index, Item in pairs(self.LotteryTab) do
        Item:UnSelect();
    end
    
    if self.LotteryTab[LotteryID] then
        self.LotteryTab[LotteryID]:Select();
        self.SelectedLotteryID = LotteryID;
        if self.IsUseModeOne == ELotteryMainUIType.Default or self.IsUseModeOne == ELotteryMainUIType.TwoDimensionBg then
            self.LotteryModeOneUI:InitUI(LotteryID, self.ShowAwardNum, self.LotteryExchange, self.LotteryGiftProgress, self.IsUseModeOne);
        elseif self.IsUseModeOne == ELotteryMainUIType.ShowAward or ELotteryMainUIType.ThreeDimensionBg then
            self.LotteryModeTwoUI:InitUI(LotteryID, self.ShowAwardNum, self.LotteryExchange, self.LotteryGiftProgress, self.IsUseModeOne);
        end
        self:ShowPanel(ESlateVisibility.SelfHitTestInvisible);
    end
end

function Lottery_MainUI_UIBP:RefreshExchangeCurrencyNum()
    if self.IsUseModeOne == ELotteryMainUIType.Default or self.IsUseModeOne == ELotteryMainUIType.TwoDimensionBg then
        self.LotteryModeOneUI:RefreshExchangeCurrencyNum();
    elseif self.IsUseModeOne == ELotteryMainUIType.ShowAward or ELotteryMainUIType.ThreeDimensionBg then
        self.LotteryModeTwoUI:RefreshExchangeCurrencyNum();
    end
end

function Lottery_MainUI_UIBP:RefreshTodayDrawTimes(TodayDrawTimes)
    if self.IsUseModeOne == ELotteryMainUIType.Default or self.IsUseModeOne == ELotteryMainUIType.TwoDimensionBg then
        self.LotteryModeOneUI:RefreshTodayDrawTimes(TodayDrawTimes);        
    elseif self.IsUseModeOne == ELotteryMainUIType.ShowAward or ELotteryMainUIType.ThreeDimensionBg then
        self.LotteryModeTwoUI:RefreshTodayDrawTimes(TodayDrawTimes);        
    end
end

function Lottery_MainUI_UIBP:RefreshTotalDrawTimes(TotalDrawTimes)
    if self.IsUseModeOne == ELotteryMainUIType.Default or self.IsUseModeOne == ELotteryMainUIType.TwoDimensionBg then
        self.LotteryModeOneUI:RefreshTotalDrawTimes(TotalDrawTimes);        
    elseif self.IsUseModeOne == ELotteryMainUIType.ShowAward or ELotteryMainUIType.ThreeDimensionBg then
        self.LotteryModeTwoUI:RefreshTotalDrawTimes(TotalDrawTimes);        
    end
end

function Lottery_MainUI_UIBP:GetGiftProgress(LotteryID, Progress)
    if self.SelectedLotteryID == LotteryID then
        if self.IsUseModeOne == ELotteryMainUIType.Default or self.IsUseModeOne == ELotteryMainUIType.TwoDimensionBg then
            self.LotteryModeOneUI:GetGiftProgress(Progress);        
        elseif self.IsUseModeOne == ELotteryMainUIType.ShowAward or ELotteryMainUIType.ThreeDimensionBg then
            self.LotteryModeTwoUI:GetGiftProgress(Progress);        
        end 
    end
end

function Lottery_MainUI_UIBP:RefreshGiftProgress()
    if self.IsUseModeOne == ELotteryMainUIType.Default or self.IsUseModeOne == ELotteryMainUIType.TwoDimensionBg then
        self.LotteryModeOneUI:RefreshGiftProgress();        
    elseif self.IsUseModeOne == ELotteryMainUIType.ShowAward or ELotteryMainUIType.ThreeDimensionBg then
        self.LotteryModeTwoUI:RefreshGiftProgress();        
    end 
end

function Lottery_MainUI_UIBP:RefreshDrawDiscount()
    if self.IsUseModeOne == ELotteryMainUIType.Default or self.IsUseModeOne == ELotteryMainUIType.TwoDimensionBg then
        self.LotteryModeOneUI:RefreshDrawDiscount();        
    elseif self.IsUseModeOne == ELotteryMainUIType.ShowAward or ELotteryMainUIType.ThreeDimensionBg then
        self.LotteryModeTwoUI:RefreshDrawDiscount();        
    end 
end

function Lottery_MainUI_UIBP:ScrollToStart()
    self.LotteryTabMenu:ScrollToStart();
end

function Lottery_MainUI_UIBP:InitCurrencyBar()
    if self.IsUseModeOne == ELotteryMainUIType.Default or self.IsUseModeOne == ELotteryMainUIType.TwoDimensionBg then
        self.LotteryModeOneUI:InitCurrencyBar();
    elseif self.IsUseModeOne == ELotteryMainUIType.ShowAward or ELotteryMainUIType.ThreeDimensionBg then
        self.LotteryModeTwoUI:InitCurrencyBar();
    end
end

return Lottery_MainUI_UIBP