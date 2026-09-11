---@class RecruitMain_C:UAEUserWidget
---@field Button_0 UButton
--Edit Below--
local RecruitMain = {
    bInitDoOnce = false,
    lastSelectIndex = nil,
    lastHasTeam = nil,
}

function RecruitMain:Construct()
    self:LuaInit()
end

function RecruitMain:Tick(MyGeometry, InDeltaTime)
    if RecruitManager.TeamInfo.HasTeam ~= self.lastHasTeam or RecruitManager.TeamInfo.SelectedIndex ~= self.lastSelectIndex then
        self.lastSelectIndex = RecruitManager.TeamInfo.SelectedIndex;
        self.lastHasTeam = RecruitManager.TeamInfo.HasTeam;
        self.TeamList:Reload(#RecruitManager.TeamList);
        self:RefreshUI();
    end
end

function RecruitMain:LuaInit()
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true;
    self:Listen();
    RecruitManager:RegisterMainUI(self);
end

function RecruitMain:Listen()
    self.Button_0.OnClicked:Add(self.Exit, self);
    self.TeamList.OnUpdateItem:Add(self.TeamListUpdate, self);
end

function RecruitMain:Exit()
    RecruitManager:CloseMainUI();
end

function RecruitMain:TeamListUpdate(Item, Index)
    Item.Index = Index+1;
    Item:SetRoomText();
    if self.lastSelectIndex == Item.Index then
        Item:SetSelected(true);
    else
        Item:SetSelected(false);
    end
end

function RecruitMain:RefreshUI()
    if self.lastSelectIndex == nil then
        if self.lastHasTeam then
            self.Selected:SetVisibility(ESlateVisibility.Visible);
            self.Normal:SetVisibility(ESlateVisibility.Collapsed);
            self:RefreshMemberItem();
        else
            self.Selected:SetVisibility(ESlateVisibility.Collapsed);
            self.Normal:SetVisibility(ESlateVisibility.Visible);
        end
    else
        self.Selected:SetVisibility(ESlateVisibility.Visible);
        self.Normal:SetVisibility(ESlateVisibility.Collapsed);
        self:RefreshMemberItem();
    end
end

function RecruitMain:RefreshMemberItem()
    self:SetItemData(self.MemberItem1, RecruitManager.TeamList[self.lastSelectIndex].member[1], 1);
    self:SetItemData(self.MemberItem2, RecruitManager.TeamList[self.lastSelectIndex].member[2], 2);
    self:SetItemData(self.MemberItem3, RecruitManager.TeamList[self.lastSelectIndex].member[3], 3);
    self:SetItemData(self.MemberItem4, RecruitManager.TeamList[self.lastSelectIndex].member[4], 4);
end

function RecruitMain:SetItemData(Item, dat, Index)
    Item.No:SetText(tostring(Index))
    if dat ~= nil then
        Item.HasMember:SetVisibility(ESlateVisibility.Visible);
        Item.Nobody:SetVisibility(ESlateVisibility.Collapsed);
        Item.Username:SetText(dat.name);
    else
        Item.HasMember:SetVisibility(ESlateVisibility.Collapsed);
        Item.Nobody:SetVisibility(ESlateVisibility.Visible);
    end
end

function RecruitMain:CollapsedTeamList()

end

function RecruitMain:CollapsedInfo()

end

function RecruitMain:VisibleTeamList()

end

function RecruitMain:VisibleInfo()

end

return RecruitMain