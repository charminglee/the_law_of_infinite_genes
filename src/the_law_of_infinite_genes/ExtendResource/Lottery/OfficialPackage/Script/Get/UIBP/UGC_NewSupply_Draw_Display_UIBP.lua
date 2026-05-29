---@class UGC_NewSupply_Draw_Display_UIBP_C:UUserWidget
---@field CheckBox_SetSkip UCheckBox
---@field Image_Supply_OpenBox_AnimationLastKey UImage
---@field NewSupply_OneDraw_UIBP UUGC_NewSupply_OneDraw_UIBP_C
---@field NewSupply_TenDraw_UIBP UUGC_NewSupply_TenDraw_UIBP_C
---@field WidgetSwitcher_Mode UWidgetSwitcher
--Edit Below--

local UGC_NewSupply_Draw_Display_UIBP = { bInitDoOnce = false } 

function UGC_NewSupply_Draw_Display_UIBP:Construct()
    self.Image_Supply_OpenBox_AnimationLastKey:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
    self.CheckBox_SetSkip.OnCheckStateChanged:Add(self.ChangeCheckState, self);
    self.CheckBox_SetSkip:SetVisibility(ESlateVisibility.Collapsed);
end

function UGC_NewSupply_Draw_Display_UIBP:ChangeCheckState(IsCheck)
    LotteryManager:WriteSkipAnim(IsCheck);
end

-- function UGC_NewSupply_Draw_Display_UIBP:Tick(MyGeometry, InDeltaTime)

-- end

function UGC_NewSupply_Draw_Display_UIBP:Destruct()
    self.CheckBox_SetSkip.OnCheckStateChanged:RemoveAll();
end

function UGC_NewSupply_Draw_Display_UIBP:ShowOneDraw(LotteryID, ItemList)
    local IsSkipAnim = LotteryManager:GetSkipAnim();
    self.CheckBox_SetSkip:SetIsChecked(IsSkipAnim);
    self.WidgetSwitcher_Mode:SetActiveWidgetIndex(0);
    self.NewSupply_OneDraw_UIBP:SetItemInfo(LotteryID, ItemList);
end

function UGC_NewSupply_Draw_Display_UIBP:ShowTenDraw(LotteryID, ItemList)
    local IsSkipAnim = LotteryManager:GetSkipAnim();
    self.CheckBox_SetSkip:SetIsChecked(IsSkipAnim);
    self.WidgetSwitcher_Mode:SetActiveWidgetIndex(1);
    self.NewSupply_TenDraw_UIBP:SetItemInfo(LotteryID, ItemList);
end

function UGC_NewSupply_Draw_Display_UIBP:RefreshSkipAnim(IsSkipAnim)
    self.CheckBox_SetSkip:SetIsChecked(IsSkipAnim);
end

return UGC_NewSupply_Draw_Display_UIBP