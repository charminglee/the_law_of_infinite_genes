---@class GachaAttributeItem_C:UAEUserWidget
---@field Text UTextBlock
local GachaAttributeItem = { bInitDoOnce = false } 

function GachaAttributeItem:LuaInit()
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true;
end

---@param text string
---@param HexColor string
function GachaAttributeItem:SetText(text,HexColor)
    self.Text:SetText(text);
    self.Text:SetColorRGBStr(HexColor);
end

return GachaAttributeItem