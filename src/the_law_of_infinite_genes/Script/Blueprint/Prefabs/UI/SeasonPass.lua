---@class SeasonPass_C:UUserWidget
---@field background UImage
---@field Button_0 UButton
---@field Button_1 UButton
---@field exit UButton
---@field Image_55 UImage
---@field Image_56 UImage
---@field Image_57 UImage
---@field Image_59 UImage
---@field Image_60 UImage
---@field Image_63 UImage
---@field Image_64 UImage
---@field prospect UImage
---@field ReuseList2 ReuseList2_C
---@field SeasonPassLevelProgress SeasonPassLevelProgress_C
---@field WidgetSwitcher_26 UWidgetSwitcher
--Edit Below--
local SeasonPass = { bInitDoOnce = false } 


function SeasonPass:Construct()
	self:LuaInit();
	
end


-- function SeasonPass:Tick(MyGeometry, InDeltaTime)

-- end

-- function SeasonPass:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
function SeasonPass:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	-- [Editor Generated Lua] BindingProperty Begin:
	-- [Editor Generated Lua] BindingProperty End;
	
	-- [Editor Generated Lua] BindingEvent Begin:
	self.ReuseList2.OnUpdateItem:Add(self.ReuseList2_OnUpdateItem, self);
	-- [Editor Generated Lua] BindingEvent End;
end

function SeasonPass:ReuseList2_OnUpdateItem(Widget, Idx)
	return nil;
end

-- [Editor Generated Lua] function define End;

return SeasonPass