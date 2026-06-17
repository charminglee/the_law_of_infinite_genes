---@class ACHVTitle_C:UUserWidget
---@field Frame UButton
---@field Icon UImage
---@field Lock UImage
---@field Name UTextBlock
---@field PressedImg UImage
--Edit Below--
local ACHVTitle = { 
    bInitDoOnce = false,
    parent = nil,
    index = 0
} 

function ACHVTitle:Construct()
	self:LuaInit();
end

function ACHVTitle:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	self.Frame.OnClicked:Add(self.FrameClicked, self);
end

function ACHVTitle:Refresh()
    self.Name:SetText(ACHVManager.Config.TitleNameLabel[ACHVManager.CategoryListUI.selectedTabID + 1][self.index + 1]);
end

function ACHVTitle:Select()
    self.PressedImg:SetVisibility(ESlateVisibility.Visible);
    self.Frame:SetIsEnabled(true)
end

function ACHVTitle:Deselect()
	self.PressedImg:SetVisibility(ESlateVisibility.Collapsed);
end

function ACHVTitle:FrameClicked()
    self.parent:SelectTab(self.index);
end

return ACHVTitle