---@class TeamItem_C:UAEUserWidget
---@field Button_0 UButton
---@field ItemName1 UTextBlock
---@field ItemName2 UTextBlock
---@field ItemName3 UTextBlock
---@field ItemName4 UTextBlock
---@field Name UTextBlock
---@field Normal UCanvasPanel
---@field occ1 UCanvasPanel
---@field occ2 UCanvasPanel
---@field occ3 UCanvasPanel
---@field occ4 UCanvasPanel
---@field Selected UCanvasPanel
---@field TeamId UTextBlock
--Edit Below--
local TeamItem = { bInitDoOnce = false, Index=nil}
function TeamItem:Construct()
	self:LuaInit();
end
function TeamItem:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	self:Listen();
end
function TeamItem:Listen()
	self.Button_0.OnClicked:Add(self.ItemClicked, self);
end

function TeamItem:ItemClicked()
	ugcprint('clicked');
	ugcprint('当前索引为'..tostring(self.Index));
	ugcprint(tostring(RecruitManager.TeamList[self.Index].name))
	RecruitManager.TeamInfo.SelectedIndex = self.Index;
end

function TeamItem:SetRoomText()
	self.TeamId:SetText(tostring(self.Index));
	self.Name:SetText(RecruitManager.TeamList[self.Index].name);
	local ItemData = RecruitManager.TeamList[self.Index].member;
	self:SetMemberItemData(self.ItemName1, ItemData[1]);
	self:SetMemberItemData(self.ItemName2, ItemData[2]);
	self:SetMemberItemData(self.ItemName3, ItemData[3]);
	self:SetMemberItemData(self.ItemName4, ItemData[4]);
end

function TeamItem:SetSelected(has_visible)
	if has_visible then
		self.Selected:SetVisibility(ESlateVisibility.Visible);
		self.Normal:SetVisibility(ESlateVisibility.Collapsed);
	else
		self.Selected:SetVisibility(ESlateVisibility.Collapsed);
		self.Normal:SetVisibility(ESlateVisibility.Visible);
	end
end
function TeamItem:SetMemberItemData(Item, dat)
	if dat ~= nil then
		Item:SetText(dat.name);
	else
		Item:SetText('无')
	end
end
return TeamItem