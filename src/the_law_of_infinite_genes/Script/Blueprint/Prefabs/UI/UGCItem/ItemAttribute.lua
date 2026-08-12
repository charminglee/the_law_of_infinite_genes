---@class ItemAttribute_C:UAEUserWidget
---@field Equipment UUTRichTextBlock
---@field Knel UUTRichTextBlock
--Edit Below--
local ItemAttribute = {
    bInitDoOnce = false,
}

function ItemAttribute:Construct()
end

function ItemAttribute:InitData(Data)
    if type(Data) ~= "table" or not Data[1] or not Data[1].ItemDefineID then
        self.Equipment:SetText("")
        self.Knel:SetText("");
        self.Knel:SetVisibility(ESlateVisibility.Collapsed)
        return
    end
    local DefineId = Data[1].ItemDefineID
    ugcprint_concat(UGCItemSystemV2.GetItemNameV2(DefineId.TypeSpecificID));
    local Slots = UGCItemSystemV2.GetAttachChildrenItem(DefineId) or {}
    local KenlText = ""
    if ItemCfg.CustomizeType[UGCItemSystemV2.GetItemCustomizedTypeV2(DefineId.TypeSpecificID)] then
        self.Equipment:SetText(self:GetEquipmentDAT(DefineId));
    else
        self.Equipment:SetVisibility(ESlateVisibility.Collapsed);
        self.Knel:SetVisibility(ESlateVisibility.Visible);
        self.Knel:SetText(self:GetKenlDAT(DefineId));
        return;
    end
    for _, Slot in pairs(Slots) do
        local SlotItemId = Slot and Slot.TypeSpecificID or 0
        if SlotItemId and SlotItemId ~= 0 then
            KenlText = self:GetKenlDAT(DefineId);
            break
        end
    end

    if KenlText ~= "" then
        self.Knel:SetVisibility(ESlateVisibility.Visible)
        self.Knel:SetText(KenlText)
    else
        self.Knel:SetText("")
        self.Knel:SetVisibility(ESlateVisibility.Collapsed)
    end
end

--- @param DefineID ItemDefineID
function ItemAttribute:GetEquipmentDAT(DefineID)
    local FQuality = UGCItemSystemV2.GetItemQualityV2ByDefineID(DefineID)
    local customDat = LocalPlayerState.ItemDataManager:GetCustomData(DefineID)
    local strengthenLevel = customDat.strengthenLevel
    local ItemName = UGCItemSystemV2.GetItemNameV2(DefineID.TypeSpecificID);
    local Attr = ItemCfg.EquipmentAttribute[ItemName]
    local Base = Attr.Base
    local Factor = Attr.Factor[FQuality]
    local EquipmentText = RichText.Line(
            RichText.Inline(
                    RichText.Font(string.format('品质\t\t\t%s',ItemCfg.ItemQuality[FQuality].name), {size=20, color=ItemCfg.ItemQuality[FQuality].color})
            ),
            RichText.Inline(
                    RichText.Font("装备强化\t\t", { size = 18, color = 'FFFFFFFF'}),
                    RichText.Font(string.format('+%s',strengthenLevel, ItemCfg.colorTable[strengthenLevel].Text),{size=20, color=ItemCfg.colorTable[strengthenLevel].HexColor})
            ),
            RichText.Inline(
                    RichText.Font(string.format("--%s\t\t\t", AttributeMate[Base[1].property].anno), {size=16, color = 'FFFFFFFF'}),
                    RichText.Font(tostring(math.floor(Base[1].value * Factor)), {size=16, color='41ff4cFF'})
            ),
            RichText.Inline(
                    RichText.Font(string.format("--%s\t\t\t", AttributeMate[Base[2].property].anno), {size=16, color = 'FFFFFFFF'}),
                    RichText.Font(tostring(math.floor(Base[2].value * Factor)), {size=16, color='ff8b49FF'})
            ),
            RichText.Inline(
                    RichText.Font(string.format("--%s\t\t\t", AttributeMate[Base[3].property].anno), {size=16, color = 'FFFFFFFF'}),
                    RichText.Font(tostring(math.floor(Base[3].value * Factor)), {size=16,  color='00fffcFF'})
            )
    )
    return EquipmentText;
end


--- @param DefineID ItemDefineID
function ItemAttribute:GetKenlDAT(DefineID)
    local Dat = LocalPlayerState.ItemDataManager:GetCustomData(DefineID);

    if not Dat.isIdentified then
        return RichText.Line(RichText.Font('核心属性未鉴定', {size=18, color='FFFFFFFF'}));
    end
    local KenlTable = {
        RichText.Font('核心属性', {size = 20, color = "FFFFFFFF"})
    };
    local ItemFlag = 1
    for k, v in ipairs(Dat.entries) do
        local attrName = AttributeMate[v.property].anno;
        table.insert(KenlTable,
                RichText.Inline(
                        RichText.Font(string.format('--属性%s\t\t\t', tostring(ItemFlag)), {size = 18, color = "FFFFFFFF"}),
                        RichText.Font(string.format('%s+%s',attrName, v.value), {size=16, color='B8FFA1FF'})
                )
        )
        ItemFlag = ItemFlag + 1;
    end
    local KenlText =table.concat(KenlTable, "\n");
    return KenlText;
end

return ItemAttribute