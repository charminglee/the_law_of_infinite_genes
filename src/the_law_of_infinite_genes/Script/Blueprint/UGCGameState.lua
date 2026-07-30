---@class UGCGameState_C:BP_UGCGameState_C
---@field GlobalEventComponent GlobalEventComponent_C
---@field SpecialEventManager SpecialEventManager_C
---@field MobSpawnerManager MobSpawnerManager_C
--Edit Below--
local UGCGameState = {
    isWaiting = true,   -- 在大厅等待阶段时为true，否则为false
}


UGCGameSystem.UGCRequire('Script.Common.ue_enum_custom')
UGCGameSystem.UGCRequire("Script.GameAttribute.game_attribute_type")
UGCGameSystem.UGCRequire("Script.Common.Const")
UGCGameSystem.UGCRequire("Script.Common.Common")
UGCGameSystem.UGCRequire("Script.Lib.Lib")                             
UGCGameSystem.UGCRequire("Script.Common.UGCLog")                       
UGCGameSystem.UGCRequire("Script.Common.TweenManager")                 
UGCGameSystem.UGCRequire("Script.Common.Config")                       
UGCGameSystem.UGCRequire("Script.Common.Card")                         
UGCGameSystem.UGCRequire("Script.Common.GeneTree")
UGCGameSystem.UGCRequire("Script.Common.TimingListUtils")
UGCGameSystem.UGCRequire("Script.Blueprint.UGCGameData")               
UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Lobby.LobbyFlow")
UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.UGCItem.UGCItemManager")


local function InitSubControl(mainUI)
    if mainUI.index.topBar.IndexUIControl == nil then
        mainUI.index.topBar.IndexUIControl = mainUI.index
    end
end


function UGCGameState:ReceiveBeginPlay()
    UGCGameState.SuperClass.ReceiveBeginPlay(self)
    self.bIsOpenShovelingAbility = true
    GameState = self ---@type UGCGameState_C

    if not self:HasAuthority() then 
        -- 原生界面修改
        self:SetUIWidget();
        -- self:SetUIPosition();
    end
end


-- function UGCGameState:ReceiveTick(DeltaTime)
-- end


-- function UGCGameState:ReceiveEndPlay()
-- end


function UGCGameState:IsAllLobbyTeammateReady()
   local bIsUGCPIE = UGCGameSystem.IsUGCPIE();

   local bReady = true
   if bIsUGCPIE then ---PIE 默认全部玩家都是一个大厅队伍
      for _, PlayerState in ipairs(self.PlayerArray) do
         bReady = bReady and PlayerState.bIsReadyInLobby
      end
   else
      local PC = UGCGameSystem.GetLocalPlayerController()

      if PC ~= nil then
         for _, PlayerKey in ipairs(PC.LobbyTeammatePlayerKeys) do
            for _, PlayerState in ipairs(self.PlayerArray) do
               if UGCGameSystem.GetPlayerKeyByPlayerState(PlayerState) == PlayerKey then
                  bReady = bReady and PlayerState.bIsReadyInLobby
                  break
               end
            end
         end
      else
         bReady = false
      end
   end

   return bReady
end


function UGCGameState:SetUIWidget()
    -- UGCWidgetManagerSystem.HideWidget(UGCWidgetManagerSystem.GetMainControlUI());
    local path = UGCGameSystem.GetUGCResourcesFullPath('Asset/Blueprint/MainWidget.MainWidget_C');
    UGCWidgetManagerSystem.SetWidgetLayout(path);
    UGCWidgetManagerSystem.GetMainControlUI().NavigatorPanel:SetVisibility(ESlateVisibility.Collapsed);
    UGCWidgetManagerSystem.GetMainControlUI().Image_0:SetVisibility(ESlateVisibility.Collapsed);
end


function UGCGameState:SetUIPosition()
    local widget = {
        UGCWidgetManagerSystem.GetMainControlUI().CanvasEnterSetting,
        UGCWidgetManagerSystem.GetMainControlUI().Canvas_Speaker,
        UGCWidgetManagerSystem.GetMainControlUI().ChatAndChatPanelCanvas
    };
    local vector2D = {
        {X = -250, Y = 52},
        {X = -250, Y = 104},
        {X = -350, Y = 156},
    };
    for k, v in pairs(widget) do
        UGCWidgetManagerSystem.SlotAsCanvasSlot(v):SetPosition(vector2D[k]);
    end
end


---【服务端】开始游戏。
function UGCGameState:StartGame()
    if not self:HasAuthority() then
        return
    end
    self.isWaiting = false
    self.MobSpawnerManager:NextWave()
end


---【服务端】结束游戏。
function UGCGameState:EndGame()
    if not self:HasAuthority() or self.isWaiting then
        return
    end
    self.isWaiting = true
end


--【客户端】佩戴称号广播事件。
function UGCGameState:MulticastRPC_EquippedTitle(uid, id)
    ACHVManager.CacheEquippedTitle = id;
end


-- 是否在大厅中
function UGCGameState.IsInLobby()
   return UGCGameData.GetGameModeName(UGCMultiMode.GetModeID()) == UGCGameData.ModeName.Lobby
end


return UGCGameState
