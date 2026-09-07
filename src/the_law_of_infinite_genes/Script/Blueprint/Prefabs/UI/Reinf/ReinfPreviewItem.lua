---@class ReinfPreviewItem_C:UUserWidget
---@field CanvasPanel_Icon UCanvasPanel
---@field Image_Icon UImage
---@field Image_QualityBar UImage
---@field Image_QualityBarBg UImage
---@field TextBlock_Fortify UTextBlock
---@field TextBlock_Num UTextBlock
---@field Size FVector2D
---@field DurabilityPercent float
--Edit Below--
local ReinfPreviewItem = { bInitDoOnce = false, DefineID=nil}

function ReinfPreviewItem:Construct()
	self:LuaInit()
end

function ReinfPreviewItem:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self:Listen();
end

function ReinfPreviewItem:Listen()
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);

end

function ReinfPreviewItem:Button_0_Clicked()
    ugcprint('clicked');
    FortifyManager:Reload(self.DefineID, FortifyManager.FilterType);
end

--- @param DefineID ItemDefineID
function ReinfPreviewItem:SetSelected(DefineID)
    if DefineID.InstanceID == self.DefineID.InstanceID then
        self.Image_Select:SetVisibility(ESlateVisibility.Visible);
    else
        self.Image_Select:SetVisibility(ESlateVisibility.Collapsed);
    end
end

--- @param DefineID ItemDefineID
function ReinfPreviewItem:SetDefineID(DefineID)
    self.DefineID = Lib.ToItemDefineId(DefineID, ItemCfg.ItemType.Kenl);

    local ItemId = self.DefineID.TypeSpecificID;
    local quality = UGCItemSystemV2.GetItemQualityV2(ItemId);
    local icon = UGCItemSystemV2.GetItemIconTextureV2(ItemId);
    self:AsyncSetTexture({AssetPathName=ItemCfg.ItemQuality[quality].Bg, SubPathString=nil}, self.Image_QualityBarBg);
    self:AsyncSetTexture({AssetPathName=ItemCfg.ItemQuality[quality].bar, SubPathString=nil}, self.Image_QualityBar);
    self:AsyncSetTexture(icon, self.Image_Icon);
end

function ReinfPreviewItem:AsyncSetTexture(path, UI)
    Common.LoadObjectWithSoftPathAsync(path,
            function (PATH)
                if self == nil or PATH == nil then
                    return;
                end
                UI:SetBrushFromTexture(PATH);
            end
    );
end

return ReinfPreviewItem
