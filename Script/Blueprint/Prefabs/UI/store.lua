---@class store_C:UUserWidget
---@field bg_01 UImage
---@field bg_02 UImage
---@field equipmentSlot equipmentSlot_C
---@field ReuseList2 ReuseList2_C
---@field ReuseList2_0 ReuseList2_C
---@field storeTab storeTab_C
---@field storeTopBar storeTopBar_C
---@field WidgetSwitcher_0 UWidgetSwitcher
--Edit Below--
local store = { bInitDoOnce = false, LobbyUIControl=nil} 


function store:Construct()
	self:LuaInit();
end


-- function store:Tick(MyGeometry, InDeltaTime)

-- end

-- function store:Destruct()

-- end

function store:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	self.storeTopBar.paternal = self
	self.BlockyLuaLoopScrollGrid_0.OnRefreshItem:Add(self.BlockyLuaLoopScrollGrid_0_OnRefreshItem, self);
	self.BlockyLuaLoopScrollGrid_0.OnChangeData:Add(self.BlockyLuaLoopScrollGrid_0_OnChangeData, self);
end

function store:BlockyLuaLoopScrollGrid_0_OnRefreshItem(Item, Index)
	return nil;
end

function store:BlockyLuaLoopScrollGrid_0_OnChangeData(Item, Index, Key)
	return nil;
end

-- [Editor Generated Lua] function define End;

return store