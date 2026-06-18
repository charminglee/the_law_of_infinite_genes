---@class FirearmPurchaseLTabItem_C:UUserWidget
---@field Button_0 UButton
---@field Image_2 UImage
---@field Image_3 UImage
---@field Image_4 UImage
---@field selected UCanvasPanel
---@field tabImage_0 UImage
---@field TextBlock_43 UTextBlock
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

function FirearmPurchaseLTabItem:SetTabIcon(Path)
    local Texture = LoadObject(Path);
    self.tabImage_0:SetBrushFromTexture(Texture, true);
end

function FirearmPurchaseLTabItem:SetText(text)
    self.TextBlock_43:SetText(text);
end

return FirearmPurchaseLTabItem