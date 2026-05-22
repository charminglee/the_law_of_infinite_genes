---@class Lottery_DescShop_UIBP_C:UUserWidget
---@field CanvasPanel_11 UCanvasPanel
---@field CanvasPanel_Desc UCanvasPanel
---@field CanvasPanel_Package UCanvasPanel
---@field HorizontalBox_Price UHorizontalBox
---@field Image_Commodity UImage
---@field Image_Market_Goods_QualityBg UImage
---@field Image_Market_Goods_QualityLine UImage
---@field Image_Money1 UImage
---@field Text_1 UTextBlock
---@field Text_2 UTextBlock
---@field TextBlock_14 UTextBlock
---@field TextBlock_Desc UTextBlock
---@field TextBlock_Name UTextBlock
---@field UGC_ReuseList2_MustObtain UUGC_ReuseList2_C
---@field UGC_ReuseList2_Probability UUGC_ReuseList2_C
--Edit Below--
local Lottery_DescShop_UIBP = { bInitDoOnce = false } 

function Lottery_DescShop_UIBP:Construct()
	self:InitBindEvent();
end

-- function Lottery_DescShop_UIBP:Tick(MyGeometry, InDeltaTime)

-- end

-- function Lottery_DescShop_UIBP:Destruct()

-- end

function Lottery_DescShop_UIBP:InitBindEvent()
    self.UGC_ReuseList2_MustObtain.OnAfterNewItem:Add(self.InitMustObtainItem, self)
    self.UGC_ReuseList2_Probability.OnAfterNewItem:Add(self.InitProbabilityItem, self)
end

function Lottery_DescShop_UIBP:InitMustObtainItem(item, index)

end

function Lottery_DescShop_UIBP:InitProbabilityItem(item, index)
    
end

function Lottery_DescShop_UIBP:RefreshUI(ItemID)
    local ItemInfo = LotteryManager:GetItemConfigData(ItemID);
    -- 道具名称
    if ItemInfo.ItemName then
        self.TextBlock_Name:SetText(ItemInfo.ItemName);
    end
    -- 道具描述
    if ItemInfo.ItemDesc then
        self.TextBlock_Desc:SetText(ItemInfo.ItemDesc);
    end
    -- 道具Icon
    if ItemInfo.ItemIcon then
        Common.LoadObjectAsync(ItemInfo.ItemIcon, 
            function (IconTexture)
                if self ~= nil and UE.IsValid(self) then
                    self.Image_Commodity:SetBrushFromTexture(IconTexture);
                end
            end
        );
    end

    local IsGiftBox = false;
    -- 判断是不是礼盒
    if IsGiftBox then
        self.CanvasPanel_Package:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
        self.CanvasPanel_11:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
        self:ShowGiftBox(ItemID);
    else
        self.CanvasPanel_Package:SetVisibility(ESlateVisibility.Collapsed);
        self.CanvasPanel_11:SetVisibility(ESlateVisibility.Collapsed);
    end
    self.HorizontalBox_Price:SetVisibility(ESlateVisibility.Collapsed);
end

function Lottery_DescShop_UIBP:ShowGiftBox(ItemID)

end

return Lottery_DescShop_UIBP