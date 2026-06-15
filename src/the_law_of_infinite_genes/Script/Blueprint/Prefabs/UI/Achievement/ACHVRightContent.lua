---@class ACHVRightContent_C:UUserWidget
---@field ACHVPreview CHVPreview_C
---@field AttributeBonusesBg_0 UImage
---@field AttributeBonusesBg_1 UImage
---@field Bg UImage
---@field CircularThrobber_0 UCircularThrobber
---@field Exit UButton
---@field Set UButton
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
	self.Exit.OnClicked:Add(self.ExitOnClicked, self);

end

-- function ACHVRightContent:Tick(MyGeometry, InDeltaTime)

-- end

-- function ACHVRightContent:Destruct()

-- end

function ACHVRightContent:ExitOnClicked()
    ACHVManager:CloseMainUI();
end

return ACHVRightContent