---@class articleItem_C:UUserWidget
---@field background UImage
---@field border UImage
---@field goods UImage
---@field quality UImage
---@field TextBlock_0 UTextBlock
--Edit Below--
local articleItem = { bInitDoOnce = false } 


function articleItem:Construct()
	self:LuaInit();
	
end


-- function articleItem:Tick(MyGeometry, InDeltaTime)

-- end

-- function articleItem:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
function articleItem:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	-- [Editor Generated Lua] BindingProperty Begin:
	self.goods:BindingProperty("Brush", self.quality_Brush, self);
	self.quality:BindingProperty("ColorAndOpacity", self.quality_ColorAndOpacity, self);
	self.TextBlock_0:BindingProperty("Text", self.TextBlock_0_Text, self);
	self.background:BindingProperty("ColorAndOpacity", self.background_ColorAndOpacity, self);
	self.border:BindingProperty("ColorAndOpacity", self.border_ColorAndOpacity, self);
	-- [Editor Generated Lua] BindingProperty End;
	
	-- [Editor Generated Lua] BindingEvent Begin:
	-- [Editor Generated Lua] BindingEvent End;
end

function articleItem:quality_Brush(ReturnValue)
	return { };
end

function articleItem:quality_ColorAndOpacity(ReturnValue)
	return { };
end

function articleItem:TextBlock_0_Text(ReturnValue)
	return "";
end

function articleItem:background_ColorAndOpacity(ReturnValue)
	return { };
end

function articleItem:border_ColorAndOpacity(ReturnValue)
	return { };
end

-- [Editor Generated Lua] function define End;

return articleItem