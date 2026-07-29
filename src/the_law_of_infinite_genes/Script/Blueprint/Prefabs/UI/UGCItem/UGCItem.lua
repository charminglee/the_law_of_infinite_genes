---@class UGCItem_C:UUserWidget
---@field Button_ClickArea UButton
---@field CanvasPanel_0 UCanvasPanel
---@field CanvasPanel_Icon UCanvasPanel
---@field Image_Icon UImage
---@field Image_Null UImage
---@field Image_QualityBar UImage
---@field Image_QualityBarBg UImage
---@field Image_Select UImage
---@field TextBlock_Num UTextBlock
---@field UGC_FittingSlot_UIBP UCanvasPanel
---@field WrapGroupBox_QualityPoint UWrapGroupBox
---@field Size FVector2D
---@field DurabilityPercent float
--Edit Below--
if UGCGameSystem ~= nil and UGCGameSystem.UGCRequire ~= nil then
    UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.UGCItem.UGCItemManager");
end

local UGCItem = {
    bInitDoOnce = false,
    Index = nil,
    index = nil,
    ItemData = nil,
    OwnerWidget = nil,
    UseListFlag = nil,
    ClickCallback = nil,
    bClickOpenInfo = false,
    bSelected = false,
    DurabilityPercent = 1,
}

local function ToNumber(Value, DefaultValue)
    local NumberValue = tonumber(Value)
    if NumberValue == nil then
        return DefaultValue
    end
    return NumberValue
end

local function Clamp(Value, MinValue, MaxValue)
    if Value < MinValue then
        return MinValue
    end
    if Value > MaxValue then
        return MaxValue
    end
    return Value
end

function UGCItem:Construct()
    self:LuaInit();
end

function UGCItem:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self:Listen();
    self:SetSelectedVisible(false);
end

function UGCItem:Listen()
    if self.Button_ClickArea == nil or self.Button_ClickArea.OnClicked == nil then
        return;
    end
    self.Button_ClickArea.OnClicked:Add(self.Button_ClickArea_Clicked, self);
end

function UGCItem:Button_ClickArea_Clicked()
    self:ItemClicked();
end

function UGCItem:ItemClicked()
    if UGCItemManager ~= nil and UGCItemManager.OnItemClicked ~= nil then
        return UGCItemManager:OnItemClicked(self);
    end

    local Index = self:GetIndex();

    if type(self.ClickCallback) == "function" then
        self.ClickCallback(self, Index, self.ItemData, self.UseListFlag);
        return true;
    end

    local OwnerWidget = self.OwnerWidget or self.ParentWidget or self.parent or self.Parent;
    if OwnerWidget ~= nil then
        if type(OwnerWidget.OnUGCItemClicked) == "function" then
            OwnerWidget.OnUGCItemClicked(OwnerWidget, self.UseListFlag, Index, self.ItemData, self);
            return true;
        end
        if type(OwnerWidget.OnListItemClicked) == "function" then
            OwnerWidget.OnListItemClicked(OwnerWidget, self.UseListFlag, Index, self.ItemData, self);
            return true;
        end
        if type(OwnerWidget.OnItemClicked) == "function" then
            OwnerWidget.OnItemClicked(OwnerWidget, Index, self.ItemData, self.UseListFlag, self);
            return true;
        end
        if type(OwnerWidget.RefreshSelect) == "function" then
            OwnerWidget.RefreshSelect(OwnerWidget, Index);
            return true;
        end
    end

    return false;
end

function UGCItem:SetOwnerWidget(OwnerWidget)
    self.OwnerWidget = OwnerWidget;
end

function UGCItem:SetUseListFlag(UseListFlag)
    self.UseListFlag = UseListFlag;
end

function UGCItem:SetListContext(OwnerWidget, UseListFlag, Index)
    self.OwnerWidget = OwnerWidget;
    self.UseListFlag = UseListFlag;
    if Index ~= nil then
        self:SetIndex(Index);
    end
