---@class GunTabItem_C:UAEUserWidget
---@field Button_0 UButton
---@field CanvasPanel_Icon UCanvasPanel
---@field Image_Null UImage
---@field Image_QualityBar UImage
---@field Normal UCanvasPanel
---@field selected UCanvasPanel
---@field TextBlock UTextBlock
--Edit Below--
local GunTabItem = { bInitDoOnce = false, Index=nil}

function GunTabItem:Construct()
	self:LuaInit();
end

function GunTabItem:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self:Listen();
end

function GunTabItem:Listen()
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);
end

function GunTabItem:Button_0_Clicked()
    GunsManager:Reload(GunsManager.DefineId, GunsManager.GunsType[self.Index+1].Type);
end

function GunTabItem:SetDAT(Index, Text)
    self.Index = Index;
    self.TextBlock:SetText(Text);
end

function GunTabItem:SetSelected(Visible)
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

return GunTabItem