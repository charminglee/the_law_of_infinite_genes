---@class ACHVRightContent_C:UUserWidget
---@field ACHVPreview CHVPreview_C
---@field AttributeBonusesBg_0 UImage
---@field AttributeBonusesBg_1 UImage
---@field Bg UImage
---@field CircularThrobber_0 UCircularThrobber
---@field Exit UButton
---@field Info_1 UTextBlock
---@field Info_2 UTextBlock
---@field ReuseList2 ReuseList2_C
---@field Set UButton
---@field SetBtnText UTextBlock
---@field UnlockConditions UImage
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
	self.ReuseList2.OnUpdateItem:Add(self.ReuseList2Update, self);
end

function ACHVRightContent:Refresh()
	self.Info_1:SetText(ACHVManager:SelectedTitleData().CollectEffects);
	self.Info_2:SetText(ACHVManager:SelectedTitleData().WearEffects);
	self.SetBtnText:SetText(ACHVManager.Config.SetStateText[ACHVManager:SelectedTitleData().UnlockState]);
	self:Reload();
end
function ACHVRightContent:SetOnClicked()
	ACHVManager:SelectedTitleObj():ToggleState();
	self:Refresh();
end

function ACHVRightContent:ExitOnClicked()
    ACHVManager:CloseMainUI();
end

function ACHVRightContent:Reload()
	self.ReuseList2:Reload(#ACHVManager:SelectedTitleData().UnlockType + 1);
end

function ACHVRightContent:ReuseList2Update(item, index)
	if item.parent == nil then
		item.parent = self;
	end
	item.index = index;
	item:Refresh();
end

return ACHVRightContent