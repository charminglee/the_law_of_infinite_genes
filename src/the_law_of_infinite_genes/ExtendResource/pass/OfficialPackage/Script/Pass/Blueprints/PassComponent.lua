---@class PassComponent_C:ActorComponent
---@field MainUIClassPath FSoftClassPath
---@field PassConfig UDataTable
--Edit Below--

UGCGameSystem.UGCRequire("ExtendResource.pass.OfficialPackage." .. "Script.Pass.PassManager")

local PassComponent = 
{
    MainUI = nil,
    ActivePassID = -1,
    OwnedAdvancedPass = {},
    CountDown = 0,

    HasClaimedAllAwardPassIDs = {}
}

local AddVirtualItemRequestMark = "PassComponent"
 
function PassComponent:ReceiveBeginPlay()
    PassComponent.SuperClass.ReceiveBeginPlay(self)
    PassManager:Log("Begin play", "PassComponent:ReceiveBeginPlay")

    local PlayerControllerClass = UGCObjectUtility.LoadClass("/Game/UGC/UGCGame/GameMode/BP_UGCPlayerController.BP_UGCPlayerController_C")

    if not UGCObjectUtility.IsA(self:GetOwner(), PlayerControllerClass) then
        PassManager:LogFatal("PassComponent must attach to a UGCPlayerController")
        return
    end

    PassManager:SetComponentClass(UGCObjectUtility.GetObjectClass(self))

    ---处理GamePart时序依赖后进行初始化
    local PromiseFuture = require("common.PromiseFuture")
    PassManager:Log("Check GamePart dependency start", "PassComponent:ReceiveBeginPlay")

    PromiseFuture.New():Set(
        function (PromiseFuture)
            while not self:CheckGamePartDependency() do
                PromiseFuture:Yield()
            end

            PassManager:Log("Check GamePart dependency finished", "PassComponent:ReceiveBeginPlay")

            self:Init()
        end
    ):AutoResume(self, 0.5, 20)
end

function PassComponent:CheckGamePartDependency()
    if not PassManager:GetTaskManager() then
        PassManager:Log("TaskManager is not ready yet", "PassComponent:CheckGamePartDependency")
        return false
    end

    local TaskComp = PassManager:GetTaskPlayerComponent(self:GetOwner())
    if not TaskComp then
        PassManager:Log("TaskComp is not ready yet", "PassComponent:CheckGamePartDependency")
        return false
    end

    if not TaskComp.TaskInited then
        PassManager:Log("Task is not init yet", "PassComponent:CheckGamePartDependency")
        return false
    end

    if not PassManager:GetVirtualItemManager() then
        PassManager:Log("VirtualItemManager is not ready yet", "PassComponent:CheckGamePartDependency")
        return false
    end

    return true
end

function PassComponent:ReceiveEndPlay()
    PassComponent.SuperClass.ReceiveEndPlay(self)    
    PassManager:Log("End play", "PassComponent:ReceiveEndPlay")

    self:UnbindDelegates()
end

function PassComponent:Init()
    local PC = self:GetOwner()

    if not UGCObjectUtility.IsObjectValid(PC) then
        PassManager:LogFatal("PlayerController is not valid", "PassComponent:Init")
        return
    end
    
    PassManager:Log("Begin init for " .. PC.PlayerKey, "PassComponent:Init")

    if not PassManager.bPassConfigLoaded then
        self:LoadConfig(self.PassConfig) 
    end

    if PC:HasAuthority() then
        self.ActivePassID = PassManager:GetActivePassID()
        UnrealNetwork.RepLazyProperty(self, "ActivePassID")

        self:StartPassTimeCheck(self.ActivePassID)

        if PassManager:HasAdvancedPass(self.ActivePassID, self:GetOwner()) then
            self.OwnedAdvancedPass[self.ActivePassID] = true
            UnrealNetwork.RepLazyProperty(self, "OwnedAdvancedPass")
        end
    else
        UGCWidgetManagerSystem.CreateWidgetAsync(self.MainUIClassPath, 
            function (Widget)
                if not UGCObjectUtility.IsObjectValid(self) or Widget == nil then
                    PassManager:LogFatal("Load MainUI failed", "PassComponent:Init")
                    return
                end

                self.MainUI = Widget
                UGCWidgetManagerSystem.AddToSlot(self.MainUI, "UI.UISlot.MainUISlot_High")
                self.MainUI:SetVisibility(ESlateVisibility.Collapsed)
                PassManager:Log("MainUI load finished")
            end
        )
    end

    self:BindDelegates()

    PassManager:Log("End init", "PassComponent:Init")
