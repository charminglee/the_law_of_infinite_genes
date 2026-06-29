---@class UGCPass_Get_UIBP_C:UUserWidget
---@field CloseButton UNewButton
---@field ConfirmButton UButton
---@field ItemList ReuseList2_C
--Edit Below--
local UGCPass_Get_UIBP = { bInitDoOnce = false } 

function UGCPass_Get_UIBP:Construct()
	self.CloseButton.OnClicked:Add(self.OnCloseButtonClick, self)
    self.ConfirmButton.OnClicked:Add(self.OnCloseButtonClick, self)

    self.ItemList.OnUpdateItem:Add(self.RefreshItem, self)
end

function UGCPass_Get_UIBP:Destruct()
    self.CloseButton.OnClicked:Remove(self.OnCloseButtonClick, self)
    self.ConfirmButton.OnClicked:Remove(self.OnCloseButtonClick, self)

    self.ItemList.OnUpdateItem:Remove(self.RefreshItem, self)
end

function UGCPass_Get_UIBP:Refresh(Items)
    self.Items = {}

    for ItemID, Num in pairs(Items) do
        table.insert(self.Items, {ItemID=ItemID, Num=Num})
    end

    self.ItemList:Reload(#self.Items)
end

function UGCPass_Get_UIBP:RefreshItem(Widget, Index)
    Widget:Refresh(self.Items[Index+1])
end

function UGCPass_Get_UIBP:OnCloseButtonClick()
    self:SetVisibility(ESlateVisibility.Collapsed)
end

return UGCPass_Get_UIBP