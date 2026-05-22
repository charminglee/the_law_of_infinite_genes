---@class Lottery_Tab_Mode2_UIBP_C:UUserWidget
---@field Btn_AwardPreview UButton
---@field Button_Explain UButton
---@field Button_GetRecord UButton
---@field CanvasPanel_IPX UCanvasPanel
---@field CanvasPanel_PropUI UCanvasPanel
---@field CanvasPanel_RemainingTips UCanvasPanel
---@field CanvasPanel_Upload UCanvasPanel
---@field HorizontalBox_6 UHorizontalBox
---@field HorizontalBox_Top UHorizontalBox
---@field Image_4 UImage
---@field Image_AwardIcon UImage
---@field Image_Money UImage
---@field Lottery_BigReward_UIBP ULottery_BigReward_UIBP_C
---@field Lottery_Button_One_UIBP ULottery_Button_One_UIBP_C
---@field Lottery_Button_Ten_UIBP ULottery_Button_Ten_UIBP_C
---@field Lottery_Currency_01 ULottery_Currency_UIBP_C
---@field Lottery_Currency_02 ULottery_Currency_UIBP_C
---@field Lottery_Currency_03 ULottery_Currency_UIBP_C
---@field Lottery_GetBoxItem_Bar_UIBP ULottery_GetBoxItem_Bar_UIBP_C
---@field Lottery_IconItem_03 ULottery_IconItem_UIBP_C
---@field Lottery_IconItem_UIBP_01 ULottery_IconItem_UIBP_C
---@field Lottery_IconItem_UIBP_02 ULottery_IconItem_UIBP_C
---@field Lottery_IconItem_UIBP_04 ULottery_IconItem_UIBP_C
---@field Lottery_IconItem_UIBP_05 ULottery_IconItem_UIBP_C
---@field Lottery_IconItem_UIBP_06 ULottery_IconItem_UIBP_C
---@field Lottery_IconItem_UIBP_07 ULottery_IconItem_UIBP_C
---@field NewButton_Mask UButton
---@field NewButton_Shop UNewButton
---@field ScaleBox_IPX UScaleBox
---@field TextBlock_CurrentNum UTextBlock
---@field TextBlock_MoneyNum UTextBlock
---@field TextBlock_Time UTextBlock
---@field TextBlock_Title UTextBlock
---@field TextBlock_Total UTextBlock
--Edit Below--

local Lottery_Tab_Mode2_UIBP = { bInitDoOnce = false } 

function Lottery_Tab_Mode2_UIBP:Construct()
    self:InitBindEvent();

    self.ShowAwardList = {
        [1] = self.Lottery_IconItem_UIBP_01,
        [2] = self.Lottery_IconItem_UIBP_02,
        [3] = self.Lottery_IconItem_03, 
        [4] = self.Lottery_IconItem_UIBP_04,
        [5] = self.Lottery_IconItem_UIBP_05,
        [6] = self.Lottery_IconItem_UIBP_06,
        [7] = self.Lottery_IconItem_UIBP_07,
    }
end

-- function Lottery_Tab_Mode2_UIBP:Tick(MyGeometry, InDeltaTime)

-- end

function Lottery_Tab_Mode2_UIBP:Destruct()
    self.Button_GetRecord.OnClicked:Remove(self.GetRecordBtnClick, self);
    self.Btn_AwardPreview.OnClicked:Remove(self.AwardPreviewBtnClick, self);
    self.NewButton_Shop.OnClicked:Remove(self.ExchangeShopBtnClick, self);
    self.Button_Explain.OnClicked:Remove(self.ExplainBtnClick, self);
    LotteryManager.OnItemNumChangeDelegate:Remove(self.RefreshExchangeCurrencyNum, self);
end

function Lottery_Tab_Mode2_UIBP:InitBindEvent()
    self.Button_GetRecord.OnClicked:Add(self.GetRecordBtnClick, self);
    self.Btn_AwardPreview.OnClicked:Add(self.AwardPreviewBtnClick, self);
    self.NewButton_Shop.OnClicked:Add(self.ExchangeShopBtnClick, self);
    self.Button_Explain.OnClicked:Add(self.ExplainBtnClick, self);
end

