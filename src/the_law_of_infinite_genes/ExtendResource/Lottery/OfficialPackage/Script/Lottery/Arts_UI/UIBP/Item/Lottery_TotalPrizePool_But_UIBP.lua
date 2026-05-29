---@class Lottery_TotalPrizePool_But_UIBP_C:UUserWidget
---@field Button_TotalPrizePool UButton
---@field Image_icon UImage
---@field TextItem_number UTextBlock
--Edit Below--

local Lottery_TotalPrizePool_But_UIBP = { bInitDoOnce = false } 

function Lottery_TotalPrizePool_But_UIBP:Construct()
    self:InitBindEvent();
end

function Lottery_TotalPrizePool_But_UIBP:InitBindEvent()
    self.Button_TotalPrizePool.OnClicked:Add(self.ButtonClick, self);
end

function Lottery_TotalPrizePool_But_UIBP:ButtonClick()
    -- 奖品预览界面
    LotteryManager:OpenLotteryAwardPreview();
end

-- function Lottery_TotalPrizePool_But_UIBP:Tick(MyGeometry, InDeltaTime)

-- end

-- function Lottery_TotalPrizePool_But_UIBP:Destruct()

-- end

return Lottery_TotalPrizePool_But_UIBP