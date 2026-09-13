---@class InvitationItem_C:UAEUserWidget
---@field Button_1 UButton
---@field CanvasPanel_Icon UCanvasPanel
---@field Image_1 UImage
---@field TextBlock_PlayerName UTextBlock
--Edit Below--
local InvitationItem = { bInitDoOnce = false }

function InvitationItem:Construct()
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true
    self.Button_1.OnClicked:Add(self.OnInviteClicked, self)
end

function InvitationItem:OnUpdate(Data)
    self.Player = Data.Player
    self.OnInvite = Data.OnInvite
    self.TextBlock_PlayerName:SetText(self.Player.PlayerName or "")
    self.Button_1:SetIsEnabled(Data.bInvited ~= true)
end

function InvitationItem:OnInviteClicked()
    self.Button_1:SetIsEnabled(false)
    self.OnInvite(self.Player)
end

return InvitationItem
