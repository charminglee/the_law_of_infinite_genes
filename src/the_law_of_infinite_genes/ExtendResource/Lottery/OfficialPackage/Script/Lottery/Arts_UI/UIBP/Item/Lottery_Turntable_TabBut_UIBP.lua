---@class Lottery_Turntable_TabBut_UIBP_C:UUserWidget
---@field Button_Select UButton
---@field Canvas_BannerSize UCanvasPanel
---@field HorizontalBox_Title UScaleBox
---@field Image_Icon UImage
---@field Image_Label UImage
---@field Image_Selected UImage
---@field TextBlock_Title UTextBlock
--Edit Below--
local Lottery_Turntable_TabBut_UIBP = { bInitDoOnce = false } 


function Lottery_Turntable_TabBut_UIBP:Construct()
	self:InitBindEvent();
end

-- function Lottery_Turntable_TabBut_UIBP:Tick(MyGeometry, InDeltaTime)

-- end

-- function Lottery_Turntable_TabBut_UIBP:Destruct()

-- end

function Lottery_Turntable_TabBut_UIBP:Init(LotteryID)
    self.LotteryID = LotteryID;
    local LotteryData = LotteryManager:GetLotteryConfigData(LotteryID);
    if LotteryData then
        self:SetTitle(LotteryData.Name);
        self:SetIcon(LotteryData.Icon);
    end
    self.Image_Label:SetVisibility(ESlateVisibility.Collapsed);
    self.Image_Icon:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
end

---@param title FString
function Lottery_Turntable_TabBut_UIBP:SetTitle(title)
    self.TextBlock_Title:SetText(LotteryManager:GetLegalStr(title, 7));
end

---@param iconPath FSoftObjectPath
function Lottery_Turntable_TabBut_UIBP:SetIcon(IconPath)
    Common.LoadObjectAsync(IconPath, 
        function (IconTexture)
            if self ~= nil and UE.IsValid(self) then
                self.Image_Icon:SetBrushFromTexture(IconTexture);
            end
        end
    );
end

function Lottery_Turntable_TabBut_UIBP:InitBindEvent()
    self.Button_Select.OnClicked:Add(self.ButtonClick, self);
end

function Lottery_Turntable_TabBut_UIBP:ButtonClick()
    print(string.format("Lottery_Turntable_TabBut_UIBP:SelectLottery LotteryID: %d", self.LotteryID));
    -- 更新抽卡界面信息
    LotteryManager:SwitchLotteryTab(self.LotteryID);
    -- 更新奖励一览信息
    LotteryManager:RefreshAwardPreview(self.LotteryID);
end

function Lottery_Turntable_TabBut_UIBP:Select()
    self.Image_Selected:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
end

function Lottery_Turntable_TabBut_UIBP:UnSelect()
    self.Image_Selected:SetVisibility(ESlateVisibility.Collapsed);
end

return Lottery_Turntable_TabBut_UIBP