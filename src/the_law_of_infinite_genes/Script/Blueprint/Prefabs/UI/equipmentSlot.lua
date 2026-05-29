---@class equipmentSlot_C:UUserWidget
---@field ReuseList2 ReuseList2_C
--Edit Below--
local equipmentSlot = { bInitDoOnce = false} 

function equipmentSlot:Construct()
	self:LuaInit();
end

function equipmentSlot:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
    self:ListenEvent();
    self:InitUI();
end

function equipmentSlot:ListenEvent()
    self.ReuseList2.OnUpdateItem:Add(self.UpdateEquipmentItem, self)
end
function equipmentSlot:InitUI()
    self.ReuseList2:Reload(5);
end

function equipmentSlot:UpdateEquipmentItem(item, index)
end

return equipmentSlot