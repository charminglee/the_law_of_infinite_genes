---@class ACHVRightContent_C:UUserWidget
---@field ACHVPreview CHVPreview_C
---@field Bg UImage
---@field Exit UButton
---@field Info_0 UTextBlock
---@field Info_1 UTextBlock
---@field Info_2 UTextBlock
---@field Set UButton
---@field SetBtnText UTextBlock
---@field UnlockConditions UImage
---@field UnlockProgressBar UProgressBar
--Edit Below--
local ACHVRightContent = { bInitDoOnce = false } 

function ACHVRightContent:Construct()
	self:LuaInit();
end

function ACHVRightContent:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	ACHVManager.RightContent = self;
	self.Set.OnClicked:Add(self.SetOnClicked, self);
	self.Exit.OnClicked:Add(self.ExitOnClicked, self);
end

function ACHVRightContent:Refresh()
	self.Info_0:SetText(ACHVManager.MainUI:SelectedTitleData().UnlockConditions)
	self.Info_1:SetText(ACHVManager.MainUI:SelectedTitleData().CollectEffects)
	self.Info_2:SetText(ACHVManager.MainUI:SelectedTitleData().WearEffects)
	self.SetBtnText:SetText(ACHVManager.Config.SetStateText[ACHVManager.MainUI:SelectedTitleData().UnlockState])
end
function ACHVRightContent:SetOnClicked()
	ACHVManager.MainUI:SelectedTitleObj():ToggleState();
	self:Refresh();
end

function ACHVRightContent:ExitOnClicked()
    ACHVManager:CloseMainUI();
end

return ACHVRightContent