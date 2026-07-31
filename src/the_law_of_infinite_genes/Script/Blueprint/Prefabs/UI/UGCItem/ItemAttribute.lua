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
    local DefineId = Data[1].ItemDefineID;
    local Slots = UGCItemSystemV2.GetAttachChildrenItem(DefineId);
    local has_slots = Slots[1] ~= nil;
    local EquipmentText = self:Line(
            self:Font("装备强化+15", { size = 20, color = "FFEA42FF" }),
            self:Font("赤锋套装", { size = 16, color = "FFEA42FF" }),
            self:Font("攻击力 +10", { size = 14, color = "FFFFFFFF" }),
            self:Font("生命值 +100", { size = 14, color = "FFFFFFFF" }),
            self:Font("[2]套效果", { size = 15, color = "7BDFFFff" }),
            self:Font("暴击率 +5%", { size = 14, color = "B8FFB8FF" })
    )
    local KnelText = '';
    if has_slots then
        local slotItemId = Slots[1].TypeSpecificID;
        if Slots[1].TypeSpecificID ~= 0 then
                KnelText = self:Line(
                        self:Font("属性一", { size = 20, color = "FFEA42FF" }),
                        self:Font("属性二", { size = 16, color = "FFEA42FF" }),
                        self:Font("属性三", { size = 14, color = "FFFFFFFF" })
                )
        end
    end
    self.Equipment:SetText(EquipmentText);
    self.Knel:SetText(KnelText);
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