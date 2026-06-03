---@class HomeComponent_C:ActorComponent
---@field MainUIClassPath FSoftClassPath
--Edit Below--
local HomeComponent = {}
-- UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Lobby.HomeManager");
UGCGameSystem.UGCRequire("Script.Common.Common");

function HomeComponent:ReceiveBeginPlay()
    ugcprint('init home');
    HomeComponent.SuperClass.ReceiveBeginPlay(self);
    if self:GetOwner():HasAuthority() == false then
        self:InitHomeUI(self.MainUIClassPath);
    end
end


function HomeComponent:InitHomeUI(MainUIClass)
    -- Common.LoadObjectWithSoftPathAsync(self.MainUIClassPath, 
    --     function (MainUIClass)
    --         if self == nil or MainUIClass == nil then
    --             return;
    --         end
    --         local MainUI = UserWidget.NewWidgetObjectBP(self:GetOwner(), MainUIClass);
    --         MainUI:AddToViewport(0);
    --         MainUI:SetVisibility(ESlateVisibility.Visible);
    --     end
    -- );
        -- -- 加载 MainUI 蓝图类
        -- -- 获得当前PlayerController
            -- local MainUI = UE.LoadClass( UGCMapInfoLib.GetRootLongPackagePath().. "Asset/Blueprint/Prefabs/WidgetLayout/lobby.lobby_C");
        -- -- 加载 MainUI 蓝图类
        -- local PlayerController = GameplayStatics.GetPlayerController(self, 0);
        -- -- 获得当前PlayerController
        -- local MainUI_BP = UserWidget.NewWidgetObjectBP(PlayerController, MainUI);
        -- -- 加载 MainUI
        -- MainUI_BP:AddToViewport(10000);
        -- -- 将 MainUI 加入视口，显示UI
        -- -- 隐藏原生界面
        local MainUI = UE.LoadClass( UGCMapInfoLib.GetRootLongPackagePath().. "Asset/Blueprint/Prefabs/UI/Lobby/Home/HomeMain.HomeMain_C");
        local MainUI_BP = UserWidget.NewWidgetObjectBP(self:GetOwner(), MainUI);
        -- -- 加载 MainUI
        MainUI_BP:AddToViewport(10000);
        -- -- 将 MainUI 加入视口，显示UI
        -- -- 隐藏原生界面
end
return HomeComponent