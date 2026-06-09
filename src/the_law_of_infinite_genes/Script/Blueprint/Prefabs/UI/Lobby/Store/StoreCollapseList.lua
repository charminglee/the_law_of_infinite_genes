---@class StoreCollapseList_C:UUserWidget
---@field ReuseList2 ReuseList2_C
--Edit Below--
local StoreCollapseList = { bInitDoOnce = false } 

function StoreCollapseList:Construct()
    self:LuaInit();
    
end

function StoreCollapseList:LuaInit()
	if self.bInitDoOnce then
		return;
    end
    self.ReuseList2:Reload(100);
end

return StoreCollapseList