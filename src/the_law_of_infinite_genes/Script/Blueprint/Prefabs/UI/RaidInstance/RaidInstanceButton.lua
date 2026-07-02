---@class RaidInstanceButton_C:TopTips001_C
---@field Button_0 UButton
---@field Image_3 UImage
---@field Image_4 UImage
---@field inner UImage
---@field TextBlock_0 UTextBlock
--Edit Below--
local RaidInstanceButton = { bInitDoOnce = false } 


function RaidInstanceButton:Construct()
	self:LuaInit();
	
end


-- function RaidInstanceButton:Tick(MyGeometry, InDeltaTime)

-- end

-- function RaidInstanceButton:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
function RaidInstanceButton:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	-- [Editor Generated Lua] BindingProperty Begin:
	-- [Editor Generated Lua] BindingProperty End;
	
	-- [Editor Generated Lua] BindingEvent Begin:
	-- [Editor Generated Lua] BindingEvent End;
end

function RaidInstanceButton:TextBlock_0_Text(ReturnValue)
	return "";
end

-- [Editor Generated Lua] function define End;

return RaidInstanceButton