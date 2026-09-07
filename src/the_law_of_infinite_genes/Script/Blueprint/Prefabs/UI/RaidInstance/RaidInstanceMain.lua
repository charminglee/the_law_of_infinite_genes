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
local RaidInstanceMain = {
    bInitDoOnce = false,
}

local function FormatMultiplier(value)
    return tostring(math.floor(value * 100 + 0.5)) .. "%";
end

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
    Lib.EventSystem.Listen(Event.OnRemainingMobCountChanged, self.OnRemainingMobCountChanged, self);
    Lib.EventSystem.Listen(Event.OnWaveStart, self.OnWaveStart, self);
    self:RefreshResourceCoin();
    self:RefreshCombatInfo();
    self:ShowCardGrid(true);
end
function RaidInstanceMain:Destruct()
    Lib.EventSystem.UnlistenByOwner(self);
end
function RaidInstanceMain:OnOpen(...)
    self:RefreshResourceCoin();
    self:RefreshCombatInfo();
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
function RaidInstanceMain:RefreshCombatInfo()
    self:RefreshRemainingMobCount(GameState:GetRemainingMobCount());
    if GameState.MobSpawnerManager ~= nil then
        self:RefreshWave(GameState:GetWaveIndex());
    end
end
function RaidInstanceMain:RefreshRemainingMobCount(count)
    self.Monster:SetText(string.format('剩余怪物:%s只', tostring(count)));
end
function RaidInstanceMain:OnRemainingMobCountChanged(OldCount, NewCount)
    self:RefreshRemainingMobCount(NewCount);
end
function RaidInstanceMain:OnWaveStart(waveIndex)
    self:RefreshWave(waveIndex);
end
function RaidInstanceMain:RefreshWave(waveIndex)
    self.Wave:SetText(string.format('第%s关', tostring(waveIndex)));
    self:RefreshMonsterMultipliers(waveIndex);
end
function RaidInstanceMain:RefreshMonsterMultipliers(waveIndex)
    self.Bouns_1:SetText(FormatMultiplier(GameState:GetMonsterAttackMultiplier(waveIndex)));
    self.Bonus_2:SetText(FormatMultiplier(GameState:GetMonsterDefenseMultiplier(waveIndex)));
    self.Bonus_3:SetText(FormatMultiplier(GameState:GetMonsterHealthMultiplier(waveIndex)));
end
return RaidInstanceMain
