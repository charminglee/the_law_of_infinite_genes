---@class equipItem_C:UUserWidget
---@field background UImage
---@field border UImage
---@field goods UImage
---@field quality UImage
--Edit Below--
local equipItem = { bInitDoOnce = false } 


function equipItem:Construct()
	self:LuaInit();
	
end


-- function equipItem:Tick(MyGeometry, InDeltaTime)

-- end

-- function equipItem:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
function equipItem:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	-- [Editor Generated Lua] BindingProperty Begin:
	self.border:BindingProperty("ColorAndOpacity", self.border_ColorAndOpacity, self);
	self.quality:BindingProperty("ColorAndOpacity", self.tips_ColorAndOpacity, self);
	-- [Editor Generated Lua] BindingProperty End;
	
	-- [Editor Generated Lua] BindingEvent Begin:
	-- [Editor Generated Lua] BindingEvent End;
end

function equipItem:border_ColorAndOpacity(ReturnValue)
	return { };
end

function equipItem:background_ColorAndOpacity(ReturnValue)
	return { };
end

function equipItem:tips_ColorAndOpacity(ReturnValue)
	return { };
end

-- [Editor Generated Lua] function define End;

return equipItem