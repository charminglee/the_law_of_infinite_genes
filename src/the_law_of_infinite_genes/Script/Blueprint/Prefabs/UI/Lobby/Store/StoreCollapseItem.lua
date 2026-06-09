---@class StoreCollapseItem_C:UUserWidget
---@field Button_1 UButton
---@field Image_0 UImage
---@field Image_1 UImage
---@field selected UImage
--Edit Below--
local StoreCollapseItem = { bInitDoOnce = false } 

function StoreCollapseItem:Construct()
    self:LuaInit();
    
end

function StoreCollapseItem:LuaInit()
	if self.bInitDoOnce then
		return;
    end
    self:Listen();
end

function StoreCollapseItem:Listen()
    self.ReuseList2.OnUpdateItem:Add(self.ReuseList2Updadte, self);
end

function StoreCollapseItem:ReuseList2Updadte(Item, Index)

end

return StoreCollapseItem