---@class RoomList_C:UAEUserWidget
---@field AuxCreateRoom UCanvasPanel
---@field Button_0 UButton
---@field Button_Refresh UButton
---@field RoomReuseList UGC_ReuseList2_C
--Edit Below--
local RoomList = { bInitDoOnce = false }
function RoomList:Init(OnSelected, OnCreate)
    self.OnSelected = OnSelected
    self.OnCreate = OnCreate
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true
    self.Button_0.OnClicked:Add(self.OnCreateClicked, self)
    self.RoomReuseList.OnAfterNewItem:Add(self.OnRoomItemReload, self)
end
function RoomList:Refresh(Rooms, SelectedIndex, bShowCreateRoom)
    self.Rooms = Rooms
    self.SelectedIndex = SelectedIndex
    local bEmpty = #Rooms == 0
    self.Button_0:SetVisibility(bShowCreateRoom and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    self.Button_Refresh:SetVisibility(bEmpty and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    self.AuxCreateRoom:SetVisibility(bEmpty and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
    self.RoomReuseList:SetVisibility(bEmpty and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible)
    self.RoomReuseList:Reload(#Rooms)
end
function RoomList:OnCreateClicked()
    self.OnCreate()
end
function RoomList:OnRoomItemReload(Item, ZeroBasedIndex)
    local Index = ZeroBasedIndex + 1
    Item:OnUpdate({
        Room = self.Rooms[Index],
        Index = Index,
        bSelected = self.SelectedIndex == Index,
        OnSelected = self.OnSelected,
    })
end
return RoomList
