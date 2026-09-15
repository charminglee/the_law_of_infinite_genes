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
---@field TeamList TeamList_C
---@field TextBlock_Degree UTextBlock
---@field TextBlock_Description UTextBlock
---@field TextBlock_MapName UTextBlock
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
    self.Button_Begin.OnClicked:Add(self.OnBeginClicked, self)
    self.Button_Invitation.OnClicked:Add(self.OnInvitationClicked, self)
    self.Button_RoomConfig.OnClicked:Add(self.OnRoomConfigClicked, self)
    self.CheckBox_AllowRestock.OnCheckStateChanged:Add(self.OnAllowRestockChanged, self)
    self.CheckBox_AllowServe.OnCheckStateChanged:Add(self.OnAllowServeChanged, self)
    self.DropList.OnAfterNewItem:Add(self.OnDropItemReload, self)
    self.UGC_ReuseList2.OnAfterNewItem:Add(self.OnDropItemReload, self)
end
function ExistRoom:OnUpdate(Room, bCurrentRoom)
    if not Room then
        return
    end
    self.Room = Room
    local PlayerController = UGCGameSystem.GetLocalPlayerController()
    self.bCanEditRoom = bCurrentRoom and PlayerController and PlayerController.bIsTeamLeader == true
    self.DropItems = Room.Config.DropItems or {}
    self.TextBlock_MapName:SetText(Room.Config.MapName or "")
    self.TextBlock_Degree:SetText(Room.Config.Difficulty or "")
    self.TextBlock_Description:SetText(Room.Config.Description or "")
    self.Image_Customs:SetVisibility(Room.Config.MapImage and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
    if Room.Config.MapImage then
        self.Image_Customs:SetBrushFromTexture(Room.Config.MapImage, false)
    end
    local bAllowRestock = Room.Config.AllowRestock == true
    if bCurrentRoom then
        bAllowRestock = RecruitManager:GetAllowRestock()
    end
    self.bUpdatingFillTeammate = true
    self.CheckBox_AllowRestock:SetIsChecked(bAllowRestock)
    self.bUpdatingFillTeammate = false
    self.CheckBox_AllowServe:SetIsChecked(Room.Config.AllowServe == true)
    self.CheckBox_AllowRestock:SetIsEnabled(self.bCanEditRoom)
    self.CheckBox_AllowServe:SetIsEnabled(self.bCanEditRoom)
    self.DropList:Reload(#self.DropItems)
    self.UGC_ReuseList2:Reload(#self.DropItems)
    self.TeamList:SetMembers(Room.Members or {})
    self.Button_Join:SetVisibility(bCurrentRoom and ESlateVisibility.Collapsed or ESlateVisibility.Visible)
    self.Button_Join:SetIsEnabled(#(Room.Members or {}) < (Room.MaxMembers or 4))
    self.Button_Prepare:SetVisibility(ESlateVisibility.Collapsed)
    self.Button_CancelParpare:SetVisibility(ESlateVisibility.Collapsed)
    self.Button_Begin:SetVisibility(self.bCanEditRoom and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    self.Button_Invitation:SetVisibility(bCurrentRoom and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    self.Button_RoomConfig:SetVisibility(self.bCanEditRoom and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
end
function ExistRoom:OnAllowRestockChanged(IsChecked)
    if self.bUpdatingFillTeammate or not self.bCanEditRoom then
        return
    end
    RecruitManager:SetAllowRestock(IsChecked)
end
function ExistRoom:OnAllowServeChanged(IsChecked)
    if not self.bCanEditRoom then
        return
    end
    self.Room.Config.AllowServe = IsChecked == true
    RecruitManager:NotifyChanged()
end
function ExistRoom:OnDropItemReload(Item, ZeroBasedIndex)
    Item:SetData(self.DropItems[ZeroBasedIndex + 1])
end
function ExistRoom:OnJoinClicked() self.Callbacks.OnJoin() end
function ExistRoom:OnBeginClicked() self.Callbacks.OnStart() end
function ExistRoom:OnInvitationClicked() self.Callbacks.OnInvite() end
function ExistRoom:OnRoomConfigClicked() self.Callbacks.OnConfig() end
return ExistRoom
