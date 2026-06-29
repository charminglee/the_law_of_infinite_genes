---@class UGCPass_AwardContent_UIBP_C:UUserWidget
---@field AdvancedPassIcon UImage
---@field AdvancedPassNameText UTextBlock
---@field ArchiveButton UNewButton
---@field AwardsList ReuseList2_C
---@field BaseAwardButton UNewButton
---@field BasePassIcon UImage
---@field BasePassNameText UTextBlock
---@field BuyAdvancedPassButton UNewButton
---@field BuyAdvancedPassText UTextBlock
---@field BuyLevelButton UNewButton
---@field CountDownText UTextBlock
---@field CurrentLevelText UTextBlock
---@field DescriptionButton UNewButton
---@field FullLevelButton UNewButton
---@field GetAllAwardButton UNewButton
---@field GetAllAwardNumText UTextBlock
---@field LevelProgressText UTextBlock
---@field LevelPurchaseSwitcher UWidgetSwitcher
---@field Lock UCanvasPanel
---@field LockMask UImage
---@field NextAdvancedAward UGCPass_Common_Item_UIBP_C
---@field NextAwardLevelText UTextBlock
---@field NextBaseAward UGCPass_Common_Item_UIBP_C
---@field PointIcon UImage
---@field PrizePreviewButton UNewButton
---@field RedDot UCanvasPanel
---@field RuleButton UButton
---@field ShareButton UNewButton
---@field ThemeIcon UImage
---@field ThemeNameText UTextBlock
---@field UnlockButton UNewButton
---@field BuyLevelUIClassPath FSoftClassPath
---@field PrizePreviewUIClassPath FSoftClassPath
---@field RecordUIClassPath FSoftClassPath
--Edit Below--
local UGCPass_AwardContent_UIBP = 
{ 
    bInitDoOnce = false,
    PassID = 0,
    bHasRedDot = false,
    BuyLevelPanel = nil,

    bHasAdvancedPass = false,
} 

function UGCPass_AwardContent_UIBP:Construct()
    self.BuyAdvancedPassButton.OnClicked:Add(self.OnBuyAdvancedPassButtonClick, self)
    self.BuyLevelButton.OnClicked:Add(self.OnBuyLevelButtonClick, self)
    self.GetAllAwardButton.OnClicked:Add(self.OnGetAllAwardButtonClick, self)
    self.BuyAdvancedPassButton.OnClicked:Add(self.OnBuyAdvancedPassButtonClick, self)
    self.PrizePreviewButton.OnClicked:Add(self.OnPrizePreviewButtonClick, self)
    self.ArchiveButton.OnClicked:Add(self.OnArchiveButtonClick, self)

    self.AwardsList.OnUpdateItem:Add(self.RefreshAward, self)

    --自定义Button
    self.DescriptionButton.OnClicked:Add(self.OnDescriptionButtonClick, self)
    self.RuleButton.OnClicked:Add(self.OnRuleButtonClick, self)

    PassManager.OnClaimAwardClickDelegate:Add(self.OnAwardClicked, self)
end

function UGCPass_AwardContent_UIBP:Destruct()
    self.BuyAdvancedPassButton.OnClicked:Remove(self.OnBuyAdvancedPassButtonClick, self)
    self.BuyLevelButton.OnClicked:Remove(self.OnBuyLevelButtonClick, self)
    self.GetAllAwardButton.OnClicked:Remove(self.OnGetAllAwardButtonClick, self)
    self.BuyAdvancedPassButton.OnClicked:Remove(self.OnBuyAdvancedPassButtonClick, self)
    self.PrizePreviewButton.OnClicked:Remove(self.OnPrizePreviewButtonClick, self)
    self.ArchiveButton.OnClicked:Remove(self.OnArchiveButtonClick, self)

    self.AwardsList.OnUpdateItem:Remove(self.RefreshAward, self)

    self.DescriptionButton.OnClicked:Remove(self.OnDescriptionButtonClick, self)
    self.RuleButton.OnClicked:Remove(self.OnRuleButtonClick, self)

    PassManager.OnClaimAwardClickDelegate:Remove(self.OnAwardClicked, self)
