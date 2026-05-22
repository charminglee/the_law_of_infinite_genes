---@class WBP_OpenLotteryButton_C:UUserWidget
---@field OpenLotteryButton UButton
--Edit Below--

local WBP_OpenLotteryButton = { bInitDoOnce = false } 

function WBP_OpenLotteryButton:Construct()
    self.OpenLotteryButton.OnClicked:Add(self.OnOpenButtonClicked, self);
end

function WBP_OpenLotteryButton:OnOpenButtonClicked()
    LotteryManager:OpenLotteryPanel();
end

-- function WBP_OpenLotteryButton:Tick(MyGeometry, InDeltaTime)

-- end


return WBP_OpenLotteryButton