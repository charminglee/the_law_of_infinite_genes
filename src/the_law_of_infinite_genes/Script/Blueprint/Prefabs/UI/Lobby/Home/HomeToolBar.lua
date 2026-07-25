---@class HomeToolBar_C:UUserWidget
---@field AnimBtn UButton
---@field ReuseList2 ReuseList2_C
--Edit Below--
local HomeToolBar = { 
    bInitDoOnce = false, 
    parent=nil,  
    ToolBarButtonLabel = {'商城', '抽奖', '排行榜', '仓库', '成就', '通行证', '基因树', '招募', '合成'},
    selectIndex = 0,
	aniState = false,
	currentTween = nil
}

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

	self.AnimBtn.OnClicked:Add(self.AnimBtnOnClicked, self);

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
	Item:Refresh();
end

function HomeToolBar:AnimBtnOnClicked()
    self.aniState = not self.aniState
    local slot = UGCWidgetManagerSystem.SlotAsCanvasSlot(self.ReuseList2);
    local originalSize = {X = 330, Y = 125};
    local currentSize = slot:GetSize();
    -- 停止正在播放的动画（避免同时多个动画冲突）
    if self.currentTween then
        TweenManager.Stop(self.currentTween)
        self.currentTween = nil
    end
    self.currentTween = TweenManager.SizeAnim(
        slot,
        KismetMathLibrary.MakeVector2D(0, originalSize.Y),
        KismetMathLibrary.MakeVector(currentSize.X, 0, 0),
        KismetMathLibrary.MakeVector(self.aniState and 0 or originalSize.X , 0, 0),
        0.5,
        self.aniState and TweenManager.EEasingType.QuartInOut or TweenManager.EEasingType.QuartOut
    );
    -- 动画结束后清除句柄
    if self.currentTween then
        TweenManager.OnComplete(self.currentTween, function()
            self.currentTween = nil
        end);
    end
end

return HomeToolBar