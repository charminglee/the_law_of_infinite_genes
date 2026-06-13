---@class ACHVCategoryList_C:UUserWidget
---@field ReuseList2 ReuseList2_C
--Edit Below--
local ACHVCategoryList = { bInitDoOnce = false } 

function ACHVCategoryList:Construct()
	self:LuaInit();
end

function ACHVCategoryList:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	self.ReuseList2.OnUpdateItem:Add(self.ReuseList2Update, self);
	self.ReuseList2:Reload(6);
end

-- function ACHVCategoryList:Tick(MyGeometry, InDeltaTime)

-- end

-- function ACHVCategoryList:Destruct()

-- end

function ACHVCategoryList:ReuseList2Update(Item, Index)
	-- if Item.Parent == nil then
	-- 	Item.Parent = self;
	-- 	Item.Index = Index;
	-- end
	-- Item:Refresh();
end

return ACHVCategoryList