end

function UGCItem:SetContext(OwnerWidget, UseListFlag, Index)
    self:SetListContext(OwnerWidget, UseListFlag, Index);
end

function UGCItem:SetClickCallback(Callback)
    self.ClickCallback = Callback;
end

function UGCItem:SetClickOpenInfo(bOpen)
    self.bClickOpenInfo = bOpen == true;
end

function UGCItem:SetIndex(Index)
    self.Index = Index;
    self.index = Index;
end

function UGCItem:GetIndex()
    if self.Index ~= nil then
        return self.Index;
    end
    return self.index;
end

function UGCItem:GetItemData()
    return self.ItemData;
end

function UGCItem:GetItemId()
    if self.ItemData == nil then
        return nil;
    end
    return self.ItemData.ItemId;
end

function UGCItem:SetItem(ItemData, Count)
    self:SetItemData(ItemData, Count);
end

function UGCItem:SetGoodItem(ItemId, Count)
    self:SetItemData(ItemId, Count);
end

function UGCItem:SetItemData(ItemData, Count)
    local Data = self:NormalizeItemData(ItemData, Count);
    if Data == nil or Data.ItemId == nil then
        self:SetNoneItem();
        return;
    end

    self.ItemData = Data;
    self.DurabilityPercent = self:GetDurabilityPercent(Data);

    self:SetVisibleSafe(self.CanvasPanel_Icon, ESlateVisibility.Visible);
    self:SetVisibleSafe(self.Image_Icon, ESlateVisibility.Visible);
    self:SetVisibleSafe(self.Image_Null, ESlateVisibility.Collapsed);
    self:SetVisibleSafe(self.Image_QualityBarBg, ESlateVisibility.Visible);
    self:SetVisibleSafe(self.WrapGroupBox_QualityPoint, ESlateVisibility.Visible);
    self:SetVisibleSafe(self.UGC_FittingSlot_UIBP, Data.bCanEquip and ESlateVisibility.Visible or ESlateVisibility.Collapsed);

    local bIconLoaded = self:SetImageByPath(self.Image_Icon, self:GetItemIconPath(Data.ItemId));
    if not bIconLoaded then
        self:SetVisibleSafe(self.Image_Icon, ESlateVisibility.Collapsed);
        self:SetVisibleSafe(self.Image_Null, ESlateVisibility.Visible);
    end

    local QualityPath = self:GetQualityPath(Data.Quality);
    local bQualityLoaded = self:SetImageByPath(self.Image_QualityBar, QualityPath);
    self:SetVisibleSafe(self.Image_QualityBar, bQualityLoaded and ESlateVisibility.Visible or ESlateVisibility.Collapsed);

    self:SetCountText(Data.Count);
    self:SetDurabilityPercent(self.DurabilityPercent);
end

function UGCItem:SetNoneItem()
    self.ItemData = nil;
    self.DurabilityPercent = 0;

    self:SetVisibleSafe(self.CanvasPanel_Icon, ESlateVisibility.Collapsed);
    self:SetVisibleSafe(self.Image_Icon, ESlateVisibility.Collapsed);
    self:SetVisibleSafe(self.Image_Null, ESlateVisibility.Visible);
    self:SetVisibleSafe(self.Image_QualityBar, ESlateVisibility.Collapsed);
    self:SetVisibleSafe(self.Image_QualityBarBg, ESlateVisibility.Collapsed);
    self:SetVisibleSafe(self.WrapGroupBox_QualityPoint, ESlateVisibility.Collapsed);
    self:SetVisibleSafe(self.UGC_FittingSlot_UIBP, ESlateVisibility.Collapsed);
    self:SetVisibleSafe(self.Durable_Mask, ESlateVisibility.Collapsed);
    self:SetCountText(0);
end

