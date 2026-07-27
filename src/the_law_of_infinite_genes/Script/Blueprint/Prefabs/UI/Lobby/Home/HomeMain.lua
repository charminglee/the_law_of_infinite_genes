---@class HomeMain_C:UserWidgetLayout
---@field Button_46 UButton
---@field Button_CancelMatch UButton
---@field Button_CancelReady UButton
---@field Button_DifficultySelect UButton
---@field Button_Ready UButton
---@field Button_Show UButton
---@field CanvasPanel_CancelReady UCanvasPanel
---@field CanvasPanel_Matching UCanvasPanel
---@field CanvasPanel_Ready UCanvasPanel
---@field CanvasPanel_SelectDifficult UCanvasPanel
---@field CanvasPanel_Time UCanvasPanel
---@field Challenge UCanvasPanel
---@field FillTeammateCheckBox UCheckBox
---@field FillTeammatePanel UCanvasPanel
---@field GamePanel UVerticalBox
---@field HomeToolBar HomeToolBar_C
---@field HomeUserInfo HomeUserInfo_C
---@field ImageEx_GameMode UImage
---@field NewButton_ModeSelect UButton
---@field TextBlock_Auto UTextBlock
---@field TextBlock_Countdown UTextBlock
---@field TextBlock_Difficult UTextBlock
---@field TextBlock_MatchingTime UTextBlock
---@field TextBlock_ModeName UTextBlock
---@field UGC_ReuseList2_Difficulty UGC_ReuseList2_C
---@field WidgetSwitcher_Arrow UWidgetSwitcher
---@field WidgetSwitcher_Matching UWidgetSwitcher
---@field WidgetSwitcher_Time UWidgetSwitcher
--Edit Below--
local HomeMain = {
	bInitDoOnce = false,
} 

function HomeMain:Construct()
	self:LuaInit();
end

function HomeMain:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
    self.HomeToolBar.parent = self;
	HomeManager:RegisterMainUI(self);
	local ModeID = UGCMultiMode.GetModeID()
	self:InitMode(ModeID)
	self:Listen();
end

function HomeMain:InitMode(modeId)
    if modeId == 1001 then
		self:ToggleDifficulty(false);
	elseif modeId == 1002 then
		self.GamePanel:SetVisibility(ESlateVisibility.Collapsed);
        self.HomeToolBar:SetVisibility(ESlateVisibility.Collapsed);
	end
end

function HomeMain:Listen()
	self.Button_46.OnClicked:Add(self.Button_46_OnClicked, self);

	self.Button_Show.OnClicked:Add(self.OnMatchClicked, self);
    self.Button_CancelMatch.OnClicked:Add(self.OnCancelMatchClicked, self);
    self.Button_Ready.OnClicked:Add(self.OnReadyClicked, self);
    self.Button_CancelReady.OnClicked:Add(self.OnCancelReadyClicked,self);
	self.Button_DifficultySelect.OnClicked:Add(self.OnDifficultySelectClicked, self)

    self.UGC_ReuseList2_Difficulty.OnAfterNewItem:Add(self.UGC_ReuseList2_Difficulty_OnAfterNewItem, self)
end

function HomeMain:OnUpdate(Data)
    self.Data = Data

    -- 更新模式信息
    self:UpdateMode()
    -- 更新匹配信息
    self:UpdateMatch()
    -- 更新难度信息
    self:UpdateDifficulty()

    local PC = UGCGameSystem.GetLocalPlayerController()
    if PC ~= nil and UGCGameSystem.GetPlayerStateByPlayerController(PC) ~= nil then
        if UGCGameSystem.GetPlayerStateByPlayerController(PC).bIsLobbyTeamLeader then
            self.WidgetSwitcher_Matching:SetActiveWidgetIndex(0)
        elseif UGCGameSystem.GetPlayerStateByPlayerController(PC) then
            self.WidgetSwitcher_Matching:SetActiveWidgetIndex(UGCGameSystem.GetPlayerStateByPlayerController(PC).bIsReadyInLobby and 2 or 1)
        else
            self.WidgetSwitcher_Matching:SetActiveWidgetIndex(1)
        end

        self.FillTeammateCheckBox:SetIsChecked(PC.LobbyInfo.bFillTeammate) 
    end
