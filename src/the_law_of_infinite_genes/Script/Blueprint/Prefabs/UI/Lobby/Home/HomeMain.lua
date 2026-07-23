---@class HomeMain_C:UserWidgetLayout
---@field Button_46 UButton
---@field Button_CancelMatch UButton
---@field Button_CancelReady UButton
---@field Button_DifficultySelect UButton
---@field Button_Ready UButton
---@field Button_Show UButton
---@field CanvasPanel_CancelReady UCanvasPanel
---@field CanvasPanel_Difficulty UCanvasPanel
---@field CanvasPanel_Matching UCanvasPanel
---@field CanvasPanel_ModeSelect UCanvasPanel
---@field CanvasPanel_Ready UCanvasPanel
---@field CanvasPanel_SelectDifficult UCanvasPanel
---@field CanvasPanel_StartGAME UCanvasPanel
---@field CanvasPanel_Time UCanvasPanel
---@field Challenge UCanvasPanel
---@field FillTeammateCheckBox UCheckBox
---@field FillTeammatePanel UCanvasPanel
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
		self.WidgetSwitcher_Matching:SetActiveWidgetIndex(0);
	elseif modeId == 1002 then
		self.CanvasPanel_StartGAME:SetVisibility(ESlateVisibility.Hidden);
	end
end

function HomeMain:Listen()
	self.Button_46.OnClicked:Add(self.Button_46_OnClicked, self);

	self.Button_Show.OnClicked:Add(self.OnMatchClicked, self);
    self.Button_CancelMatch.OnClicked:Add(self.OnCancelMatchClicked, self);
    self.Button_Ready.OnClicked:Add(self.OnReadyClicked, self);
    self.Button_CancelReady.OnClicked:Add(self.OnCancelReadyClicked,self);
end

function HomeMain:Button_46_OnClicked()
	UnrealNetwork.CallUnrealRPC(LocalPlayerController, GachaManager.ComponentClass, "ResetCardData", LocalPlayerController.PlayerKey);
	RaidInstanceManager:OpenMainUI();
end

-- 开始匹配
function HomeMain:OnMatchClicked()
	UGCWidgetManagerSystem.ShowTipsUI('开始挑战，请耐心等待');
    UGCMultiMode.RequestMatch(1002, self.MatchResCallBack, self, true)
end

-- 取消匹配
function HomeMain:OnCancelMatchClicked()

end

-- 准备
function HomeMain:OnReadyClicked()

end

-- 取消准备
function HomeMain:OnCancelReadyClicked()

end

-- 匹配结束回调
function HomeMain:MatchResCallBack(res)

end

return HomeMain