---@param LotteryData LotteryData
function Lottery_Tab_Mode2_UIBP:InitUI(LotteryID, ShowAwardNum, IsShowExchange, IsShowGiftProgress, IsUseModeOne)
    local LotteryData = LotteryManager:GetLotteryConfigData(LotteryID);
    if LotteryData then
        -- 设置奖池名称
        self.TextBlock_Title:SetText(LotteryManager:GetLegalStr(LotteryData.Name, 7));
        -- 设置今日抽奖次数上限
        if LotteryData.DailyDrawLimit == 0 then
            self.CanvasPanel_RemainingTips:SetVisibility(ESlateVisibility.Collapsed);
            self.IsShowTodayDrawTimes = false;
        else
            self.CanvasPanel_RemainingTips:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
            local LotteryInfo = LotteryManager:GetLotteryInfo(LotteryID);
            if LotteryInfo and LotteryInfo.LotteryRecords then
                local TodayDrawTimes = LotteryManager:GetPlayerTodayDraws(LotteryID);
                self.TextBlock_CurrentNum:SetText(tostring(TodayDrawTimes));
            else
                self.TextBlock_CurrentNum:SetText("0");
            end
            self.TextBlock_Total:SetText(LotteryData.DailyDrawLimit);
            self.IsShowTodayDrawTimes = true;
        end
        -- 设置奖池左上角Icon
        self.Lottery_Button_One_UIBP:InitUI(LotteryID);
        self.Lottery_Button_Ten_UIBP:InitUI(LotteryID);

        print(string.format("Lottery_Tab_Mode1_UIBP:InitUI LotteryID: %d", LotteryID));
        if IsShowGiftProgress then
            if LotteryData.GiftProgressRewards then
                local count = 0;
                for k, v in pairs(LotteryData.GiftProgressRewards) do
                    count = count + 1;
                end
    
                if count == 0 then
                    self.Lottery_GetBoxItem_Bar_UIBP:SetVisibility(ESlateVisibility.Collapsed);
                    self.IsShowTotalDrawTimes = false;
                else
                    self.Lottery_GetBoxItem_Bar_UIBP:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
                    local TotalDrawTimes = LotteryManager:GetPlayerTotalDraws(LotteryID);
                    self.Lottery_GetBoxItem_Bar_UIBP:InitUI(LotteryID, TotalDrawTimes, LotteryData.GiftProgressRewards);
                    self.IsShowTotalDrawTimes = true;
                end
            else
                self.Lottery_GetBoxItem_Bar_UIBP:SetVisibility(ESlateVisibility.Collapsed);
            end
        else
            self.Lottery_GetBoxItem_Bar_UIBP:SetVisibility(ESlateVisibility.Collapsed);
        end

        self.Lottery_BigReward_UIBP:InitUI(LotteryID);

        if IsUseModeOne == ELotteryMainUIType.ShowAward then
            self.CanvasPanel_Upload:SetVisibility(ESlateVisibility.Collapsed);
            self.HorizontalBox_6:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
            self.Lottery_BigReward_UIBP:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
            self:ShowAward(LotteryID, ShowAwardNum);
        elseif IsUseModeOne == ELotteryMainUIType.ThreeDimensionBg then
            self.CanvasPanel_Upload:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
            self.HorizontalBox_6:SetVisibility(ESlateVisibility.Collapsed);
            self.Lottery_BigReward_UIBP:SetVisibility(ESlateVisibility.Collapsed);
        end

        self.LotteryExplanation = LotteryData.LotteryRule;
    end

    self:ShowExchangeButton(IsShowExchange);
    -- self:ShowGiftProgress(IsShowGiftProgress);
    local IsShowOasis = true;
    if IsShowOasis then
        self:InitCurrencyBar();
    end
    self.IsShowGiftProgress = IsShowGiftProgress;
    self.TextBlock_Time:SetVisibility(ESlateVisibility.Collapsed);
end

function Lottery_Tab_Mode2_UIBP:RefreshTodayDrawTimes(TodayDrawTimes)
    if self.IsShowTodayDrawTimes then
        self.TextBlock_CurrentNum:SetText(tostring(TodayDrawTimes));
    end
end

