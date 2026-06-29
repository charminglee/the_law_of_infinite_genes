---@class UGCPass_Upgrade_UIBP_C:UUserWidget
---@field ConfirmButton UNewButton
---@field Icon UImage
---@field TitleText UTextBlock
---@field Info ULuaMapHelper<int32, FF_GetAdvancedPassInfo__pf2076753310>
--Edit Below--
local UGCPass_Upgrade_UIBP = { bInitDoOnce = false } 

function UGCPass_Upgrade_UIBP:Construct()
	self.ConfirmButton.OnClicked:Add(self.OnConfirmButtonClick, self)
end

function UGCPass_Upgrade_UIBP:Destruct()
    self.ConfirmButton.OnClicked:Remove(self.OnConfirmButtonClick, self)
end

function UGCPass_Upgrade_UIBP:Refresh(PassID)
    if self.Info[PassID] then
        PassManager:SetImageFromIconPath(self.Icon, self.Info[PassID].Icon)
        self.TitleText:SetText(self.Info[PassID].Title)
    end
end

function UGCPass_Upgrade_UIBP:OnConfirmButtonClick()
    self:SetVisibility(ESlateVisibility.Collapsed)
end

return UGCPass_Upgrade_UIBP