---@class RaidInstanceMain_C:UAEUserWidget
---@field RaidInstanceCardGrid RaidInstanceCardGrid_C
---@field RaidInstanceShopGrid RaidInstanceShopGrid_C
---@field RaidInstanceTop RaidInstanceTop_C
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
    self.RaidInstanceTop:SetVisibility(ESlateVisibility.Collapsed);
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
