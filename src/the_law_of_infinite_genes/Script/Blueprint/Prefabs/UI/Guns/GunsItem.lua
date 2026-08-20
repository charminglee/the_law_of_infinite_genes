---@class GunsItem_C:UUserWidget
---@field Button_0 UButton
---@field CanvasPanel_0 UCanvasPanel
---@field CanvasPanel_Icon UCanvasPanel
---@field Image_Icon UImage
---@field Image_Null UImage
---@field Image_QualityBarBg UImage
---@field Image_Select UImage
---@field ItemName UTextBlock
---@field Size FVector2D
---@field DurabilityPercent float
--Edit Below--
local GunsItem = { bInitDoOnce = false, DefineID=nil}

function GunsItem:Construct()
	self:LuaInit()
end

function GunsItem:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self:Listen();
end

function GunsItem:Listen()
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);

end

function GunsItem:Button_0_Clicked()
    GunsManager:Reload(self.DefineID, GunsManager.FilterType);
end

--- @param DefineID ItemDefineID
function GunsItem:SetSelected(DefineID)
    if DefineID.ItemId == self.DefineID.ItemId then
        self.Image_Select:SetVisibility(ESlateVisibility.Visible);
        self.Image_QualityBarBg:SetVisibility(ESlateVisibility.Visible);
    else
        self.Image_Select:SetVisibility(ESlateVisibility.Collapsed);
        self.Image_QualityBarBg:SetVisibility(ESlateVisibility.Collapsed);
    end
end

--- @param DefineID ItemDefineID
function GunsItem:SetDefineID(DefineID)
    self.DefineID = DefineID;
    local ItemId = self.DefineID.ItemId;
    local icon = UGCItemSystemV2.GetItemIconTextureV2(ItemId);
    local name = UGCItemSystemV2.GetItemNameV2(DefineID.ItemId);
    self:AsyncSetTexture(icon, self.Image_Icon);
    self.ItemName:SetText(name);
end

function GunsItem:AsyncSetTexture(path, UI)
    Common.LoadObjectWithSoftPathAsync(path,
            function (PATH)
                if self == nil or PATH == nil then
                    return;
                end
                UI:SetBrushFromTexture(PATH);
            end
    );
end

return GunsItem