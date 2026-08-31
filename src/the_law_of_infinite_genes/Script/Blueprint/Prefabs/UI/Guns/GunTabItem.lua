---@class GunTabItem_C:UAEUserWidget
---@field Button_0 UButton
---@field Normal UCanvasPanel
---@field selected UCanvasPanel
---@field TextBlock UTextBlock
--Edit Below--
local GunTabItem = {
    bInitDoOnce = false,
    Index = nil,
}

function GunTabItem:Construct()
    self:LuaInit();
end

function GunTabItem:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);
end

function GunTabItem:Button_0_Clicked()
    local tab = GunsManager.GunsType[self.Index + 1];
    GunsManager:Reload(nil, tab.Type);
end

function GunTabItem:SetDAT(Index, Text)
    self.Index = Index;
    self:SetVisibility(ESlateVisibility.Visible);
    self.TextBlock:SetText(Text);
end

function GunTabItem:SetSelected(IsSelected)
    self.selected:SetVisibility(IsSelected and ESlateVisibility.Visible or ESlateVisibility.Collapsed);
    self.Normal:SetVisibility(IsSelected and ESlateVisibility.Collapsed or ESlateVisibility.Visible);
end

return GunTabItem
