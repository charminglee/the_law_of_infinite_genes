---@class UGCPass_Task_Item2_UIBP_C:UUserWidget
---@field CoinIcon UImage
---@field CoinNum UTextBlock
---@field DescriptionText UTextBlock
---@field FinishButton UNewButton
---@field FX_SweepLight UImage
---@field PointIcon UImage
---@field PointNum UTextBlock
---@field ProgressText UTextBlock
---@field QuickFinishButton UNewButton
---@field Switcher UWidgetSwitcher
--Edit Below--
local UGCPass_Task_Item2_UIBP = { InitDoOnce = false } 

function UGCPass_Task_Item2_UIBP:Construct()
    self.FinishButton.OnClicked:Add(self.OnFinishButtonClick, self)
    self.QuickFinishButton.OnClicked:Add(self.OnQuickFinishButtonClick, self)
end

function UGCPass_Task_Item2_UIBP:Destruct()
    self.FinishButton.OnClicked:Remove(self.OnFinishButtonClick, self)
    self.QuickFinishButton.OnClicked:Remove(self.OnQuickFinishButtonClick, self)
end

function UGCPass_Task_Item2_UIBP:Refresh(PassID, TaskIndex)
    local PassConfig = PassManager:GetPassConfigData(PassID)
    if PassConfig == nil then
        PassManager:LogError("No config for PassID " .. PassID, "UGCPass_Task_Item2_UIBP:Refresh")
        return
    end

    local TaskConfig = PassManager:GetTaskConfigData(PassID, TaskIndex)
    if TaskConfig == nil then
        PassManager:LogError("TaskConfig is nil", "UGCPass_Task_Item2_UIBP:Refresh")
        return
    end

    self.PassID         = PassID
    self.TaskLineName   = PassConfig.TaskLineName
    self.TaskIndex      = TaskConfig.TaskIndex

    local TaskDetail = PassManager:GetTaskDetail(TaskConfig.TaskID)
    if TaskDetail then
        if #TaskDetail.TaskAwardList > 0 then
            PassManager:SetImageFromItemID(self.PointIcon, TaskDetail.TaskAwardList[1].ItemID)
            self.PointNum:SetText(TaskDetail.TaskAwardList[1].ItemNum)
        else
            PassManager:LogWarning("TaskID=" .. TaskConfig.TaskID .. " has no award PointItemID", "UGCPass_Task_Item2_UIBP:Refresh")
        end
    end

    local TaskState = PassManager:GetTaskState(PassID, TaskConfig.TaskIndex)
    if TaskState == EUGCTaskState.NotBegin then
        self.DescriptionText:SetText("未到解锁时间")
        self.ProgressText:SetVisibility(ESlateVisibility.Collapsed)
        self.Switcher:SetActiveWidgetIndex(3)
        return
    elseif TaskState == EUGCTaskState.Incomplete then
        local SkipItemProductData = PassManager:GetCommodityOperationManager():GetProductData(PassConfig.SkipTaskProductID)
        local SkipTaskItemID = SkipItemProductData and SkipItemProductData.ItemID or 0

        if SkipTaskItemID ~= 0 and TaskConfig.SkipItemNum > 0 then
            --显示快速完成
            self.Switcher:SetActiveWidgetIndex(1)
            PassManager:SetImageFromItemID(self.CoinIcon, SkipTaskItemID)
            self.CoinNum:SetText(tostring(TaskConfig.SkipItemNum))

            local VirtualItemManager = PassManager:GetVirtualItemManager()
            if VirtualItemManager ~= nil then
                local CurSkipItemNum = VirtualItemManager:GetItemNum(SkipTaskItemID)
                if CurSkipItemNum < TaskConfig.SkipItemNum then
                    self.CoinNum:SetColorRGBStr("FF0000")
                else
                    self.CoinNum:SetColorRGBStr("2A2B68FF")
                end
            end
        else
            self.Switcher:SetActiveWidgetIndex(3)
        end
    elseif TaskState == EUGCTaskState.NotClaimed then
        self.Switcher:SetActiveWidgetIndex(0)
    elseif TaskState == EUGCTaskState.HasClaimed then
        self.Switcher:SetActiveWidgetIndex(2)
    elseif TaskState == EUGCTaskState.Expired then
        PassManager:LogError(string.format("TaskID %s expired, task end time must equal to taskline end time!", TaskConfig.TaskID), "UGCPass_Task_Item2_UIBP:Refresh")
        return
    end

    self.DescriptionText:SetText(TaskDetail.TaskDesc)

    local Goal = PassManager:GetTaskGoal(TaskConfig.TaskID)
    local Current = PassManager:GetTaskProgress(self.TaskLineName, TaskConfig.TaskIndex)
    self.ProgressText:SetText(Current .. "/" .. Goal)
    self.ProgressText:SetVisibility(ESlateVisibility.HitTestInvisible)
end

function UGCPass_Task_Item2_UIBP:OnFinishButtonClick()
    local TaskPlayerComp = PassManager:GetTaskPlayerComponent()
    if TaskPlayerComp == nil then
        PassManager:LogError("TaskPlayerComp is nil", "UGCPass_Task_Item2_UIBP:OnFinishButtonClick")
        return
    end

    TaskPlayerComp:ClaimPercentTaskAward(self.TaskLineName, self.TaskIndex)
end

function UGCPass_Task_Item2_UIBP:OnQuickFinishButtonClick()
    local TaskManager = PassManager:GetTaskManager()
    if TaskManager == nil then
        PassManager:LogError("TaskManager is nil", "UGCPass_Task_Item2_UIBP:OnQuickFinishButtonClick")
        return
    end

    local PassConfig = PassManager:GetPassConfigData(self.PassID)
    local TaskConfig = PassManager:GetTaskConfigData(self.PassID, self.TaskIndex)

    if PassConfig.SkipTaskProductID ~= 0 and TaskConfig.SkipItemNum > 0 then
        local SkipTaskItemID = PassManager:GetCommodityOperationManager():GetProductData(PassConfig.SkipTaskProductID).ItemID

        local CurNum = PassManager:GetVirtualItemManager():GetItemNum(SkipTaskItemID)
        if CurNum >= TaskConfig.SkipItemNum then
            if not self.BlockQuickFinish then
                PassManager:QuickCompleteTask(self.PassID, self.TaskIndex)
                self.BlockQuickFinish = true
                UGCTimerUtility.CreateLuaTimer(1, function () self.BlockQuickFinish = false end)
            end
        else
            PassManager:ShowRechargeSkipTaskItemPanel(PassConfig.SkipTaskProductID)
        end
    end
end

return UGCPass_Task_Item2_UIBP