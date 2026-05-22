---@class Lottery_IconItem_UIBP_C:UUserWidget
---@field Button_Item UButton
---@field CanvasPanel_Have UCanvasPanel
---@field Image_icon UImage
---@field TextItem_number UTextBlock
--Edit Below--
local Lottery_IconItem_UIBP = { bInitDoOnce = false } 

function Lottery_IconItem_UIBP:Construct()
	self:InitBindEvent();
end

function Lottery_IconItem_UIBP:InitBindEvent()
    self.Button_Item.OnPressed:Add(self.ButtonLongPress, self);
    self.Button_Item.OnReleased:Add(self.ButtonReleased, self);
end

function Lottery_IconItem_UIBP:ButtonLongPress()
    local AbsPosition = SlateBlueprintLibrary.GetAbsolutePosition(self:GetCachedGeometry());
    local Position = SlateBlueprintLibrary.AbsoluteToLocal(WidgetLayoutLibrary.GetViewportWidgetGeometry(self), AbsPosition);
    LotteryManager:OpenLotteryItemTipUI(self.ItemID, Position);
end

function Lottery_IconItem_UIBP:ButtonReleased()
    LotteryManager:CloseLotteryItemTipUI();
end

-- function Lottery_IconItem_UIBP:Tick(MyGeometry, InDeltaTime)
-- end

function Lottery_IconItem_UIBP:Destruct()
    self.Button_Item.OnPressed:RemoveAll();
    self.Button_Item.OnReleased:RemoveAll();
end

function Lottery_IconItem_UIBP:InitUI(ItemID)
    self.ItemID = ItemID;
    local ItemInfo = LotteryManager:GetItemConfigData(ItemID);
    -- 设置道具Icon
    if ItemInfo and ItemInfo.ItemIcon then
        Common.LoadObjectAsync(ItemInfo.ItemIcon, 
            function (IconTexture)
                if self ~= nil and UE.IsValid(self) then
                    self.Image_Icon:SetBrushFromTexture(IconTexture);
                end
            end
        );
    end
    self.TextItem_number:SetText(tostring(0));
end

return Lottery_IconItem_UIBP