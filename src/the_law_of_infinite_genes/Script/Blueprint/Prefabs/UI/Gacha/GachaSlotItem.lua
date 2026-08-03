---@class GachaSlotItem_C:UUserWidget
---@field bg UImage
---@field Button_0 UButton
---@field ColorGradient_0 UColorGradient
---@field E0 UImage
---@field E1 UImage
---@field Empty UCanvasPanel
---@field GachaImage UImage
---@field GachaText UTextBlock
---@field quality UImage
---@field selected UCanvasPanel
---@field Used UCanvasPanel
--Edit Below--
local GachaSlotItem = { bInitDoOnce = false, BufferSlot=nil, Index=nil}; 

function GachaSlotItem:Construct()
	self:LuaInit();
end

function GachaSlotItem:LuaInit()
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true;
    self:Listen();
end

function GachaSlotItem:Listen()
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);
end

function GachaSlotItem:Button_0_Clicked()
    GachaManager:SetCurrentClickedParam(self);
end

function GachaSlotItem:SetSelectedVisibility(Visible)
    if Visible == 0 then
        self:SelectedStatus();
    elseif Visible == 1 then
        self:UsedStatus();
    elseif Visible == 2 then
        self:EmptyStatus();
    elseif Visible == 3 then
        self:NilShopItem();
    end
end

function GachaSlotItem:EmptyStatus()
    self.Empty:SetVisibility(ESlateVisibility.Visible);
    self.E1:SetVisibility(ESlateVisibility.Visible);
    self.Used:SetVisibility(ESlateVisibility.Collapsed);
    self.selected:SetVisibility(ESlateVisibility.Collapsed);
end

function GachaSlotItem:SelectedStatus()
    self.Empty:SetVisibility(ESlateVisibility.Collapsed);
    self.Used:SetVisibility(ESlateVisibility.Visible);
    self.E1:SetVisibility(ESlateVisibility.Visible);
    self.selected:SetVisibility(ESlateVisibility.Visible);
end
function GachaSlotItem:UsedStatus()
    self.Empty:SetVisibility(ESlateVisibility.Collapsed);
    self.Used:SetVisibility(ESlateVisibility.Visible);
    self.E1:SetVisibility(ESlateVisibility.Visible);
    self.selected:SetVisibility(ESlateVisibility.Collapsed);
end

function GachaSlotItem:NilShopItem()
    self.Empty:SetVisibility(ESlateVisibility.Visible);
    self.Used:SetVisibility(ESlateVisibility.Collapsed);
    self.selected:SetVisibility(ESlateVisibility.Collapsed);
    self.E1:SetVisibility(ESlateVisibility.Collapsed);
end
function GachaSlotItem:SetItemTexture(Slot)
    local SlotIndex = Slot[1]
    local star = Slot[2]
    local _card = CardCfg.Cards[SlotIndex];
    self.GachaText:SetText(_card.name);
    local Texture = LoadObject(_card.texture);
    self.GachaImage:SetBrushFromTexture(Texture);
    local suitIndex = _card.suit;
    local gradeIndex = _card.grade;
    self.GachaImage:SetColorRGBStr(CardCfg.Group[suitIndex].HexColor);
    self.quality:SetColorRGBStr(CardCfg.Grade[gradeIndex].HexColor)
end


return GachaSlotItem