---@class SeasonPassLevelProgress_C:UUserWidget
---@field Image_0 UImage
---@field ProgressBar_0 UProgressBar
---@field TextBlock_1 UTextBlock
---@field TextBlock_2 UTextBlock
--Edit Below--
local SeasonPassLevelProgress = { bInitDoOnce = false } 


function SeasonPassLevelProgress:Construct()
	self:LuaInit();
	
end


-- function SeasonPassLevelProgress:Tick(MyGeometry, InDeltaTime)

-- end

-- function SeasonPassLevelProgress:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
function SeasonPassLevelProgress:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	-- [Editor Generated Lua] BindingProperty Begin:
	self.ProgressBar_0:BindingProperty("Percent", self.ProgressBar_0_Percent, self);
	self.TextBlock_1:BindingProperty("Text", self.TextBlock_1_Text, self);
	self.TextBlock_2:BindingProperty("Text", self.TextBlock_2_Text, self);
	-- [Editor Generated Lua] BindingProperty End;
	
	-- [Editor Generated Lua] BindingEvent Begin:
	-- [Editor Generated Lua] BindingEvent End;
end

function SeasonPassLevelProgress:ProgressBar_0_Percent(ReturnValue)
	return 0;
end

function SeasonPassLevelProgress:TextBlock_1_Text(ReturnValue)
	return "";
end

function SeasonPassLevelProgress:TextBlock_2_Text(ReturnValue)
	return "";
end

-- [Editor Generated Lua] function define End;

return SeasonPassLevelProgress