---@class RaidInstanceMain_C:UAEUserWidget
---@field Button_0 UButton
---@field CardButton UButton
---@field Image_35 UImage
---@field Image_36 UImage
---@field Image_37 UImage
---@field Image_38 UImage
---@field Right UCanvasPanel
---@field ShopButton UButton
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
    self:Listen();
    RaidInstanceManager:RegisterMainUI(self);
end

function RaidInstanceMain:Listen()
    self.CardButton.OnClicked:Add(self.OpenCardUI, self);
    self.ShopButton.OnClicked:Add(self.OpenShopUI, self);
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);
end

function RaidInstanceMain:OnOpen(...)
    UnrealNetwork.CallUnrealRPC(LocalPlayerController, GachaManager.ComponentClass, "ResetCardData", LocalPlayerController.PlayerKey);
end

function RaidInstanceMain:OpenCardUI()
    GachaManager:OpenMainUI();
        
end

function RaidInstanceMain:Exit()
    RaidInstanceManager:CloseMainUI();
end

function RaidInstanceMain:OpenShopUI()
    FightManager:OpenMainUI();
end

function RaidInstanceMain:Button_0_Clicked()
    UGCGameSystem.GetLocalPlayerController():OnGameSettle();
end

return RaidInstanceMain