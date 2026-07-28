---@meta


---@alias Card [number, number]


---@alias InvItem {itemId: ItemId, count: number, userData: table<string, any>?}
---@alias AttrEntry {property: Attribute, value: number}
---@alias InvItemEquipment {
---    itemId: ItemId, 
---    count: number, 
---    userData: {
---        strengthenLevel: number, 
---        refineAttributeSlot: ntable<AttrEntry>,
---        quality: number,
---    }
---}


---@alias GeneNode {level: number, isUnlocked: boolean, nodeId: number}
---@alias GeneNodeDetail {
---    Id: number,
---    BranchId: number,
---    SkillText: string,
---    LvHighest: number,
---    LvText: string,
---    EffectText: string[],
---    IconPath: string,
---    Unlocked: boolean,
---    Lv: number,
---}