end

function PassComponent:BindDelegates()
    local TaskPlayerComp = PassManager:GetTaskPlayerComponent(self:GetOwner())
    local VirtualItemManager = PassManager:GetVirtualItemManager(self:GetOwner())

    if self:GetOwner():HasAuthority() then
        
    else
        TaskPlayerComp.OnTaskLineAwardInfoChangeDelegate:Add(self.OnTaskLineAwardInfoChange, self)
        TaskPlayerComp.OnTaskInfoChangeDelegate:Add(self.OnTaskInfoChange, self)
        TaskPlayerComp.OnTaskLineProgressChangeDelegate:Add(self.OnTaskLineProgressChange, self)
    end

    VirtualItemManager.AddItemResultDelegate:Add(self.OnAddItemResult, self)
end

function PassComponent:UnbindDelegates()
    local TaskPlayerComp = PassManager:GetTaskPlayerComponent(self:GetOwner())
    local VirtualItemManager = PassManager:GetVirtualItemManager(self:GetOwner())

    if self:GetOwner():HasAuthority() then
        
    else
        if UGCObjectUtility.IsObjectValid(TaskPlayerComp) then
            TaskPlayerComp.OnTaskLineAwardInfoChangeDelegate:Remove(self.OnTaskLineAwardInfoChange, self)
            TaskPlayerComp.OnTaskInfoChangeDelegate:Remove(self.OnTaskInfoChange, self)
            TaskPlayerComp.OnTaskLineProgressChangeDelegate:Remove(self.OnTaskLineProgressChange, self)
        end
    end

    if UGCObjectUtility.IsObjectValid(VirtualItemManager) then
        VirtualItemManager.AddItemResultDelegate:Remove(self.OnAddItemResult, self)
    end
end

function PassComponent:OnAddItemResult(Result)
    if not Result.bSucceeded then
        return
    end

    if self:GetOwner():HasAuthority() then
        --第一次获得高级通行证，则一次性领取之前未领取的高级奖励
        if not self.OwnedAdvancedPass[self.ActivePassID] and PassManager:HasAdvancedPass(self.ActivePassID, self:GetOwner()) then
            self.OwnedAdvancedPass[self.ActivePassID] = true
            UnrealNetwork.RepLazyProperty(self, "OwnedAdvancedPass")
            UnrealNetwork.CallUnrealRPC(self:GetOwner(), self, "ShowUnlockAdvancedPassPanel", self.ActivePassID)
            self:RetrieveAllAdvancedAwards()
        end
    elseif Result.RequestMark == AddVirtualItemRequestMark then
        self.MainUI:ShowGetPopup(Result.ItemList)
    end
end

function PassComponent:OnItemNumUpdate()
    --任务卡数量更新
    if self.MainUI and self.MainUI.bOpenned and self.MainUI.CurrentTab == 1 then
        local PassConfig = PassManager:GetPassConfigData(self.ActivePassID)

        if PassConfig.SkipTaskProductID == 0 then
            return
        end

        local SkipTaskItemID = PassManager:GetCommodityOperationManager():GetProductData(PassConfig.SkipTaskProductID).ItemID
        local SkipTaskItemNum = PassManager:GetVirtualItemManager():GetItemNum(SkipTaskItemID)

        if self.LastSkipTaskItemNum ~= SkipTaskItemNum then
            self.LastSkipTaskItemNum = SkipTaskItemNum
            self.MainUI.TaskPanel:Refresh(self.ActivePassID)
        end
    end
