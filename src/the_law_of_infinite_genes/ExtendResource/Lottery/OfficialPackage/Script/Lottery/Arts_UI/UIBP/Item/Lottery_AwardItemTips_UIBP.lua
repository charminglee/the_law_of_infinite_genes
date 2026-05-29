---@class Lottery_AwardItemTips_UIBP_C:UUserWidget
---@field CanvasPanel_0 UCanvasPanel
---@field ContainText UTextBlock
---@field DetailText UTextBlock
---@field Icon UImage
---@field Image_5 UImage
---@field Panel UCanvasPanel
---@field TextBlock_0 UTextBlock
---@field TextBlock_GrandTotal UTextBlock
---@field TitleText UTextBlock
--Edit Below--

local Lottery_AwardItemTips_UIBP = { bInitDoOnce = false } 

function Lottery_AwardItemTips_UIBP:Construct()
	
end

-- function Lottery_AwardItemTips_UIBP:Tick(MyGeometry, InDeltaTime)

-- end

-- function Lottery_AwardItemTips_UIBP:Destruct()

-- end

function Lottery_AwardItemTips_UIBP:ShowAwardItemTip(Progress, ProgressDesc, ItemID, Position)
    self.TextBlock_GrandTotal:SetText(string.format("累计%d次奖励", Progress));
    self.DetailText:SetText(ProgressDesc);
    local ItemInfo = LotteryManager:GetItemConfigData(ItemID);
    if ItemInfo then
        if ItemInfo.ItemName then
            self.TitleText:SetText(ItemInfo.ItemName); 
        end
        if ItemInfo.ItemIcon then
            Common.LoadObjectAsync(ItemInfo.ItemIcon, 
                function (IconTexture)
                    if self ~= nil and UE.IsValid(self) then
                        self.Icon:SetBrushFromTexture(IconTexture);
                    end
                end
            );
        end
        local ItemNum = LotteryManager:GetPlayerOwnedItemNum(ItemID);
        self.ContainText:SetText(string.format("拥有:%d", ItemNum));
    end
    self:SetPosition(Position);
end

function Lottery_AwardItemTips_UIBP:SetPosition(Position)
    local TipSize = self.CanvasPanel_0.Slots[1]:GetSize();
    Position.X = Position.X + TipSize.X * 2;
    Position.Y = Position.Y + TipSize.Y * 2;
    self.CanvasPanel_0.Slots[1]:SetPosition(Position);
end

return Lottery_AwardItemTips_UIBP