end

function UGCPass_AwardContent_UIBP:Refresh(PassID)
    self.PassID = PassID
    self.bHasAdvancedPass = PassManager:HasAdvancedPass(self.PassID)

    local PassConfig = PassManager:GetPassConfigData(self.PassID)

    self.ThemeNameText:SetText(PassConfig.ThemeName)
    self.BasePassNameText:SetText(PassConfig.BasePassName)
    self.AdvancedPassNameText:SetText(PassConfig.AdvancedPassName)

    PassManager:SetImageFromIconPath(self.ThemeIcon, PassConfig.ThemeIcon)
    PassManager:SetImageFromIconPath(self.BasePassIcon, PassConfig.BasePassIcon)
    PassManager:SetImageFromIconPath(self.AdvancedPassIcon, PassConfig.AdvancedPassIcon)
    PassManager:SetImageFromItemID(self.PointIcon, PassConfig.PointItemID)

    self.NotClaimedAwardNum = PassManager:GetNotClaimedAwardNum(PassID)

    if self.bHasAdvancedPass then
        self.BuyAdvancedPassButton:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.BuyAdvancedPassButton:SetVisibility(ESlateVisibility.Visible)
    end

    self:RefreshGetAllAwardButton()
    self:RefreshLevel()
    self:RefreshAwardList()

    self.AwardsList:JumpByIdxStyle(self.LevelData.Level)
end

function UGCPass_AwardContent_UIBP:RefreshGetAllAwardButton()
    if self.NotClaimedAwardNum > 0 then
        local Num = self.NotClaimedAwardNum
        if PassManager:HasAdvancedPass(self.PassID) then
            Num = Num * 2
        end

        Num = math.min(Num, 99)

        self.RedDot:SetVisibility(ESlateVisibility.HitTestInvisible)
        self.GetAllAwardNumText:SetText(tostring(Num))
    else
        self.RedDot:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function UGCPass_AwardContent_UIBP:RefreshLevel()
    PassManager:Log("", "UGCPass_AwardContent_UIBP:RefreshLevel")

    self.LevelData = PassManager:GetPassCurrentLevelData(self.PassID)

    self.CurrentLevelText:SetText(self.LevelData.Level)
    self.LevelProgressText:SetText(self.LevelData.Point .. "/" .. self.LevelData.NextPoint)
end

function UGCPass_AwardContent_UIBP:UpdateAward(Index)
    local Widgets = {}
    self.AwardsList:GetAllItems(Widgets, true)

    for _, Widget in ipairs(Widgets) do
        if Widget.Index == Index then
            self:RefreshAward(Widget, Index-1)
            return
        end
    end
end