end

function PassComponent:OnTaskLineAwardInfoChange(TaskLineName, Index)
    local ConfigData = PassManager:GetConfigDataByTaskLineName(TaskLineName)
    if ConfigData == nil or self.ActivePassID ~= ConfigData.PassID then
        return
    end

    PassManager.OnAwardUpdateDelegate(TaskLineName, Index)

    PassManager:Log(string.format("TaskLineName=%s Index=%s", TaskLineName, Index), "PassComponent:OnTaskLineAwardInfoChange")
end

function PassComponent:OnTaskInfoChange(Info)
    local ConfigData = PassManager:GetConfigDataByTaskLineName(Info.TaskLineName)
    if ConfigData == nil or self.ActivePassID ~= ConfigData.PassID then
        return
    end

    PassManager.OnTaskUpdateDelegate()

    PassManager:Log(string.format("PassID=%s, TaskLineName=%s TaskIndex=%s", self.ActivePassID, Info.TaskLineName, Info.PercentTaskIndex), "PassComponent:OnTaskInfoChange")
end

function PassComponent:OnTaskLineProgressChange(TaskLineName)
    local ConfigData = PassManager:GetConfigDataByTaskLineName(TaskLineName)
    if ConfigData == nil or self.ActivePassID ~= ConfigData.PassID then
        return
    end

    PassManager:Log(string.format("PassID=%s, TaskLineName=%s", self.ActivePassID, TaskLineName), "PassComponent:OnTaskLineProgressChange")
    if self.MainUI == nil or not self.MainUI.bOpenned then
        return
    end

    if self.MainUI.CurrentTab == 0 then
        self.MainUI.AwardPanel:RefreshLevel()
    elseif self.MainUI.CurrentTab == 1 then
        self.MainUI.TaskPanel:RefreshPassProgress()
    end
end

function PassComponent:StartPassTimeCheck()
    PassManager:Log("Start time check PassID=" .. self.ActivePassID, "PassComponent:StartPassTimeCheck")

    self:DoPassTimeCheck(self.ActivePassID)
end

function PassComponent:StopPassTimeCheck()
    PassManager:Log("Stop time check PassID=" .. self.ActivePassID, "PassComponent:StopPassTimeCheck")

    UGCTimerUtility.RemoveLuaTimer(self.PassTimer)
    self.PassTimer = nil
end

function PassComponent:DoPassTimeCheck(PassID)
    local CurrentTime = UGCGameSystem.GetServerTimeSec()
    local Config = PassManager:GetPassConfigData(PassID)

    self.CountDown = Config.EndTime - CurrentTime
    UnrealNetwork.RepLazyProperty(self, "CountDown")

    if CurrentTime < Config.StartTime or CurrentTime >= Config.EndTime then
        self.ActivePassID = PassManager:GetActivePassID()
        PassID = self.ActivePassID

        PassManager:Log(string.format("PassID %d is ended, switch to new PassID %d", PassID, self.ActivePassID), "PassComponent:DoPassTimeCheck")
        UnrealNetwork.RepLazyProperty(self, "ActivePassID")
    end

    self.PassTimer = UGCTimerUtility.CreateLuaTimer(1, function () self:DoPassTimeCheck(PassID) end, false)
end

function PassComponent:LoadConfig()
    if self.PassConfig == nil then
        PassManager:LogFatal("PassConfig DataTable is nil", "PassComponent:LoadConfig")
        return
    end

    PassManager:LoadConfig(self.PassConfig)
end

function PassComponent:CheckPassID(PassID, CallingFuncName)
    if self.ActivePassID ~= PassID then
        PassManager:LogError(string.format("PassID %s is not current active PassID %s", PassID, self.ActivePassID), CallingFuncName)
        return false
    end

    return true
end

