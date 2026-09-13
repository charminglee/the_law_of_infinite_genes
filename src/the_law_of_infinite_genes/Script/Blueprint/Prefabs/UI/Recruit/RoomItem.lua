---@class RoomItem_C:UUserWidget
---@field Button_0 UButton
---@field Image_3 UImage
---@field Image_4 UImage
---@field Overlay_Selected UOverlay
---@field TextBlock_AllowJoin UTextBlock
---@field TextBlock_Degree UTextBlock
---@field TextBlock_MapName UTextBlock
---@field TextBlock_Number UTextBlock
---@field TextBlock_RoomName UTextBlock
---@field Size FVector2D
---@field DurabilityPercent float
--Edit Below--
local RoomItem = { bInitDoOnce = false }

function RoomItem:Construct()
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true
    self.Button_0.OnClicked:Add(self.OnClicked, self)
end

function RoomItem:OnUpdate(Data)
    self.Index = Data.Index
    self.OnSelected = Data.OnSelected
    local Room = Data.Room
    local Config = Room.Config
    local MemberCount = #(Room.Members or {})
    local MaxMembers = Room.MaxMembers or 4
    local bCanJoin = MemberCount < MaxMembers

    self.TextBlock_RoomName:SetText(Room.RoomName or "")
    self.TextBlock_MapName:SetText(Config.MapName or "")
    self.TextBlock_Degree:SetText(Config.Difficulty or "")
    self.TextBlock_Number:SetText(string.format("%d/%d", MemberCount, MaxMembers))
    self.TextBlock_AllowJoin:SetText(bCanJoin and "可加入" or "已满")
    self.Overlay_Selected:SetVisibility(Data.bSelected and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
    self.Image_3:SetVisibility(Config.AllowRestock and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
    self.Image_4:SetVisibility(Config.AllowServe and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
end

function RoomItem:OnClicked()
    self.OnSelected(self.Index)
end

return RoomItem
