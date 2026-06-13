---@class ACHVCategoryBtn_C:UUserWidget
---@field AnimImg UImage
---@field Btn UButton
---@field PressedImg UImage
--Edit Below--
local ACHVCategoryBtn = { bInitDoOnce = false } 


function ACHVCategoryBtn:Construct()
	self:LuaInit();
	
end


-- function ACHVCategoryBtn:Tick(MyGeometry, InDeltaTime)

-- end

-- function ACHVCategoryBtn:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
function ACHVCategoryBtn:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	-- [Editor Generated Lua] BindingProperty Begin:
	-- [Editor Generated Lua] BindingProperty End;
	
	-- [Editor Generated Lua] BindingEvent Begin:
	-- [Editor Generated Lua] BindingEvent End;
end

-- [Editor Generated Lua] function define End;

return ACHVCategoryBtn