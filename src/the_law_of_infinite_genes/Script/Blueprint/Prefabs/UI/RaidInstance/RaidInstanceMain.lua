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
    self:ShowCardGrid(true);
    self.RaidInstanceCardGrid:RefreshCardLists();
end
function RaidInstanceMain:OnOpen(...)
    self.RaidInstanceCardGrid:RefreshCardLists();
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
return RaidInstanceMain