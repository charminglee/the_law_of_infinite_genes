---@class RaidInstanceShopGrid_C:UAEUserWidget
---@field CardButton UButton
---@field Collspoce UButton
---@field ShopButton UButton
---@field TextBlock_Coin UTextBlock
---@field TextBlock_Suit1 UTextBlock
---@field TextBlock_Suit2 UTextBlock
---@field TextBlock_Suit3 UTextBlock
---@field TextBlock_Suit4 UTextBlock
--Edit Below--
local RaidInstanceShopGrid = { bInitDoOnce = false }

function RaidInstanceShopGrid:Construct()
    self:LuaInit();
end

function RaidInstanceShopGrid:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self.CardButton.OnClicked:Add(self.OpenCardUI, self);
    self.ShopButton.OnClicked:Add(self.OpenShopUI, self);
    self.Collspoce.OnClicked:Add(self.TogglePanel, self);
    self.TextBlock_Suit1:SetVisibility(ESlateVisibility.Visible);
    self.TextBlock_Suit2:SetVisibility(ESlateVisibility.Visible);
    self.TextBlock_Suit3:SetVisibility(ESlateVisibility.Visible);
    self.TextBlock_Suit4:SetVisibility(ESlateVisibility.Visible);
end

function RaidInstanceShopGrid:SetSuitCounts(counts, groupCardLists)
    self.TextBlock_Suit1:SetText(tostring(counts[1]) .. "/" .. tostring(#groupCardLists[1]));
    self.TextBlock_Suit2:SetText(tostring(counts[2]) .. "/" .. tostring(#groupCardLists[2]));
    self.TextBlock_Suit3:SetText(tostring(counts[3]) .. "/" .. tostring(#groupCardLists[3]));
    self.TextBlock_Suit4:SetText(tostring(counts[4]) .. "/" .. tostring(#groupCardLists[4]));
end

function RaidInstanceShopGrid:OpenCardUI()
    GachaManager:OpenMainUI();
end

function RaidInstanceShopGrid:OpenShopUI()
    FightManager:OpenMainUI();
end

function RaidInstanceShopGrid:TogglePanel()
    RaidInstanceManager.MainUI:ShowCardGrid(true);
end

return RaidInstanceShopGrid
