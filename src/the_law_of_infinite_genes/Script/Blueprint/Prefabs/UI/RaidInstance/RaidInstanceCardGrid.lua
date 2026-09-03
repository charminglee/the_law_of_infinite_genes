---@class RaidInstanceCardGrid_C:UAEUserWidget
---@field CardButton UButton
---@field CardList1 UGC_ReuseList2_C
---@field CardList2 UGC_ReuseList2_C
---@field CardList3 UGC_ReuseList2_C
---@field CardList4 UGC_ReuseList2_C
---@field Collspoce UButton
---@field ShopButton UButton
---@field TextBlock_Coin UTextBlock
---@field TextBlock_Suit1 UTextBlock
---@field TextBlock_Suit2 UTextBlock
---@field TextBlock_Suit3 UTextBlock
---@field TextBlock_Suit4 UTextBlock
--Edit Below--
local RaidInstanceCardGrid = {
    bInitDoOnce = false,
    GroupCardLists = nil,
    EquippedCardMap = nil,
}
function RaidInstanceCardGrid:Construct()
    self:LuaInit();
end
function RaidInstanceCardGrid:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self.CardButton.OnClicked:Add(self.OpenCardUI, self);
    self.ShopButton.OnClicked:Add(self.OpenShopUI, self);
    self.Collspoce.OnClicked:Add(self.TogglePanel, self);
    self.CardList1.OnUpdateItem:Add(self.CardList1Update, self);
    self.CardList2.OnUpdateItem:Add(self.CardList2Update, self);
    self.CardList3.OnUpdateItem:Add(self.CardList3Update, self);
    self.CardList4.OnUpdateItem:Add(self.CardList4Update, self);
    Lib.EventSystem.Listen(Event.OnRepCardData, self.RefreshCardLists, self);
    Lib.EventSystem.Listen(Event.OnCardAutoUpgradeAfter, self.OnCardAutoUpgradeAfter, self);
    self:BuildGroupCardLists();
    self:RefreshEmptyState();
end
function RaidInstanceCardGrid:Destruct()
    Lib.EventSystem.UnlistenByOwner(self);
end
function RaidInstanceCardGrid:BuildGroupCardLists()
    self.GroupCardLists = {{}, {}, {}, {}};
    for cardIndex, card in pairs(CardCfg.Cards) do
        local suit = CardCfg.Suit[card.suit];
        local groupList = self.GroupCardLists[suit.Group];
        if groupList ~= nil then
            table.insert(groupList, cardIndex);
        end
    end
    for _, groupList in ipairs(self.GroupCardLists) do
        table.sort(groupList, function(a, b)
            local cardA = CardCfg.Cards[a];
            local cardB = CardCfg.Cards[b];
            local costA = CardCfg.Grade[cardA.grade].cost;
            local costB = CardCfg.Grade[cardB.grade].cost;
            if costA ~= costB then
                return costA < costB;
            end
            return a < b;
        end);
    end
end
function RaidInstanceCardGrid:SetSuitCounts(counts)
    self.TextBlock_Suit1:SetVisibility(ESlateVisibility.Visible);
    self.TextBlock_Suit2:SetVisibility(ESlateVisibility.Visible);
    self.TextBlock_Suit3:SetVisibility(ESlateVisibility.Visible);
    self.TextBlock_Suit4:SetVisibility(ESlateVisibility.Visible);
    self.TextBlock_Suit1:SetText(tostring(counts[1]) .. "/" .. tostring(#self.GroupCardLists[1]));
    self.TextBlock_Suit2:SetText(tostring(counts[2]) .. "/" .. tostring(#self.GroupCardLists[2]));
    self.TextBlock_Suit3:SetText(tostring(counts[3]) .. "/" .. tostring(#self.GroupCardLists[3]));
    self.TextBlock_Suit4:SetText(tostring(counts[4]) .. "/" .. tostring(#self.GroupCardLists[4]));
    if RaidInstanceManager.MainUI ~= nil then
        RaidInstanceManager.MainUI:SyncSuitCounts(counts, self.GroupCardLists);
    end
end
function RaidInstanceCardGrid:RefreshEmptyState()
    self.EquippedCardMap = {};
    self:SetSuitCounts({0, 0, 0, 0});
    self.CardList1:Reload(#self.GroupCardLists[1]);
    self.CardList2:Reload(#self.GroupCardLists[2]);
    self.CardList3:Reload(#self.GroupCardLists[3]);
    self.CardList4:Reload(#self.GroupCardLists[4]);
end
function RaidInstanceCardGrid:RefreshCardLists()
    self.EquippedCardMap = {};
    local equippedGroupCounts = {0, 0, 0, 0};
    local playerState = UGCGameSystem.GetLocalPlayerState();
    local manager = playerState.PlayerDataManager;
    for slot = 1, CardCfg.Common.EquippedSlotCount do
        local data = manager:GetEquippedCard(slot);
        if data ~= nil then
            local cardIndex = data[1];
            local card = CardCfg.Cards[cardIndex];
            local suit = card and CardCfg.Suit[card.suit];
            if suit ~= nil and equippedGroupCounts[suit.Group] ~= nil then
                equippedGroupCounts[suit.Group] = equippedGroupCounts[suit.Group] + 1;
            end
            local current = self.EquippedCardMap[cardIndex];
            if current == nil or (data[2] or 1) > (current[2] or 1) then
                self.EquippedCardMap[cardIndex] = data;
            end
        end
    end
    self:SetSuitCounts(equippedGroupCounts);
    self.CardList1:Reload(#self.GroupCardLists[1]);
    self.CardList2:Reload(#self.GroupCardLists[2]);
    self.CardList3:Reload(#self.GroupCardLists[3]);
    self.CardList4:Reload(#self.GroupCardLists[4]);
end
function RaidInstanceCardGrid:OnCardAutoUpgradeAfter(UID)
    self:RefreshCardLists();
end

function RaidInstanceCardGrid:UpdateGroupItem(Item, GroupIndex, Index)
    local cardIndex = self.GroupCardLists[GroupIndex][Index + 1];
    Item:SetData(cardIndex, self.EquippedCardMap[cardIndex]);
end
function RaidInstanceCardGrid:CardList1Update(Item, Index)
    self:UpdateGroupItem(Item, 1, Index);
end
function RaidInstanceCardGrid:CardList2Update(Item, Index)
    self:UpdateGroupItem(Item, 2, Index);
end
function RaidInstanceCardGrid:CardList3Update(Item, Index)
    self:UpdateGroupItem(Item, 3, Index);
end
function RaidInstanceCardGrid:CardList4Update(Item, Index)
    self:UpdateGroupItem(Item, 4, Index);
end
function RaidInstanceCardGrid:OpenCardUI()
    GachaManager:OpenMainUI();
end
function RaidInstanceCardGrid:OpenShopUI()
    FightManager:OpenMainUI();
end
function RaidInstanceCardGrid:TogglePanel()
    RaidInstanceManager.MainUI:ShowCardGrid(false);
end
return RaidInstanceCardGrid
