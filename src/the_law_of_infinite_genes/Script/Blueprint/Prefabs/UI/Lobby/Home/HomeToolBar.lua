---@class HomeToolBar_C:UUserWidget
---@field aniBtn UButton
---@field ReuseList2 ReuseList2_C
--Edit Below--
local HomeToolBar = { 
    bInitDoOnce = false, 
    parent=nil,  
    ToolBarButtonLabel = {'商城', '抽奖', '排行榜', '仓库', '组队'},
    selectIndex = 0,
	aniState = false
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
	
	self.Slot = UGCWidgetManagerSystem.SlotAsCanvasSlot(self.ReuseList2)

	self.TestP = self.Slot:GetPosition()
	self.TestS = self.Slot:GetSize()
	
	ugcprint('控件尺寸'..tostring(self.TestS.X)..','..tostring(self.TestS.Y))

    if self.aniState then
		TweenManager.VectorAnim(
			function(Value)
				self.Slot:SetSize(KismetMathLibrary.MakeVector2D(self.TestS.X + Value.X, self.TestS.Y))
			end,
			KismetMathLibrary.MakeVector(0, 0, 0),
			KismetMathLibrary.MakeVector(-500, 0, 0),
			0.25,
			TweenManager.EEasingType.QuadOut
		)
		-- local startColor = KismetMathLibrary.MakeColor(1,1,1,1)   -- 透明
		-- local endColor = KismetMathLibrary.MakeColor(1,1,1,0)     -- 不透明
		-- TweenManager.ColorAnim(
		-- function(Value)
		-- 	self.ReuseList2:SetColorAndOpacity(Value)
		-- end, startColor, endColor, 0.2, TweenManager.EEasingType.Linear)

    else
		TweenManager.VectorAnim(
			function(Value)
				self.Slot:SetSize(KismetMathLibrary.MakeVector2D(self.TestS.X + Value.X, self.TestS.Y))
			end,
			KismetMathLibrary.MakeVector(0, 0, 0),
			KismetMathLibrary.MakeVector(500, 0, 0),
			0.25,
			TweenManager.EEasingType.QuadIn
		)
		-- local startColor = KismetMathLibrary.MakeColor(1,1,1,0)
		-- local endColor = KismetMathLibrary.MakeColor(1,1,1,1)
		-- TweenManager.ColorAnim(
		-- function(Value)
		-- 	self.ReuseList2:SetColorAndOpacity(Value)
		-- end, startColor, endColor, 0.2, TweenManager.EEasingType.Linear)
    end

end

return HomeToolBar