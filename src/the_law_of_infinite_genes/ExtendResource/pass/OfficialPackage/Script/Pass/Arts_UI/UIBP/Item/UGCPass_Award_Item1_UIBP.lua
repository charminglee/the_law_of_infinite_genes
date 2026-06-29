---@class UGCPass_Award_Item1_UIBP_C:UUserWidget
---@field AdvancedAward UGCPass_Common_Item_UIBP_C
---@field AwardStateSwitcher UWidgetSwitcher
---@field BaseAward UGCPass_Common_Item_UIBP_C
---@field Button UNewButton
---@field CurrentLevelText UTextBlock
---@field LevelText UTextBlock
---@field LockedLevelText UTextBlock
--Edit Below--
local UGCPass_Award_Item1_UIBP = { bInitDoOnce = false } 

function UGCPass_Award_Item1_UIBP:Construct()
	self.Button.OnClicked:Add(self.OnButtonClick, self)
end

function UGCPass_Award_Item1_UIBP:Destruct()
    self.Button.OnClicked:Remove(self.OnButtonClick, self)
end

function UGCPass_Award_Item1_UIBP:OnButtonClick()
    if self.Index and self.Index == -1 then
        PassManager:LogError("Index is -1", "UGCPass_Common_Item_UIBP:OnButtonClick")
        return
    end

    if not self.bBlockClick then
        self.bBlockClick = true

        PassManager.OnClaimAwardClickDelegate(self.Index)
        UGCTimerUtility.CreateLuaTimer(1, function () self.bBlockClick = false end)
    end
end

return UGCPass_Award_Item1_UIBP