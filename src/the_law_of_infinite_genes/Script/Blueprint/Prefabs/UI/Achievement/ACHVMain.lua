---@class ACHVMain_C:UUserWidget
---@field ACHVLeftContent CHVLeftContent_C
---@field ACHVRightContent CHVRightContent_C
--Edit Below--
local ACHVMain = { bInitDoOnce = false } 

function ACHVMain:Construct()
	self:LuaInit();
end

function ACHVMain:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
    ACHVManager:RegisterMainUI(self);

end

-- function ACHVMain:Tick(MyGeometry, InDeltaTime)

-- end

-- function ACHVMain:Destruct()

-- end

return ACHVMain