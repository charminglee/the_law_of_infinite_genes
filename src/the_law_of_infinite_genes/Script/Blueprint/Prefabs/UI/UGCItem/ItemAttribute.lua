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
    local EquipmentText = RichText.Line(
            RichText.Inline(
                    RichText.Font(string.format('品质\t\t\t%s',ItemCfg.ItemQuality[FQuality].name), {size=20, color=ItemCfg.ItemQuality[strengthenLevel].color})
            ),
            RichText.Inline(
                    RichText.Font("装备强化\t\t", { size = 18, color = 'FFFFFFFF'}),
                    RichText.Font(string.format('+%s',strengthenLevel, ItemCfg.colorTable[strengthenLevel].Text),{size=20, color=ItemCfg.colorTable[strengthenLevel].HexColor})
            ),
            RichText.Inline(
                    RichText.Font("--生命值\t\t\t", {size=16, color = 'FFFFFFFF'}),
                    RichText.Font("200", {size=16, color='41ff4cFF'})
            ),
            RichText.Inline(
                    RichText.Font("--防御力\t\t\t", {size=16, color = 'FFFFFFFF'}),
                    RichText.Font("200", {size=16, color='00fffcFF'})
            ),
            RichText.Inline(
                    RichText.Font("--攻击力\t\t\t", {size=16, color = 'FFFFFFFF'}),
                    RichText.Font("200", {size=16, color='ff8b49FF'})
            )
    )
    return EquipmentText;
end

--- @param DefineID ItemDefineID
function ItemAttribute:GetKenlDAT(DefineID)
    local KenlText = RichText.Line(
            RichText.Inline(RichText.Font("核心属性", { size = 18, color = "FFFFFFFF" })),
            RichText.Inline(
                    RichText.Font("--属性一\t\t\t", { size = 16, color = "FFFFFFFF" }),
                    RichText.Font('攻击力+10', {size=16, color='B8FFA1FF'})
            ),
            RichText.Inline(
                    RichText.Font("--属性二\t\t\t", { size = 16, color = "FFFFFFFF" }),
                    RichText.Font('攻击力+10', {size=16, color='B8FFA1FF'})
            ),
            RichText.Inline(
                    RichText.Font("--属性三\t\t\t", { size = 16, color = "FFFFFFFF" }),
                    RichText.Font('攻击力+10', {size=16, color='B8FFA1FF'})
            )
    )
    return KenlText;
end

function ItemAttribute:EscapeText(Text)
    Text = tostring(Text or "")
    Text = string.gsub(Text, "&", "&amp;")
    Text = string.gsub(Text, "<", "&lt;")
    Text = string.gsub(Text, ">", "&gt;")
    return Text
end

function ItemAttribute:Font(Text, Style)
    Style = Style or {}

    local AttrList = {}

    if Style.src then
        table.insert(AttrList, string.format('src="%s"', Style.src))
    end

    if Style.size then
        table.insert(AttrList, string.format('size="%s"', tostring(Style.size)))
    end

    if Style.color then
        table.insert(AttrList, string.format('color="%s"', Style.color))
    end

    if Style.use_shadow then
        table.insert(AttrList, string.format('use_shadow="%s"', tostring(Style.use_shadow)))
    end

    if Style.shadow_color then
        table.insert(AttrList, string.format('shadow_color="%s"', Style.shadow_color))
    end

    if Style.shadow_offset then
        table.insert(AttrList, string.format('shadow_offset="%s"', Style.shadow_offset))
    end

    if #AttrList <= 0 then
        return self:EscapeText(Text)
    end

    return string.format("<font %s>%s</>", table.concat(AttrList, " "), self:EscapeText(Text))
end

function ItemAttribute:Image(Style)
    Style = Style or {}

    local AttrList = {}

    if Style.src then
        table.insert(AttrList, string.format('src="%s"', tostring(Style.src)))
    end

    if Style.size then
        table.insert(AttrList, string.format('size="%s"', tostring(Style.size)))
    elseif Style.width and Style.height then
        table.insert(AttrList, string.format('size="%s;%s"', tostring(Style.width), tostring(Style.height)))
    end

    if Style.baseline then
        table.insert(AttrList, string.format('baseline="%s"', tostring(Style.baseline)))
    end

    return string.format("<pic %s/>", table.concat(AttrList, " "))
end

function ItemAttribute:Inline(...)
    local Result = {}

    for _, Text in ipairs({ ... }) do
        table.insert(Result, tostring(Text or ""))
    end

    return table.concat(Result, "")
end

function ItemAttribute:Line(...)
    local Result = {}
    for _, Text in ipairs({ ... }) do
        table.insert(Result, tostring(Text or ""))
    end

    return table.concat(Result, "\n")
end

return ItemAttribute