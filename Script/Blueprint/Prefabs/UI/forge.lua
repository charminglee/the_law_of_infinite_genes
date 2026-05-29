---@class forge_C:UUserWidget
---@field Button_0 UButton
---@field Button_1 UButton
---@field forgePreview forgePreview_C
---@field Image_0 UImage
---@field Image_1 UImage
---@field Image_2 UImage
---@field Image_3 UImage
---@field Image_4 UImage
---@field Image_5 UImage
---@field ReuseList2 ReuseList2_C
---@field WidgetSwitcher_0 UWidgetSwitcher
--Edit Below--
local forge = { bInitDoOnce = false } 

function forge:Construct()
	self:LuaInit();
end

function forge:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
    self.Button_0.OnClicked:Add(self.Button_0_Click, self);
    self.Button_1.OnClicked:Add(self.Button_1_Click, self);
    self.Image_2:SetVisibility(ESlateVisibility.Visible)
    self.Image_3:SetVisibility(ESlateVisibility.Visible)
    self.Image_4:SetVisibility(ESlateVisibility.Collapsed)
    self.Image_5:SetVisibility(ESlateVisibility.Collapsed)
end

function forge:Button_0_Click()
    self.Image_2:SetVisibility(ESlateVisibility.Visible)
    self.Image_3:SetVisibility(ESlateVisibility.Visible)
    self.Image_4:SetVisibility(ESlateVisibility.Collapsed)
    self.Image_5:SetVisibility(ESlateVisibility.Collapsed)
end

function forge:Button_1_Click()
    self.Image_2:SetVisibility(ESlateVisibility.Collapsed)
    self.Image_3:SetVisibility(ESlateVisibility.Collapsed)
    self.Image_4:SetVisibility(ESlateVisibility.Visible)
    self.Image_5:SetVisibility(ESlateVisibility.Visible)
end
return forge