---@class RaidInstanceMain_C:UAEUserWidget
---@field Bonus_2 UTextBlock
---@field Bonus_3 UTextBlock
---@field Bouns_1 UTextBlock
---@field Monster UTextBlock
---@field RaidInstanceCardGrid RaidInstanceCardGrid_C
---@field RaidInstanceShopGrid RaidInstanceShopGrid_C
---@field Score UTextBlock
---@field Wave UTextBlock
--Edit Below--
local RaidInstanceMain = { bInitDoOnce = false } 

function RaidInstanceMain:Construct()
	self:LuaInit();
end

function RaidInstanceMain:LuaInit()
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true;
    RaidInstanceManager:RegisterMainUI(self);
    Lib.EventSystem.Listen(Event.OnCoinChangeAfter, self.OnCoinChangeAfter, self);
    self:RefreshResourceCoin();
    self:ShowCardGrid(true);
end
function RaidInstanceMain:Destruct()
    Lib.EventSystem.UnlistenByOwner(self);
end
function RaidInstanceMain:OnOpen(...)
    self:RefreshResourceCoin();
    UnrealNetwork.CallUnrealRPC(LocalPlayerController, GachaManager.ComponentClass, "ResetCardData", LocalPlayerController.PlayerKey);
end
function RaidInstanceMain:Exit()
    RaidInstanceManager:CloseMainUI();
end
function RaidInstanceMain:ShowCardGrid(showCardGrid)
    self.RaidInstanceCardGrid:SetVisibility(showCardGrid
            and ESlateVisibility.Visible or ESlateVisibility.Collapsed);
    self.RaidInstanceShopGrid:SetVisibility(showCardGrid
            and ESlateVisibility.Collapsed or ESlateVisibility.Visible);
end
function RaidInstanceMain:SyncSuitCounts(counts, groupCardLists)
    self.RaidInstanceShopGrid:SetSuitCounts(counts, groupCardLists);
end
function RaidInstanceMain:RefreshResourceCoin()
    local playerState = UGCGameSystem.GetLocalPlayerState();
    local value = playerState.PlayerDataManager:GetCoin(ItemId.Coin_6);
    self.RaidInstanceCardGrid:SetResourceCoin(value);
    self.RaidInstanceShopGrid:SetResourceCoin(value);
end
function RaidInstanceMain:OnCoinChangeAfter(UID, CoinId, OldValue, NewValue)
    if CoinId == ItemId.Coin_6 then
        self.RaidInstanceCardGrid:SetResourceCoin(NewValue);
        self.RaidInstanceShopGrid:SetResourceCoin(NewValue);
    end
end
return RaidInstanceMain
