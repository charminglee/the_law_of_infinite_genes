---@class Title_C:ObjectPositionWidget
---@field Icon UImage
---@field Name UTextBlock
--Edit Below--
local Title = { 
	bInitDoOnce = false,
} 


function Title:Construct()
	self:LuaInit();
	
end

-- function Title:Tick(MyGeometry, InDeltaTime)

-- end

-- function Title:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
function Title:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	self.Name:BindingProperty("Text", self.NameText, self);
end

function Title:NameText(ReturnValue)
	return "囊中羞涩";
end

-- [Editor Generated Lua] function define End;

return Title