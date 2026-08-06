---@class ItemAux_C:UUserWidget
---@field CanvasPanel_0 UCanvasPanel
---@field CanvasPanel_Icon UCanvasPanel
---@field Image_Null UImage
---@field Image_Suit UImage
---@field StrengthenNum UTextBlock
---@field Size FVector2D
---@field DurabilityPercent float
--Edit Below--
local ItemAux = { bInitDoOnce = false }
function ItemAux:Construct()
end

function ItemAux:InitData(Data)
    local DefineId = Data.ItemDefineID
    local customDat = LocalPlayerState.ItemDataManager:GetCustomData(DefineId)
    local strengthenLevel = customDat.strengthenLevel;
    self.StrengthenNum:SetText(tostring(strengthenLevel));
    self.StrengthenNum:SetColorRGBStr(ItemCfg.colorTable[strengthenLevel].HexColor);

end


return ItemAux