---@class lobby_C:UserWidgetLayout
---@field aniBtn UButton
---@field gameMode gameMode_C
---@field playerItem playerItem_C
---@field RechargeMenu ReuseList2_C
---@field TabMenu ReuseList2_C
---@field LobbyTabs ULuaArrayHelper<FLobbyTabs__pf2327386574>
---@field SelectedTabID int32
---@field RechargeTabs ULuaArrayHelper<FRechargeTabs__pf2327386574>
---@field SelectedRechargeID int32
--Edit Below--
local lobby = { 
	bInitDoOnce = false;
	TabInfos = {};
    TabButtons = {};

    RechargeTabInfos = {};
    RechargeTabButtons = {};
} 

function lobby:Construct()
	self:LuaInit();
end

function lobby:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;

	self.TabMenu.OnUpdateItem:Add(self.RefreshTabMenuButton, self);
    self.RechargeMenu.OnUpdateItem:Add(self.RefreshRechargeMenuButton, self);
    self.aniBtn.OnClicked:Add(self.AniBtn_OnClicked, self);

	self:RefreshLobbyTabs()
	self:RefreshRechargeTabs()

end

-- function lobby:Tick(MyGeometry, InDeltaTime)

-- end

-- function lobby:Destruct()

-- end

function lobby:RefreshLobbyTabs()
    local bHasSelectedTabID = false;
    self.TabInfos = {};
    for i, Tab in ipairs(self.LobbyTabs) do
        local TabInfo = {};
        TabInfo.TabID       = Tab.TabID;
        TabInfo.TabName     = Tab.TabName;
        TabInfo.TabDesc = Tab.TabDesc;
        table.insert(self.TabInfos, TabInfo);
        if TabInfo.TabID == self.SelectedTabID then
            bHasSelectedTabID = true;
        end
    end
    if bHasSelectedTabID == false then
        self.SelectedTabID = self.TabInfos[1].TabID;
    end
    self.TabMenu:Reload(#self.TabInfos);
end

function lobby:RefreshRechargeTabs()
    local bHasSelectedTabID = false;
    self.RechargeTabInfos = {};
    for i, Tab in ipairs(self.RechargeTabs) do
        local TabInfo = {};
        TabInfo.TabID       = Tab.TabID;
        TabInfo.TabName     = Tab.TabName;
        TabInfo.TabDesc = Tab.TabDesc;
        table.insert(self.RechargeTabInfos, TabInfo);
        if TabInfo.TabID == self.SelectedRechargeID then
            bHasSelectedTabID = true;
        end
    end
    if bHasSelectedTabID == false then
        self.SelectedRechargeID = self.RechargeTabInfos[1].TabID;
    end
    self.RechargeMenu:Reload(#self.RechargeTabInfos);
end

function lobby:RefreshTabMenuButton(TabButton, Idx)
	if TabButton.paternal == nil then
		TabButton.paternal = self;
	end
    TabButton:SetupTabInfo(self.TabInfos[Idx+1]);
    if TabButton.TabID == self.SelectedTabID then
        TabButton:Select();
    else
        TabButton:Deselect(self.TabInfos[Idx+1].Tab);
    end
    self.TabButtons[TabButton.TabID] = TabButton;
end

function lobby:RefreshRechargeMenuButton(TabButton, Idx)
	if TabButton.paternal == nil then
		TabButton.paternal = self;
	end
    TabButton:SetupTabInfo(self.RechargeTabInfos[Idx+1]);
    if TabButton.TabID == self.SelectedRechargeID then
        TabButton:Select();
    else
        TabButton:Deselect(self.RechargeTabInfos[Idx+1].Tab);
    end
    self.RechargeTabButtons[TabButton.TabID] = TabButton;
end

function lobby:SelectTab(TabID)
    if TabID == self.SelectedTabID then
        return;
    end
    self.TabButtons[TabID]:Select();
    self.TabButtons[self.SelectedTabID]:Deselect();
    self.SelectedTabID = TabID;
end

function lobby:SelectRechargeTab(TabID)
    if TabID == self.SelectedRechargeID then
        return;
    end
    self.RechargeTabButtons[TabID]:Select();
    self.RechargeTabButtons[self.SelectedRechargeID]:Deselect();
    self.SelectedRechargeID = TabID;
end

function lobby:AniBtn_OnClicked()
    local Controller = UGCGameSystem.GetLocalPlayerController()
    
    -- 定义起始颜色和目标颜色
    local StartColor = KismetMathLibrary.MakeColor(0, 1, 0, 1)  -- 绿色
    local EndColor = KismetMathLibrary.MakeColor(1, 0, 0, 1)    -- 红色
    
    -- 创建回调函数
    local Delegate = UGCDelegateUtility.CreateUEDelegate(Controller)
    Delegate:Bind(function(Obj, Value)
        ugcprint('AniBtn_OnClicked_color: ' .. Value)
        self.aniBtn:SetColorAndOpacity(Value)
    end, self)
    
    -- 配置动画参数
    local Config = CreateStruct('/Script/UnrealTween.UnrealTweenConfig')
    Config.Delay = 0           -- 无延迟
    Config.RepeatCount = -1    -- 无限循环
    Config.bYoyo = false       -- 不往返
    Config.RepeatDelay = 0     -- 循环间无延迟
    

    local TweenLibrary = KismetLibrary.New("/Script/UnrealTween.UnrealTweenBlueprintLibrary")

    -- 创建颜色动画（1秒持续时间，使用 Linear 缓动）
    self.TweenHandler = TweenLibrary.TweenColorValue(
        Controller,
        StartColor,
        EndColor,
        1.0,
        EEasingType.Linear,        -- 缓动类型
        Delegate,
        Config
    )
    
    -- 暂停动画
    TweenLibrary.PauseTween(Controller, self.TweenHandler)
end

return lobby