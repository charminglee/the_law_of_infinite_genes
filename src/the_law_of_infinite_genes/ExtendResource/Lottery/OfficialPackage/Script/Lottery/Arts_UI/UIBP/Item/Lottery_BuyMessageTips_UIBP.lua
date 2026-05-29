---@class Lottery_BuyMessageTips_UIBP_C:UUserWidget
---@field DX_In UWidgetAnimation
---@field Panel UCanvasPanel
---@field TitleTextTips UTextBlock
--Edit Below--
local Lottery_BuyMessageTips_UIBP = { bInitDoOnce = false } 

function Lottery_BuyMessageTips_UIBP:Construct()
end

function Lottery_BuyMessageTips_UIBP:OnAnimationFinished(Animation)
    if Animation == self.DX_In then
        self:SetVisibility(ESlateVisibility.Collapsed);
    end
end

-- function Lottery_BuyMessageTips_UIBP:Tick(MyGeometry, InDeltaTime)

-- end

-- function Lottery_BuyMessageTips_UIBP:Destruct()

-- end

function Lottery_BuyMessageTips_UIBP:ShowMessageTip(Text)
    self.TitleTextTips:SetText(Text);
    -- 播放动画
    if CheckObjectContainsField(self, "DX_In") then
        self:PlayAnimation(self.DX_In, 0, 1, EUMGSequencePlayMode.Forward, 1);
    end
end

return Lottery_BuyMessageTips_UIBP