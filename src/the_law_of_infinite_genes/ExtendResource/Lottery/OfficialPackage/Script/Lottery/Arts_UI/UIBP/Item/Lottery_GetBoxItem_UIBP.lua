---@class Lottery_GetBoxItem_UIBP_C:UUserWidget
---@field Button_gift UButton
---@field Image_icon01 UImage
---@field Image_icon02 UImage
---@field Image_icon03 UImage
---@field Text_Times UTextBlock
---@field WidgetSwitcher_Status UWidgetSwitcher
--Edit Below--
local Lottery_GetBoxItem_UIBP = { bInitDoOnce = false } 
local AwardState = {
    Lock = 1,
    NotClaimed = 2,    
    HasClaimed = 3,
}

function Lottery_GetBoxItem_UIBP:Construct()
	self:InitBindEvent();
    self.State = AwardState.Lock;
end

function Lottery_GetBoxItem_UIBP:InitBindEvent()
    self.Button_gift.OnPressed:Add(self.ButtonPress, self);
    self.Button_gift.OnReleased:Add(self.ButtonRelease, self);
    self.Button_gift.OnClicked:Add(self.ReceiveItem, self);
end

function Lottery_GetBoxItem_UIBP:ButtonPress()
    ---弹出道具Tip
    ---判断一下是否可领取
    if self.State ~= AwardState.NotClaimed then
        local AbsPosition = SlateBlueprintLibrary.GetAbsolutePosition(self:GetCachedGeometry());
        local Position = SlateBlueprintLibrary.AbsoluteToLocal(WidgetLayoutLibrary.GetViewportWidgetGeometry(self), AbsPosition);
        LotteryManager:OpenLotteryGiftProgressTipUI(self.Progress, self.Desc, self.ItemID, Position);
    end
end

function Lottery_GetBoxItem_UIBP:ButtonRelease()
    if self.State ~= AwardState.NotClaimed then
        LotteryManager:CloseLotteryGiftProgressTipUI();
    end
end

function Lottery_GetBoxItem_UIBP:ReceiveItem()
    if self.State == AwardState.NotClaimed then
        LotteryManager:GetProgressItem(self.LotteryID, self.Progress);
    end
end

-- function Lottery_GetBoxItem_UIBP:Tick(MyGeometry, InDeltaTime)

-- end

function Lottery_GetBoxItem_UIBP:Destruct()
    self.Button_gift.OnPressed:RemoveAll();
    self.Button_gift.OnReleased:RemoveAll();
    self.Button_gift.OnClicked:RemoveAll();
end

function Lottery_GetBoxItem_UIBP:InitUI(LotteryID, Progress, Desc, ItemID)
    self.Text_Times:SetText(tostring(Progress));
    self.ItemID = ItemID;
    self.Progress = Progress;
    self.Desc = Desc;
    self.LotteryID = LotteryID;
    local ItemInfo = LotteryManager:GetItemConfigData(ItemID);
    if ItemInfo and ItemInfo.ItemIcon then
        Common.LoadObjectAsync(ItemInfo.ItemIcon, 
            function (IconTexture)
                if self ~= nil and UE.IsValid(self) then
                    self.Image_icon01:SetBrushFromTexture(IconTexture);
                    self.Image_icon02:SetBrushFromTexture(IconTexture);
                    self.Image_icon03:SetBrushFromTexture(IconTexture);
                end
            end
        );
    end
    self:Refresh();
end

function Lottery_GetBoxItem_UIBP:GetGiftProgress()
    -- 已领取
    self.WidgetSwitcher_Status:SetActiveWidgetIndex(1);
    self.State = AwardState.HasClaimed;
end

function Lottery_GetBoxItem_UIBP:Refresh()
    if self.LotteryID == nil or self.Progress == nil then
        return
    end
    --- 判断是否达到进度
    local CurPorgress = LotteryManager:GetPlayerTotalDraws(self.LotteryID);
    if CurPorgress >= self.Progress then
        -- 判断是否领取
        local HasGot = LotteryManager:CheckGiftProgressGet(self.LotteryID, self.Progress);
        if HasGot == true then
            self.WidgetSwitcher_Status:SetActiveWidgetIndex(1);
            self.State = AwardState.HasClaimed;
        else
            self.WidgetSwitcher_Status:SetActiveWidgetIndex(2);
            self.State = AwardState.NotClaimed;
        end
    else
        self.WidgetSwitcher_Status:SetActiveWidgetIndex(0);
        self.State = AwardState.Lock;
    end
end

return Lottery_GetBoxItem_UIBP
