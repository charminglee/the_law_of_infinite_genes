---@class UGCPass_Tips_PopupsBg_UIBP_C:UUserWidget
---@field CloseButton UButton
---@field ConfirmButton UNewButton
---@field ConfirmText UTextBlock
---@field DescriptionText UUTRichTextBlock
---@field TitleText UTextBlock
--Edit Below--
local Delegate = require("common.Delegate")

local UGCPass_Tips_PopupsBg_UIBP = 
{ 
    bInitDoOnce = false,
    OnClickDelegate = Delegate.New()
}

function UGCPass_Tips_PopupsBg_UIBP:Construct()
	self.CloseButton.OnClicked:Add(self.OnCloseClick, self)
    self.ConfirmButton.OnClicked:Add(self.OnConfirmClick, self)
end

function UGCPass_Tips_PopupsBg_UIBP:Destruct()
	self.CloseButton.OnClicked:Remove(self.OnCloseClick, self)
    self.ConfirmButton.OnClicked:Remove(self.OnConfirmClick, self)
end

function UGCPass_Tips_PopupsBg_UIBP:Refresh(Title, Description, ConfirmText)
    self.TitleText:SetText(Title)
    self.DescriptionText:SetText(Description)
    self.ConfirmText:SetText(ConfirmText)
end

function UGCPass_Tips_PopupsBg_UIBP:OnCloseClick()
    self:SetVisibility(ESlateVisibility.Collapsed)

    self.OnClickDelegate(false)
    self.OnClickDelegate:RemoveAll()
end

function UGCPass_Tips_PopupsBg_UIBP:OnConfirmClick()
    self:SetVisibility(ESlateVisibility.Collapsed)
    
    self.OnClickDelegate(true)
    self.OnClickDelegate:RemoveAll()
end

return UGCPass_Tips_PopupsBg_UIBP