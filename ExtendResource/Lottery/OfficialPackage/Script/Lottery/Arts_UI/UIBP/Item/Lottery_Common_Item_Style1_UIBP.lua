---@class Lottery_Common_Item_Style1_UIBP_C:UUserWidget
---@field Button_Item UButton
---@field Canvas_Root UCanvasPanel
---@field CanvasPanel_Select UCanvasPanel
---@field Down UImage
---@field FX_Light UCanvasPanel
---@field Image_Bg_Default UImage
---@field Image_Bg_Quality UImage
---@field Image_Icon UImage
---@field Image_Icon_Quality UImage
---@field Left UImage
---@field Right UImage
---@field Up UImage
--Edit Below--
local Lottery_Common_Item_Style1_UIBP = { bInitDoOnce = false } 

function Lottery_Common_Item_Style1_UIBP:Construct()
	self:InitBindEvent();
end

-- function Lottery_Common_Item_Style1_UIBP:Tick(MyGeometry, InDeltaTime)

-- end

function Lottery_Common_Item_Style1_UIBP:Destruct()
    self.Button_Item.OnPressed:RemoveAll();
    self.Button_Item.OnReleased:RemoveAll();
    self.Button_Item.OnClicked:RemoveAll();
end

function Lottery_Common_Item_Style1_UIBP:InitUI(ItemID, NeedTip, NeedSelect)
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

    if NeedTip then
        self.Button_Item.OnPressed:RemoveAll();
        self.Button_Item.OnReleased:RemoveAll();
        self.Button_Item.OnPressed:Add(self.ButtonLongPress, self);
        self.Button_Item.OnReleased:Add(self.ButtonReleased, self);
    end

    if NeedSelect then
        self.Button_Item.OnClicked:RemoveAll();
        self.Button_Item.OnClicked:Add(self.ButtonClick, self);
    end
end

function Lottery_Common_Item_Style1_UIBP:InitBindEvent()
    -- self.Button_Item.OnClicked:Add(self.ButtonClick, self);
    -- self.Button_Item.OnPressed:Add(self.ButtonLongPress, self);
    -- self.Button_Item.OnReleased:Add(self.ButtonReleased, self);
end

function Lottery_Common_Item_Style1_UIBP:ButtonClick()
    LotteryManager:SelectItem(self.ItemID);
end
    
function Lottery_Common_Item_Style1_UIBP:ButtonLongPress()
    print("Lottery_Common_Item_Style1_UIBP:ButtonLongPress");
    --- 弹出道具Tip
    local AbsPosition = SlateBlueprintLibrary.GetAbsolutePosition(self:GetCachedGeometry());
    local Position = SlateBlueprintLibrary.AbsoluteToLocal(WidgetLayoutLibrary.GetViewportWidgetGeometry(self), AbsPosition);
    LotteryManager:OpenLotteryItemTipUI(self.ItemID, Position);
end

function Lottery_Common_Item_Style1_UIBP:ButtonReleased()
    print("Lottery_Common_Item_Style1_UIBP:ButtonReleased");
    LotteryManager:CloseLotteryItemTipUI();
end

function Lottery_Common_Item_Style1_UIBP:Select()
    self.CanvasPanel_Select:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
end

function Lottery_Common_Item_Style1_UIBP:UnSelect()
    print("Lottery_Common_Item_Style1_UIBP:UnSelect")
    self.CanvasPanel_Select:SetVisibility(ESlateVisibility.Collapsed);
end

return Lottery_Common_Item_Style1_UIBP