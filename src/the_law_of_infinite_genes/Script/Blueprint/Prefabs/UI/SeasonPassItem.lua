---@class SeasonPassItem_C:UUserWidget
---@field Button_0 UButton
---@field Button_24 UButton
---@field freeitem UImage
---@field Image_0 UImage
---@field Image_2 UImage
---@field Image_9 UImage
---@field Image_39 UImage
---@field Image_66 UImage
---@field Image_67 UImage
---@field Image_124 UImage
---@field Image_125 UImage
---@field Image_127 UImage
---@field Image_128 UImage
---@field levelText UTextBlock
--Edit Below--
local SeasonPassItem = { bInitDoOnce = false } 


function SeasonPassItem:Construct()
	self:LuaInit();
	
end


-- function SeasonPassItem:Tick(MyGeometry, InDeltaTime)

-- end

-- function SeasonPassItem:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
function SeasonPassItem:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	-- [Editor Generated Lua] BindingProperty Begin:
	self.left:BindingProperty("ColorAndOpacity", self.left_ColorAndOpacity, self);
	self.Image_5:BindingProperty("ColorAndOpacity", self.left_ColorAndOpacity, self);
	self.Image_7:BindingProperty("ColorAndOpacity", self.left_ColorAndOpacity, self);
	self.Image_8:BindingProperty("ColorAndOpacity", self.left_ColorAndOpacity, self);
	self.Image_6:BindingProperty("ColorAndOpacity", self.left_ColorAndOpacity, self);
	self.Image_39:BindingProperty("Brush", self.Image_39_Brush, self);
	self.freeitem:BindingProperty("Brush", self.freeitem_Brush, self);
	self.Image_0:BindingProperty("ColorAndOpacity", self.Image_0_ColorAndOpacity, self);
	self.levelText:BindingProperty("Text", self.levelText_Text, self);
	-- [Editor Generated Lua] BindingProperty End;
	
	-- [Editor Generated Lua] BindingEvent Begin:
	-- [Editor Generated Lua] BindingEvent End;
end

function SeasonPassItem:left_ColorAndOpacity(ReturnValue)
	return { };
end

function SeasonPassItem:Image_39_Brush(ReturnValue)
	return { };
end

function SeasonPassItem:freeitem_Brush(ReturnValue)
	return { };
end

function SeasonPassItem:Image_0_ColorAndOpacity(ReturnValue)
	return { };
end

function SeasonPassItem:levelText_Text(ReturnValue)
	return "";
end

-- [Editor Generated Lua] function define End;

return SeasonPassItem