function PassComponent:Server_UpgradeLevel(PassID, TargetLevel)
    PassManager:Log(string.format("Upgrade PassID %d level to %d", PassID, TargetLevel), "PassComponent:UpgradeLevel")

    if not self:CheckPassID(PassID, "PassComponent:UpgradeLevel") then
        return
    end

    if not self:GetOwner():HasAuthority() then
        PassManager:LogError("Calling PassComponent:UpgradeLevel on client!")
        return
    end

    local PassConfig = PassManager:GetPassConfigData(PassID)
    local VirtualItemManager = PassManager:GetVirtualItemManager(self:GetOwner())
    local LevelData = PassManager:GetPassCurrentLevelData(PassID, self:GetOwner())
    local UpgradeLevel = TargetLevel - LevelData.Level

    if UpgradeLevel <= 0 then
        return
    end

    VirtualItemManager:RemoveItem(self:GetOwner(), PassConfig.LevelPurchaseItemID, PassConfig.LevelPurchaseItemNum * UpgradeLevel, 
        function (Result)
            if not Result.bSucceeded then
                PassManager:LogError(string.format("PlayerKey %s cost LevelPurchaseItemID %s Num %s failed", 
                                        Result.PlayerKey, Result.ItemID, Result.Num), "PassComponent:UpgradeLevel")
                return
            end
                        
            local TaskPlayerComp = PassManager:GetTaskPlayerComponent(self:GetOwner())
            
            local TargetLevelAwardConfig = PassConfig.Awards[TargetLevel] 
            if TargetLevelAwardConfig == nil then
                PassManager:LogError("Target level is invalid", "PassComponent:UpgradeLevel")
                return
            end

            TaskPlayerComp:SetTaskLineProgress(PassConfig.TaskLineName, TargetLevelAwardConfig.Point + LevelData.Point)
        end
    )
end

function PassComponent:Server_ClaimAward(PassID, AwardIndex)
    PassManager:Log(string.format("Claim PassID %d AwardIndex %d award", PassID, AwardIndex), "PassComponent:ClaimAward")

    if not self:CheckPassID(PassID, "PassComponent:ClaimAward") then
        return
    end

    if not self:GetOwner():HasAuthority() then
        PassManager:LogError("Calling PassComponent:ClaimAward on client!")
    end

    local PassConfig = PassManager:GetPassConfigData(PassID)
    local TaskPlayerComp = PassManager:GetTaskPlayerComponent(self:GetOwner())
    local VirtualItemManager = PassManager:GetVirtualItemManager()
    
    local AwardState = TaskPlayerComp:GetTaskLineAwardState(PassConfig.TaskLineName, AwardIndex)
    if AwardState ~= EUGCTaskLineAwardState.NotClaimed then
        PassManager:LogWarning(string.format("AwardIndex %d AwardState is not NotClaimed", AwardIndex), "PassComponent:ClaimAward")
        return
    end

    TaskPlayerComp:ClaimTaskLineAward(PassConfig.TaskLineName, AwardIndex)
    
    AwardState = TaskPlayerComp:GetTaskLineAwardState(PassConfig.TaskLineName, AwardIndex)
    if AwardState == EUGCTaskLineAwardState.HasClaimed then
        local Award = PassConfig.Awards[AwardIndex]
        if Award == nil then
            PassManager:LogError("Cannot find config for AwardIndex %s" .. AwardIndex, "PassComponent:ClaimAward")
            return
        end

        local ItemList = {}
        ItemList[Award.NormalItem.ItemID] = Award.NormalItem.Num
        if PassManager:HasAdvancedPass(PassID, self:GetOwner()) then
            ItemList[Award.AdvancedItem.ItemID] = Award.AdvancedItem.Num
        end

        local bSuccess = VirtualItemManager:AddVirtualItems(self:GetOwner(), ItemList, AddVirtualItemRequestMark)
        if not bSuccess then
            PassManager:LogError("Add award virtual item failed", "PassComponent:ClaimAward")
        end
    end
end

