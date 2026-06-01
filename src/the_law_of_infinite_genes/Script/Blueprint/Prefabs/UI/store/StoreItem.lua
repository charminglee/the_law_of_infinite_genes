---@class StoreItem_C:UUserWidget
---@field Button_0 UButton
---@field number_label UTextBlock
---@field quality UImage
---@field selected UImage
---@field sticker UImage
--Edit Below--
local StoreItem = { 
	bInitDoOnce = false,
	quality = 0,
	number = 0,
	sticker = 0,
	index = nil,
	storeList = nil,
	parent = nil,
} 


function StoreItem:Construct()
	self:LuaInit();
	
end

function StoreItem:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	self.quality:BindingProperty("Brush", self.quality_Brush, self);
	self.number_label:BindingProperty("Text", self.number_label_Text, self);
	self.sticker:BindingProperty("Brush", self.sticker_Brush, self);
	self.Button_0.OnClicked:Add(self.Button_0_clicked, self);
end


function StoreItem:quality_Brush(ReturnValue)
	return {};
end

function StoreItem:number_label_Text(ReturnValue)
	return tostring(self.number);
end

function StoreItem:sticker_Brush(ReturnValue)
	return { };
end

function StoreItem:Button_0_clicked()
	return nil
end

function StoreItem:GetOwnerParent()
	return self:GetOwner();
end

function StoreItem:SetSelectedVisiblity(Visible)
	self.selected:SetVisiblity(Visible)	
end

-- [Editor Generated Lua] function define End;

return StoreItem