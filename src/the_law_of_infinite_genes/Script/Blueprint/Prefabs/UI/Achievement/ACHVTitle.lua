---@class ACHVTitle_C:UUserWidget
---@field Frame UButton
---@field Lock UImage
---@field LockBg UImage
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
    return ACHVManager.Config.UnlockState[ACHVManager.CategoryListUI.selectedTabID + 1][self.index + 1]
end

function ACHVTitle:GetUnlockStateText()
    return ACHVManager.Config.UnlockStateText[self:GetUnlockState() + 1]
end

function ACHVTitle:SetUnlockState(value)
    -- ACHVManager.Config.UnlockState[ACHVManager.CategoryListUI.selectedTabID + 1][self.index + 1] = value
end

function ACHVTitle:Lock()
    self.Lock:SetVisibility(ESlateVisibility.Visible);
    self.LockBg:SetVisibility(ESlateVisibility.Visible);
end

function ACHVTitle:Unlock()
    self.Lock:SetVisibility(ESlateVisibility.Collapsed);
    self.LockBg:SetVisibility(ESlateVisibility.Collapsed);
end

function ACHVTitle:Refresh()
    self.Name:SetText(ACHVManager.Config.TitleNameLabel[ACHVManager.CategoryListUI.selectedTabID + 1][self.index + 1]);
    self.State:SetText(self:GetUnlockStateText())
    
    -- local value = self:GetUnlockState();
    -- if value == 0 then
    --     self:Lock();
    -- elseif value == 1 then
    --     self:Unlock();
    -- end
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