function PassComponent:Server_ClaimAllAwards(PassID)
    PassManager:Log(string.format("Claim PassID %d all awards", PassID), "PassComponent:ClaimAllAwards")

    -- if not self:CheckPassID(PassID, "PassComponent:ClaimAllAwards") then
    --     return
    -- end

    if not self:GetOwner():HasAuthority() then
        PassManager:LogError("Calling PassComponent:ClaimAllAwards on client!")
    end

    local TaskPlayerComp = PassManager:GetTaskPlayerComponent(self:GetOwner())
    local PassConfig = PassManager:GetPassConfigData(PassID)

    local ItemList = {}
    local NotClaimedList = {}
    local bHasAdvance = PassManager:HasAdvancedPass(PassID, self:GetOwner())
    for Index, Award in ipairs(PassConfig.Awards) do
        local AwardState = TaskPlayerComp:GetTaskLineAwardState(PassConfig.TaskLineName, Index)
        if AwardState == EUGCTaskLineAwardState.NotClaimed then
            TaskPlayerComp:ClaimTaskLineAward(PassConfig.TaskLineName, Index)
            AwardState = TaskPlayerComp:GetTaskLineAwardState(PassConfig.TaskLineName, Index)

            if AwardState == EUGCTaskLineAwardState.HasClaimed then
                ItemList[Award.NormalItem.ItemID] = (ItemList[Award.NormalItem.ItemID] or 0) + Award.NormalItem.Num
                if bHasAdvance then
                    ItemList[Award.AdvancedItem.ItemID] = (ItemList[Award.AdvancedItem.ItemID] or 0) + Award.AdvancedItem.Num
                end
            end
        end
    end

    local VirtualItemManager = PassManager:GetVirtualItemManager()
    local bSuccess = VirtualItemManager:AddVirtualItems(self:GetOwner(), ItemList, AddVirtualItemRequestMark)
    if not bSuccess then
        PassManager:LogError("Add award virtual item failed", "PassComponent:ClaimAllAwards")
        PassManager:LogTree("ItemList=", "PassComponent:ClaimAllAwards", ItemList)
    end
end

function PassComponent:RetrieveAllAdvancedAwards()
    PassManager:Log("Retrieve advanced awards", "PassComponent:RetrieveAllAdvancedAwards")

    local ItemList = {}
    local LevelData = PassManager:GetPassCurrentLevelData(self.ActivePassID, self:GetOwner())
    local AwardConfigs = PassManager:GetPassAwardConfigData(self.ActivePassID)

    local bNewItem = false
    for AwardIndex=1, LevelData.Level do
        local AwardConfig = AwardConfigs[AwardIndex]
        if AwardConfig then
            local AwardState = PassManager:GetAwardState(self.ActivePassID, AwardIndex, self:GetOwner())

            --之前已经领取过普通奖励
            if AwardState == EUGCTaskLineAwardState.HasClaimed then
                ItemList[AwardConfig.AdvancedItem.ItemID] = (ItemList[AwardConfig.AdvancedItem.ItemID] or 0) + AwardConfig.AdvancedItem.Num
                bNewItem = true
            end
        end
    end

    if bNewItem then
        local VirtualItemManager = PassManager:GetVirtualItemManager(self:GetOwner())
        VirtualItemManager:AddVirtualItems(self:GetOwner(), ItemList, AddVirtualItemRequestMark) 
    end
end

function PassComponent:Server_ClaimAllTasks(PassID)
    PassManager:Log(string.format("Claim PassID %d all completed tasks", PassID), "PassComponent:ClaimAllTasks")

    if not self:GetOwner():HasAuthority() then
        PassManager:LogError("Calling PassComponent:ClaimAllTasks on client!")
    end

    local TaskConfigs = PassManager:GetTaskConfigDatas(PassID)
    local TaskPlayerComp = PassManager:GetTaskPlayerComponent(self:GetOwner())
    local PassConfig = PassManager:GetPassConfigData(PassID)

    ---#TODO 内部接口优化 ClaimAllTaskLineTask
    for _, Task in ipairs(TaskConfigs.Tasks) do
        local TaskState = PassManager:GetTaskState(PassID, Task.TaskIndex, self:GetOwner())
        if TaskState == EUGCTaskState.NotClaimed then
            PassManager:Log(string.format("Claim TaskLineName %s TaskIndex %s", PassConfig.TaskLineName, Task.TaskIndex), "PassComponent:ClaimAllTasks")
            TaskPlayerComp:ClaimPercentTaskAward(PassConfig.TaskLineName, Task.TaskIndex)
        end
    end
