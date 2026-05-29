---@class userItem_C:UUserWidget
---@field Image_0 UImage
---@field Image_87 UImage
---@field TextBlock_0 UTextBlock
---@field TextBlock_1 UTextBlock
---@field TextBlock_2 UTextBlock
---@field WeakRefImage_1 UWeakRefImage
--Edit Below--
local userItem = { bInitDoOnce = false } 


function userItem:Construct()
	self:LuaInit();
	
end


-- function userItem:Tick(MyGeometry, InDeltaTime)

-- end

-- function userItem:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
function userItem:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	-- [Editor Generated Lua] BindingProperty Begin:
	self.TextBlock_0:BindingProperty("Text", self.TextBlock_0_Text, self);
	-- [Editor Generated Lua] BindingProperty End;
	
	-- [Editor Generated Lua] BindingEvent Begin:
	-- [Editor Generated Lua] BindingEvent End;
end

function userItem:TextBlock_0_Text(ReturnValue)
	return "";
end

-- [Editor Generated Lua] function define End;

return userItem