---@class HomeToolBar_C:UUserWidget
---@field aniBtn UButton
---@field ReuseList2 ReuseList2_C
--Edit Below--
local HomeToolBar = { 
    bInitDoOnce = false, 
    parent=nil,  
    ToolBarButtonLabel = {'商城', '抽奖', '排行榜', '仓库', '组队'},
    selectIndex = 0,
	aniState = false,
	currentTween = nil
}

local TweenManager = UGCGameSystem.UGCRequire('Script.Common.TweenManager')

function HomeToolBar:Construct()
	self:LuaInit();
end

function HomeToolBar:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	self:Listen();
	self:RefreshHomeToolBar();

	TweenManager:Initialize();

	self.aniBtn.OnClicked:Add(self.aniBtn_OnClicked, self);

end

function HomeToolBar:Listen()
	self.ReuseList2.OnUpdateItem:Add(self.HomeToolBarUpdate, self);
end

function HomeToolBar:RefreshHomeToolBar()
	self.ReuseList2:Reload(#self.ToolBarButtonLabel);
end

function HomeToolBar:HomeToolBarUpdate(Item, Index)
	if Item.Parent == nil then
		Item.Parent = self;
		Item.Index = Index;
	end
	Item:SetText(self.ToolBarButtonLabel[Index+1]);
end

function HomeToolBar:aniBtn_OnClicked()

    self.aniState = not self.aniState

	local slot = UGCWidgetManagerSystem.SlotAsCanvasSlot(self.ReuseList2)

	-- 获取当前实时尺寸（防止动画跳跃）
    local currentSize = slot:GetSize()
    local easingType = self.aniState and TweenManager.EEasingType.QuartIn or TweenManager.EEasingType.QuartOut
    local startWidth = currentSize.X
    local endWidth = self.aniState and 0 or 500 

    -- 停止正在播放的动画（避免同时多个动画冲突）
    if self.currentTween then
        TweenManager.Stop(self.currentTween)
        self.currentTween = nil
    end

    -- 创建宽度动画（从当前宽度到目标宽度）
    local startVec = KismetMathLibrary.MakeVector(startWidth, 0, 0)
    local endVec   = KismetMathLibrary.MakeVector(endWidth, 0, 0)

    self.currentTween = TweenManager.VectorAnim(
        function(value)
            slot:SetSize(KismetMathLibrary.MakeVector2D(value.X, currentSize.Y))
        end,
        startVec,
        endVec,
        0.25,
        easingType
    )

    -- 动画结束后清除句柄
    if self.currentTween then
        TweenManager.OnComplete(self.currentTween, function()
            self.currentTween = nil
        end)
    end

end

return HomeToolBar