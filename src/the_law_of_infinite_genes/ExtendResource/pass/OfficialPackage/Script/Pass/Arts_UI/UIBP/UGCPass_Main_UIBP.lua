---@class UGCPass_Main_UIBP_C:UUserWidget
---@field AwardPanel UGCPass_AwardContent_UIBP_C
---@field ContentSwitcher UWidgetSwitcher
---@field ScaleBox_IPX UScaleBox
---@field TaskPanel UGCPass_Task_UIBP_C
---@field TopTab UGCPass_FirstTab_UIBP_C
---@field GetPopupUIClassPath FSoftClassPath
---@field BuyAdvancedPassClassPath FSoftClassPath
---@field PassPrizeClassPath FSoftClassPath
---@field UnlockAdvancedPassClassPath FSoftClassPath
---@field RechargeSkipTaskItemUIPath FSoftClassPath
---@field TipPanelUIClassPath FSoftClassPath
--Edit Below--
local UGCPass_Main_UIBP = 
{ 
    bInitDoOnce = false,
    PassID = 0,
    CurrentTab = 0,

    NotClaimedNum = 0,

    GetPopup = nil,
}

function UGCPass_Main_UIBP:Construct()
	PassManager:Log("MainUI Construct")

    self.TopTab.CloseButton.OnClicked:Add(self.OnCloseButtonClick, self)
    self.TopTab.AwardButton.OnClicked:Add(self.OnAwardTabClick, self)
    self.TopTab.TaskButton.OnClicked:Add(self.OnTasktabClick, self)

    PassManager.OnAwardUpdateDelegate:Add(self.OnAwardUpdate, self)
    PassManager.OnTaskUpdateDelegate:Add(self.OnTaskUpdate, self)

    -- PassManager:RegisterGetItemQuailityRankFunc(function (ItemID)
    --     return 1
    -- end)
end

function UGCPass_Main_UIBP:Destruct()
    PassManager:Log("MainUI Destruct")

    self.TopTab.CloseButton.OnClicked:Remove(self.OnCloseButtonClick, self)
    self.TopTab.AwardButton.OnClicked:Remove(self.OnAwardTabClick, self)
    self.TopTab.TaskButton.OnClicked:Remove(self.OnTasktabClick, self)

    PassManager.OnAwardUpdateDelegate:Remove(self.OnAwardUpdate, self)
    PassManager.OnTaskUpdateDelegate:Remove(self.OnTaskUpdate, self)
end

function UGCPass_Main_UIBP:Refresh(PassID)
    PassManager:Log("Refresh MainUI", "UGCPass_Main_UIBP:Refresh")
    PassID = PassID or self.PassID
    self.PassID = PassID
    self.AwardPanel.PassID = PassID
    self.TaskPanel.PassID = PassID

    self.ContentSwitcher:SetActiveWidgetIndex(self.CurrentTab)

    if self.CurrentTab == 0 then
        PassManager:Log("Refresh AwardPanel", "UGCPass_Main_UIBP:Refresh")
        self.AwardPanel:Refresh(PassID)
        self.TaskPanel:StopWeekTimer()
        self.TopTab.AwardStateSwitcher:SetActiveWidgetIndex(1)
        self.TopTab.TaskStateSwitcher:SetActiveWidgetIndex(0)
    elseif self.CurrentTab == 1 then
        PassManager:Log("Refresh TaskPanel", "UGCPass_Main_UIBP:Refresh")
        self.TaskPanel:Refresh(PassID)
        self.TaskPanel:StartWeekTimer()
        self.TopTab.AwardStateSwitcher:SetActiveWidgetIndex(0)
        self.TopTab.TaskStateSwitcher:SetActiveWidgetIndex(1)
    end
end

function UGCPass_Main_UIBP:SelectWeekTab(Week)
    if self.CurrentTab ~= 1 then
        return
    end

    self.TaskPanel:SelectWeekTab(Week)
end

function UGCPass_Main_UIBP:OnAwardTabClick()
    if self.CurrentTab ~= 0 then
        PassManager:Log("Switch to award panel", "UGCPass_Main_UIBP:OnAwardTabClick")
        self.CurrentTab = 0
        self:Refresh(self.PassID)
    end
end

function UGCPass_Main_UIBP:OnTasktabClick()
    if self.CurrentTab ~= 1 then
        PassManager:Log("Switch to task panel", "UGCPass_Main_UIBP:OnTasktabClick")
        self.CurrentTab = 1
        self:Refresh(self.PassID)
    end
end

function UGCPass_Main_UIBP:OnCloseButtonClick()
    PassManager:CloseMainUI()
end

function UGCPass_Main_UIBP:OnAwardUpdate(TaskLineName, Index)
    if not self.bOpenned then
        return
    end

    local NotClaimedNum = PassManager:GetNotClaimedAwardNum(self.PassID)
    PassManager.bHasNotClaimedAward = NotClaimedNum > 0
    self.TopTab.AwardRedDot:SetVisibility(NotClaimedNum > 0 and ESlateVisibility.HitTestInvisible or ESlateVisibility.Collapsed)

    self.AwardPanel.NotClaimedAwardNum = NotClaimedNum
    self.AwardPanel:RefreshGetAllAwardButton()
    -- self.AwardPanel:RefreshAwardList()
    self.AwardPanel:UpdateAward(Index)
end

