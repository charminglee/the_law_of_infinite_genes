---@class ACHVRightContent_C:UUserWidget
---@field ACHVPreview CHVPreview_C
---@field Exit UButton
---@field Info_0 UTextBlock
---@field Info_1 UTextBlock
---@field Info_2 UTextBlock
---@field Set UButton
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
	self.Exit.OnClicked:Add(self.ExitOnClicked, self);
end

function ACHVRightContent:Refresh()
	self.Info_0:SetText(ACHVManager.Config.UnlockConditions[ACHVManager.CategoryListUI.selectedTabID + 1][ACHVManager.TitleListUI.selectedTabID + 1])
	self.Info_1:SetText(ACHVManager.Config.CollectEffects[ACHVManager.CategoryListUI.selectedTabID + 1][ACHVManager.TitleListUI.selectedTabID + 1])
	self.Info_2:SetText(ACHVManager.Config.WearEffects[ACHVManager.CategoryListUI.selectedTabID + 1][ACHVManager.TitleListUI.selectedTabID + 1])
end

function ACHVRightContent:ExitOnClicked()
    ACHVManager:CloseMainUI();
end

return ACHVRightContent