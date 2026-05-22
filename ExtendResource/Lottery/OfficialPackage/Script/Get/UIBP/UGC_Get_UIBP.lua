---@class UGC_Get_UIBP_C:UUserWidget
---@field DX_Loop UWidgetAnimation
---@field DX_GetAni UWidgetAnimation
---@field Border_Bg UBorder
---@field Border_jiantou UBorder
---@field Border_Pin UBorder
---@field Button_sure UButton
---@field CancelBtn UButton
---@field CanvasPanel_IPX UCanvasPanel
---@field CanvasPanel_Loading UCanvasPanel
---@field CanvasPanel_New UCanvasPanel
---@field CheckBox_equip UNewCheckBox
---@field FX_Glow_A UBorder
---@field FX_Glow_B UBorder
---@field Image_0 UImage
---@field Image_31 UImage
---@field Image_35 UImage
---@field Image_40 UImage
---@field Image_CarrierIcon UImage
---@field Image_Gun UImage
---@field Image_Item_Quality UImage
---@field ShareBtn UButton
---@field SharePicBtn UButton
---@field TextBlock_0 UTextBlock
---@field TextBlock_1 UTextBlock
---@field UIParticleEmitter_0 UUIParticleEmitter
---@field UIParticleEmitter_6 UUIParticleEmitter
---@field WidgetSwitcher_Btn UWidgetSwitcher
---@field WidgetSwitcher_Sharebtn UWidgetSwitcher
---@field WidgetSwitcher_Ting UWidgetSwitcher
--Edit Below--
local UGC_Get_UIBP = { bInitDoOnce = false } 

function UGC_Get_UIBP:Construct()
	self:InitBindEvent();
end

function UGC_Get_UIBP:InitBindEvent()
    self.CancelBtn.OnClicked:Add(self.Canel, self);
    self.ShareBtn.OnClicked:Add(self.Share, self);
    self.DX_GetAni.OnAnimationFinished:Add(self.PlayLoop, self);
end

function UGC_Get_UIBP:Cancel()

end

function UGC_Get_UIBP:Share()
    GCWidgetManagerSystem.Share();
end

function UGC_Get_UIBP:PlayLoop()
    if CheckObjectContainsField(self, "DX_Loop") then
        self:PlayAnimation(self.DX_Loop, 0, 1, EUMGSequencePlayMode.Forward, 1);
    end
end

-- function UGC_Get_UIBP:Tick(MyGeometry, InDeltaTime)

-- end

-- function UGC_Get_UIBP:Destruct()

-- end

function UGC_Get_UIBP:InitUI(ItemID)
    local ItemInfo = LotteryManager:GetItemConfigData(ItemID);
    if ItemInfo then
        if ItemInfo.ItemName then
            self.TextBlock_0:SetText(ItemInfo.ItemName);
        end
        if ItemInfo.ItemIcon then
            self.Image_0:SetBrushFromTexture(UE.LoadObject(ItemInfo.ItemIcon));
        end
    end

    if CheckObjectContainsField(self, "DX_GetAni") then
        self:PlayAnimation(self.DX_GetAni, 0, 1, EUMGSequencePlayMode.Forward, 1);
    end
end

return UGC_Get_UIBP