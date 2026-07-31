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
        self.Knel:SetText("")
        self.Knel:SetVisibility(ESlateVisibility.Collapsed)
        return
    end

    local DefineId = Data[1].ItemDefineID
    local Slots = UGCItemSystemV2.GetAttachChildrenItem(DefineId) or {}
    local FQuality = UGCItemSystemV2.GetItemQualityV2ByDefineID(DefineId)

    local EquipmentText = self:Line(
            self:Inline(self:Font('品质\t\t', {size=20, color='FFFFFFFF'}, self:Font(Config.ItemQuality[FQuality].name, {size=20, color=Config.ItemQuality[FQuality].color}))),
            self:Inline(self:Font("装备强化\t\t", { size = 18, color = 'FFFFFFFF'}), self:Font('+15', {size=20, color='FEEA42FF'})),
            self:Inline(self:Font("攻击力\t", { size = 14, color = "FFFFFFFF" }), self:Font('+10', {size=14, color='B8FFA1FF'})),
            self:Inline(self:Font("生命值\t", { size = 14, color = "FFFFFFFF" }), self:Font('+10', {size=14, color='B8FFA1FF'})),
            self:Inline(self:Font("防御力\t", { size = 14, color = "FFFFFFFF" }), self:Font('+10', {size=14, color='B8FFA1FF'})),
            self:Font("赤锋套装", { size = 16, color = "B8FFB8FF" }),
            self:Font("[2]套效果", { size = 15, color = "BFFFFFFF" }),
            self:Font("暴击率 +5%", { size = 14, color = "FF5555FF" })
    )

    local KnelText = ""

    for _, Slot in pairs(Slots) do
        local SlotItemId = Slot and Slot.TypeSpecificID or 0

        if SlotItemId and SlotItemId ~= 0 then
            KnelText = self:Line(
                    self:Inline(self:Font("核心属性\t", { size = 18, color = "FFFFFFFF" })),
                    self:Inline(self:Font("属性一\t", { size = 14, color = "FFFFFFFF" }), self:Font('攻击力+10', {size=14, color='B8FFA1FF'})),
                    self:Inline(self:Font("属性二\t", { size = 14, color = "FFFFFFFF" }), self:Font('攻击力+10', {size=14, color='B8FFA1FF'})),
                    self:Inline(self:Font("属性三\t", { size = 14, color = "FFFFFFFF" }), self:Font('攻击力+10', {size=14, color='B8FFA1FF'}))
            )
            break
        end
    end

    self.Equipment:SetText(EquipmentText)

    if KnelText ~= "" then
        self.Knel:SetVisibility(ESlateVisibility.Visible)
        self.Knel:SetText(KnelText)
    else
        self.Knel:SetText("")
        self.Knel:SetVisibility(ESlateVisibility.Collapsed)
    end
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