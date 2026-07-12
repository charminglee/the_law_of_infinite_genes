---@class ComposeGoodsItem_C:UAEUserWidget
---@field Button_0 UButton
---@field Item UImage
---@field ItemName UTextBlock
---@field quality UImage
--Edit Below--
local ComposeGoodsItem = {
    bInitDoOnce = false,
    Index = nil,
}

function ComposeGoodsItem:Construct()
    self:LuaInit();
end

function ComposeGoodsItem:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self:Listen();
end

function ComposeGoodsItem:Listen()
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);
end

function ComposeGoodsItem:Button_0_Clicked()
    ComposeManager.SelectedIndex = self.Index;
end

function ComposeGoodsItem:SetItem(ItemId)
    local formula = Config.Formula[ItemId];

end

return ComposeGoodsItem