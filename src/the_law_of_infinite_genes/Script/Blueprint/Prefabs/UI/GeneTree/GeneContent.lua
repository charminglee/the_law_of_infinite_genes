---@class GeneContent_C:UAEUserWidget
---@field GeneInfoBar GeneInfoBar_C
---@field ReuseList2 ReuseList2_C
--Edit Below--
local GeneContent = { 
    bInitDoOnce = false,
    tabButtons = {},
	selectedTabID = 0,
    aniState = false,
	posAnim_0 = nil,
	posAnim_1 = nil
} 

function GeneContent:Construct()
	self:LuaInit();
end

function GeneContent:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
    GeneManager.Content = self;
    self.ReuseList2.OnUpdateItem:Add(self.ReuseList2Update, self);
end

function GeneContent:Reload()
	self.ReuseList2:Reload(5);
end

function GeneContent:ReuseList2Update(item, index)
	if item.parent == nil then
		item.parent = self;
	end
	item.index = index;
    GeneManager.SkillBranch:Reload();
	item:Refresh();
end

function GeneContent:PlayAnim()
    self.aniState = not self.aniState
    local infoBarSlot = UGCWidgetManagerSystem.SlotAsCanvasSlot(self.GeneInfoBar);
    local reuseList2Slot = UGCWidgetManagerSystem.SlotAsCanvasSlot(self.ReuseList2);
    local infoBarSize = infoBarSlot:GetSize();
    -- 停止正在播放的动画（避免同时多个动画冲突）
    if self.posAnim_0 then
        TweenManager.Stop(self.posAnim_0)
        self.posAnim_0 = nil
    end
    if self.posAnim_1 then
        TweenManager.Stop(self.posAnim_1)
        self.posAnim_1 = nil
    end
    self.GeneInfoBar.InfoPanel:SetVisibility(self.aniState and ESlateVisibility.Visible or ESlateVisibility.Hidden);
    self.posAnim_0 = TweenManager.PositionAnim(
        infoBarSlot,
        KismetMathLibrary.MakeVector2D(0, 0),
        infoBarSlot:GetPosition(),
        KismetMathLibrary.MakeVector2D(self.aniState and -1 * infoBarSize.X or 0, 0),
        GeneManager.Config.AnimDur.Set,
        self.aniState and TweenManager.EEasingType.QuartInOut or TweenManager.EEasingType.QuartOut
    );
    self.posAnim_1 = TweenManager.PositionAnim(
        reuseList2Slot,
        KismetMathLibrary.MakeVector2D(0, 0),
        reuseList2Slot:GetPosition(),
        KismetMathLibrary.MakeVector2D(self.aniState and -325 or 0, 0),
        GeneManager.Config.AnimDur.Set,
        self.aniState and TweenManager.EEasingType.QuartInOut or TweenManager.EEasingType.QuartOut
    );
    -- 动画结束后清除句柄
    if self.posAnim_0 then
        TweenManager.OnComplete(self.posAnim_0, function()
            self.posAnim_0 = nil;
        end);
    end
    if self.posAnim_1 then
        TweenManager.OnComplete(self.posAnim_1, function()
            self.posAnim_1 = nil;
            self.GeneInfoBar.InfoPanel:SetVisibility(self.aniState and ESlateVisibility.Visible or ESlateVisibility.Hidden);
        end);
    end
end

return GeneContent