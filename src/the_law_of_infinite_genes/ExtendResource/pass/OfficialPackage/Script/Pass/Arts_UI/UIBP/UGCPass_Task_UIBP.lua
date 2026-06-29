---@class UGCPass_Task_UIBP_C:UUserWidget
---@field ClaimAllButton UNewButton
---@field ClaimButtonSwitcher UWidgetSwitcher
---@field DescriptionButton UButton
---@field PassTaskTab UGCPass_Task_Item1_UIBP_C
---@field PointIcon UImage
---@field ProgressBar UProgressBar
---@field ProgressText UTextBlock
---@field SkipItemIcon UImage
---@field SkipItemNumText UTextBlock
---@field TaskList ReuseList2_C
---@field ThemeIcon UImage
---@field TipText UTextBlock
---@field WeeklyTaskTab UGCPass_Task_Item1_UIBP_C
---@field WeekTabList ReuseList2_C
---@field WeekTabs UCanvasPanel
--Edit Below--
local UGCPass_Task_UIBP = 
{ 
    bInitDoOnce = false,
    PassID = 0,

    CurrentTab = 0,
    CurrentWeekTasks = nil,
    SelectedWeek = nil,

    bHasNotClaimed = false,
    
    ClaimTaskIndexs = {}
} 

function UGCPass_Task_UIBP:Construct()
	self.WeeklyTaskTab:Init("周挑战")
    self.PassTaskTab:Init("赛季挑战")

    self.WeeklyTaskTab.Button.OnClicked:Add(self.OnWeeklyTaskTabClick, self)
    self.PassTaskTab.Button.OnClicked:Add(self.OnPassTaskTabClick, self)
    self.ClaimAllButton.OnClicked:Add(self.OnClaimAllButtonClick, self)

    ---可自定义内容
    self.DescriptionButton.OnClicked:Add(self.OnDescriptionClick, self)

    self.TaskList.OnUpdateItem:Add(self.RefreshTask, self)
    self.WeekTabList.OnUpdateItem:Add(self.RefreshWeekTab, self)
end

function UGCPass_Task_UIBP:Destruct()
    self.WeeklyTaskTab.Button.OnClicked:Remove(self.OnWeeklyTaskTabClick, self)
    self.PassTaskTab.Button.OnClicked:Remove(self.OnPassTaskTabClick, self)
    self.ClaimAllButton.OnClicked:Remove(self.OnClaimAllButtonClick, self)

    self.DescriptionButton.OnClicked:Remove(self.OnDescriptionClick, self)

    self.TaskList.OnUpdateItem:Remove(self.RefreshTask, self)
    self.WeekTabList.OnUpdateItem:Remove(self.RefreshWeekTab, self)
end

function UGCPass_Task_UIBP:Refresh(PassID)
    PassID = PassID or self.PassID
    self.PassID = PassID

    local PassConfig = PassManager:GetPassConfigData(PassID)
    if PassConfig == nil then
        PassManager:LogError("PassConfig is nil", "UGCPass_Task_UIBP:Refresh")
        return
    end

    self.StartDate = os.date("*t", PassConfig.StartTime)
    self.EndDate = os.date("*t", PassConfig.EndTime)

    if PassConfig.SkipTaskProductID ~= 0 then
        local SkipTaskItemID = PassManager:GetCommodityOperationManager():GetProductData(PassConfig.SkipTaskProductID).ItemID
        PassManager:SetImageFromItemID(self.SkipItemIcon, SkipTaskItemID)
        self.SkipItemIcon:SetVisibility(ESlateVisibility.HitTestInvisible)
    else
        self.SkipItemIcon:SetVisibility(ESlateVisibility.Collapsed)
    end

    PassManager:SetImageFromItemID(self.PointIcon, PassConfig.PointItemID)
    PassManager:SetImageFromIconPath(self.ThemeIcon, PassConfig.ThemeIcon)

    self:RefreshTab()
    self:RefreshTaskList()
    self:RefreshPassProgress()
end

