---@class ExistRoom_C:UAEUserWidget
---@field Button_Begin UButton
---@field Button_CancelParpare UButton
---@field Button_Invitation UButton
---@field Button_Join UButton
---@field Button_Prepare UButton
---@field Button_RoomConfig UButton
---@field CheckBox_AllowRestock UCheckBox
---@field CheckBox_AllowServe UCheckBox
---@field DropList UGC_ReuseList2_C
---@field Image_1 UImage
---@field Image_Customs UImage
---@field Image_NoRequired_1 UImage
---@field Image_NoRequired_2 UImage
---@field TeamList TeamList_C
---@field TextBlock_Degree UTextBlock
---@field TextBlock_Description UTextBlock
---@field UGC_ReuseList2 UGC_ReuseList2_C
--Edit Below--
local ExistRoom = { bInitDoOnce = false }

function ExistRoom:Init(Callbacks)
    self.Callbacks = Callbacks
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true
    self.Button_Join.OnClicked:Add(self.OnJoinClicked, self)
    self.Button_Prepare.OnClicked:Add(self.OnPrepareClicked, self)
    self.Button_CancelParpare.OnClicked:Add(self.OnCancelPrepareClicked, self)
    self.Button_Begin.OnClicked:Add(self.OnBeginClicked, self)
    self.Button_Invitation.OnClicked:Add(self.OnInvitationClicked, self)
    self.Button_RoomConfig.OnClicked:Add(self.OnRoomConfigClicked, self)
    self.DropList.OnAfterNewItem:Add(self.OnDropItemReload, self)
    self.UGC_ReuseList2.OnAfterNewItem:Add(self.OnDropItemReload, self)
end

function ExistRoom:OnUpdate(Room, bCurrentRoom)
    if not Room then
        return
    end
    self.Room = Room
    self.DropItems = Room.Config.DropItems or {}
    self.TextBlock_Degree:SetText(Room.Config.Difficulty or "")
    self.TextBlock_Description:SetText(Room.Config.Description or "")
    self.Image_Customs:SetBrushFromTexture(Room.Config.MapImage, false)
    self.CheckBox_AllowRestock:SetIsChecked(Room.Config.AllowRestock == true)
    self.CheckBox_AllowServe:SetIsChecked(Room.Config.AllowServe == true)
    self.CheckBox_AllowRestock:SetIsEnabled(false)
    self.CheckBox_AllowServe:SetIsEnabled(false)
    self.Image_NoRequired_1:SetVisibility(Room.Config.AllowRestock and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible)
    self.Image_NoRequired_2:SetVisibility(Room.Config.AllowServe and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible)
    self.DropList:Reload(#self.DropItems)
    self.UGC_ReuseList2:Reload(#self.DropItems)
    self.TeamList:SetMembers(Room.Members or {})

    local PlayerController = UGCGameSystem.GetLocalPlayerController()
    local PlayerState = UGCGameSystem.GetLocalPlayerState()
    local bLeader = bCurrentRoom and PlayerController and PlayerController.bIsTeamLeader == true
    local bReady = bCurrentRoom and PlayerState and PlayerState.bIsReadyInLobby == true
    self.Button_Join:SetVisibility(bCurrentRoom and ESlateVisibility.Collapsed or ESlateVisibility.Visible)
    self.Button_Join:SetIsEnabled(#(Room.Members or {}) < (Room.MaxMembers or 4))
    self.Button_Prepare:SetVisibility(bCurrentRoom and not bLeader and not bReady and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    self.Button_CancelParpare:SetVisibility(bCurrentRoom and not bLeader and bReady and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    self.Button_Begin:SetVisibility(bLeader and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    self.Button_Invitation:SetVisibility(bLeader and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    self.Button_RoomConfig:SetVisibility(bLeader and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
end

function ExistRoom:OnDropItemReload(Item, ZeroBasedIndex)
    Item:SetData(self.DropItems[ZeroBasedIndex + 1])
end

function ExistRoom:OnJoinClicked() self.Callbacks.OnJoin() end
function ExistRoom:OnPrepareClicked() self.Callbacks.OnReady(true) end
function ExistRoom:OnCancelPrepareClicked() self.Callbacks.OnReady(false) end
function ExistRoom:OnBeginClicked() self.Callbacks.OnStart() end
function ExistRoom:OnInvitationClicked() self.Callbacks.OnInvite() end
function ExistRoom:OnRoomConfigClicked() self.Callbacks.OnConfig() end

return ExistRoom
