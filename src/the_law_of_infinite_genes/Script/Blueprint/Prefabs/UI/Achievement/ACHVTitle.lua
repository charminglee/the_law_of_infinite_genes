---@class ACHVTitle_C:UUserWidget
---@field Frame UButton
---@field LockBg UImage
---@field LockImg UImage
---@field Name UTextBlock
---@field PressedFrame UImage
---@field PressedImg UImage
---@field State UTextBlock
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
 
function ACHVTitle:GetUnlockState()
    return ACHVManager.Config.TitleData[ACHVManager.CategoryListUI.selectedTabID][self.index + 1].UnlockState
end

function ACHVTitle:GetUnlockStateText()
    return ACHVManager.Config.UnlockStateText[self:GetUnlockState()]
end

function ACHVTitle:SetUnlockState(value)
    ACHVManager.Config.TitleData[ACHVManager.CategoryListUI.selectedTabID][self.index + 1].UnlockState = value
    self:Refresh();
end

function ACHVTitle:ToggleState()
    self:SetUnlockState(ACHVManager.Config.SetToggleState[self:GetUnlockState()])
end

function ACHVTitle:SetLocked(locked)
    if locked then
        self.LockImg:SetVisibility(ESlateVisibility.Visible)
        self.LockBg:SetVisibility(ESlateVisibility.Visible)
    else
        self.LockImg:SetVisibility(ESlateVisibility.Hidden)
        self.LockBg:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function ACHVTitle:Refresh()
    self.Name:SetText(ACHVManager.Config.TitleData[ACHVManager.CategoryListUI.selectedTabID][self.index + 1].NameText);
    self.State:SetText(self:GetUnlockStateText())
    self:SetLocked(self:GetUnlockState() == 0)
end

function ACHVTitle:Select()
    self.PressedFrame:SetVisibility(ESlateVisibility.Visible);
    self.PressedImg:SetVisibility(ESlateVisibility.Visible);
end

function ACHVTitle:Deselect()
	self.PressedFrame:SetVisibility(ESlateVisibility.Collapsed);
	self.PressedImg:SetVisibility(ESlateVisibility.Collapsed);
end

function ACHVTitle:FrameClicked()
    self.parent:SelectTab(self.index);
end

return ACHVTitle