function UGCPass_Task_UIBP:RefreshPassProgress()
    PassManager:Log("", "UGCPass_Task_UIBP:RefreshPassProgress")

    local LevelData = PassManager:GetPassCurrentLevelData(self.PassID)

    self.ProgressText:SetText(LevelData.Point .. "/" .. LevelData.NextPoint)
    self.ProgressBar:SetPercent(LevelData.Point / LevelData.NextPoint)

    local PassConfig = PassManager:GetPassConfigData(self.PassID)
    if PassConfig.SkipItemProductID ~= 0 then
        local VirtualItemManager = PassManager:GetVirtualItemManager()
        local SkipItemItemID = PassManager:GetCommodityOperationManager():GetProductData(PassConfig.SkipTaskProductID).ItemID
        self.SkipItemNumText:SetText(VirtualItemManager:GetItemNum(SkipItemItemID))
        self.SkipItemNumText:SetVisibility(ESlateVisibility.HitTestInvisible)
    else
        self.SkipItemNumText:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function UGCPass_Task_UIBP:RefreshTab()
    PassManager:Log("", "UGCPass_Task_UIBP:RefreshTab")

    if self.CurrentTab == 0 then
        self.WeeklyTaskTab:Select()
        self.PassTaskTab:Deselect()
        self.WeekTabs:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    elseif self.CurrentTab == 1 then
        self.PassTaskTab:Select()
        self.WeeklyTaskTab:Deselect()
        self.WeekTabs:SetVisibility(ESlateVisibility.Collapsed)
    end

    ---更新任务组页签进度
    local TaskConfigs = PassManager:GetTaskConfigDatas(self.PassID)
    if TaskConfigs == nil then
        PassManager:LogError("TaskConfig is nil", "UGCPass_Task_UIBP:RefreshTab")
        return
    end

    local bCanClaimAll = false

    ---周任务
    local MaxNum, FinishedNum, bShowRedDot = 0, 0, false
    for _, TaskIndexs in pairs(TaskConfigs.WeeklyTaskIndexs) do
        for _, TaskIndex in ipairs(TaskIndexs) do
            local TaskState = PassManager:GetTaskState(self.PassID, TaskIndex)
            MaxNum = MaxNum + 1
            if TaskState == EUGCTaskState.HasClaimed then
                FinishedNum = FinishedNum + 1
            elseif TaskState == EUGCTaskState.NotClaimed then
                bShowRedDot = true
                bCanClaimAll = true
            end
        end
    end

    self.WeeklyTaskTab:RefreshProgress(FinishedNum, MaxNum, bShowRedDot)

    ---赛季任务
    local MaxNum, FinishedNum, bShowRedDot = 0, 0, false
    for _, TaskIndex in ipairs(TaskConfigs.PassTaskIndexs) do
        local TaskState = PassManager:GetTaskState(self.PassID, TaskIndex)
        MaxNum = MaxNum + 1
        if TaskState == EUGCTaskState.HasClaimed then
            FinishedNum = FinishedNum + 1
        elseif TaskState == EUGCTaskState.NotClaimed then
            bShowRedDot = true
            bCanClaimAll = true
        end
    end

    self.PassTaskTab:RefreshProgress(FinishedNum, MaxNum, bShowRedDot)

    self.ClaimButtonSwitcher:SetActiveWidgetIndex(bCanClaimAll and 0 or 1)
    self.bHasNotClaimed = bCanClaimAll
end

