---@class ACHVMain_C:UUserWidget
---@field Bg UImage
---@field BgInner UImage
---@field Exit UButton
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
	self.Exit.OnClicked:Add(self.ExitOnClicked, self);

end

-- function ACHVMain:Tick(MyGeometry, InDeltaTime)

-- end

-- function ACHVMain:Destruct()

-- end

function ACHVMain:ExitOnClicked()
    ACHVManager:CloseMainUI();
end

return ACHVMain