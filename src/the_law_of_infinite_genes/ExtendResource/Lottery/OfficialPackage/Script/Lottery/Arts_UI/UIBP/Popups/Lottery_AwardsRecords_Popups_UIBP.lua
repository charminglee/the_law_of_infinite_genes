---@class Lottery_AwardsRecords_Popups_UIBP_C:UUserWidget
---@field Button_Close UButton
---@field Lottery_AwardsRecords_List UUGC_ReuseList2_C
---@field TY_PopupsBg_Text UTY_PopupsBg_Text_C
---@field UGC_Common_UIPopupBG UUGC_Common_UIPopupBG_C
--Edit Below--
local Lottery_AwardsRecords_Popups_UIBP = { bInitDoOnce = false } 


function Lottery_AwardsRecords_Popups_UIBP:Construct()
    self:InitBindEvent();
end

-- function Lottery_AwardsRecords_Popups_UIBP:Tick(MyGeometry, InDeltaTime)

-- end

-- function Lottery_AwardsRecords_Popups_UIBP:Destruct()

-- end

function Lottery_AwardsRecords_Popups_UIBP:InitUI(LotteryRecord)
    self.LotteryRecord = LotteryRecord;
    self.Lottery_AwardsRecords_List:Reload(#self.LotteryRecord);
end

function Lottery_AwardsRecords_Popups_UIBP:ScrollToStart()
    self.Lottery_AwardsRecords_List:ScrollToStart();
end

function Lottery_AwardsRecords_Popups_UIBP:InitBindEvent()
    self.Button_Close.OnClicked:Add(self.Close, self)
    self.Lottery_AwardsRecords_List.OnAfterNewItem:Add(self.InitAwardsRecords, self);
end

function Lottery_AwardsRecords_Popups_UIBP:Close()
    self:SetVisibility(ESlateVisibility.Collapsed);
end

function Lottery_AwardsRecords_Popups_UIBP:InitAwardsRecords(Item, Index)
    print(string.format("Lottery_AwardsRecords_Popups_UIBP:InitAwardsRecords Index: %d", Index));
    local RecordInfo = self.LotteryRecord[#self.LotteryRecord - Index];
    local ItemID = RecordInfo.ItemInfo.ID;
    local ItemNum = RecordInfo.ItemInfo.Num;
    local GetTime = RecordInfo.DrawTime;
    Item:InitUI(ItemID, ItemNum, GetTime);
end

return Lottery_AwardsRecords_Popups_UIBP