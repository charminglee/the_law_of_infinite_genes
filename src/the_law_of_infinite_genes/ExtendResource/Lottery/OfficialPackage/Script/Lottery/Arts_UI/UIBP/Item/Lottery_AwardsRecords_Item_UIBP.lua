---@class Lottery_AwardsRecords_Item_UIBP_C:UUserWidget
---@field Lottery_Common_Item_Style1_UIBP ULottery_Common_Item_Style1_UIBP_C
---@field TextBlock_ItemName UTextBlock
---@field TextBlock_Time UTextBlock
--Edit Below--
local Lottery_AwardsRecords_Item_UIBP = { bInitDoOnce = false } 


function Lottery_AwardsRecords_Item_UIBP:Construct()
	
end

-- function Lottery_AwardsRecords_Item_UIBP:Tick(MyGeometry, InDeltaTime)

-- end

-- function Lottery_AwardsRecords_Item_UIBP:Destruct()

-- end

function Lottery_AwardsRecords_Item_UIBP:InitUI(ItemID, ItemNum, GetTime)
    print(string.format("[Lottery_AwardsRecords_Item_UIBP] InitUI ItemID: %d", ItemID or -1));
    local ItemInfo = LotteryManager:GetItemConfigData(ItemID);
    if ItemInfo then
        -- 道具名称
        if ItemInfo.ItemName then
            self.TextBlock_ItemName:SetText(ItemInfo.ItemName);
        end
        local DrawDate = os.date("*t", GetTime);
        local Year = DrawDate.year;
        local Month = DrawDate.month;
        local Day = DrawDate.day;
        -- 设置获取时间
        self.TextBlock_Time:SetText(string.format("%d.%02d.%02d", Year, Month, Day));
        self.Lottery_Common_Item_Style1_UIBP:InitUI(ItemID, false, false);
    end
end

return Lottery_AwardsRecords_Item_UIBP