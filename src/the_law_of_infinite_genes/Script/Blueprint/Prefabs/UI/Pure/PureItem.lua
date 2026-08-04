---@class PureItem_C:UUserWidget
---@field Button_0 UButton
---@field CanvasPanel_0 UCanvasPanel
---@field CanvasPanel_Icon UCanvasPanel
---@field Image_Icon UImage
---@field Image_Null UImage
---@field Image_QualityBar UImage
---@field Image_QualityBarBg UImage
---@field Image_Select UImage
---@field TextBlock_Fortify UTextBlock
---@field TextBlock_Num UTextBlock
---@field Size FVector2D
---@field DurabilityPercent float
--Edit Below--
local PureItem = { bInitDoOnce = false, DefineID=nil}

function PureItem:Construct()
	self:LuaInit()
end

function PureItem:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self:Listen();
end

function PureItem:Listen()
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);

end

function PureItem:Button_0_Clicked()
    ugcprint('clicked');
    PureManager:Reload(self.DefineID, PureManager.FilterType);
end

--- @param DefineID ItemDefineID
function PureItem:SetSelected(DefineID)
    if DefineID.InstanceID == self.DefineID.InstanceID then
        self.Image_Select:SetVisibility(ESlateVisibility.Visible);
    else
        self.Image_Select:SetVisibility(ESlateVisibility.Collapsed);
    end
end

--- @param DefineID ItemDefineID
function PureItem:SetDefineID(DefineID)
    self.DefineID = DefineID;

    local ItemId = self.DefineID.TypeSpecificID;
    local quality = UGCItemSystemV2.GetItemQualityV2(ItemId);
    local icon = UGCItemSystemV2.GetItemIconTextureV2(ItemId);
    self:AsyncSetTexture({AssetPathName=ItemCfg.ItemQuality[quality].Bg, SubPathString=nil}, self.Image_QualityBarBg);
    self:AsyncSetTexture({AssetPathName=ItemCfg.ItemQuality[quality].bar, SubPathString=nil}, self.Image_QualityBar);
    self:AsyncSetTexture(icon, self.Image_Icon);
end

function PureItem:AsyncSetTexture(path, UI)
    Common.LoadObjectWithSoftPathAsync(path,
            function (PATH)
                if self == nil or PATH == nil then
                    return;
                end
                UI:SetBrushFromTexture(PATH);
            end
    );
end

return PureItem