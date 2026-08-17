---@class FMTabItem_C:UAEUserWidget
---@field Button_0 UButton
---@field CanvasPanel_Icon UCanvasPanel
---@field Image_Null UImage
---@field Image_QualityBar UImage
---@field Normal UCanvasPanel
---@field selected UCanvasPanel
---@field TextBlock UTextBlock
--Edit Below--
local FMTabItem = {
    bInitDoOnce = false,
    Index = nil,
}

function FMTabItem:Construct()
    self:LuaInit();
end

function FMTabItem:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);
end

function FMTabItem:Button_0_Clicked()
    local tab = self.Index ~= nil and FortifyManager.EquipmentType[self.Index + 1] or nil;
    if tab ~= nil then
        FortifyManager:Reload(FortifyManager.DefineId, tab.Type);
    end
end

function FMTabItem:SetDAT(Index, Text)
    self.Index = Index;
    self.TextBlock:SetText(Text or '');
end

function FMTabItem:SetSelected(Selected)
    self.selected:SetVisibility(Selected and ESlateVisibility.Visible or ESlateVisibility.Collapsed);
    self.Normal:SetVisibility(Selected and ESlateVisibility.Collapsed or ESlateVisibility.Visible);
end

return FMTabItem
