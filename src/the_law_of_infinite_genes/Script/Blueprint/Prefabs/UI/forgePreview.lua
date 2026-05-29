---@class forgePreview_C:UUserWidget
---@field bg UImage
---@field border UImage
---@field Button_0 UButton
---@field Image_4 UImage
---@field Image_5 UImage
---@field quality UImage
---@field ReuseList2 ReuseList2_C
---@field TextBlock_3 UTextBlock
---@field TextBlock_5 UTextBlock
--Edit Below--
local forgePreview = { bInitDoOnce = false } 


function forgePreview:Construct()
	self:LuaInit();
	
end


-- function forgePreview:Tick(MyGeometry, InDeltaTime)

-- end

-- function forgePreview:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
function forgePreview:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	-- [Editor Generated Lua] BindingProperty Begin:
	self.quality:BindingProperty("ColorAndOpacity", self.quality_ColorAndOpacity, self);
	self.TextBlock_1:BindingProperty("Text", self.TextBlock_1_Text, self);
	-- [Editor Generated Lua] BindingProperty End;
	
	-- [Editor Generated Lua] BindingEvent Begin:
	-- [Editor Generated Lua] BindingEvent End;
end

function forgePreview:quality_ColorAndOpacity(ReturnValue)
	return { };
end

function forgePreview:TextBlock_1_Text(ReturnValue)
	return "";
end

-- [Editor Generated Lua] function define End;

return forgePreview