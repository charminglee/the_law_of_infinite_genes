---@class UGC_NewSupply_DrawItem_UIBP_C:UUserWidget
---@field DX_ConvertedIntoMaterial_zhong UWidgetAnimation
---@field DX_ConvertedIntoMaterial_Advance UWidgetAnimation
---@field DX_ConvertedIntoMaterial UWidgetAnimation
---@field DX_Advanced UWidgetAnimation
---@field DX_General UWidgetAnimation
---@field CanvasPanel_Time UCanvasPanel
---@field DynaCanvasPanel_fenjie UDynaCanvasPanel
---@field DynaCanvasPanel_pinzhi UDynaCanvasPanel
---@field FX_BgLight UCanvasPanel
---@field FX_Funnel UImage
---@field FX_Light UImage
---@field FX_LightS UImage
---@field FX_SweepLight01 UImage
---@field Image_Fragments UImage
---@field Image_Gun UImage
---@field Image_Level UImage
---@field Image_Vehicle UImage
---@field Image_Yi UImage
---@field Text_ItemName UTextBlock
---@field Text_time UTextBlock
---@field TextBlock_Number UTextBlock
---@field WidgetSwitcher_Thing UWidgetSwitcher
--Edit Below--
local UGC_NewSupply_DrawItem_UIBP = { bInitDoOnce = false } 

local Delegate = UGCGameSystem.UGCRequire("common.Delegate");

function UGC_NewSupply_DrawItem_UIBP:Construct()
end

function UGC_NewSupply_DrawItem_UIBP:SetItemInfo(ItemID, ItemNum)
    local ItemInfo = LotteryManager:GetItemConfigData(ItemID);
    if ItemInfo then
        -- 道具名称
        if ItemInfo.ItemName then
            self.Text_ItemName:SetText(ItemInfo.ItemName);
        end
        -- 道具Icon
        if ItemInfo.ItemIcon then
            self.Image_Yi:SetBrushFromTexture(UE.LoadObject(ItemInfo.ItemIcon));
        end

        self.TextBlock_Number:SetText(tostring(ItemNum));
        self.TextBlock_Number:SetVisibility(ESlateVisibility.Visible);
        self.WidgetSwitcher_Thing:SetActiveWidgetIndex(0);
    end

    print(string.format("UGC_NewSupply_DrawItem_UIBP:SetItemInfo ID: %d Num: %d", ItemID, ItemNum));
end

function UGC_NewSupply_DrawItem_UIBP:TrunOverItem()
    if CheckObjectContainsField(self, "DX_Advanced") then
        self:PlayAnimation(self.DX_Advanced, 0, 1, EUMGSequencePlayMode.Forward, 1);
    end
end

-- function UGC_NewSupply_DrawItem_UIBP:Tick(MyGeometry, InDeltaTime)

-- end

function UGC_NewSupply_DrawItem_UIBP:JumpAnimToStart()
    self:JumpAnimation(self.DX_Advanced, 0);
end

function UGC_NewSupply_DrawItem_UIBP:Destruct()
    -- self.DX_Advanced.OnAnimationFinished:RemoveAll();
end

return UGC_NewSupply_DrawItem_UIBP