function Lottery_Tab_Mode2_UIBP:RefreshTotalDrawTimes(TotalDrawTimes)
    if self.IsShowTotalDrawTimes then
        self.Lottery_GetBoxItem_Bar_UIBP:RefreshTotalDrawTimes(TotalDrawTimes);
    end
end

function Lottery_Tab_Mode2_UIBP:InitCurrencyBar()
    UGCCommoditySystem.ShowRechargeEntryUI():Then(
        function (Result)
            local UI = Result:Get();

            if UI ~= nil then
                UI:RemoveFromParent();
                UI:SetVisibility(ESlateVisibility.Visible);
                self.HorizontalBox_Top:AddChild(UI);
            end
        end
    );
end

function Lottery_Tab_Mode2_UIBP:GetRecordBtnClick()
    -- 获奖记录界面
    LotteryManager:OpenLotteryAwardRecord();
end

function Lottery_Tab_Mode2_UIBP:AwardPreviewBtnClick()
    -- 奖品预览界面
    LotteryManager:OpenLotteryAwardPreview();
end

function Lottery_Tab_Mode2_UIBP:ExchangeShopBtnClick()
    -- 碎片兑换界面
    LotteryManager:OpenLotteryExchange();
end

function Lottery_Tab_Mode2_UIBP:ExplainBtnClick()
    -- 抽奖说明界面
    LotteryManager:OpenLotteryExplanation(self.LotteryExplanation);
end

function Lottery_Tab_Mode2_UIBP:ShowAward(LotteryID, ShowAwardNum)
    local LotteryAward = LotteryManager:GetLotteryAwardData(LotteryID);
    local totalAwardNum = #LotteryAward;
    if totalAwardNum < ShowAwardNum then
        ShowAwardNum = totalAwardNum; 
    end
    print(string.format("Lottery_Tab_Mode2_UIBP:ShowAward ItemNum: %d ShowNum: %d", totalAwardNum, ShowAwardNum));
    if ShowAwardNum >= 7 then
        for index, v in pairs(self.ShowAwardList) do
            v:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
        end
        --- 设置展示道具信息
        for Index, ItemID in pairs(LotteryAward) do
            if self.ShowAwardList[Index] then
                self.ShowAwardList[Index]:InitUI(ItemID);
            end
        end
    else
        if ShowAwardNum == 6 then
            --- 设置展示道具信息
            self.ShowAwardList[1]:InitUI(LotteryAward[1]);
            self.ShowAwardList[2]:InitUI(LotteryAward[2]);
            self.ShowAwardList[3]:InitUI(LotteryAward[3]);
            self.ShowAwardList[4]:InitUI(LotteryAward[4]);
            self.ShowAwardList[6]:InitUI(LotteryAward[5]);
            self.ShowAwardList[7]:InitUI(LotteryAward[6]);
            for i = 1, 7 do
                if i == 5 then
                    self.ShowAwardList[i]:SetVisibility(ESlateVisibility.Collapsed);
                else
                    self.ShowAwardList[i]:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
                end
            end
        elseif ShowAwardNum == 5 then
            --- 设置展示道具信息
            self.ShowAwardList[1]:InitUI(LotteryAward[1]);
            self.ShowAwardList[3]:InitUI(LotteryAward[2]);
            self.ShowAwardList[4]:InitUI(LotteryAward[3]);
            self.ShowAwardList[5]:InitUI(LotteryAward[4]);
            self.ShowAwardList[6]:InitUI(LotteryAward[5]);
            for i = 1, 7 do
                if i == 2 or i == 7 then
                    self.ShowAwardList[i]:SetVisibility(ESlateVisibility.Collapsed);
                else
                    self.ShowAwardList[i]:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
                end
            end
        elseif ShowAwardNum == 4 then
            --- 设置展示道具信息
            self.ShowAwardList[1]:InitUI(LotteryAward[1]);
            self.ShowAwardList[3]:InitUI(LotteryAward[2]);
            self.ShowAwardList[4]:InitUI(LotteryAward[3]);
            self.ShowAwardList[6]:InitUI(LotteryAward[4]);
            for i = 1, 7 do
                if i == 2 or i == 5 or i == 7 then
                    self.ShowAwardList[i]:SetVisibility(ESlateVisibility.Collapsed);
                else
                    self.ShowAwardList[i]:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
                end
            end
        elseif ShowAwardNum == 3 then
            --- 设置展示道具信息
            self.ShowAwardList[1]:InitUI(LotteryAward[1]);
            self.ShowAwardList[3]:InitUI(LotteryAward[2]);
            self.ShowAwardList[6]:InitUI(LotteryAward[3]);
            for i = 1, 7 do
                if i == 2 or i == 4 or i == 5 or i == 7 then
                    self.ShowAwardList[i]:SetVisibility(ESlateVisibility.Collapsed);
                else
                    self.ShowAwardList[i]:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
                end
            end
        elseif ShowAwardNum == 2 then
            --- 设置展示道具信息
            self.ShowAwardList[1]:InitUI(LotteryAward[1]);
            self.ShowAwardList[6]:InitUI(LotteryAward[2]);
            for i = 1, 7 do
                if i == 1 or i == 6 then
                    self.ShowAwardList[i]:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
                else
                    self.ShowAwardList[i]:SetVisibility(ESlateVisibility.Collapsed);
                end
            end
        else
            for i = 1, 7 do
                if i <= ShowAwardNum then
                    --- 设置展示道具信息
                    self.ShowAwardList[i]:InitUI(LotteryAward[i]);
                    self.ShowAwardList[i]:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
                else
                    self.ShowAwardList[i]:SetVisibility(ESlateVisibility.Collapsed);
                end
            end
        end
    end
