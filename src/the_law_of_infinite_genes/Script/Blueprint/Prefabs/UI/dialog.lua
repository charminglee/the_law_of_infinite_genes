---@class dialog_C:UUserWidget
---@field background_bottom UImage
---@field background_center UImage
---@field background_left UImage
---@field background_right UImage
---@field background_top UImage
---@field border UImage
---@field exit UButton
---@field WidgetSwitcher_66 UWidgetSwitcher
--Edit Below--
local dialog = { bInitDoOnce = false } 


function dialog:Construct()
	self:LuaInit();
	
end

function dialog:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	-- [Editor Generated Lua] BindingProperty Begin:
	-- [Editor Generated Lua] BindingProperty End;
	
	-- [Editor Generated Lua] BindingEvent Begin:
	self.exit.OnClicked:Add(self.exit_OnClicked, self);
	-- [Editor Generated Lua] BindingEvent End;
end

function dialog:exit_OnClicked()
	self:SetVisibility(ESlateVisibility.Collapsed);
	return nil;
end

-- [Editor Generated Lua] function define End;

return dialog