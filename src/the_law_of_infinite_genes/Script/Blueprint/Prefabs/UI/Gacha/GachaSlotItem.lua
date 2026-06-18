---@class GachaSlotItem_C:UUserWidget
---@field bg UImage
---@field Button_0 UButton
---@field ColorGradient_0 UColorGradient
---@field E0 UImage
---@field E1 UImage
---@field Empty UCanvasPanel
---@field GachaImage UImage
---@field quality UImage
---@field selected UCanvasPanel
---@field Used UCanvasPanel
--Edit Below--
local GachaSlotItem = { bInitDoOnce = false} 

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
        ugcprint('0');
        self:SelectedStatus();
    elseif Visible == 1 then
        ugcprint('1')
        self:UsedStatus();
    elseif Visible == 2 then
        self:EmptyStatus();
    end
end

function GachaSlotItem:EmptyStatus()
    self.Empty:SetVisibility(ESlateVisibility.Visible);
    self.Used:SetVisibility(ESlateVisibility.Collapsed);
    self.selected:SetVisibility(ESlateVisibility.Collapsed);
end

function GachaSlotItem:SelectedStatus()
    ugcprint('set selected');
    self.Empty:SetVisibility(ESlateVisibility.Collapsed);
    self.Used:SetVisibility(ESlateVisibility.Visible);
    self.selected:SetVisibility(ESlateVisibility.Visible);
end
function GachaSlotItem:UsedStatus()
    self.Empty:SetVisibility(ESlateVisibility.Collapsed);
    self.Used:SetVisibility(ESlateVisibility.Visible);
    self.selected:SetVisibility(ESlateVisibility.Collapsed);
end

-- function GachaSlotItem:Destruct()

-- end

return GachaSlotItem