---@class hy_suit_bottom_C:Template_Equipment_Kneepad_C
--Edit Below--
local hy_suit_bottom = {} 

--[[V2背包事件]]--
--[[
--- func 能否更新此物品实例，可重载并自定义(服务端生效)
---@param NewItemCount number 新物品数量
---@param OldItemCount number 旧物品数量
---@return 是否允许物品数量更新，若不允许，物品添加或移除操作可能失败
-- function hy_suit_bottom:CanUpdateItemCountV2(NewItemCount, OldItemCount)
--     return hy_suit_bottom.SuperClass.CanUpdateItemCountV2(self, NewItemCount, OldItemCount);
-- end

--- func 物品数量更新后回调，可重载并自定义(服务端生效)
---@param NewItemCount number 新物品数量
---@param OldItemCount number 旧物品数量
-- function hy_suit_bottom:OnUpdateItemCountV2(NewItemCount, OldItemCount)
--     hy_suit_bottom.SuperClass.OnUpdateItemCountV2(self, NewItemCount, OldItemCount);
-- end

--- func 能否使用物品，可重载并自定义(服务端生效)
---@return 物品是否能够被使用
-- function hy_suit_bottom:CanUseV2()
--     return hy_suit_bottom.SuperClass.CanUseV2(self);
-- end

--- func 当物品被使用回调，可重载并自定义(服务端生效)
-- function hy_suit_bottom:OnUseV2()
--     hy_suit_bottom.SuperClass.OnUseV2(self);
-- end

--- func 当物品被取消使用，与UseItem对应，用于清理状态，应当支持多次调用，不产生额外副作用，移除物品时自动调用，可重载并自定义(服务端生效)
-- function hy_suit_bottom:OnDisuseV2()
--     hy_suit_bottom.SuperClass.OnDisuseV2(self);
-- end

--- func 其他物品能否附加到此槽位(服务端生效)
---@param SlotName string 槽位名称
---@param ItemDefineID userdata 物品ID
-- function hy_suit_bottom:CanAttachToSlot(SlotName, ItemDefineID)
--     return hy_suit_bottom.SuperClass.CanAttachToSlot(self, SlotName, ItemDefineID);
-- end

--- func 当其他物品附加到此槽位(服务端生效)
---@param SlotName string 槽位名称
---@param ItemDefineID userdata 物品ID
-- function hy_suit_bottom:OnAttachToSlot(SlotName, ItemDefineID)
--     hy_suit_bottom.SuperClass.OnAttachToSlot(self, SlotName, ItemDefineID);
-- end

--- func 当物品从此槽位移除(服务端生效)
---@param SlotName string 槽位名称
---@param ItemDefineID userdata 物品ID
-- function hy_suit_bottom:OnDetachBySlot(SlotName, ItemDefineID)
--     hy_suit_bottom.SuperClass.OnDetachBySlot(self, SlotName, ItemDefineID);
-- end

--- func 能否Attach到Parent物品上, 如果Parent为空物品, 说明将被Attach到背包装备槽位(服务端生效)
---@param ParentDefineID userdata 父物品ID
---@param SlotName string 槽位名称
---@return bool 能否Attach
-- function hy_suit_bottom:CanAttach(ParentDefineID, SlotName)
--     return hy_suit_bottom.SuperClass.CanAttach(self, ParentDefineID, SlotName);
-- end

--- func 当Attach到Parent物品上, 如果Parent为空物品, 说明是被Attach到背包装备槽位(服务端生效)
---@param ParentDefineID userdata 父物品ID
---@param SlotName string 槽位名称
-- function hy_suit_bottom:OnAttach(ParentDefineID, SlotName)
--     hy_suit_bottom.SuperClass.OnAttach(self, ParentDefineID, SlotName);
-- end

--- func 当从Parent物品上解除Attach, 如果Parent为空物品, 说明是从背包装备槽位解除装备(服务端生效)
---@param ParentDefineID userdata 父物品ID
---@param SlotName string 槽位名称
-- function hy_suit_bottom:OnDetach(ParentDefineID, SlotName)
--     hy_suit_bottom.SuperClass.OnDetach(self, ParentDefineID, SlotName);
-- end

--- func 当物品被装备前，检查能否装备(服务端生效)
---@return bool 能否装备
-- function hy_suit_bottom:CanEquip()
--     return hy_suit_bottom.SuperClass.CanEquip(self);
-- end

--- func 当物品被装备回调(服务端生效)
-- function hy_suit_bottom:OnEquip()
--     hy_suit_bottom.SuperClass.OnEquip(self);
-- end

--- func 当物品被卸下回调(服务端生效)
-- function hy_suit_bottom:OnUnEquip()
--     hy_suit_bottom.SuperClass.OnUnEquip(self);
-- end

--- func 当物品在背包中被交换槽位前，检查能否交换(服务端生效)
---@param OldSlotName string 旧槽位名称
---@param NewSlotName string 新槽位名称
---@return 能否交换到新槽位
-- function hy_suit_bottom:CanSwapEquipSlot(OldSlotName, NewSlotName)
--     return hy_suit_bottom.SuperClass.CanSwapEquipSlot(self, OldSlotName, NewSlotName);
-- end

--- func 当物品被交换到新装备槽位后回调(服务端生效)
---@param OldSlotName string 旧槽位名称
---@param NewSlotName string 新槽位名称
-- function hy_suit_bottom:OnSwapEquipSlot(OldSlotName, NewSlotName)
--     hy_suit_bottom.SuperClass.OnSwapEquipSlot(self, OldSlotName, NewSlotName);
-- end

--- func 当物品开始使用时回调，可重载并自定义(服务端生效)
-- function hy_suit_bottom:UGC_OnStartUse()
--     hy_suit_bottom.SuperClass.UGC_OnStartUse(self)
-- end

--- func 当物品停止使用时回调，可重载并自定义(服务端生效)，在OnUseV2后调用
-- function hy_suit_bottom:UGC_OnStopUse(Reason)
    hy_suit_bottom.SuperClass.UGC_OnStopUse(self, Reason)
-- end
]]--

return hy_suit_bottom