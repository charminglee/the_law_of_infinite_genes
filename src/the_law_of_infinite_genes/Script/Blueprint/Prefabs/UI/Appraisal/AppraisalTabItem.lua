---@class AppraisalTabItem_C:UAEUserWidget
---@field Button_0 UButton
---@field CanvasPanel_Icon UCanvasPanel
---@field Image_Null UImage
---@field Image_QualityBar UImage
---@field Normal UCanvasPanel
---@field selected UCanvasPanel
---@field TextBlock UTextBlock
--Edit Below--
local AppraisalTabItem = { bInitDoOnce = false, Index=nil}

function AppraisalTabItem:Construct()
	self:LuaInit();
end

function AppraisalTabItem:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self:Listen();
end

function AppraisalTabItem:Listen()
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);
end

function AppraisalTabItem:Button_0_Clicked()
    AppraisalManager:Reload(AppraisalManager.DefineId, AppraisalManager.EquipmentType[self.Index+1].Type);
end

function AppraisalTabItem:SetDAT(Index, Text)
    self.Index = Index;
    self.TextBlock:SetText(Text);
end

function AppraisalTabItem:SetSelected(Visible)
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

return AppraisalTabItem