end

-- 更新模式
function HomeMain:UpdateMode()
    -- print("UGC_Lobby_Main_UIBP:UpdateMode Data.ModeID="..tostring(self.Data.ModeID) .. "CurrentSelectedModeID=" .. tostring( LobbyModel:GetCurrentSelectedModeID()))
    -- local ModeID = self.Data.ModeID or LobbyModel:GetCurrentSelectedModeID()
    -- local ModeConfig = LobbyModel:GetModeConfig(ModeID)

    -- -- 刷新模式名称
    -- self.TextBlock_ModeName:SetText(LobbyUtils.GetTrimmedString(ModeConfig.ModeName, 6))

    -- -- 刷新模式图标
    -- self.ImageEx_GameMode:SetBrushFromTexture(ModeConfig.ModeBanner, false)

    -- --单人模式无需匹配队友
    -- local ModeMaxPlayerNum = UGCMultiMode.GetModeSetting(LobbyModel.CurrentSelectedModeID).TeamPlayers
    -- if ModeMaxPlayerNum <= 1 then
    --     self.FillTeammatePanel:SetVisibility(ESlateVisibility.Collapsed)
    -- else
    --     self.FillTeammatePanel:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    -- end
end

-- 更新匹配
function HomeMain:UpdateMatch()
    if self.Data.bIsMatching == nil then
        return
    end

    if self.Data.bIsMatching then
        self.Challenge:SetVisibility(ESlateVisibility.Collapsed);
        self.CanvasPanel_Matching:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
        self.WidgetSwitcher_Matching:SetVisibility(ESlateVisibility.Collapsed);

        if not self.MatchingTimer then
            self.TextBlock_MatchingTime:SetText("00:00");
            self.MatchingStartTime = os.time();
            self.MatchingTimer = UGCTimerUtility.CreateLuaTimer(1, function()
                UGCSoundManagerSystem.PlaySound2D(UE.LoadObject('/Game/UGC/Repository/CG032/PVPTemplate/Audio/WwiseEvent/Play_UGC_Mode_SkillPVP_UI_Countdown.Play_UGC_Mode_SkillPVP_UI_Countdown'));
                local MatchingPassTime = os.time() - self.MatchingStartTime;
                self.TextBlock_MatchingTime:SetText(string.format("%02d:%02d", MatchingPassTime // 60, MatchingPassTime % 60));
            end, true);
        end
    else
        self.Challenge:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
        self.CanvasPanel_Matching:SetVisibility(ESlateVisibility.Collapsed);
        self.WidgetSwitcher_Matching:SetVisibility(ESlateVisibility.SelfHitTestInvisible);

        if self.MatchingTimer then
            UGCTimerUtility.RemoveLuaTimer(self.MatchingTimer);
            self.MatchingTimer = nil;
        end
    end
end

-- 更新难度
function HomeMain:UpdateDifficulty()
    if self.Data.Difficulty or LobbyModel:GetCurrentSelectedDifficulty() then
        local Difficulty = self.Data.Difficulty or LobbyModel:GetCurrentSelectedDifficulty()
        self.TextBlock_Difficult:SetText(Difficulty)
        self:ToggleDifficulty(false)
    end
    self.UGC_ReuseList2_Difficulty:Reload(#LobbyModel:GetModeListWithSameDetailID())
end

-- 刷新匹配按钮
function HomeMain:RefreshMatchButton(bIsLeader)
    self.WidgetSwitcher_Matching:SetActiveWidgetIndex(bIsLeader and 0 or 1);
end

function HomeMain:Button_46_OnClicked()
	UnrealNetwork.CallUnrealRPC(LocalPlayerController, GachaManager.ComponentClass, "ResetCardData", LocalPlayerController.PlayerKey);
	RaidInstanceManager:OpenMainUI();
end

-- 难度列表刷新
function HomeMain:UGC_ReuseList2_Difficulty_OnAfterNewItem(Widget, Idx)
    Idx = Idx + 1

    local ModeID = LobbyModel:GetCurrentSelectedModeID()

    local ModeConfig = LobbyModel:GetModeListWithSameDetailID(ModeID)[Idx]
    local Difficulty = ModeConfig.Difficulty
    local bIsLocked = LobbyModel:IsModeLocked(ModeConfig.ModeID)

    Widget:OnUpdate({
        Idx = Idx,
        Difficulty = Difficulty,
        bIsLocked = bIsLocked,
        ModeConfig = ModeConfig,
        bTipsIsLeft = false,
        FocusedMode = ModeID,
        bIsBig = true
    })
end

-- 开始匹配
function HomeMain:OnMatchClicked()
    -- local ModeMaxPlayerNum = UGCMultiMode.GetModeSetting(LobbyModel.CurrentSelectedModeID).TeamPlayers
    local PlayerController = UGCGameSystem.GetLocalPlayerController()
    -- local CurPlayerNum = #PlayerController.LobbyTeammatePlayerKeys
    
    -- if not PlayerController.LobbyInfo.bTeamComplete then
    --     UGCWidgetManagerSystem.ShowTipsUI("队伍有成员退出，请退出玩法重新进入")
    --     return
    -- end

    -- if CurPlayerNum > ModeMaxPlayerNum then
    --     UGCWidgetManagerSystem.ShowTipsUI("当前人数大于模式最大人数!")
    --     return;
    -- end

    local bLeader = PlayerController.bIsTeamLeader
    if bLeader then
        if not UGCGameSystem.GameState:IsAllLobbyTeammateReady() then
            UGCWidgetManagerSystem.ShowTipsUI("有队友未准备，不能开始匹配!")
            return
        end
    end

    LobbyModel:RequestMatch(not self.FillTeammateCheckBox:IsChecked())
end

-- 取消匹配
function HomeMain:OnCancelMatchClicked()
	LobbyModel:CancelMatch();
end

-- 准备
function HomeMain:OnReadyClicked()
    local PlayerController = UGCGameSystem.GetLocalPlayerController()

    -- UGCWidgetManagerSystem.ShowTipsUI("已准备")
    PlayerController:SetLobbyReadyStatus(true)
end

-- 取消准备
function HomeMain:OnCancelReadyClicked()
    local PlayerController = UGCGameSystem.GetLocalPlayerController()

    -- UGCWidgetManagerSystem.ShowTipsUI("已取消准备")
    PlayerController:SetLobbyReadyStatus(false)
end

-- 匹配结束回调
function HomeMain:MatchResCallBack(res)

end

-- 选择难度
function HomeMain:OnDifficultySelectClicked()
    if LobbyModel:IsMatching() then
        UGCWidgetManagerSystem.ShowTipsUI("匹配中无法设置")
        return
    end

    local PC = UGCGameSystem.GetLocalPlayerController()
    if PC and not PC.bIsTeamLeader then
        UGCWidgetManagerSystem.ShowTipsUI("只有队长才能选择难度")
        return
    end

    self:ToggleDifficulty();
end

-- 切换难度
function HomeMain:ToggleDifficulty(bExpand)
    local bIsExpanded = self.CanvasPanel_SelectDifficult:GetVisibility() == ESlateVisibility.Visible;

    -- 如果 bExpand 没有定义，则根据当前的展开状态切换
    if bExpand == nil then
        bExpand = not bIsExpanded;
    end

    -- 根据 bExpand 的值设置箭头索引和可见性
    self.WidgetSwitcher_Arrow:SetActiveWidgetIndex(bExpand and 1 or 0);
    self.CanvasPanel_SelectDifficult:SetVisibility(bExpand and ESlateVisibility.Visible or ESlateVisibility.Collapsed);
end

return HomeMain