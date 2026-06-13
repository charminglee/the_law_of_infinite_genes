---@class FirearmPurchaseLTabItem_C:UUserWidget
---@field Button_0 UButton
---@field Image_2 UImage
---@field Image_3 UImage
---@field Image_4 UImage
---@field selected UCanvasPanel
---@field tabImage_0 UImage
---@field tabImage_1 UImage
---@field tabImage_2 UImage
---@field tabImage_3 UImage
---@field tabImage_4 UImage
--Edit Below--
local FirearmPurchaseLTabItem = { 
    bInitDoOnce = false,
     Index=nil,
     } 

function FirearmPurchaseLTabItem:Construct()
	self:LuaInit();
end

function FirearmPurchaseLTabItem:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
    self:Listen();
end

function FirearmPurchaseLTabItem:Listen()
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);
end

function FirearmPurchaseLTabItem:Button_0_Clicked()
    ugcprint('clicked index is:'..tostring(self.Index));
    FightManager.LTabListSelectedIndex = self.Index;
end

function FirearmPurchaseLTabItem:SetSelectedVisible(Visible)
    if Visible == true then
        self.selected:SetVisibility(ESlateVisibility.Visible);
    else
        self.selected:SetVisibility(ESlateVisibility.Collapsed);
    end
end

function FirearmPurchaseLTabItem:SetTabIcon(path)
    -- self.tabImage_0:SetBrushFromTexture(path);
    for i = 0, 4, 1 do
        local ImageVar = 'tabImage_'..tostring(i);
        ugcprint(ImageVar);
        if self.Index == i then
            self[ImageVar]:SetVisibility(ESlateVisibility.Visible);
        else
            self[ImageVar]:SetVisibility(ESlateVisibility.Collapsed);
        end
    end
end

return FirearmPurchaseLTabItem