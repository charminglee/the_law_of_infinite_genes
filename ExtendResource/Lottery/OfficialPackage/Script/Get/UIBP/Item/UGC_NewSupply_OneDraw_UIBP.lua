---@class UGC_NewSupply_OneDraw_UIBP_C:UUserWidget
---@field DX_OneDrawBtnIn UWidgetAnimation
---@field DX_OneDrawItemLoop UWidgetAnimation
---@field DX_OneDrawItemIn UWidgetAnimation
---@field Btn_OneDraw UButton
---@field buyOneMoneyIcon UImage
---@field CanvasPanel_OneDraw_OriginPrice UCanvasPanel
---@field CanvasPanel_OneDrawBtn UCanvasPanel
---@field CanvasPanel_OneDrawFreeLabel UCanvasPanel
---@field CanvasPanel_SingleItem UCanvasPanel
---@field FX_BgLight01 UImage
---@field FX_BgLight02 UImage
---@field FX_BigLighe UImage
---@field FX_mianfei UCanvasPanel
---@field HorizontalBox_Price UHorizontalBox
---@field NewSupply_DrawItem_UIBP UUGC_NewSupply_DrawItem_UIBP_C
---@field OneDrawBtnOk UButton
---@field TextBlock_OneBuyDiscount UTextBlock
---@field TextBlock_OneDraw_OriginPrice UTextBlock
---@field TextBlock_OneDraw_RealPrice UTextBlock
---@field WidgetSwitcher_OneDraw_Label UWidgetSwitcher
--Edit Below--
local UGC_NewSupply_OneDraw_UIBP = { bInitDoOnce = false } 


function UGC_NewSupply_OneDraw_UIBP:Construct()
    self:InitBindEvent();
end

function UGC_NewSupply_OneDraw_UIBP:InitBindEvent()
    self.OneDrawBtnOk.OnClicked:Add(self.OKButtonClick, self);
    self.Btn_OneDraw.OnClicked:Add(self.OneDrawButtonClick, self);
end

function UGC_NewSupply_OneDraw_UIBP:OKButtonClick()
    LotteryManager:CloseLotteryDrawDisplayUI();
end

function UGC_NewSupply_OneDraw_UIBP:OneDrawButtonClick()
    LotteryManager:DrawOnce(self.LotteryID); 
end

-- function UGC_NewSupply_OneDraw_UIBP:Tick(MyGeometry, InDeltaTime)

-- end

function UGC_NewSupply_OneDraw_UIBP:SetItemInfo(LotteryID, ItemList)
    self.LotteryID = LotteryID;
    self.OneDrawBtnOk:SetVisibility(ESlateVisibility.Collapsed);
    self.Btn_OneDraw:SetVisibility(ESlateVisibility.Collapsed);

    local ItemID = ItemList[1].ItemID or -1;
    local ItemNum = ItemList[1].ItemNum or 0;
    print(string.format("UGC_NewSupply_OneDraw_UIBP:SetItemInfo ID: %d Num: %d", ItemID, ItemNum));
    self.NewSupply_DrawItem_UIBP:SetItemInfo(ItemID, ItemNum, self);
    self.NewSupply_DrawItem_UIBP:JumpAnimToStart();

    local LotteryData = LotteryManager:GetLotteryConfigData(LotteryID);
    local CostID = LotteryManager:GetItemIDByProduct(LotteryData.DrawCostID);
    local CostItemInfo = LotteryManager:GetItemConfigData(CostID);
    -- 消耗货币Icon
    if CostItemInfo and CostItemInfo.ItemIcon then
        self.buyOneMoneyIcon:SetBrushFromTexture(UE.LoadObject(CostItemInfo.ItemIcon));
    end
    
    local CostNum = 0;
    if LotteryManager:HasFirstDrawGuarant(LotteryID) then
        -- 首次抽取折扣可用
        CostNum = LotteryData.FirstDrawDiscountCost;
    else
        CostNum = LotteryData.OneDrawCostNum;
    end
    self.TextBlock_OneDraw_RealPrice:SetText(tostring(CostNum));
    self:PlayItemIn();
    self.NewSupply_DrawItem_UIBP:TrunOverItem();
    self:PlayItemLoop();

    Timer.InsertTimer(0,function()
        self:ShowBtn();
    end, false, "DelayTimer", 1);
end

function UGC_NewSupply_OneDraw_UIBP:PlayItemLoop()
    if CheckObjectContainsField(self, "DX_OneDrawItemLoop") then
        -- UIUtil.PlayAnimToEnd(self, "DX_OneDrawItemIn");
        self:PlayAnimation(self.DX_OneDrawItemLoop, 0, 0, EUMGSequencePlayMode.Forward, 1);
    end
end

function UGC_NewSupply_OneDraw_UIBP:PlayItemIn()
    if CheckObjectContainsField(self, "DX_OneDrawItemIn") then
        -- UIUtil.PlayAnimToEnd(self, "DX_OneDrawItemIn");
        self:PlayAnimation(self.DX_OneDrawItemIn, 0, 1, EUMGSequencePlayMode.Forward, 1);
    end
end

function UGC_NewSupply_OneDraw_UIBP:ShowBtn()
    self.OneDrawBtnOk:SetVisibility(ESlateVisibility.Visible);
    self.Btn_OneDraw:SetVisibility(ESlateVisibility.Visible);
    if CheckObjectContainsField(self, "DX_OneDrawBtnIn") then
        -- UIUtil.PlayAnimToEnd(self, "DX_OneDrawItemIn");
        self:PlayAnimation(self.DX_OneDrawBtnIn, 0, 1, EUMGSequencePlayMode.Forward, 1);
    end
end

function UGC_NewSupply_OneDraw_UIBP:Destruct()
end

return UGC_NewSupply_OneDraw_UIBP