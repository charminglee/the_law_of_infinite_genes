---@class GachaDragItem:UUserWidget
---@field ItemSlot UCanvasPanel
local GachaDragItem = {
    CardWidget = nil,
    DragData = nil,
    LoadVersion = 0,
    bInitDoOnce = false,
}

local CARD_WIDGET_CLASS_PATH = "Asset/Blueprint/Prefabs/UI/Gacha/GachaItem.GachaItem_C";

function GachaDragItem:Construct()
    self:LuaInit();
    if self.DragData ~= nil then
        self:RefreshCard();
    end
end

function GachaDragItem:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
end

function GachaDragItem:InitData(dragData)
    ugcprint("[GachaDrag] GachaDragItem InitData");
    self.DragData = dragData;
    if self.bInitDoOnce then
        self:RefreshCard();
    end
end

function GachaDragItem:RefreshCard()
    self.LoadVersion = self.LoadVersion + 1;
    local loadVersion = self.LoadVersion;
    local weakSelf = WeakObjectPtr(self);
    local classPath = UGCMapInfoLib.GetRootLongPackagePath() .. CARD_WIDGET_CLASS_PATH;
    Common.LoadObjectAsync(classPath, function(UIClass)
        ugcprint("[GachaDrag] Card UI async callback");
        if not weakSelf:IsValid() then
            return;
        end
        local selfObject = weakSelf:Get();
        if selfObject.LoadVersion ~= loadVersion then
            return;
        end
        local cardWidget = UserWidget.NewWidgetObjectBP(selfObject, UIClass);
        local slot = selfObject.ItemSlot:AddChildToCanvas(cardWidget);
        slot:SetAutoSize(false);
        slot:SetSize(selfObject.DragData.Size);
        cardWidget:SetVisibility(ESlateVisibility.HitTestInvisible);
        cardWidget:SetData(selfObject.DragData.Index, selfObject.DragData.Tag, selfObject.DragData.Data);
        selfObject.CardWidget = cardWidget;
        selfObject:ForceLayoutPrepass();
        ugcprint("[GachaDrag] Card UI created");
    end);
end

return GachaDragItem
