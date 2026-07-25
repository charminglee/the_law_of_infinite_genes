---@class ComposeTabItem_C:UAEUserWidget
---@field Button_0 UButton
---@field Image_1 UImage
---@field Image_2 UImage
---@field ItemName UTextBlock
---@field Selected UCanvasPanel
--Edit Below--
local ComposeTabItem = { bInitDoOnce = false, Index=nil}

function ComposeTabItem:Construct()
	self:LuaInit();
end

function ComposeTabItem:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self:Listen();
end

function ComposeTabItem:Listen()
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);
end

function ComposeTabItem:Button_0_Clicked()
    ComposeManager.TabSelectedIndex = self.Index;
    ComposeManager.GoodSelectedIndex = nil;
end

function ComposeTabItem:SetSelected(Visible)
    if Visible then
        self.Selected:SetVisibility(ESlateVisibility.Visible);
    else
        self.Selected:SetVisibility(ESlateVisibility.Collapsed);
    end
end

return ComposeTabItem