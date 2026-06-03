---@class StoreList_C:UUserWidget
---@field ReuseList2 ReuseList2_C
--Edit Below--
local StoreList = { 
	bInitDoOnce = false,
	DataList = {},
	selectedIndex = 0,
	maxListLength=100,
	parent = nil,
	} 



function StoreList:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
    -- self:Listen();
	ugcprint('Store List 加载');
end

function StoreList:Listen()
	self.ReuseList2.OnUpdateItem:Add(self.ReuseList2_OnUpdateItem, self);
end

function StoreList:ReloadList(DataList)
	self.DataList = DataList;
	self.ReuseList2:Reload(self.maxListLength);
end

function StoreList:GetItemDataById(ItemId)
	return {quality=0, number=1, sticker=0}
end

function StoreList:ReuseList2_OnUpdateItem(Item, Idx)
	if Item.parent == nil then
		Item.parent = self;
		Item.index = Idx;
	end
	if Idx == self.selectedIndex then
		Item:SetSelectedVisiblity(ESlateVisibility.Visible)
	else
		Item:SetSelectedVisiblity(ESlateVisibility.Collapsed)
	end
	return nil;
end

function StoreList:SetItemData(Item, Idx)
	if Idx + 1 > #self.DataList then
		Item:SetDefaultData();
	else
		local item_data = self.GetItemDataById(self.DataList[Idx+1].ItemId);
		local quality = item_data.quality;
		local number = item_data.number;
		local sticker = item_data.sticker;
		Item:SetItemData(quality, number, sticker);
	end
end

function StoreList:RefreshSelect(index)
	self.selectedIndex = index;
	self.ReuseList2:Reload(self.maxListLength);
end

return StoreList