end

function PassComponent:Server_QuickCompleteTask(PassID, TaskIndex)
    PassManager:Log(string.format("Quick complete Task PassID=%s, TaskIndex=%s", PassID, TaskIndex), "PassComponent:QuickCompleteTask")

    if not self:CheckPassID(PassID, "PassComponent:QuickCompleteTask") then
        return
    end

    if not self:GetOwner():HasAuthority() then
        PassManager:LogError("Calling PassComponent:QuickCompleteTask on client!")
    end
    
    local PassConfig = PassManager:GetPassConfigData(PassID)
    local TaskManager = PassManager:GetTaskManager()
    local VirtualItemManager = PassManager:GetVirtualItemManager()
    local TaskConfigs = PassManager:GetTaskConfigDatas(PassID)

    local Task = TaskConfigs.Tasks[TaskIndex]
    if Task == nil then
        PassManager:LogError("TaskIndex " .. TaskIndex .. " not exist", "PassComponent:QuickCompleteTask")
    end

    if PassManager:GetTaskState(PassID, TaskIndex, self:GetOwner()) ~= EUGCTaskState.Incomplete then
        PassManager:Log(string.format("PassID %s TaskIndex %s TaskID %s task state is not EUGCTaskState.Incomplete", PassID, TaskIndex, Task.TaskID), "PassComponent:QuickCompleteTask")
        return
    end

    local SkipTaskItemID = PassManager:GetCommodityOperationManager():GetProductData(PassConfig.SkipTaskProductID).ItemID
    local SkipItemNum = VirtualItemManager:GetItemNum(SkipTaskItemID, self:GetOwner())
    if SkipItemNum < Task.SkipItemNum then
        PassManager:Log(string.format("PassID %s TaskIndex %s TaskID %s cannot afford", PassID, TaskIndex, Task.TaskID), "PassComponent:QuickCompleteTask")
        UnrealNetwork.CallUnrealRPC(self:GetOwner(), self, "ShowTips", "任务卡不足")
        return
    end

    VirtualItemManager:RemoveItem(self:GetOwner(), SkipTaskItemID, Task.SkipItemNum, 
        function (Result)
            if not Result.bSucceeded then
                PassManager:LogError(string.format("PlayerKey %s cost SkipItemID %s Num %s failed", 
                                        Result.PlayerKey, Result.ItemID, Result.Num), "PassComponent:QuickCompleteTask")
                return
            end
                        
            TaskManager:UpdateTaskProgress({TaskLineName=PassConfig.TaskLineName, PercentTaskIndex=TaskIndex}, 
                                            self:GetOwner(), PassManager:GetTaskGoal(Task.TaskID))
        end
    )
end

function PassComponent:CheckNotClaimedAward()
    PassManager:Log("", "PassComponent:CheckNotClaimedAward")

    local PassConfigs = PassManager:GetAllPassConfigDatas()
    local CurrentTime = UGCGameSystem.GetServerTimeSec()

    for PassID, PassConfigs in pairs(PassConfigs) do
        if CurrentTime > PassConfigs.EndTime and not self.HasClaimedAllAwardPassIDs[PassID] then
            for Index, AwardData in ipairs(PassConfigs.Awards) do
                if PassManager:GetAwardState(PassID, Index) == EUGCTaskLineAwardState.NotClaimed then
                    PassManager:Log(string.format("Claim PassID %d not claimed award", PassID), "PassComponent:CheckNotClaimedAward")
                    UnrealNetwork.CallUnrealRPC(self:GetOwner(), self, "Server_ClaimAllAwards", PassID)
                    break
                end
            end

            self.HasClaimedAllAwardPassIDs[PassID] = true
        end
    end
end

