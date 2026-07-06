---@class FirearmPurchaseLTabItem_C:UUserWidget
---@field Button_0 UButton
---@field Item UImage
---@field selected UCanvasPanel
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
    FightManager.TabSelectIndex = self.Index;
end

function FirearmPurchaseLTabItem:SetSelected(Visible)
    self.selected:SetVisibility(Visible);
end

function FirearmPurchaseLTabItem:SetIcon()
    local path = FightManager.LTabIconList[self.Index+1].path;
    local Texture = LoadObject(path);
    self.Item:SetBrushFromTexture(Texture);
end

return FirearmPurchaseLTabItem