---@class GeneInfoBar_C:UAEUserWidget
---@field Add UButton
---@field Highest UButton
---@field Info_0 UTextBlock
---@field Info_1 UTextBlock
---@field InfoPanel UCanvasPanel
---@field Lowest UButton
---@field Name UTextBlock
---@field Reduce UButton
---@field SidebarBtn UButton
--Edit Below--
local GeneInfoBar = { 
	bInitDoOnce = false,
	tips = {
		NeedToUnlock = '需要先解锁基因',
		ReachedTheHighest = '基因已达到上限',
		ReachedTheLowest = '基因已达到下限',
		ProhibitedLower = '下一级基因已进化，禁止降低等级，请重铸基因',
		ProhibitedHigher = '上一级基因未进化至上限，禁止增加等级'
	}
} 

function GeneInfoBar:Construct()
	self:LuaInit();
end

function GeneInfoBar:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	GeneManager.InfoBar = self;
	self.SidebarBtn.OnClicked:Add(self.SidebarBtnClicked, self);
	self.Lowest.OnClicked:Add(self.LowestClicked, self);
	self.Reduce.OnClicked:Add(self.ReduceClicked, self);
	self.Add.OnClicked:Add(self.AddClicked, self);
	self.Highest.OnClicked:Add(self.HighestClicked, self);
end

function GeneInfoBar:Refresh()
	local data = GeneManager.Content:SelectedNodeData();
	self.Name:SetText(data.SkillText);
	self.Info_0:SetText(data.LvText);
	self.Info_1:SetText(data.EffectText[data.Lv + 1]);
end

function GeneInfoBar:SidebarBtnClicked()
    GeneManager.Content:PlayAnim();
	self:Refresh();
end

function GeneInfoBar:Executable(value)
	if value < 0 or value > GeneManager.Content:SelectedNodeLvLimit() then
		return false
	end
	return true
end

function GeneInfoBar:LowestClicked()
	local tab = GeneManager.Content:SelectedTab();
	local data = tab:Data();
	if not data.Unlocked then
        return UGCWidgetManagerSystem.ShowTipsUI(self.tips.NeedToUnlock)
    end
	if tab:NextData() ~= nil and tab:NextData().Lv > 0 then
		return UGCWidgetManagerSystem.ShowTipsUI(self.tips.ProhibitedLower);
	end
	if data.Lv == 0 then
		return UGCWidgetManagerSystem.ShowTipsUI(self.tips.ReachedTheLowest);
	end
	data.Lv = 0;
    tab:Refresh();
	self:Refresh();
end

function GeneInfoBar:ReduceClicked()
	local tab = GeneManager.Content:SelectedTab();
	local data = tab:Data();
	if not data.Unlocked then
        return UGCWidgetManagerSystem.ShowTipsUI(self.tips.NeedToUnlock)
    end
	if tab:NextData() ~= nil and tab:NextData().Lv > 0 then
		return UGCWidgetManagerSystem.ShowTipsUI(self.tips.ProhibitedLower);
	end
	local value = data.Lv - 1;
	if not self:Executable(value) then
		return UGCWidgetManagerSystem.ShowTipsUI(self.tips.ReachedTheLowest);
	end
	data.Lv = value;
    tab:Refresh();
	self:Refresh();
end

function GeneInfoBar:AddClicked()
	local tab = GeneManager.Content:SelectedTab();
	local data = tab:Data();
	if not data.Unlocked then
        return UGCWidgetManagerSystem.ShowTipsUI(self.tips.NeedToUnlock)
    end
	local previousData = tab:PreviousData();
	if previousData ~= nil and previousData.Lv < previousData.LvHighest then
		return UGCWidgetManagerSystem.ShowTipsUI(self.tips.ProhibitedHigher);
	end
	local value = data.Lv + 1;
	if not self:Executable(value) then
		return UGCWidgetManagerSystem.ShowTipsUI(self.tips.ReachedTheHighest);
	end
	data.Lv = value;
    tab:Refresh();
	self:Refresh();
end

function GeneInfoBar:HighestClicked()
	local tab = GeneManager.Content:SelectedTab();
	local data = tab:Data();
	if not data.Unlocked then
        return UGCWidgetManagerSystem.ShowTipsUI(self.tips.NeedToUnlock)
    end
	local previousData = tab:PreviousData();
	if previousData ~= nil and previousData.Lv < previousData.LvHighest then
		return UGCWidgetManagerSystem.ShowTipsUI(self.tips.ProhibitedHigher);
	end
	local limit = GeneManager.Content:SelectedNodeLvLimit();
	if data.Lv == limit then
		return UGCWidgetManagerSystem.ShowTipsUI(self.tips.ReachedTheHighest);
	end
	data.Lv = limit;
    tab:Refresh();
	self:Refresh();
end

return GeneInfoBar