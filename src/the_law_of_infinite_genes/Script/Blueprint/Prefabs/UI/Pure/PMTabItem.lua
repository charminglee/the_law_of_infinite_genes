---@class PMTabItem_C:UAEUserWidget
---@field Button_0 UButton
---@field Normal UCanvasPanel
---@field selected UCanvasPanel
---@field TextBlock UTextBlock
--Edit Below--
local PMTabItem = {
    bInitDoOnce = false,
    Index = nil,
}

function PMTabItem:Construct()
    self:LuaInit();
end

function PMTabItem:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);
end

function PMTabItem:Button_0_Clicked()
    local tab = self.Index ~= nil and PureManager.EquipmentType[self.Index + 1] or nil;
    if tab ~= nil then
        PureManager:Reload(PureManager.DefineId, tab.Type);
    end
end

function PMTabItem:SetDAT(Index, Text)
    self.Index = Index;
    self.TextBlock:SetText(Text or '');
end

function PMTabItem:SetSelected(Selected)
    self.selected:SetVisibility(Selected and ESlateVisibility.Visible or ESlateVisibility.Collapsed);
    self.Normal:SetVisibility(Selected and ESlateVisibility.Collapsed or ESlateVisibility.Visible);
end

return PMTabItem