function UGCPass_Main_UIBP:OnTaskUpdate()
    if not self.bOpenned then
        return
    end

    self.TaskPanel:RefreshTab()
    self.TaskPanel:RefreshTaskList()

    PassManager.bHasNotClaimedTask = self.TaskPanel.bHasNotClaimed
    self.TopTab.TaskRedDot:SetVisibility(self.TaskPanel.bHasNotClaimed and ESlateVisibility.HitTestInvisible or ESlateVisibility.Collapsed)
end

function UGCPass_Main_UIBP:ShowGetPopup(ItemList)
    if UGCObjectUtility.IsObjectValid(self.GetPopup) then
        self.GetPopup:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.GetPopup:Refresh(ItemList)
        return
    end

    UGCWidgetManagerSystem.CreateWidgetAsync(self.GetPopupUIClassPath, 
        function (Widget)
            if not UGCObjectUtility.IsObjectValid(self) or Widget == nil then
                PassManager:Error("Load GetPopup failed")
                return
            end

            self.GetPopup = Widget
            UGCWidgetManagerSystem.AddToSlot(self.GetPopup, "UI.UISlot.MainUISlot_High", 20)
            self.GetPopup:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.GetPopup:Refresh(ItemList)
            PassManager:Log("GetPopup load finished")
        end
    )
end

function UGCPass_Main_UIBP:ShowBuyAdvancedPassPanel(PassID)
    if UGCObjectUtility.IsObjectValid(self.BuyAdvancedPassPanel) then
        if self.BuyAdvancedPassPanel.bBlockBuy then
            PassManager:Log("Block Buy", "UGCPass_Main_UIBP:ShowBuyAdvancedPassPanel")
            return
        end

        self.BuyAdvancedPassPanel:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.BuyAdvancedPassPanel:Refresh(PassID)
        return
    end

    UGCWidgetManagerSystem.CreateWidgetAsync(self.BuyAdvancedPassClassPath, 
        function (Widget)
            if not UGCObjectUtility.IsObjectValid(self) or Widget == nil then
                PassManager:Error("Load BuyAdvancedPassPanel failed")
                return
            end

            self.BuyAdvancedPassPanel = Widget
            UGCWidgetManagerSystem.AddToSlot(self.BuyAdvancedPassPanel, "UI.UISlot.MainUISlot_High", 30)
            self.BuyAdvancedPassPanel:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.BuyAdvancedPassPanel:Refresh(PassID)

            PassManager:Log("Load BuyAdvancedPassPanel finished")
        end
    )
end

function UGCPass_Main_UIBP:ShowUnlockAdvancedPassPanel(PassID)
    if UGCObjectUtility.IsObjectValid(self.UnlockAdvancedPassPanel) then
        self.UnlockAdvancedPassPanel:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.UnlockAdvancedPassPanel:Refresh(PassID)
        return
    end

    UGCWidgetManagerSystem.CreateWidgetAsync(self.UnlockAdvancedPassClassPath, 
        function (Widget)
            if not UGCObjectUtility.IsObjectValid(self) or Widget == nil then
                PassManager:Error("Load UnlockAdvancedPassPanel failed")
                return
            end

            self.UnlockAdvancedPassPanel = Widget
            UGCWidgetManagerSystem.AddToSlot(self.UnlockAdvancedPassPanel, "UI.UISlot.MainUISlot_High", 40)
            self.UnlockAdvancedPassPanel:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.UnlockAdvancedPassPanel:Refresh(PassID)

            PassManager:Log("Load UnlockAdvancedPassPanel finished")
        end
    )
end

function UGCPass_Main_UIBP:ShowRechargeSkipTaskItemPanel(ProductID)
    if UGCObjectUtility.IsObjectValid(self.RechargeSkipTaskItemPanel) then
        self.RechargeSkipTaskItemPanel:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.RechargeSkipTaskItemPanel:Refresh(ProductID)
        return
    end

    UGCWidgetManagerSystem.CreateWidgetAsync(self.RechargeSkipTaskItemUIPath, 
        function (Widget)
            if not UGCObjectUtility.IsObjectValid(self) or Widget == nil then
                PassManager:Error("Load RechargeSkipTaskItemPanel failed")
                return
            end

            self.RechargeSkipTaskItemPanel = Widget
            UGCWidgetManagerSystem.AddToSlot(self.RechargeSkipTaskItemPanel, "UI.UISlot.MainUISlot_High", 40)
            self.RechargeSkipTaskItemPanel:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.RechargeSkipTaskItemPanel:Refresh(ProductID)

            PassManager:Log("Load RechargeSkipTaskItemPanel finished")
        end
    )
end

function UGCPass_Main_UIBP:ShowTipPanel(Title, Description, ConfirmText)
    if UGCObjectUtility.IsObjectValid(self.TipPanel) then
        self.TipPanel:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.TipPanel:Refresh(Title, Description, ConfirmText)
        return self.TipPanel.OnClickDelegate
    end

    UGCWidgetManagerSystem.CreateWidgetAsync(self.TipPanelUIClassPath, 
        function (Widget)
            if not UGCObjectUtility.IsObjectValid(self) or Widget == nil then
                PassManager:Error("Load TipPanel failed")
                return nil
            end

            self.TipPanel = Widget
            UGCWidgetManagerSystem.AddToSlot(self.TipPanel, "UI.UISlot.MainUISlot_High", 40)
            self.TipPanel:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.TipPanel:Refresh(Title, Description, ConfirmText)

            PassManager:Log("Load TipPanel finished")

            return self.TipPanel.OnClickDelegate
        end
    )
end

return UGCPass_Main_UIBP