function UGCPass_AwardContent_UIBP:RefreshAwardList()
    PassManager:Log("", "UGCPass_AwardContent_UIBP:RefreshAwardList")

    local AwardConfigs = PassManager:GetPassAwardConfigData(self.PassID)

    if AwardConfigs == nil then
        PassManager:LogError("AwardConfig is nil", "UGCPass_Main_UIBP:RefreshAwardList")
        return
    end

    local NextLevel = math.min(math.floor(self.LevelData.Level / 10 + 1) * 10, #AwardConfigs)
    self.NextAwardLevelText:SetText(tostring(NextLevel))

    self.NextBaseAward:Reset()
    self.NextAdvancedAward:Reset()
    local AwardState = PassManager:GetAwardState(self.PassID, NextLevel)
    if AwardState == EUGCTaskLineAwardState.Lock then
        self.NextBaseAward.LockIcon:SetVisibility(ESlateVisibility.HitTestInvisible)
        self.NextAdvancedAward.LockIcon:SetVisibility(ESlateVisibility.HitTestInvisible)
    elseif AwardState == EUGCTaskLineAwardState.HasClaimed then
        self.NextBaseAward.ClaimedIcon:SetVisibility(ESlateVisibility.HitTestInvisible)
        self.NextAdvancedAward.ClaimedIcon:SetVisibility(ESlateVisibility.HitTestInvisible)
    end

    self.NextBaseAward:Refresh(AwardConfigs[NextLevel].NormalItem)
    self.NextAdvancedAward:Refresh(AwardConfigs[NextLevel].AdvancedItem)
    self.AwardsList:Reload(#AwardConfigs)
end

---@param Widget UGCPass_Award_Item1_UIBP_C
function UGCPass_AwardContent_UIBP:RefreshAward(Widget, Index)
    local AwardConfig = PassManager:GetPassAwardConfigData(self.PassID)
    Index = Index + 1
    local LevelStr = Index .. "级"

    Widget.Index = Index

    Widget.LevelText:SetText(LevelStr)
    Widget.CurrentLevelText:SetText(LevelStr)
    Widget.LockedLevelText:SetText(LevelStr)

    Widget.BaseAward:Refresh(AwardConfig[Index].NormalItem)
    Widget.AdvancedAward:Refresh(AwardConfig[Index].AdvancedItem)

    self.Lock:SetVisibility(ESlateVisibility.Collapsed)
    self.LockMask:SetVisibility(ESlateVisibility.Collapsed)
    self:ResetAwardWidget(Widget)

    if not self.bHasAdvancedPass then
        self.Lock:SetVisibility(ESlateVisibility.HitTestInvisible)
        self.LockMask:SetVisibility(ESlateVisibility.HitTestInvisible)
    end

    local AwardState = PassManager:GetAwardState(self.PassID, Index)
    if AwardState == EUGCTaskLineAwardState.Lock then
        Widget.AwardStateSwitcher:SetActiveWidgetIndex(2)
        Widget.BaseAward.LockIcon:SetVisibility(ESlateVisibility.HitTestInvisible)
        Widget.AdvancedAward.LockIcon:SetVisibility(ESlateVisibility.HitTestInvisible)
    elseif AwardState == EUGCTaskLineAwardState.HasClaimed then
        Widget.AwardStateSwitcher:SetActiveWidgetIndex(0)
        Widget.BaseAward.ClaimedIcon:SetVisibility(ESlateVisibility.HitTestInvisible)

        if self.bHasAdvancedPass then
            Widget.AdvancedAward.ClaimedIcon:SetVisibility(ESlateVisibility.HitTestInvisible)
        end
    elseif AwardState == EUGCTaskLineAwardState.NotClaimed then
        Widget.AwardStateSwitcher:SetActiveWidgetIndex(1)
        Widget.BaseAward.CanClaim:SetVisibility(ESlateVisibility.HitTestInvisible)
        if self.bHasAdvancedPass then
            Widget.AdvancedAward.CanClaim:SetVisibility(ESlateVisibility.HitTestInvisible)
        end
    end
end

function UGCPass_AwardContent_UIBP:ResetAwardWidget(Widget)
    Widget.BaseAward.LockIcon:SetVisibility(ESlateVisibility.Collapsed)
    Widget.AdvancedAward.LockIcon:SetVisibility(ESlateVisibility.Collapsed)
    Widget.BaseAward.ClaimedIcon:SetVisibility(ESlateVisibility.Collapsed)
    Widget.AdvancedAward.ClaimedIcon:SetVisibility(ESlateVisibility.Collapsed)
    Widget.BaseAward.CanClaim:SetVisibility(ESlateVisibility.Collapsed)
    Widget.AdvancedAward.CanClaim:SetVisibility(ESlateVisibility.Collapsed)
end

function UGCPass_AwardContent_UIBP:OnAwardClicked(AwardIndex)
    local AwardState = PassManager:GetAwardState(self.PassID, AwardIndex)

    if AwardState == EUGCTaskLineAwardState.NotClaimed then
        PassManager:ClaimAward(self.PassID, AwardIndex) 
    end
end

function UGCPass_AwardContent_UIBP:OnBuyLevelButtonClick()
    if UGCObjectUtility.IsObjectValid(self.BuyLevelPanel) then
        self.BuyLevelPanel:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.BuyLevelPanel:Refresh(self.PassID)
        return
    end

    UGCWidgetManagerSystem.CreateWidgetAsync(self.BuyLevelUIClassPath, 
        function (Widget)
            if not UGCObjectUtility.IsObjectValid(self) or Widget == nil then
                PassManager:Error("Load BuyLevelPanel failed")
                return
            end

            self.BuyLevelPanel = Widget
            UGCWidgetManagerSystem.AddToSlot(self.BuyLevelPanel, "UI.UISlot.MainUISlot_High", 10)
            self.BuyLevelPanel:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.BuyLevelPanel:Refresh(self.PassID)
            PassManager:Log("BuyLevelPanel load finished")
        end
    )
end

function UGCPass_AwardContent_UIBP:OnGetAllAwardButtonClick()
    if not self.bBlockClaimAll and self.NotClaimedAwardNum > 0 then
        self.bBlockClaimAll = true
        PassManager:ClaimAllAwards(self.PassID)

        UGCTimerUtility.CreateLuaTimer(1, function () self.bBlockClaimAll = false end)
    end
end

function  UGCPass_AwardContent_UIBP:OnBuyAdvancedPassButtonClick()
    PassManager:ShowBuyAdvancedPassPanel(self.PassID)
end

function UGCPass_AwardContent_UIBP:OnPrizePreviewButtonClick()
    if UGCObjectUtility.IsObjectValid(self.PrizePreviewPanel) then
        self.PrizePreviewPanel:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.PrizePreviewPanel:Refresh(self.PassID)
        return
    end

    UGCWidgetManagerSystem.CreateWidgetAsync(self.PrizePreviewUIClassPath, 
        function (Widget)
            if not UGCObjectUtility.IsObjectValid(self) or Widget == nil then
                PassManager:Error("Load PrizePreviewPanel failed")
                return
            end

            self.PrizePreviewPanel = Widget
            UGCWidgetManagerSystem.AddToSlot(self.PrizePreviewPanel, "UI.UISlot.MainUISlot_High", 10)
            self.PrizePreviewPanel:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.PrizePreviewPanel:Refresh(self.PassID)
            PassManager:Log("PrizePreviewPanel load finished")
        end
    )
end

function UGCPass_AwardContent_UIBP:OnArchiveButtonClick()
    if UGCObjectUtility.IsObjectValid(self.RecordPanel) then
        self.RecordPanel:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.RecordPanel:Refresh()
        return
    end

    UGCWidgetManagerSystem.CreateWidgetAsync(self.RecordUIClassPath, 
        function (Widget)
            if not UGCObjectUtility.IsObjectValid(self) or Widget == nil then
                PassManager:Error("Load RecordPanel failed")
                return
            end

            self.RecordPanel = Widget
            UGCWidgetManagerSystem.AddToSlot(self.RecordPanel, "UI.UISlot.MainUISlot_High", 10)
            self.RecordPanel:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.RecordPanel:Refresh()
            PassManager:Log("RecordPanel load finished")
        end
    )
end

function UGCPass_AwardContent_UIBP:OnDescriptionButtonClick()
    ---可自定义内容
    PassManager:ShowTipPanel("说明", "该UI可以参考wiki说明自行修改", "确定")
end

function UGCPass_AwardContent_UIBP:OnRuleButtonClick()
    ---可自定义内容
    PassManager:ShowTipPanel("?", "该UI可以参考wiki说明自行修改", "确定")
end

function UGCPass_AwardContent_UIBP:RefreshCountDown(CountDown)
    if CountDown < 0 then
        return
    end

    local Day = math.floor(CountDown / 86400)
    local Hour = math.floor((CountDown % 86400) / 3600)

    self.CountDownText:SetText(string.format("本赛季结束倒计时:%d天%d小时", Day, Hour))
end

return UGCPass_AwardContent_UIBP