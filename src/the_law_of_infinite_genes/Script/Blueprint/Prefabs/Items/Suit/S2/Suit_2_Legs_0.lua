---@class Suit_2_Legs_0_C:Template_Equipment_Kneepad_C
--Edit Below--
local Suit_2_Legs_0 = {} 

--[[V2背包事件]]--
--[[
--- func 能否更新此物品实例，可重载并自定义(服务端生效)
---@param NewItemCount number 新物品数量
---@param OldItemCount number 旧物品数量
---@return 是否允许物品数量更新，若不允许，物品添加或移除操作可能失败
-- function Suit_2_Legs_0:CanUpdateItemCountV2(NewItemCount, OldItemCount)
--     return Suit_2_Legs_0.SuperClass.CanUpdateItemCountV2(self, NewItemCount, OldItemCount);
-- end

--- func 物品数量更新后回调，可重载并自定义(服务端生效)
---@param NewItemCount number 新物品数量
---@param OldItemCount number 旧物品数量
-- function Suit_2_Legs_0:OnUpdateItemCountV2(NewItemCount, OldItemCount)
--     Suit_2_Legs_0.SuperClass.OnUpdateItemCountV2(self, NewItemCount, OldItemCount);
-- end

--- func 能否使用物品，可重载并自定义(服务端生效)
---@return 物品是否能够被使用
-- function Suit_2_Legs_0:CanUseV2()
--     return Suit_2_Legs_0.SuperClass.CanUseV2(self);
-- end

--- func 当物品被使用回调，可重载并自定义(服务端生效)
-- function Suit_2_Legs_0:OnUseV2()
--     Suit_2_Legs_0.SuperClass.OnUseV2(self);
-- end

--- func 当物品被取消使用，与UseItem对应，用于清理状态，应当支持多次调用，不产生额外副作用，移除物品时自动调用，可重载并自定义(服务端生效)
-- function Suit_2_Legs_0:OnDisuseV2()
--     Suit_2_Legs_0.SuperClass.OnDisuseV2(self);
-- end

--- func 其他物品能否附加到此槽位(服务端生效)
---@param SlotName string 槽位名称
---@param ItemDefineID userdata 物品ID
-- function Suit_2_Legs_0:CanAttachToSlot(SlotName, ItemDefineID)
--     return Suit_2_Legs_0.SuperClass.CanAttachToSlot(self, SlotName, ItemDefineID);
-- end

--- func 当其他物品附加到此槽位(服务端生效)
---@param SlotName string 槽位名称
---@param ItemDefineID userdata 物品ID
-- function Suit_2_Legs_0:OnAttachToSlot(SlotName, ItemDefineID)
--     Suit_2_Legs_0.SuperClass.OnAttachToSlot(self, SlotName, ItemDefineID);
-- end

--- func 当物品从此槽位移除(服务端生效)
---@param SlotName string 槽位名称
---@param ItemDefineID userdata 物品ID
-- function Suit_2_Legs_0:OnDetachBySlot(SlotName, ItemDefineID)
--     Suit_2_Legs_0.SuperClass.OnDetachBySlot(self, SlotName, ItemDefineID);
-- end

--- func 能否Attach到Parent物品上, 如果Parent为空物品, 说明将被Attach到背包装备槽位(服务端生效)
---@param ParentDefineID userdata 父物品ID
---@param SlotName string 槽位名称
---@return bool 能否Attach
-- function Suit_2_Legs_0:CanAttach(ParentDefineID, SlotName)
--     return Suit_2_Legs_0.SuperClass.CanAttach(self, ParentDefineID, SlotName);
-- end

--- func 当Attach到Parent物品上, 如果Parent为空物品, 说明是被Attach到背包装备槽位(服务端生效)
---@param ParentDefineID userdata 父物品ID
---@param SlotName string 槽位名称
-- function Suit_2_Legs_0:OnAttach(ParentDefineID, SlotName)
--     Suit_2_Legs_0.SuperClass.OnAttach(self, ParentDefineID, SlotName);
-- end

--- func 当从Parent物品上解除Attach, 如果Parent为空物品, 说明是从背包装备槽位解除装备(服务端生效)
---@param ParentDefineID userdata 父物品ID
---@param SlotName string 槽位名称
-- function Suit_2_Legs_0:OnDetach(ParentDefineID, SlotName)
--     Suit_2_Legs_0.SuperClass.OnDetach(self, ParentDefineID, SlotName);
-- end

--- func 当物品被装备前，检查能否装备(服务端生效)
---@return bool 能否装备
-- function Suit_2_Legs_0:CanEquip()
--     return Suit_2_Legs_0.SuperClass.CanEquip(self);
-- end

--- func 当物品被装备回调(服务端生效)
-- function Suit_2_Legs_0:OnEquip()
--     Suit_2_Legs_0.SuperClass.OnEquip(self);
-- end

--- func 当物品被卸下回调(服务端生效)
-- function Suit_2_Legs_0:OnUnEquip()
--     Suit_2_Legs_0.SuperClass.OnUnEquip(self);
-- end

--- func 当物品在背包中被交换槽位前，检查能否交换(服务端生效)
---@param OldSlotName string 旧槽位名称
---@param NewSlotName string 新槽位名称
---@return 能否交换到新槽位
-- function Suit_2_Legs_0:CanSwapEquipSlot(OldSlotName, NewSlotName)
--     return Suit_2_Legs_0.SuperClass.CanSwapEquipSlot(self, OldSlotName, NewSlotName);
-- end

--- func 当物品被交换到新装备槽位后回调(服务端生效)
---@param OldSlotName string 旧槽位名称
---@param NewSlotName string 新槽位名称
-- function Suit_2_Legs_0:OnSwapEquipSlot(OldSlotName, NewSlotName)
--     Suit_2_Legs_0.SuperClass.OnSwapEquipSlot(self, OldSlotName, NewSlotName);
-- end

--- func 当物品开始使用时回调，可重载并自定义(服务端生效)
-- function Suit_2_Legs_0:UGC_OnStartUse()
--     Suit_2_Legs_0.SuperClass.UGC_OnStartUse(self)
-- end

--- func 当物品停止使用时回调，可重载并自定义(服务端生效)，在OnUseV2后调用
-- function Suit_2_Legs_0:UGC_OnStopUse(Reason)
    Suit_2_Legs_0.SuperClass.UGC_OnStopUse(self, Reason)
-- end
]]--

return Suit_2_Legs_0