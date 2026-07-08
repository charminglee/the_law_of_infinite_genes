---@class FirearmPurchaseLBItem_C:UUserWidget
---@field border UImage
---@field Button_0 UButton
---@field Item UImage
---@field ItemName UTextBlock
---@field Normal UCanvasPanel
---@field Selected UCanvasPanel
--Edit Below--
local FirearmPurchaseLBItem = { 
    bInitDoOnce = false,
    Index=nil,
}

function FirearmPurchaseLBItem:Construct()
	self:LuaInit();
end

function FirearmPurchaseLBItem:LuaInit()
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true;
    self:Listen();
end

function FirearmPurchaseLBItem:Listen()
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);
end

function FirearmPurchaseLBItem:Button_0_Clicked()
    FightManager.PurchaseSelectIndex = self.Index;
end

function FirearmPurchaseLBItem:SetSelected(Visible)
    self.Selected:SetVisibility(Visible);
end

function FirearmPurchaseLBItem:SetItemData(ItemId)
    local ImagePath = UGCItemSystemV2.GetItemIconTextureV2(ItemId);
    local ItemName = UGCItemSystemV2.GetItemNameV2(ItemId);
    local Texture = LoadObject(ImagePath.AssetPathName);
    self.Item:SetBrushFromTexture(Texture);
    self.ItemName:SetText(ItemName);
end

return FirearmPurchaseLBItem