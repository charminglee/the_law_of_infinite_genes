---@class storeTab_C:UUserWidget
---@field Image_46 UImage
---@field ReuseList2 ReuseList2_C
--Edit Below--
local storeTab = {
    bInitDoOnce = false, 
    selectedIndex = 0,
    tabLabel = {'装备','消耗品','材料','活动','其他'}     
} 


function storeTab:Construct()
	self:LuaInit();
    self.InitBindEvent();
	self.InitUI();
end

function storeTab:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
end

function storeTab:InitBindEvent()
    self.ReuseList2.OnUpdateItem:Add(self.ReuseList2_OnUpdateItem, self);
end

function storeTab:InitUI()
	self.selectedIdx = 0;
	self.ReuseList2:Reload(#self.tabLabel);
end

function storeTab:ReuseList2_OnUpdateItem(Widget, Idx)
    
	return nil;
end

-- [Editor Generated Lua] function define End;

return storeTab