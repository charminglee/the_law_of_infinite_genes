---@class UGCGameState_C:BP_UGCGameState_C
--Edit Below--
UGCGameSystem.UGCRequire('Script.Common.ue_enum_custom')
local UGCGameState = {}; 
local function InitSubControl(mainUI)
    if mainUI.index.topBar.IndexUIControl == nil then
        mainUI.index.topBar.IndexUIControl = mainUI.index
    end
end

function UGCGameState:ReceiveBeginPlay()
    self.SuperClass.ReceiveBeginPlay(self);

    if self:HasAuthority() == true then 
        -- 只有客户端加载UI
    else
        local MainUI = UE.LoadClass( UGCMapInfoLib.GetRootLongPackagePath().. "Asset/Blueprint/Prefabs/WidgetLayout/lobby.lobby_C");
        -- 加载 MainUI 蓝图类
        local PlayerController = GameplayStatics.GetPlayerController(self, 0);
        -- 获得当前PlayerController
        local MainUI_BP = UserWidget.NewWidgetObjectBP(PlayerController, MainUI);
        -- 加载 MainUI
        MainUI_BP:AddToViewport(10000);
        -- 将 MainUI 加入视口，显示UI
        InitSubControl(MainUI_BP);
        -- 隐藏原生界面
        local path = UGCGameSystem.GetUGCResourcesFullPath('Asset/Blueprint/Prefabs/WidgetLayout/hideLayout.hideLayout_C')
        UGCWidgetManagerSystem.SetWidgetLayout(path)
        UGCWidgetManagerSystem.GetMainControlUI().NavigatorPanel:SetVisibility(ESlateVisibility.Collapsed);
        UGCWidgetManagerSystem.GetMainControlUI().Image_0:SetVisibility(ESlateVisibility.Collapsed);
    end

end
-- function UGCGameState:ReceiveTick(DeltaTime)

-- end
-- function UGCGameState:ReceiveEndPlay()
 
-- end


return UGCGameState;