function UGCPass_Task_UIBP:RefreshTaskList()
    PassManager:Log("", "UGCPass_Task_UIBP:RefreshTaskList")

    local TaskConfigs = PassManager:GetTaskConfigDatas(self.PassID)
    if TaskConfigs == nil then
        PassManager:LogError("TaskConfig is nil", "UGCPass_Task_UIBP:RefreshTaskList")
        return
    end

    if self.CurrentTab == 0 then
        self.SelectedWeek = self.SelectedWeek or PassManager:GetCurrentWeek(self.PassID)
        self.SelectedWeek = math.min(self.SelectedWeek, TaskConfigs.MaxWeek)
        self:RefreshWeeklyTaskList()
    elseif self.CurrentTab == 1 then
        self.TaskList:Reload(#TaskConfigs.PassTaskIndexs)
    end
end

function UGCPass_Task_UIBP:RefreshWeeklyTaskList()
    PassManager:Log("", "UGCPass_Task_UIBP:RefreshWeeklyTaskList")

    local TaskConfigs = PassManager:GetTaskConfigDatas(self.PassID)
    if TaskConfigs == nil then
        PassManager:LogError("TaskConfig is nil", "UGCPass_Task_UIBP:RefreshWeeklyTaskList")
        return
    end

    self.WeekTabList:Reload(TaskConfigs.MaxWeek)

    if TaskConfigs.WeeklyTaskIndexs[self.SelectedWeek] then
        self.CurrentWeekTaskIndexs = TaskConfigs.WeeklyTaskIndexs[self.SelectedWeek]
        self.TaskList:Reload(#self.CurrentWeekTaskIndexs)
    else
        PassManager:LogWarning("No task in week " .. self.SelectedWeek, "UGCPass_Task_UIBP:RefreshWeeklyTaskList")
        self.TaskList:Reload(0)
    end
end

function UGCPass_Task_UIBP:RefreshTask(Widget, Index)
    local TaskConfigs = PassManager:GetTaskConfigDatas(self.PassID)
    if TaskConfigs == nil then
        PassManager:LogError("TaskConfig is nil", "UGCPass_Task_UIBP:RefeshTask")
        return
    end

    local Index = Index + 1
    local TaskIndexs = nil
    if self.CurrentTab == 0 then
        TaskIndexs = TaskConfigs.WeeklyTaskIndexs[self.SelectedWeek]
    elseif self.CurrentTab == 1 then
        TaskIndexs = TaskConfigs.PassTaskIndexs
    end

    if TaskIndexs then
        Widget:Refresh(self.PassID, TaskIndexs[Index])
    end
end

function UGCPass_Task_UIBP:RefreshWeekTab(Widget, Index)
    local TaskConfigs = PassManager:GetTaskConfigDatas(self.PassID)
    if TaskConfigs == nil then
        PassManager:LogError("TaskConfig is nil", "UGCPass_Task_UIBP:RefeshTask")
        return
    end

    Index = Index + 1
    local FinishedNum, MaxNum, bShowRedDot = 0, 0, false
    for _, TaskIndex in ipairs(TaskConfigs.WeeklyTaskIndexs[Index]) do
        local State = PassManager:GetTaskState(self.PassID, TaskIndex)
        MaxNum = MaxNum + 1
        if State == EUGCTaskState.HasClaimed then
            FinishedNum = FinishedNum + 1
        elseif State == EUGCTaskState.NotClaimed then
            bShowRedDot = true
        end
    end

    Widget:Refresh(Index, FinishedNum, MaxNum, bShowRedDot, Index > PassManager:GetCurrentWeek(self.PassID))

    if Index == self.SelectedWeek then
        Widget:Select()
    else
        Widget:Deselect()
    end
end

function UGCPass_Task_UIBP:RefreshClaimAllButton()
    
end

function UGCPass_Task_UIBP:SelectWeekTab(Week)
    if self.CurrentTab ~= 0 then
        return
    end

    self.SelectedWeek = Week
    self:RefreshTab()
    self:RefreshTaskList()
end

function UGCPass_Task_UIBP:OnWeeklyTaskTabClick()
    if self.CurrentTab == 0 then
        return
    end

    PassManager:Log("Select weekly task tab", "UGCPass_Task_UIBP:OnWeeklyTaskTabClick")
    
    self.CurrentTab = 0

    self:RefreshTab()
    self:RefreshTaskList()
end

function UGCPass_Task_UIBP:OnPassTaskTabClick()
    if self.CurrentTab == 1 then
        return
    end

    PassManager:Log("Select pass task tab", "UGCPass_Task_UIBP:OnPassTaskTabClick")

    self.CurrentTab = 1

    self:RefreshTab()
    self:RefreshTaskList()
end

function UGCPass_Task_UIBP:OnClaimAllButtonClick()
    if not self.BlockClaimAll then
        PassManager:Log("Claim all tasks", "UGCPass_Task_UIBP:OnClaimAllButtonClick")
        PassManager:ClaimAllTasks(self.PassID)
        self.BlockClaimAll = true
        UGCTimerUtility.CreateLuaTimer(1, function () self.BlockClaimAll = false end)
    end
end

function UGCPass_Task_UIBP:OnDescriptionClick()
    ---可自定义内容
    PassManager:ShowTipPanel("?", "该UI可以参考wiki说明自行修改", "确定")
end

function UGCPass_Task_UIBP:StartWeekTimer()
    if not self.WeekTimer then
        self:DoWeekTimer() 
    end
end

function UGCPass_Task_UIBP:StopWeekTimer()
    if self.WeekTimer then
        UGCTimerUtility.RemoveLuaTimer(self.WeekTimer)
        self.WeekTimer = nil
    end
end

function UGCPass_Task_UIBP:DoWeekTimer()
    local CurrentWeek = PassManager:GetCurrentWeek(self.PassID)
    local StartDate = string.format("%d年%d月", self.StartDate.year, self.StartDate.month)
    local EndDate = string.format("%d年%d月", self.EndDate.year, self.EndDate.month)
    self.TipText:SetText(string.format("当前赛季:%s-%s,当前为第%d周", StartDate, EndDate, CurrentWeek))

    self.WeekTimer = UGCTimerUtility.CreateLuaTimer(1, function () self:DoWeekTimer() end)
end

return UGCPass_Task_UIBP