---@meta


---@alias Card [number, number]


---@alias AttrEntry {property: Attribute, value: number}
---@alias EquipmentData {
---    strengthenLevel: number, 
---}
---@alias KenlData {
---    entries: AttrEntry[],
---    isIdentified: boolean, 
---    refineNum: number,
---}
---@alias BaseAttrEntryDetail {
---    property: Attribute, 
---    finalValue: number, 
---    initialValue: number, 
---    strengthenValue: number,
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
