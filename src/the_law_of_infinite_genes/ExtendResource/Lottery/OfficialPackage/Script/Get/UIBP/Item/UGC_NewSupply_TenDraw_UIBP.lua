---@class UGC_NewSupply_TenDraw_UIBP_C:UUserWidget
---@field DX_Btn UWidgetAnimation
---@field BtnDrawTenAgain UButton
---@field buyTenMoneyIcon UImage
---@field CanvasPanel_TenDraw_OriginPrice UCanvasPanel
---@field CanvasPanel_TenDrawBtn UCanvasPanel
---@field CanvasPanel_TenDrawFreeLabel UCanvasPanel
---@field FX_mianfei UCanvasPanel
---@field HorizontalBox_OtherCoin UHorizontalBox
---@field HorizontalBox_Price UHorizontalBox
---@field Image_CurrencyIcon3 UImage
---@field ItemWidgetList UWrapBox
---@field TenDrawBtnOk UButton
---@field TextBlock_FinalPrice3 UTextBlock
---@field TextBlock_Open UTextBlock
---@field TextBlock_TenBuyDiscount UTextBlock
---@field TextBlock_TenDraw_OriginPrice UTextBlock
---@field TextBlock_TenDraw_RealPrice UTextBlock
---@field UGC_NewSupply_DrawItem_01 UUGC_NewSupply_DrawItem_UIBP_C
---@field UGC_NewSupply_DrawItem_010 UUGC_NewSupply_DrawItem_UIBP_C
---@field UGC_NewSupply_DrawItem_02 UUGC_NewSupply_DrawItem_UIBP_C
---@field UGC_NewSupply_DrawItem_03 UUGC_NewSupply_DrawItem_UIBP_C
---@field UGC_NewSupply_DrawItem_04 UUGC_NewSupply_DrawItem_UIBP_C
---@field UGC_NewSupply_DrawItem_05 UUGC_NewSupply_DrawItem_UIBP_C
---@field UGC_NewSupply_DrawItem_06 UUGC_NewSupply_DrawItem_UIBP_C
---@field UGC_NewSupply_DrawItem_07 UUGC_NewSupply_DrawItem_UIBP_C
---@field UGC_NewSupply_DrawItem_08 UUGC_NewSupply_DrawItem_UIBP_C
---@field UGC_NewSupply_DrawItem_09 UUGC_NewSupply_DrawItem_UIBP_C
---@field WidgetSwitcher_DrawTenBtn_Label UWidgetSwitcher
--Edit Below--
local UGC_NewSupply_TenDraw_UIBP = { bInitDoOnce = false } 


function UGC_NewSupply_TenDraw_UIBP:Construct()
    self.ItemList = {
        [1] = self.UGC_NewSupply_DrawItem_01,
        [2] = self.UGC_NewSupply_DrawItem_02,
        [3] = self.UGC_NewSupply_DrawItem_03,
        [4] = self.UGC_NewSupply_DrawItem_04,
        [5] = self.UGC_NewSupply_DrawItem_05,
        [6] = self.UGC_NewSupply_DrawItem_06,
        [7] = self.UGC_NewSupply_DrawItem_07,
        [8] = self.UGC_NewSupply_DrawItem_08,
        [9] = self.UGC_NewSupply_DrawItem_09,
        [10] = self.UGC_NewSupply_DrawItem_010,
    }
    self:InitBindEvent();
end

function UGC_NewSupply_TenDraw_UIBP:InitBindEvent()
    self.TenDrawBtnOk.OnClicked:Add(self.OKButtonClick, self);
    self.BtnDrawTenAgain.OnClicked:Add(self.TenDrawButtonClick, self);
end

function UGC_NewSupply_TenDraw_UIBP:OKButtonClick()
    LotteryManager:CloseLotteryDrawDisplayUI();
end

function UGC_NewSupply_TenDraw_UIBP:TenDrawButtonClick()
    LotteryManager:DrawTenth(self.LotteryID);
end

function UGC_NewSupply_TenDraw_UIBP:SetItemInfo(LotteryID, ItemInfoList)
    -- 将Item的翻转动画初始化
    for Index, Item in pairs(self.ItemList) do
        Item:JumpAnimToStart();
    end
    self.LotteryID = LotteryID;
    self.TenDrawBtnOk:SetVisibility(ESlateVisibility.Collapsed);
    self.BtnDrawTenAgain:SetVisibility(ESlateVisibility.Collapsed);
    self.HorizontalBox_OtherCoin:SetVisibility(ESlateVisibility.Collapsed);
    for Index, Item in pairs(self.ItemList) do
        local ItemID = ItemInfoList[Index].ItemID or -1;
        local ItemNum = ItemInfoList[Index].ItemNum or 0;
        Item:SetItemInfo(ItemID, ItemNum);
        -- 延迟播放翻转动画
        local DelayTime = (Index - 1) * 0.25;
        Timer.InsertTimer(0,function()
            Item:TrunOverItem();
        end, false, "DelayTimer", DelayTime);
    end

    --- 如果有单个物品展示，则在单个物品界面关闭后再播放，否则在最后一个道具翻转完后播放
    Timer.InsertTimer(0,function()
        self:ShowBtn();
    end, false, "DelayTimer", #self.ItemList * 0.25 + 0.5);

    local LotteryData = LotteryManager:GetLotteryConfigData(LotteryID);
    local CostID = LotteryManager:GetItemIDByProduct(LotteryData.DrawCostID);;
    local CostItemInfo = LotteryManager:GetItemConfigData(CostID);
    -- 消耗货币Icon
    if CostItemInfo and CostItemInfo.ItemIcon then
        self.buyTenMoneyIcon:SetBrushFromTexture(UE.LoadObject(CostItemInfo.ItemIcon));
    end
    local CostNum = LotteryData.TenDrawCostNum;
    self.TextBlock_TenDraw_RealPrice:SetText(tostring(CostNum));
end

function UGC_NewSupply_TenDraw_UIBP:ShowBtn()
    self.TenDrawBtnOk:SetVisibility(ESlateVisibility.Visible);
    self.BtnDrawTenAgain:SetVisibility(ESlateVisibility.Visible);
    if CheckObjectContainsField(self, "DX_Btn") then
        self:PlayAnimation(self.DX_Btn, 0, 1, EUMGSequencePlayMode.Forward, 1);
    end
end

-- function UGC_NewSupply_TenDraw_UIBP:Tick(MyGeometry, InDeltaTime)

-- end

function UGC_NewSupply_TenDraw_UIBP:Destruct()
end

return UGC_NewSupply_TenDraw_UIBP