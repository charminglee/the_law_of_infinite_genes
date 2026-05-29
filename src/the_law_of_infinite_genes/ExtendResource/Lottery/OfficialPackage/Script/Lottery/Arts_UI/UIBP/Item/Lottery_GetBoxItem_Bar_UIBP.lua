---@class Lottery_GetBoxItem_Bar_UIBP_C:UUserWidget
---@field Lottery_GetBoxItem_01 ULottery_GetBoxItem_UIBP_C
---@field Lottery_GetBoxItem_02 ULottery_GetBoxItem_UIBP_C
---@field Lottery_GetBoxItem_03 ULottery_GetBoxItem_UIBP_C
---@field Lottery_GetBoxItem_04 ULottery_GetBoxItem_UIBP_C
---@field Lottery_GetBoxItem_05 ULottery_GetBoxItem_UIBP_C
---@field Lottery_GetBoxItem_06 ULottery_GetBoxItem_UIBP_C
---@field ProgressBar_Progress UProgressBar
---@field TextBlock_Num01 UTextBlock
--Edit Below--
local Lottery_GetBoxItem_Bar_UIBP = { bInitDoOnce = false } 

function Lottery_GetBoxItem_Bar_UIBP:Construct()
    self.Lottery_GetBoxItem_01:SetVisibility(ESlateVisibility.Collapsed);
    self.Lottery_GetBoxItem_02:SetVisibility(ESlateVisibility.Collapsed);
    self.Lottery_GetBoxItem_03:SetVisibility(ESlateVisibility.Collapsed);
    self.Lottery_GetBoxItem_04:SetVisibility(ESlateVisibility.Collapsed);
    self.Lottery_GetBoxItem_05:SetVisibility(ESlateVisibility.Collapsed);
    self.Lottery_GetBoxItem_06:SetVisibility(ESlateVisibility.Collapsed);

    self.Lottery_GetBoxItem = {
        [1] = self.Lottery_GetBoxItem_01,
        [2] = self.Lottery_GetBoxItem_02,
        [3] = self.Lottery_GetBoxItem_03,
        [4] = self.Lottery_GetBoxItem_04,
        [5] = self.Lottery_GetBoxItem_05,
        [6] = self.Lottery_GetBoxItem_06,
    }
    local CanvasPanelSlot = WidgetLayoutLibrary.SlotAsCanvasSlot(self.Lottery_GetBoxItem[1]);
    local Pos = CanvasPanelSlot:GetPosition();
    self.InitPos = {X = Pos.X, Y = Pos.Y};
    print(string.format("InitPos X: %d, Y: %d", self.InitPos.X, self.InitPos.Y));
end

-- function Lottery_GetBoxItem_Bar_UIBP:Tick(MyGeometry, InDeltaTime)

-- end

-- function Lottery_GetBoxItem_Bar_UIBP:Destruct()

-- end

function Lottery_GetBoxItem_Bar_UIBP:InitUI(LotteryID, TotalDrawTimes, ProgressRewards)
    -- 获取当前抽卡次数
    self.TextBlock_Num01:SetText(TotalDrawTimes);
    self.MaxProgress = ProgressRewards[#ProgressRewards].Progress;
    local Percent = TotalDrawTimes / self.MaxProgress;
    if Percent > 1 then
        Percent = 1; 
    end
    self.ProgressBar_Progress:SetPercent(Percent);

    for Index, Item in pairs(self.Lottery_GetBoxItem) do
        Item:SetVisibility(ESlateVisibility.Collapsed);
        local CanvasPanelSlot = WidgetLayoutLibrary.SlotAsCanvasSlot(Item);
        CanvasPanelSlot:SetPosition(self.InitPos);
    end

    local SliderCanvasPanelSlot = WidgetLayoutLibrary.SlotAsCanvasSlot(self.ProgressBar_Progress);
    local SliderSize = SliderCanvasPanelSlot:GetSize();
    local SliderLength = SliderSize.Y;

    for index, v in pairs(ProgressRewards) do
        if self.Lottery_GetBoxItem[index] then
            self.Lottery_GetBoxItem[index]:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
            local CanvasPanelSlot = WidgetLayoutLibrary.SlotAsCanvasSlot(self.Lottery_GetBoxItem[index]);
            local FinalPos = {X = self.InitPos.X, Y = self.InitPos.Y};
            local Size = CanvasPanelSlot:GetSize();
            print(string.format("Pos X: %d, Y: %d Size X: %d Y: %d", FinalPos.X, FinalPos.Y, Size.X, Size.Y));
            local Offset = Size.Y / 2;
            FinalPos.Y = self.InitPos.Y - Offset;
            local Percent = v.Progress / self.MaxProgress;
            FinalPos.Y = self.InitPos.Y + (1 - Percent) * SliderLength;
            CanvasPanelSlot:SetPosition(FinalPos);
    
            if v.ItemList and #v.ItemList > 0 then
                self.Lottery_GetBoxItem[index]:InitUI(LotteryID, v.Progress, v.Desc, v.ItemList[1].ItemID);
            end
        end
    end

    self.LotteryID = LotteryID;
    self.GiftProgress = ProgressRewards;
end

function Lottery_GetBoxItem_Bar_UIBP:RefreshTotalDrawTimes(DrawTimes)
    self.TextBlock_Num01:SetText(tostring(DrawTimes));
    local Percent = DrawTimes / self.MaxProgress;
    if Percent > 1 then
        Percent = 1;
    end

    self.ProgressBar_Progress:SetPercent(Percent);
end

function Lottery_GetBoxItem_Bar_UIBP:GetGiftProgress(Progress)
    for Index, v in pairs(self.GiftProgress) do
        if Progress == v.Progress then
            self.Lottery_GetBoxItem[Index]:GetGiftProgress();
        end
    end
end

function Lottery_GetBoxItem_Bar_UIBP:RefreshGiftProgress()
    if self.GiftProgress then
        for Index, v in pairs(self.GiftProgress) do
            if self.Lottery_GetBoxItem[Index] then
                self.Lottery_GetBoxItem[Index]:Refresh();
            end
        end
    end
end

return Lottery_GetBoxItem_Bar_UIBP