function PassComponent:OpenMainUI()
    if self:GetOwner():HasAuthority() then
        return
    end

    if self.MainUI == nil then
        PassManager:LogError("MainUI is not loaded yet", "PassComponent:OpenMainUI")
        return
    end

    self.MainUI:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.MainUI:Refresh(self.ActivePassID)
    self.MainUI.bOpenned = true

    self:CheckNotClaimedAward()

    PassManager:GetVirtualItemManager().OnItemNumUpdatedDelegate:Add(self.OnItemNumUpdate, self)
end

function PassComponent:CloseMainUI()
    if self:GetOwner():HasAuthority() then
        return
    end

    if self.MainUI == nil then
        PassManager:LogError("MainUI is not loaded yet", "PassComponent:CloseMainUI")
        return
    end

    self.MainUI:SetVisibility(ESlateVisibility.Collapsed)
    self.MainUI.bOpenned = false
    self.MainUI.TaskPanel:StopWeekTimer()

    PassManager:GetVirtualItemManager().OnItemNumUpdatedDelegate:Remove(self.OnItemNumUpdate, self)
end

function PassComponent:SelectWeekTab(Week)
    if self.MainUI == nil then
        PassManager:LogError("MainUI is not loaded yet", "PassComponent:CloseMainUI")
        return
    end

    self.MainUI:SelectWeekTab(Week)
end

function PassComponent:ShowTips(Message)
    UGCWidgetManagerSystem.ShowTipsUI(Message)
end

function PassComponent:ShowBuyAdvancedPassPanel(PassID)
    if not UGCObjectUtility.IsObjectValid(self.MainUI) then
        PassManager:LogError("MainUI is invalid", "PassComponent:ShowBuyAdvancedPassPanel")
        return
    end

    self.MainUI:ShowBuyAdvancedPassPanel(PassID)
end

function PassComponent:ShowRechargeSkipTaskItemPanel(ProductID)
    if not UGCObjectUtility.IsObjectValid(self.MainUI) then
        PassManager:LogError("MainUI is invalid", "PassComponent:ShowRechargeSkipTaskItemPanel")
        return
    end

    self.MainUI:ShowRechargeSkipTaskItemPanel(ProductID)
end

function PassComponent:ShowUnlockAdvancedPassPanel(PassID)
    if not UGCObjectUtility.IsObjectValid(self.MainUI) then
        return
    end
    
    self.MainUI:ShowUnlockAdvancedPassPanel(PassID)
end

function PassComponent:ShowTipPanel(Title, Description, ConfirmText)
    if not UGCObjectUtility.IsObjectValid(self.MainUI) then
        return nil
    end

    return self.MainUI:ShowTipPanel(Title, Description, ConfirmText)
end

function PassComponent:GetReplicatedProperties()
    return {"ActivePassID", "Lazy"}, {"OwnedAdvancedPass", "Lazy"}, {"CountDown", "Lazy"}
end

function PassComponent:GetAvailableServerRPCs()
    return "Server_QuickCompleteTask", 
        "Server_ClaimAllTasks",
        "Server_ClaimAward",
        "Server_ClaimAllAwards",
        "Server_UpgradeLevel"
end

function PassComponent:OnRep_ActivePassID()
    PassManager:Log("OnRep ActivePassID " .. self.ActivePassID, "PassComponent:OnRep_ActivePassID")

    if self.MainUI and self.MainUI.bOpenned then
        self.MainUI:Refresh(self.ActivePassID)
    end
end

function PassComponent:OnRep_OwnedAdvancedPass()
    PassManager:LogTree("OwnedAdvancedPass=", "OnRep_OwnedAdvancedPass", self.OwnedAdvancedPass)

    if self.OwnedAdvancedPass[self.ActivePassID] and self.MainUI.bOpenned and self.MainUI.CurrentTab == 0 then
        self.MainUI:Refresh(self.ActivePassID)
    end
end

function PassComponent:OnRep_CountDown()
    if self.MainUI and self.MainUI.bOpenned and self.MainUI.CurrentTab == 0 then
        self.MainUI.AwardPanel:RefreshCountDown(self.CountDown)
    end
end

return PassComponent