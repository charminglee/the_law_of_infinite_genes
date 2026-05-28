---@class storeBtn_C:UUserWidget
---@field border UImage
---@field Button_0 UButton
---@field Image_3 UImage
---@field selected UImage
---@field TextBlock_0 UTextBlock
---@field un_selected UImage
--Edit Below--
local storeBtn = { bInitDoOnce = false, idx=nil, paternal=nil} 

function storeBtn:Construct()
	self:LuaInit();
end

function storeBtn:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
    self:ListenEvent();
end

function storeBtn:ListenEvent()
    self.Button_0.OnClicked:Add(self.ButtonClick, self)
end


function storeBtn:ButtonClick()
    self.paternal:changeSelected(self.idx)
    self.paternal:changePanel(self.idx)
end

function storeBtn:switchSelected(is_visible, x, y, px, py)
    self.Image_3:SetVisibility(is_visible);
    self.selected:SetVisibility(ESlateVisibility.Collapsed);
    self.un_selected:SetVisibility( is_visible);
    self.border:SetVisibility(is_visible);
end
return storeBtn