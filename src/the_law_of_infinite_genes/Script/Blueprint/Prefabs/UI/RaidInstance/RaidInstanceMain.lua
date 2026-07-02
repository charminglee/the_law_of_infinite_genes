---@class RaidInstanceMain_C:UAEUserWidget
---@field CardButton UButton
---@field ShopButton UButton
local RaidInstanceMain = { bInitDoOnce = false } 

function RaidInstanceMain:Construct()
	self:LuaInit();
end

function RaidInstanceMain:LuaInit()
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true;
    self:Listen();
    RaidInstanceManager:RegisterMainUI(self);
end

function RaidInstanceMain:Listen()
    self.CardButton.OnClicked:Add(self.OpenCardUI, self);
    self.ShopButton.OnClicked:Add(self.OpenShopUI, self);
end

function RaidInstanceMain:OpenCardUI()
    GachaManager:OpenMainUI();    
end

function RaidInstanceMain:OpenShopUI()
    FightManager:OpenMainUI();
end

return RaidInstanceMain