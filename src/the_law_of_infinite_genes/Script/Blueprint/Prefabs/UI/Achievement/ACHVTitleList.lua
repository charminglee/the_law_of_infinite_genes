---@class ACHVTitleList_C:UUserWidget
---@field ReuseList2 ReuseList2_C
--Edit Below--
local ACHVTitleList = { bInitDoOnce = false } 

function ACHVTitleList:Construct()
    self:LuaInit();
end

function ACHVTitleList:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
    self.ReuseList2.OnUpdateItem:Add(self.ReuseList2Update, self);
	self.ReuseList2:Reload(6);
end

-- function ACHVTitleList:Tick(MyGeometry, InDeltaTime)

-- end

-- function ACHVTitleList:Destruct()

-- end

function ACHVTitleList:ReuseList2Update(Item, Index)
	if Item.Parent == nil then
		Item.Parent = self;
		Item.Index = Index;
	end
	Item:Refresh();
end

return ACHVTitleList