function UGCItem:NormalizeItemData(ItemData, Count)
    if ItemData == nil then
        return nil;
    end

    local Data = {};
    if type(ItemData) == "number" or type(ItemData) == "string" then
        Data.ItemId = ToNumber(ItemData, nil);
    elseif type(ItemData) == "table" then
        for Key, Value in pairs(ItemData) do
            Data[Key] = Value;
        end
        Data.ItemId = ToNumber(Data.ItemId or Data.ItemID or Data.itemId or Data.Itemid or Data.Id or Data.id or Data.DefineID, nil);
    else
        return nil;
    end

    if Data.ItemId == nil then
        return nil;
    end

    Data.Count = ToNumber(Count or Data.Count or Data.count or Data.Number or Data.number or Data.Num or Data.num, 1);
    Data.Count = math.max(0, Data.Count);

    Data.CustomizedType = ToNumber(Data.CustomizedType or Data.CustomType or Data.Type or self:GetItemCustomizedType(Data.ItemId), 0);
    Data.CategoryIndex = ToNumber(Data.CategoryIndex or self:GetCategoryIndexByCustomizedType(Data.CustomizedType), nil);
    Data.Quality = ToNumber(Data.Quality or Data.quality or Data.QualityRank or self:GetItemQuality(Data.ItemId), 1);
    Data.Quality = Clamp(Data.Quality, 1, 7);
    Data.bCanEquip = Data.bCanEquip == true or self:IsEquipmentType(Data.CustomizedType);

    Data.StrengthenLevel = ToNumber(Data.StrengthenLevel or Data.StrengthLevel or Data.Level or Data.level, 0);
    Data.RefineAttrs = Data.RefineAttrs or Data.RefinedAttrs or Data.RefineAttributeList or Data.RefinedAttributeList;

    return Data;
end

function UGCItem:IsEquipmentType(CustomizedType)
    return CustomizedType ~= nil and CustomizedType >= 1 and CustomizedType <= 5;
end

function UGCItem:GetCategoryIndexByCustomizedType(CustomizedType)
    if self:IsEquipmentType(CustomizedType) then
        return 1;
    end
    if CustomizedType == 6 then
        return 2;
    end
    if CustomizedType == 7 then
        return 3;
    end
    if CustomizedType == 8 then
        return 4;
    end
    return nil;
end

function UGCItem:GetItemCustomizedType(ItemId)
    if UGCItemSystemV2 == nil or UGCItemSystemV2.GetItemCustomizedTypeV2 == nil then
        return nil;
    end

    local bSuccess, CustomizedType = pcall(UGCItemSystemV2.GetItemCustomizedTypeV2, ItemId);
    if bSuccess then
        return CustomizedType;
    end
    return nil;
end

function UGCItem:GetItemQuality(ItemId)
    if UGCItemSystemV2 == nil or UGCItemSystemV2.GetItemQualityV2 == nil then
        return nil;
    end

    local bSuccess, Quality = pcall(UGCItemSystemV2.GetItemQualityV2, ItemId);
    if bSuccess then
        return Quality;
    end
    return nil;
end

function UGCItem:GetItemIconPath(ItemId)
    if UGCItemSystemV2 == nil or UGCItemSystemV2.GetItemIconTextureV2 == nil then
        return nil;
    end

    local bSuccess, IconPath = pcall(UGCItemSystemV2.GetItemIconTextureV2, ItemId);
    if not bSuccess then
        return nil;
    end
    return self:GetAssetPath(IconPath);
end

function UGCItem:GetQualityPath(Quality)
    if Config == nil or Config.ItemQuality == nil then
        return nil;
    end

    local QualityConfig = Config.ItemQuality[Quality] or Config.ItemQuality[1];
    if QualityConfig == nil then
        return nil;
    end
    return QualityConfig.path;
end

