---@class Lottery_ItemTips_UIBP_C:UUserWidget
---@field CanvasPanel_0 UCanvasPanel
---@field ContainText UTextBlock
---@field DetailText UTextBlock
---@field Icon UImage
---@field Image_5 UImage
---@field Panel UCanvasPanel
---@field TextBlock_0 UTextBlock
---@field TitleText UTextBlock
--Edit Below--

local Lottery_ItemTips_UIBP = { bInitDoOnce = false } 


function Lottery_ItemTips_UIBP:Construct()
	
end


-- function Lottery_ItemTips_UIBP:Tick(MyGeometry, InDeltaTime)

-- end

-- function Lottery_ItemTips_UIBP:Destruct()

-- end

function Lottery_ItemTips_UIBP:ShowItemTip(ItemID, Position)
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
        if ItemInfo.ItemDesc then
            self.DetailText:SetText(ItemInfo.ItemDesc); 
        end
        local ItemNum = LotteryManager:GetPlayerOwnedItemNum(ItemID);
        self.ContainText:SetText(string.format("拥有:%d", ItemNum));
    end
    self:SetPosition(Position);
end

function Lottery_ItemTips_UIBP:SetPosition(Position)
    print(string.format("[Lottery_ItemTips_UIBP] SetPosition X: %s Y: %s", tostring(Position.X), tostring(Position.Y)));
    -- local ViewportSize = WidgetLayoutLibrary.GetViewportSize(self);
    -- local ViewportScale = WidgetLayoutLibrary.GetViewportScale(self);
    -- local MaxX = ViewportSize.X;
    -- local MaxY = ViewportSize.Y;

    local TipSize = self.CanvasPanel_0.Slots[1]:GetSize();
    print(string.format("[Lottery_ItemTips_UIBP] TipSizeX: %s TipSizeY: %s", tostring(TipSize.X), tostring(TipSize.Y)));
    -- local DesireX = (Position.X + TipSize.X) * ViewportScale;
    -- local DesireY = (Position.Y + TipSize.Y) * ViewportScale;

    -- if DesireX > MaxX then
    --     Position.X = Position.X - (DesireX - MaxX);
    -- end
    
    -- if DesireX < 0 then
    --     Position.X = 0;
    -- end

    -- if DesireY > MaxY then
    --     Position.Y = Position.Y - (DesireY - MaxY);
    -- end

    -- if DesireY < 0 then
    --     Position.Y = 0;
    -- end

    Position.X = Position.X + TipSize.X * 2;
    Position.Y = Position.Y + TipSize.Y * 2;
    print(string.format("[Lottery_ItemTips_UIBP] Position X: %s Y: %s", tostring(Position.X), tostring(Position.Y)));
    self.CanvasPanel_0.Slots[1]:SetPosition(Position);
end

return Lottery_ItemTips_UIBP