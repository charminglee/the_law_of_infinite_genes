---@class Lottery_BigReward_UIBP_C:UUserWidget
---@field Button_BigReward UButton
---@field CanvasPanel_Received UCanvasPanel
---@field FX_Get UImage
---@field Icon UImage
---@field Image_Get UImage
---@field Text_BigAward_Details UTextBlock
---@field TextBlock_BigAwardName UTextBlock
--Edit Below--


local Lottery_BigReward_UIBP = { bInitDoOnce = false } 

function Lottery_BigReward_UIBP:Construct()
    -- self.Image_Get:SetVisibility(ESlateVisibility.Collapsed);
end

-- function Lottery_BigReward_UIBP:Tick(MyGeometry, InDeltaTime)

-- end

-- function Lottery_BigReward_UIBP:Destruct()

-- end

function Lottery_BigReward_UIBP:InitUI(LotteryID)
end

return Lottery_BigReward_UIBP