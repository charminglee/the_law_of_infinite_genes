---@class KComposeTabItem_C:UAEUserWidget
---@field Button_0 UButton
---@field CanvasPanel_Icon UCanvasPanel
---@field Image_Null UImage
---@field Image_QualityBar UImage
---@field Normal UCanvasPanel
---@field selected UCanvasPanel
---@field TextBlock UTextBlock
--Edit Below--
local KComposeTabItem = { bInitDoOnce = false, Index=nil}

function KComposeTabItem:Construct()
	self:LuaInit();
end

function KComposeTabItem:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self:Listen();
end

function KComposeTabItem:Listen()
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);
end

function KComposeTabItem:Button_0_Clicked()
    local config = KenlComposeManager.EquipmentType[self.Index + 1];
    if config ~= nil then
        KenlComposeManager:Reload(KenlComposeManager.DefineId, config.Type);
    end
end

function KComposeTabItem:SetDAT(Index, Text)
    self.Index = Index;
    self.TextBlock:SetText(Text);
end

function KComposeTabItem:SetSelected(Visible)
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

return KComposeTabItem
