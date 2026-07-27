---@class HomeComponent_C:ActorComponent
---@field MainUIClassPath FSoftClassPath
--Edit Below--
local HomeComponent = {}
UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Lobby.HomeManager");

function HomeComponent:ReceiveBeginPlay()
    HomeComponent.SuperClass.ReceiveBeginPlay(self);
end

return HomeComponent