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
        self:InitHomeUI();
    end
end


function HomeComponent:InitHomeUI()
    Common.LoadObjectWithSoftPathAsync(self.MainUIClassPath, 
        function (MainUIClass)
            if self == nil or MainUIClass == nil then
                return;
            end

            local MainUI = UserWidget.NewWidgetObjectBP(self:GetOwner(), MainUIClass);
            MainUI:AddToViewport(0);
            MainUI:SetVisibility(ESlateVisibility.Visible);
        end
    );
end
return HomeComponent