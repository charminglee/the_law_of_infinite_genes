---@class PMTabItem_C:UAEUserWidget
---@field Button_0 UButton
---@field CanvasPanel_Icon UCanvasPanel
---@field Image_Null UImage
---@field Image_QualityBar UImage
---@field Normal UCanvasPanel
---@field selected UCanvasPanel
---@field TextBlock UTextBlock
--Edit Below--
local PMTabItem = { bInitDoOnce = false, Index=nil}

function PMTabItem:Construct()
	self:LuaInit();
end

function PMTabItem:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self:Listen();
end

function PMTabItem:Listen()
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);
end

function PMTabItem:Button_0_Clicked()
    PureManager:Reload(PureManager.DefineId, PureManager.EquipmentType[self.Index+1].Type);
end

function PMTabItem:SetDAT(Index, Text)
    self.Index = Index;
    self.TextBlock:SetText(Text);
end

function PMTabItem:SetSelected(Visible)
    local s = ESlateVisibility.Collapsed;
    local n = ESlateVisibility.Collapsed
    if Visible then
        s = ESlateVisibility.Visible;
    else
        n = ESlateVisibility.Visible;
    end
    self.selected:SetVisibility(s);
    self.Normal:SetVisibility(n);
end

return PMTabItem