---@class StoreItem_C:UUserWidget
---@field Button_0 UButton
---@field number_label UTextBlock
---@field quality UImage
---@field selected UImage
---@field sticker UImage
--Edit Below--
local StoreItem = { 
	bInitDoOnce = false,
	index = nil,
	storeList = nil,
	parent = nil,
	quality = 0,
	number = 0,
	sticker = 0,
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
	if self.number == 0 then
		return '';
	end
	return tostring(self.number);
end

function StoreItem:sticker_Brush(ReturnValue)
	return {};
end

function StoreItem:Button_0_clicked()
	self.parent:RefreshSelect(self.index);
	return nil
end

function StoreItem:SetSelectedVisiblity(Visible)
	self.selected:SetVisiblity(Visible)
	self.Button_0:SetVisiblity(ESlateVisibility.Visiblity)	
end

function StoreItem:SetDefaultData()
	self.quality = 0;
	self.number = 0;
	self.sticker = 0;
end

function StoreItem:SetItemData(quality, number, sticker)
	self.quality = quality;
	self.number = number;
	self.sticker = sticker;
end

return StoreItem