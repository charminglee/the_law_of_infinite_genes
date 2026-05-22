---@class store_C:UUserWidget
---@field BlockyLoopScrollGrid_0 UBlockyLoopScrollGrid
--Edit Below--
local store = { bInitDoOnce = false } 


function store:Construct()
	self:LuaInit();
	
end


-- function store:Tick(MyGeometry, InDeltaTime)

-- end

-- function store:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
function store:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	-- [Editor Generated Lua] BindingProperty Begin:
	-- [Editor Generated Lua] BindingProperty End;
	
	-- [Editor Generated Lua] BindingEvent Begin:
	self.BlockyLuaLoopScrollGrid_0.OnRefreshItem:Add(self.BlockyLuaLoopScrollGrid_0_OnRefreshItem, self);
	self.BlockyLuaLoopScrollGrid_0.OnChangeData:Add(self.BlockyLuaLoopScrollGrid_0_OnChangeData, self);
	-- [Editor Generated Lua] BindingEvent End;
end

function store:BlockyLuaLoopScrollGrid_0_OnRefreshItem(Item, Index)
	return nil;
end

function store:BlockyLuaLoopScrollGrid_0_OnChangeData(Item, Index, Key)
	return nil;
end

-- [Editor Generated Lua] function define End;

return store