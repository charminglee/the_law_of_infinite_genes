---@class InvitationList_C:UAEUserWidget
---@field Button_Close UButton
---@field Button_Refresh UButton
---@field Image_0 UImage
---@field Image_1 UImage
---@field UGC_ReuseList2 UGC_ReuseList2_C
--Edit Below--
local InvitationList = { bInitDoOnce = false }
function InvitationList:Construct()
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true
    self.InvitedUIDs = {}
    self.Button_Close.OnClicked:Add(self.OnCloseClicked, self)
    self.Button_Refresh.OnClicked:Add(self.OnRefreshClicked, self)
    self.UGC_ReuseList2.OnAfterNewItem:Add(self.OnInvitationItemReload, self)
end
function InvitationList:OnOpen(Data)
    self.Players = Data.Players
    self.FilterPlayers = Data.FilterPlayers
    self.OnInvite = Data.OnInvite
    self:RefreshList()
    if not self.PlayerListActor then
        self.PlayerListActor = UGCGamePartSystem.PlayerListManager.GetGlobalActor()
        if self.PlayerListActor then
            self.PlayerListActor.PlayerListUpdateDelegate:Add(self.OnPlayerListUpdated, self)
        end
    end
end
function InvitationList:OnPlayerListUpdated(Players)
    self.Players = self.FilterPlayers(Players)
    self:RefreshList()
end
function InvitationList:RefreshList()
    local bEmpty = #self.Players == 0
    self.Button_Refresh:SetVisibility(bEmpty and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    self.UGC_ReuseList2:SetVisibility(bEmpty and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible)
    self.UGC_ReuseList2:Reload(#self.Players)
end
function InvitationList:OnRefreshClicked()
    self:OnPlayerListUpdated(self.PlayerListActor:GetPlayerListData())
end
function InvitationList:OnCloseClicked()
    RecruitManager:CloseInvitation()
end
function InvitationList:OnInvitationItemReload(Item, ZeroBasedIndex)
    local Player = self.Players[ZeroBasedIndex + 1]
    Item:OnUpdate({
        Player = Player,
        OnInvite = function(InvitedPlayer)
            self:Invite(InvitedPlayer)
        end,
        bInvited = self.InvitedUIDs[Player.UID] == true,
    })
end
function InvitationList:Invite(Player)
    self.InvitedUIDs[Player.UID] = true
    self.OnInvite(Player)
end
function InvitationList:Destruct()
    self.Button_Close.OnClicked:Remove(self.OnCloseClicked, self)
    self.Button_Refresh.OnClicked:Remove(self.OnRefreshClicked, self)
    self.UGC_ReuseList2.OnAfterNewItem:Remove(self.OnInvitationItemReload, self)
    if self.PlayerListActor then
        self.PlayerListActor.PlayerListUpdateDelegate:Remove(self.OnPlayerListUpdated, self)
    end
end
return InvitationList
