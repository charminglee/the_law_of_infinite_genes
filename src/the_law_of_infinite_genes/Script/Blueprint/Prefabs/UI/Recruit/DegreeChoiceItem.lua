---@class DegreeChoiceItem_C:UUserWidget
---@field CanvasPanel_Icon UCanvasPanel
---@field Image_Lock UImage
---@field Image_NoSelected UImage
---@field Image_Selected UImage
---@field Size FVector2D
---@field DurabilityPercent float
--Edit Below--
local DegreeChoiceItem = {}

function DegreeChoiceItem:SetState(bSelected, bLocked, bVisible)
    self:SetVisibility(bVisible and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
    self.CanvasPanel_Icon:SetVisibility(bVisible and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
    self.Image_Selected:SetVisibility(bSelected and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
    self.Image_NoSelected:SetVisibility(not bSelected and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
    self.Image_Lock:SetVisibility(bLocked and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
end

return DegreeChoiceItem