function UGCItem:GetAssetPath(SourcePath)
    if SourcePath == nil then
        return nil;
    end
    if type(SourcePath) == "string" then
        return SourcePath;
    end

    local FieldNames = {"AssetPathName", "AssetPath", "ObjectPath", "Path", "path"};
    for _, FieldName in ipairs(FieldNames) do
        local bSuccess, Value = pcall(function()
            return SourcePath[FieldName];
        end);
        if bSuccess and Value ~= nil and tostring(Value) ~= "" then
            return tostring(Value);
        end
    end

    return nil;
end

function UGCItem:SetImageByPath(ImageWidget, SourcePath)
    if ImageWidget == nil or ImageWidget.SetBrushFromTexture == nil then
        return false;
    end

    local AssetPath = self:GetAssetPath(SourcePath);
    if AssetPath == nil or AssetPath == "" then
        return false;
    end

    local Texture = nil;
    if UGCObjectUtility ~= nil and UGCObjectUtility.LoadObject ~= nil then
        local bSuccess, LoadedObject = pcall(UGCObjectUtility.LoadObject, AssetPath);
        if bSuccess then
            Texture = LoadedObject;
        end
    end

    if Texture == nil and LoadObject ~= nil then
        local bSuccess, LoadedObject = pcall(LoadObject, AssetPath);
        if bSuccess then
            Texture = LoadedObject;
        end
    end

    if Texture == nil then
        return false;
    end

    ImageWidget:SetBrushFromTexture(Texture);
    return true;
end

function UGCItem:SetCountText(Count)
    if self.TextBlock_Num == nil or self.TextBlock_Num.SetText == nil then
        return;
    end

    Count = ToNumber(Count, 0);
    if Count <= 1 then
        self.TextBlock_Num:SetText("");
    else
        self.TextBlock_Num:SetText(tostring(math.floor(Count)));
    end
end

function UGCItem:SetDurabilityPercent(Percent)
    Percent = ToNumber(Percent, 1);
    if Percent > 1 then
        Percent = Percent / 100;
    end
    Percent = Clamp(Percent, 0, 1);
    self.DurabilityPercent = Percent;

    if self.Durable_Mask ~= nil and self.Durable_Mask.SetPercent ~= nil then
        self.Durable_Mask:SetPercent(Percent);
    end
    self:SetVisibleSafe(self.Durable_Mask, ESlateVisibility.Visible);
end

function UGCItem:GetDurabilityPercent(Data)
    Data = Data or self.ItemData;
    if Data == nil then
        return self.DurabilityPercent or 0;
    end

    return ToNumber(Data.DurabilityPercent or Data.durabilityPercent or Data.Durability or Data.durability or Data.Durable or Data.durable, self.DurabilityPercent or 1);
end

function UGCItem:SetSelectedVisible(Visible)
    self.bSelected = self:IsSelectedVisibleValue(Visible);

    local SlateVisible = self.bSelected and ESlateVisibility.HitTestInvisible or ESlateVisibility.Collapsed;
    self:SetVisibleSafe(self.Image_Select, SlateVisible);
end

function UGCItem:SetSelected(Visible)
    self:SetSelectedVisible(Visible);
end

function UGCItem:IsSelected()
    return self.bSelected == true;
end

function UGCItem:IsSelectedVisibleValue(Visible)
    if Visible == true then
        return true;
    end
    if Visible == false or Visible == nil then
        return false;
    end
    if ESlateVisibility == nil then
        return false;
    end
    return Visible == ESlateVisibility.Visible
        or Visible == ESlateVisibility.HitTestInvisible
        or Visible == ESlateVisibility.SelfHitTestInvisible;
end

function UGCItem:SetVisibleSafe(Widget, Visible)
    if Widget ~= nil and Widget.SetVisibility ~= nil then
        Widget:SetVisibility(Visible);
    end
end

-- Some UMG bindings exported as "None"; keep this shim for Durable_Mask percent.
function UGCItem:None(ReturnValue)
    return self:GetDurabilityPercent();
end

function UGCItem:Durable_Mask_Percent(ReturnValue)
    return self:GetDurabilityPercent();
end

return UGCItem
