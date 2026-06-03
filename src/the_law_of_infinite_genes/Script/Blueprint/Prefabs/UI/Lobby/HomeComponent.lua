---@class HomeComponent_C:ActorComponent
---@field MainUIClassPath FSoftClassPath
--Edit Below--
local HomeComponent = {}
UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Lobby.HomeManager");
UGCGameSystem.UGCRequire("Script.Common.Common");

function HomeComponent:ReceiveBeginPlay()
    ugcprint('init home');
    HomeComponent.SuperClass.ReceiveBeginPlay(self);
    if self:GetOwner():HasAuthority() == false then
        self:InitHomeUI(self.MainUIClassPath);
    end
end


function HomeComponent:InitHomeUI(MainUIClass)
        local MainUI = UE.LoadClass( UGCMapInfoLib.GetRootLongPackagePath().. "Asset/Blueprint/Prefabs/UI/Lobby/Home/HomeMain.HomeMain_C");
        local MainUI_BP = UserWidget.NewWidgetObjectBP(self:GetOwner(), MainUI);
        MainUI_BP:AddToViewport(10000);
end
return HomeComponent