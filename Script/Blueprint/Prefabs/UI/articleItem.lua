---@class articleItem_C:UUserWidget
---@field background UImage
---@field border UImage
---@field Button_0 UButton
---@field goods UImage
---@field quality UImage
---@field TextBlock_0 UTextBlock
--Edit Below--
local articleItem = { 
	bInitDoOnce = false,
	border_color = {R=0, G=0, B=0, A=1},
	goods =  '',
	item_number = 9999,
	quality = 0,
	paternal=nil,
	idx=nil,
	} 


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
	-- self.goods:BindingProperty("Brush", self.quality_Brush, self);
	-- self.quality:BindingProperty("ColorAndOpacity", self.quality_ColorAndOpacity, self);
	-- self.TextBlock_0:BindingProperty("Text", self.TextBlock_0_Text, self);
	-- self.background:BindingProperty("ColorAndOpacity", self.background_ColorAndOpacity, self);
	-- self.border:BindingProperty("ColorAndOpacity", self.border_ColorAndOpacity, self);
	-- -- [Editor Generated Lua] BindingProperty End;
	
	-- [Editor Generated Lua] BindingEvent Begin:
	self.Button_0.OnClicked:Add(self.Button_0_OnClicked, self);
	-- [Editor Generated Lua] BindingEvent End;
end

function articleItem:quality_Brush(ReturnValue)
	return {ResourceObject = self.goods};
end

function articleItem:quality_ColorAndOpacity(ReturnValue)
	return { };
end

function articleItem:TextBlock_0_Text(ReturnValue)
	return tostring(self.item_number);
end

function articleItem:background_ColorAndOpacity(ReturnValue)
	return { };
end

function articleItem:border_ColorAndOpacity(ReturnValue)
	return { };
end

function articleItem:Button_0_OnClicked()
	ugcprint('clicked p is:'..tostring(self.paternal));
	self.paternal.dialog:SetVisibility(ESlateVisibility.Visible);
	return nil;
end


return articleItem