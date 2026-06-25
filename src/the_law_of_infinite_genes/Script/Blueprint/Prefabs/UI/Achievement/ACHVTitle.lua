---@class ACHVTitle_C:UUserWidget
---@field Frame UButton
---@field LockBg UImage
---@field LockImg UImage
---@field Name UTextBlock
---@field PressedFrame UImage
---@field PressedImg UImage
---@field State UTextBlock
--Edit Below--
local ACHVTitle = { 
    bInitDoOnce = false,
    parent = nil,
    index = 0
} 

function ACHVTitle:Construct()
	self:LuaInit();
end

function ACHVTitle:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	self.Frame.OnClicked:Add(self.FrameClicked, self);
end

-- 当前称号数据表
function ACHVTitle:TitleData()
    return ACHVManager.Config.TitleData[ACHVManager.CategoryListUI.selectedTabID][self.index + 1]
end

-- 当前称号状态
function ACHVTitle:GetTitleState()
    return LocalPlayerState.PlayerDataManager:GetTitleState(self:TitleData().Id)
end

-- 当前称号状态文本
function ACHVTitle:GetTitleStateText()
    return ACHVManager.Config.TitleStateText[self:GetTitleState()]
end

function ACHVTitle:ToggleState()
    local state = self:GetTitleState();
    local res
    if state == 0 then
        res = ACHVManager:Unlock();
    elseif state == 1 then
        res = ACHVManager:Equipped();
    elseif state == 2 then
        res = ACHVManager:Unequipped();
    end
    UGCTimerUtility.CreateUETimer(
        function() self:Refresh(); ACHVManager.RightContent:Refresh() end, 
        ACHVManager.Config.AnimDur.In, 
        false
    );
end

function ACHVTitle:SetLocked(locked)
    if locked then
        self.LockImg:SetVisibility(ESlateVisibility.Visible);
        self.LockBg:SetVisibility(ESlateVisibility.Visible);
    else
        self.LockImg:SetVisibility(ESlateVisibility.Hidden);
        self.LockBg:SetVisibility(ESlateVisibility.Collapsed);
    end
end

function ACHVTitle:Refresh()
    self.Name:SetText(self:TitleData().NameText);
    self.State:SetText(self:GetTitleStateText());
    self:SetLocked(self:GetTitleState() == 0);
end

function ACHVTitle:Select()
    self.PressedFrame:SetVisibility(ESlateVisibility.Visible);
    self.PressedImg:SetVisibility(ESlateVisibility.Visible);
end

function ACHVTitle:Deselect()
	self.PressedFrame:SetVisibility(ESlateVisibility.Collapsed);
	self.PressedImg:SetVisibility(ESlateVisibility.Collapsed);
end

function ACHVTitle:FrameClicked()
    self.parent:SelectTab(self.index);
end

return ACHVTitle