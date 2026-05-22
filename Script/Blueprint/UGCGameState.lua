---@class UGCGameState_C:BP_UGCGameState_C
--Edit Below--
UGCGameSystem.UGCRequire('Script.Common.ue_enum_custom')
local UGCGameState = {}; 
function UGCGameState:ReceiveBeginPlay()
    if self:HasAuthority() == true then 
            -- 只有客户端加载UI
    else
        local MainUI = UE.LoadClass( UGCMapInfoLib.GetRootLongPackagePath().. "Asset/Blueprint/Prefabs/WidgetLayout/lobby.lobby_C");
        print("Load MainUI Class");
        -- 加载 MainUI 蓝图类

        local PlayerController = GameplayStatics.GetPlayerController(self, 0);
        print("Get Player Controller");
        -- 获得当前PlayerController

        local MainUI_BP = UserWidget.NewWidgetObjectBP(PlayerController, MainUI);
        print("Load MainUI_BP");
        -- 加载 MainUI

        MainUI_BP:AddToViewport();
        print("MainUI_BP AddToViewport");
        -- 将 MainUI 加入视口，显示UI

        local path = UGCGameSystem.GetUGCResourcesFullPath('Asset/Blueprint/Prefabs/WidgetLayout/hideLayout.hideLayout_C')
        UGCWidgetManagerSystem.SetWidgetLayout(path)

        UGCWidgetManagerSystem.GetMainControlUI().NavigatorPanel:SetVisibility(ESlateVisibility.Collapsed);
        UGCWidgetManagerSystem.GetMainControlUI().Image_0:SetVisibility(ESlateVisibility.Collapsed);

        -- UGCWidgetManagerSystem.GetMainControlUI().CanvasPanel_MiniMapAndSetting:SetVisibility(1);
        -- -- UGCWidgetManagerSystem.GetMainControlUI().CanvasPanelSurviveKill:SetVisibility(1);
        -- UGCWidgetManagerSystem.GetMainControlUI().InvalidationBox_3:SetVisibility(1);

    end
end
-- function UGCGameState:ReceiveTick(DeltaTime)

-- end
-- function UGCGameState:ReceiveEndPlay()
 
-- end
return UGCGameState;
