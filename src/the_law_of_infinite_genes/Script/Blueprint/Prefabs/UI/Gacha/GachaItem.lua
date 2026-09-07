---@class GachaItem_C:UUserWidget
---@field Add UImage
---@field Button_0 UButton
---@field CanvasPanel_Icon UCanvasPanel
---@field Image_Icon UImage
---@field Image_QualityBar UImage
---@field Image_QualityBarBg UImage
---@field Image_Select UImage
---@field Image_SuitBar UImage
---@field Image_Tips UImage
---@field Level_1 UImage
---@field Level_2 UImage
---@field Level_3 UImage
---@field Lock UImage
---@field TextBlock_Name UTextBlock
--Edit Below--
local GachaItem = {
    bInitDoOnce = false,
    Index = nil,
    Tag = nil,
    Data = nil,
    RenderVersion = 0,
    DragVisualClass = nil,
    DragOperationClass = nil,
    DragOperation = nil,
    bDragDetected = false,
}
local STAR_ACTIVE_COLOR = "FFA700";
local STAR_INACTIVE_COLOR = "3C3C3C";
local DRAG_VISUAL_CLASS_PATH = "Asset/Blueprint/Prefabs/UI/Gacha/GachaDragItem.GachaDragItem_C";
local DRAG_OPERATION_CLASS_PATH = "/Script/UMG.DragDropOperation";
function GachaItem:Construct()
    self:LuaInit();
end
function GachaItem:Destruct()
    self.DragOperation = nil;
end
function GachaItem:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self.Button_0.OnClicked:Add(self.ItemClicked, self);
    self.DragOperationClass = UE.LoadClass(DRAG_OPERATION_CLASS_PATH);
    local weakSelf = WeakObjectPtr(self);
    local classPath = UGCMapInfoLib.GetRootLongPackagePath() .. DRAG_VISUAL_CLASS_PATH;
    Common.LoadObjectAsync(classPath, function(UIClass)
        if not weakSelf:IsValid() then
            return;
        end
        weakSelf:Get().DragVisualClass = UIClass;
        ugcprint("[GachaDrag] Drag visual class loaded");
    end);
end
function GachaItem:ItemClicked()
    if self.Data == nil then
        return;
    end
    GachaManager.SelectIndex = self.Index;
    GachaManager.SelectTag = self.Tag;
    GachaManager.RefreshUI = true;
end
function GachaItem:OnPreviewMouseButtonDown(MyGeometry, MouseEvent)
    if self.Data == nil then
        return WidgetBlueprintLibrary.Unhandled();
    end
    self.bDragDetected = false;
    local dragKey = KismetInputLibrary.PointerEvent_GetEffectingButton(MouseEvent);
    ugcprint("[GachaDrag] Button_0 detect drag Index=" .. tostring(self.Index) .. " Tag=" .. tostring(self.Tag));
    return WidgetBlueprintLibrary.DetectDragIfPressed(MouseEvent, self, dragKey);
end
function GachaItem:OnMouseButtonUp(MyGeometry, MouseEvent)
    if not self.bDragDetected then
        self:ItemClicked();
    end
    return WidgetBlueprintLibrary.Handled();
end
function GachaItem:OnDragDetected(MyGeometry, PointerEvent, Operation)
    if self.Data == nil or self.DragVisualClass == nil or self.DragOperationClass == nil then
        return nil;
    end
    local dragSize = SlateBlueprintLibrary.GetLocalSize(MyGeometry);
    local dragVisual = UserWidget.NewWidgetObjectBP(self, self.DragVisualClass);
    dragVisual:SetDesiredSizeInViewport(dragSize);
    dragVisual:InitData({
        Index = self.Index,
        Tag = self.Tag,
        Data = self.Data,
        Size = dragSize,
    });
    dragVisual:SetVisibility(ESlateVisibility.HitTestInvisible);
    local dragOperation = WidgetBlueprintLibrary.CreateDragDropOperation(self.DragOperationClass);
    dragOperation.DefaultDragVisual = dragVisual;
    dragOperation.Payload = self;
    dragOperation.Pivot = EDragPivot.CenterCenter;
    dragOperation.Tag = tostring(self.Tag) .. ":" .. tostring(self.Index);
    self.DragOperation = dragOperation;
    self.bDragDetected = true;
    ugcprint("[GachaDrag] OnDragDetected operation created Index=" .. tostring(self.Index) .. " Tag=" .. tostring(self.Tag));
    return dragOperation;
end
function GachaItem:OnDragCancelled(PointerEvent, Operation)
    self.DragOperation = nil;
    self.bDragDetected = false;
    ugcprint("[GachaDrag] OnDragCancelled");
end
function GachaItem:OnDrop(MyGeometry, PointerEvent, Operation)
    local sourceItem = Operation and Operation.Payload;
    if self.Data ~= nil or sourceItem == nil or sourceItem == self then
        return false;
    end
    local mainUI = GachaManager.MainUI;
    if mainUI == nil or not mainUI:HandleItemDrop(sourceItem, self) then
        return false;
    end
    sourceItem.DragOperation = nil;
    sourceItem.bDragDetected = false;
    ugcprint("[GachaDrag] OnDrop from=" .. tostring(sourceItem.Tag) .. ":" .. tostring(sourceItem.Index)
            .. " to=" .. tostring(self.Tag) .. ":" .. tostring(self.Index));
    return true;