end

function Lottery_Tab_Mode2_UIBP:ShowExchangeButton(IsShow)
    self.NewButton_Shop:SetVisibility(ESlateVisibility.Collapsed);
    if IsShow then
        LotteryManager.OnItemNumChangeDelegate:Add(self.RefreshExchangeCurrencyNum, self);
        self:RefreshExchangeCurrencyNum();
        self.NewButton_Shop:SetVisibility(ESlateVisibility.Visible);
    end
end

function Lottery_Tab_Mode2_UIBP:RefreshExchangeCurrencyNum()
    if self.ExchangeCurrencyID == nil then
        local ExchangeItemList = LotteryManager:GetLotteryExchangeData();
        if #ExchangeItemList > 0 then
            local CurrencyID = ExchangeItemList[1].CostID;
            local CurrencyInfo = LotteryManager:GetItemConfigData(CurrencyID);
            if CurrencyInfo and CurrencyInfo.ItemIcon then
                Common.LoadObjectAsync(CurrencyInfo.ItemIcon, 
                    function (IconTexture)
                        if self ~= nil and UE.IsValid(self) then
                            self.Image_Money:SetBrushFromTexture(IconTexture);
                        end
                    end
                );
            end
            local CurrencyNum = LotteryManager:GetPlayerOwnedItemNum(CurrencyID);
            self.TextBlock_MoneyNum:SetText(tostring(CurrencyNum));
            self.ExchangeCurrencyID = CurrencyID;
        end
    else
        local CurrencyNum = LotteryManager:GetPlayerOwnedItemNum(self.ExchangeCurrencyID);
        self.TextBlock_MoneyNum:SetText(tostring(CurrencyNum));
    end
end

function Lottery_Tab_Mode2_UIBP:ShowGiftProgress(IsShow)
    if IsShow then
        self.Lottery_GetBoxItem_Bar_UIBP:SetVisibility(ESlateVisibility.Visible);
    else
        self.Lottery_GetBoxItem_Bar_UIBP:SetVisibility(ESlateVisibility.Collapsed);
    end
end

function Lottery_Tab_Mode2_UIBP:GetGiftProgress(Progress)
    if self.IsShowGiftProgress then
        self.Lottery_GetBoxItem_Bar_UIBP:GetGiftProgress(Progress);
    end
end

function Lottery_Tab_Mode2_UIBP:RefreshGiftProgress()
    if self.IsShowGiftProgress then
        self.Lottery_GetBoxItem_Bar_UIBP:RefreshGiftProgress();
    end
end

function Lottery_Tab_Mode2_UIBP:RefreshDrawDiscount()
    self.Lottery_Button_One_UIBP:RefreshDrawDiscount();
end

return Lottery_Tab_Mode2_UIBP