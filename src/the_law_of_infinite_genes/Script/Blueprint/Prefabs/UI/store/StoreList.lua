---@class StoreList_C:UUserWidget
---@field ReuseList2 ReuseList2_C
--Edit Below--
local StoreList = { 
	bInitDoOnce = false,
	DataList = {},
	selectedIndex = 0,
	} 



function StoreList:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
    self:Listen();
end

function StoreList:Listen()
	self.ReuseList2.OnUpdateItem:Add(self.ReuseList2_OnUpdateItem, self);
end

function StoreList:ReloadList(DataList)
	self.DataList = DataList;
	self.ReuseList2:Reload(#self.DataList);
end

function StoreList:ReuseList2_OnUpdateItem(Item, Idx)
	if Idx == self.selectedIndex then
		Item:SetSelectedVisiblity(ESlateVisibility.Visible)
	else
		Item:SetSelectedVisiblity(ESlateVisibility.Collapse)
	end
	return nil;
end


-- [Editor Generated Lua] function define End;

return StoreList