end
function GachaItem:_IsSelected()
    return self.Data ~= nil
            and GachaManager.SelectIndex == self.Index
            and GachaManager.SelectTag == self.Tag;
end
function GachaItem:_SetStarLevel(star)
    self.Level_1:SetColorRGBStr(star >= 1 and STAR_ACTIVE_COLOR or STAR_INACTIVE_COLOR);
    self.Level_2:SetColorRGBStr(star >= 2 and STAR_ACTIVE_COLOR or STAR_INACTIVE_COLOR);
    self.Level_3:SetColorRGBStr(star >= 3 and STAR_ACTIVE_COLOR or STAR_INACTIVE_COLOR);
end
function GachaItem:_SetEmpty(showAdd, showLock)
    self.Data = nil;
    self.RenderVersion = self.RenderVersion + 1;
    self.Image_Select:SetVisibility(ESlateVisibility.Collapsed);
    self.CanvasPanel_Icon:SetVisibility(ESlateVisibility.Visible);
    self.Image_Icon:SetVisibility(ESlateVisibility.Collapsed);
    self.Add:SetVisibility(showAdd and ESlateVisibility.Visible or ESlateVisibility.Collapsed);
    self.Lock:SetVisibility(showLock and ESlateVisibility.Visible or ESlateVisibility.Collapsed);
    self.Image_QualityBar:SetVisibility(ESlateVisibility.Collapsed);
    self.Image_QualityBarBg:SetColorRGBStr("00000099");
    self.Image_SuitBar:SetVisibility(ESlateVisibility.Collapsed);
    self.Image_Tips:SetVisibility(ESlateVisibility.Collapsed);
    self.TextBlock_Name:SetVisibility(ESlateVisibility.Collapsed);
    self.Level_1:SetVisibility(ESlateVisibility.Collapsed);
    self.Level_2:SetVisibility(ESlateVisibility.Collapsed);
    self.Level_3:SetVisibility(ESlateVisibility.Collapsed);
    if GachaManager.SelectIndex == self.Index and GachaManager.SelectTag == self.Tag then
        GachaManager.PreviewDAT = nil;
    end
end
---@param data table
---@param showTips boolean
function GachaItem:_SetCard(data, showTips)
    local card = CardCfg.Cards[data[1]];
    if card == nil then
        self:_SetEmpty();
        return;
    end
    local suit = CardCfg.Suit[card.suit];
    local group = CardCfg.Group[suit.Group];
    local grade = CardCfg.Grade[card.grade];
    self.Data = data;
    self.RenderVersion = self.RenderVersion + 1;
    local renderVersion = self.RenderVersion;
    self.CanvasPanel_Icon:SetVisibility(ESlateVisibility.Visible);
    self.Image_Icon:SetVisibility(ESlateVisibility.Visible);
    self.Add:SetVisibility(ESlateVisibility.Collapsed);
    self.Lock:SetVisibility(ESlateVisibility.Collapsed);
    self.Image_QualityBar:SetVisibility(ESlateVisibility.Visible);
    self.Image_SuitBar:SetVisibility(ESlateVisibility.Visible);
    self.Image_Tips:SetVisibility(showTips and ESlateVisibility.Visible or ESlateVisibility.Collapsed);
    self.TextBlock_Name:SetVisibility(ESlateVisibility.Visible);
    self.Level_1:SetVisibility(ESlateVisibility.Visible);
    self.Level_2:SetVisibility(ESlateVisibility.Visible);
    self.Level_3:SetVisibility(ESlateVisibility.Visible);
    self:AsyncSetTexture({AssetPathName = card.texture, SubPathString = nil}, self.Image_Icon, renderVersion);
    self.Image_Icon:SetColorRGBStr(group.HexColor);
    self.Image_QualityBar:SetColorRGBStr(grade.HexColor);
    self.Image_QualityBarBg:SetColorAndOpacity(grade.rgba);
    self.Image_SuitBar:SetColorRGBStr(group.HexColor);
    self.TextBlock_Name:SetText(card.name);
    self:_SetStarLevel(data[2] or 1);
    local isSelected = self:_IsSelected();
    self.Image_Select:SetVisibility(isSelected and ESlateVisibility.Visible or ESlateVisibility.Collapsed);
    if isSelected then
        GachaManager:SetPreviewDAT(data);
    end
end
---@param index integer
---@param tag integer
---@param data table|nil
---@param showAdd boolean
---@param showLock boolean
---@param showTips boolean
function GachaItem:SetData(index, tag, data, showAdd, showLock, showTips)
    self.Index = index;
    self.Tag = tag;
    if data == nil then
        self:_SetEmpty(showAdd, showLock);
        return;
    end
    self:_SetCard(data, showTips);
end
function GachaItem:AsyncSetTexture(Path, UI, RenderVersion)
    Common.LoadObjectWithSoftPathAsync(Path,
            function(Texture)
                if self ~= nil and Texture ~= nil and self.RenderVersion == RenderVersion then
                    UI:SetBrushFromTexture(Texture);
                end
            end
    );
end
return GachaItem