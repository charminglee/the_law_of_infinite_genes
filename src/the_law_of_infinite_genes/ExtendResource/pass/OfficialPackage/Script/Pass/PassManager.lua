local Delegate = UGCGameSystem.UGCRequire("common.Delegate");

local function GetMondayDayTime(Time)
    local WeekDay = os.date("*t", Time).wday - 1
    WeekDay = WeekDay == 0 and 7 or WeekDay;

    local MondayDate = os.date("*t", Time - (WeekDay - 1) * 86400)

    return os.time({year=MondayDate.year, month=MondayDate.month, day=MondayDate.day, hour=0, min=0, sec=0})
end

PassManager = PassManager or
{
    bAvailable = true,
    PassConfigDatas = nil,
    TaskConfigDatas = nil,
    bPassConfigLoaded = false,

    OnPassConfigLoadedDelegate = Delegate.New(),

    OnAwardUpdateDelegate = Delegate.New(),
    OnTaskUpdateDelegate = Delegate.New(),

    OnClaimAwardClickDelegate = Delegate.New(),

    bHasNotClaimedAward = false,
    bHasNotClaimedTask  = false,
}

function PassManager:IsAvailable()
    return self.bAvailable
end

---检查Pass模板是否可用，如果不可用会抛出LuaException
function PassManager:CheckIsAvailable()
    assert(self.bAvailable, "PassManager is not available. Please check the log file with [PassManager][Fatal]")
end

function PassManager:SetComponentClass(Class)
    if self.ComponentClass == nil then
        self.ComponentClass = Class
    end
end

function PassManager:GetPassComponent(PlayerController)
    if self.ComponentClass == nil then
        self:LogError("ComponentClass is nil", "PassManager:GetPassComponent")
        return nil
    end

    if UGCGameSystem.IsServer() then
        if UGCObjectUtility.IsObjectValid(PlayerController) then
            return PlayerController:GetComponentByClass(self.ComponentClass)
        else
            self:LogError("PlayerController is not valid", "PassManager:GetPassComponent")
            return nil
        end
    end

    if self.LocalComponent == nil then
        local PC = UGCGameSystem.GetLocalPlayerController()
        if not UGCObjectUtility.IsObjectValid(PC) then
            self:LogError("Local PlayerController is not valid", "PassManager:GetPassComponent")
        end

        self.LocalComponent = PC:GetComponentByClass(self.ComponentClass)
    end

    return self.LocalComponent
end

---@return VirtualItemManager
function PassManager:GetVirtualItemManager()
    if not UGCGamePartSystem.IsGamePartLoaded("VirtualItemManager") then
        return nil
    end

    return UGCGamePartSystem.GetGamePartGlobalActor("VirtualItemManager")
end

---@return CommodityOperationManager
function PassManager:GetCommodityOperationManager()
    if not UGCGamePartSystem.IsGamePartLoaded("CommodityOperationManager") then
        return nil
    end

    return UGCGamePartSystem.GetGamePartGlobalActor("CommodityOperationManager")
end

---@return TaskManager
function PassManager:GetTaskManager()
    if not UGCGamePartSystem.IsGamePartLoaded("TaskManager") then
        return nil
    end

    return UGCGamePartSystem.GetGamePartGlobalActor("TaskManager")
end

function PassManager:GetTaskPlayerComponent(PlayerController)
    if not UGCGamePartSystem.IsGamePartLoaded("TaskManager") then
        return nil
    end

    local PC = nil

    if UGCObjectUtility.IsObjectValid(PlayerController) then
        PC = PlayerController
    elseif not UGCGameSystem.IsServer() then
        local LocalPC = UGCGameSystem.GetLocalPlayerController()
        if UGCObjectUtility.IsObjectValid(LocalPC) then
            PC = LocalPC
        end
    end
    
    if PC == nil then
        self:LogError("PlayerController is invalid", "PassManager:GetTaskPlayerComponent")
    end

    return UGCGamePartSystem.GetGamePartPlayerComponent("TaskManager", PC, "Task")
end

function PassManager:IsPassValid(PassID)
    local ConfigData = self:GetPassConfigData(PassID)

    if ConfigData == nil then
        self:LogError(string.format("PassID %d ConfigData not exist", PassID), "PassManager:IsValidPassID")
        return false
    end

    self:Log(string.format("Check PassID %d time", PassID), "PassManager:IsValidPassID")
    local CurrentTime = UGCGameSystem.GetServerTimeSec()
    self:Log("CurrentTime=" .. CurrentTime)
    self:Log("StartTime=" .. ConfigData.StartTime)
    self:Log("EndTime=" .. ConfigData.EndTime)

    return CurrentTime >= ConfigData.StartTime and CurrentTime < ConfigData.EndTime
end

function PassManager:GetActivePassID()
    self:Log("", "PassManager:GetActivePassID")
    local PassConfigs = self:GetAllPassConfigDatas()

    if PassConfigs == nil then
        return -1
    end

    for PassID, Config in pairs(PassConfigs) do
        local CurrentTime = UGCGameSystem.GetServerTimeSec()
        self:Log("CurrentTime=" .. CurrentTime)
        self:Log("StartTime=" .. Config.StartTime)
        self:Log("EndTime=" .. Config.EndTime)

        if CurrentTime >= Config.StartTime and CurrentTime < Config.EndTime then
            return Config.PassID
        end
    end

    return -1
end

function PassManager:GetAllPassConfigDatas()
    if self.PassConfigDatas == nil then
        self:LogWarning("Pass config datas is not loaded yet", "PassManager:GetAllPassConfigDatas")
        return {}
    end

    return self.PassConfigDatas
end

function PassManager:GetPassConfigData(PassID)
    local ConfigData = self:GetAllPassConfigDatas()[PassID]
    if ConfigData == nil then
        self:LogWarning(string.format("PassID %s config data not found!", PassID), "PassManager:GetPassConfigData")
        return nil
    end

    return ConfigData
end

function PassManager:GetAllTaskConfigDatas()
    if self.TaskConfigDatas == nil then
        self:LogWarning("Task config datas is not loaded yet", "PassManager:GetAllTaskConfigDatas")
    end

    return self.TaskConfigDatas
end

function PassManager:GetTaskConfigDatas(PassID)
    local ConfigData = self:GetAllTaskConfigDatas()[PassID]
    if ConfigData == nil then
        self:LogWarning(string.format("PassID %s task config data not found!", PassID), "PassManager:GetTaskConfigDatas")
        return nil
    end

    return ConfigData
end

function PassManager:GetTaskConfigData(PassID, TaskIndex)
    local TaskConfigs = self:GetTaskConfigDatas(PassID)
    if TaskConfigs == nil then
        self:LogWarning("No task configs for PassID " .. PassID, "PassManager:GetTaskConfigData")
        return nil
    end

    return TaskConfigs.Tasks[TaskIndex] 
end

function PassManager:GetTaskDetail(TaskID)
    local TaskManager = self:GetTaskManager()

    if TaskManager == nil then
        return nil
    end

    return TaskManager:GetTaskConfig(TaskID)
end

function PassManager:GetTaskGoal(TaskID)
    local TaskManager = self:GetTaskManager()

    if TaskManager == nil then
        return 0
    end

    return TaskManager:GetTaskTarget(TaskID)
end

function PassManager:GetTaskProgress(TaskLineName, TaskIndex, PlayerController)
    local TaskPlayerComp = self:GetTaskPlayerComponent(PlayerController)
    if TaskPlayerComp == nil then
        self:LogWarning("TaskPlayerComp is nil", "PassManager:GetTaskProgress")
        return 0
    end

    return TaskPlayerComp:GetPercentTaskProgress(TaskLineName, TaskIndex)
end

function PassManager:GetTaskLineConfigData(PassID)
    local ConfigData = self:GetPassConfigData(PassID)

    if ConfigData == nil then
        return nil
    end

    local TaskManager = self:GetTaskManager()
    return TaskManager and TaskManager:GetTaskLineConfig(ConfigData.TaskLineName) or nil
end

---@return EUGCTaskState
function PassManager:GetTaskState(PassID, TaskIndex, PlayerController)
    local PassConfig = self:GetPassConfigData(PassID)

    if PassConfig == nil then
        self:LogWarning("PassID=" .. PassID .. "not found", "PassManager:GetTaskState")
        return EUGCTaskState.Lock
    end

    local TaskPlayerComp = self:GetTaskPlayerComponent(PlayerController)
    if TaskPlayerComp == nil then
        self:LogWarning("TaskPlayerComp is nil", "PassManager:GetTaskState")
        return EUGCTaskState.Lock
    end

    local State = TaskPlayerComp:GetPercentTaskState(PassConfig.TaskLineName, TaskIndex)
    -- self:Log(string.format("TaskLineName=%s TaskIndex=%s TaskState=%s", PassConfig.TaskLineName, TaskIndex, State), "PassManager:GetTaskState")
    return State
end

function PassManager:GetPassAwardConfigData(PassID)
    local ConfigData = self:GetPassConfigData(PassID)

    if ConfigData == nil or #ConfigData.Awards == 0 then
        self:LogWarning(string.format("PassID %s award data not found!", PassID), "PassManager:GetPassAwardConfigData")
        return {}
    end

    return ConfigData.Awards
end

function PassManager:GetConfigDataByTaskLineName(TaskLineName)
    local ConfigDatas = self:GetAllPassConfigDatas()

    if ConfigDatas == nil then
        return nil
    end

    for _, ConfigData in pairs(ConfigDatas) do
        if ConfigData.TaskLineName == TaskLineName then
            return ConfigData
        end
    end

    return nil
end

function PassManager:GetNotClaimedAwardNum(PassID)
    local NotClaimedNum = 0
    local Awards = self:GetPassAwardConfigData(PassID)
    for Index, Award in ipairs(Awards) do
        if PassManager:GetAwardState(PassID, Index) == EUGCTaskLineAwardState.NotClaimed then
            NotClaimedNum = NotClaimedNum + 1
        end
    end
    
    return NotClaimedNum
end

function PassManager:GetPassCurrentLevelData(PassID, PlayerController)
    local LevelData = 
    {
        Level = 0,
        Point = 0,
        NextPoint = 0,
        TotalPoint = 0,
    }

    local ConfigData = self:GetPassConfigData(PassID)
    if ConfigData == nil then
        self:LogWarning("No config data for PassID " .. tostring(PassID), "PassManager:GetCurrentPassLevelData")
        return LevelData
    end

    local TaskPlayerComp = self:GetTaskPlayerComponent(PlayerController)
    if TaskPlayerComp == nil then
        self:LogWarning("TaskPlayerComp is nil", "PassManager:GetCurrentPassLevelData")
        return LevelData
    end

    LevelData.TotalPoint = TaskPlayerComp:GetTaskLineProgress(ConfigData.TaskLineName)

    local L, R = 1, #ConfigData.Awards
    while L <= R do
        local M = math.floor((L + R) * 0.5)
        if ConfigData.Awards[M].Point > LevelData.TotalPoint then
            R = M - 1
        else
            L = M + 1
        end
    end

    LevelData.Level = L - 1;

    local LastPoint = ConfigData.Awards[L-1] and ConfigData.Awards[L-1].Point or 0
    if ConfigData.Awards[L] == nil then
        LevelData.Point = LastPoint
        LevelData.NextPoint = LastPoint
    else
        LevelData.Point = LevelData.TotalPoint - LastPoint
        LevelData.NextPoint = ConfigData.Awards[L].Point - LastPoint
    end

    return LevelData
end

function PassManager:GetMaxLevel(PassID)
    return #PassManager:GetPassAwardConfigData(PassID)
end

function PassManager:HasAdvancedPass(PassID, PlayerController)
    self:Log("", "PassManager:HasAdvancedPass")

    local Comp = self:GetPassComponent(PlayerController)
    if Comp and Comp.OwnedAdvancedPass[PassID] then
        --已经有高级通行证就不必查询了
        return true
    end

    local PassConfig = self:GetPassConfigData(PassID)

    if PassConfig == nil then
        self:LogWarning("Cannot get passs config " .. PassID, "PassManager:HasAdvancedPass")
        return false
    end

    local VirtualItemManager = self:GetVirtualItemManager()
    if VirtualItemManager == nil then
        self:LogWarning("VirtualItemManager is nil", "PassManager:HasAdvancedPass")
        return false
    end

    local CommodityOperationManager = self:GetCommodityOperationManager()
    if CommodityOperationManager == nil then
        self:LogWarning("CommodityOperationManager is nil", "PassManager:HasAdvancedPass")
        return false
    end

    if PlayerController == nil then
        if UGCGameSystem.IsServer() then
            self:LogWarning("PlayerController is nil on server", "PassManager:HasAdvancedPass")
            return false
        else
            PlayerController = UGCGameSystem.GetLocalPlayerController()
        end
    end

    local AdvancedPassProductData = CommodityOperationManager:GetProductData(PassConfig.AdvancedPassProductID)
    local UltraPassProductData = CommodityOperationManager:GetProductData(PassConfig.UltraPassProductID)
    local AdvancedPassItemNum = AdvancedPassProductData and VirtualItemManager:GetItemNum(AdvancedPassProductData.ItemID, PlayerController) or 0
    local UltraPassItemNum = UltraPassProductData and VirtualItemManager:GetItemNum(UltraPassProductData.ItemID, PlayerController) or 0

    local bHasAdvancedPass = AdvancedPassItemNum > 0 or UltraPassItemNum > 0
    self:Log(string.format("PassID %d AdvancedPassItemNum %d UltraPassItemNum %d bHasAdvancedPass %s", PassID, AdvancedPassItemNum, UltraPassItemNum, bHasAdvancedPass), "PassManager:HasAdvancedPass")

    return bHasAdvancedPass
end

function PassManager:GetAwardState(PassID, Index, PlayerController)
    local PassConfig = self:GetPassConfigData(PassID)
    if PassConfig == nil then
        self:LogWarning("PassConfig is nil", "PassManager:HasClaimedAward")
        return false
    end

    local TaskPlayerComp = self:GetTaskPlayerComponent(PlayerController)
    if TaskPlayerComp == nil then
        self:LogWarning("TaskPlayerComp is nil", "PassManager:HasClaimedAward")
        return false
    end

    local State = TaskPlayerComp:GetTaskLineAwardState(PassConfig.TaskLineName, Index)
    self:Log(string.format("PassID %d Index %d AwardState %d", PassID, Index, State), "PassManager:GetAwardState")

    return State
end

function PassManager:GetCurrentWeek(PassID)
    local PassConfig = self:GetPassConfigData(PassID)
    if PassConfig == nil then
        self:LogWarning("PassConfig is nil", "PassManager:GetCurrentWeek")
        return 0
    end

    local CurrentTime = UGCGameSystem.GetServerTimeSec()
    if CurrentTime < PassConfig.StartTime or CurrentTime >= PassConfig.EndTime then
        return -1
    end

    local PassStartMondayTime = GetMondayDayTime(PassConfig.StartTime)
    local CurrentMondayTime = GetMondayDayTime(CurrentTime)

    return math.floor((CurrentMondayTime - PassStartMondayTime) / 604800) + 1
end

function PassManager:ClaimAward(PassID, AwardIndex, PlayerController)
    local Comp = self:GetPassComponent(PlayerController)

    if Comp == nil then
        self:LogError("PassComponent is nil", "PassManager:ClaimAward")
        return
    end

    if UGCGameSystem.IsServer() then
        Comp:Server_ClaimAward(PassID, AwardIndex)
    else
        UnrealNetwork.CallUnrealRPC(UGCGameSystem.GetLocalPlayerController(), Comp, "Server_ClaimAward", PassID, AwardIndex)
    end
end

function PassManager:ClaimAllAwards(PassID, PlayerController)
    local Comp = self:GetPassComponent(PlayerController)

    if Comp == nil then
        self:LogError("PassComponent is nil", "PassManager:ClaimAllAwards")
        return
    end

    if UGCGameSystem.IsServer() then
        Comp:Server_ClaimAllAwards(PassID)
    else
        UnrealNetwork.CallUnrealRPC(UGCGameSystem.GetLocalPlayerController(), Comp, "Server_ClaimAllAwards", PassID)
    end
end

function PassManager:ClaimAllTasks(PassID, PlayerController)
    local Comp = self:GetPassComponent(PlayerController)

    if Comp == nil then
        self:LogError("PassComponent is nil", "PassManager:QuickCompleteTask")
        return
    end

    if UGCGameSystem.IsServer() then
        Comp:Server_ClaimAllTasks(PassID)
    else
        UnrealNetwork.CallUnrealRPC(UGCGameSystem.GetLocalPlayerController(), Comp, "Server_ClaimAllTasks", PassID)        
    end
end

function PassManager:QuickCompleteTask(PassID, TaskIndex, PlayerController)
    local Comp = self:GetPassComponent(PlayerController)

    if Comp == nil then
        self:LogError("PassComponent is nil", "PassManager:QuickCompleteTask")
        return
    end

    if UGCGameSystem.IsServer() then
        Comp:Server_QuickCompleteTask(PassID, TaskIndex)
    else
        UnrealNetwork.CallUnrealRPC(UGCGameSystem.GetLocalPlayerController(), Comp, "Server_QuickCompleteTask", PassID, TaskIndex)        
    end
end

function PassManager:UpgradeLevel(PassID, TargetLevel)
    local Comp = self:GetPassComponent(PlayerController)

    if Comp == nil then
        self:LogError("PassComponent is nil", "PassManager:UpgradeLevel")
        return
    end

    if UGCGameSystem.IsServer() then
        Comp:Server_UpgradeLevel(PassID, TargetLevel)
    else
        UnrealNetwork.CallUnrealRPC(UGCGameSystem.GetLocalPlayerController(), Comp, "Server_UpgradeLevel", PassID, TargetLevel)        
    end
end

function PassManager:HasNotClaimedAwardsOrTasks()
    return self.bHasNotClaimedAward or self.bHasNotClaimedTask
end

function PassManager:LoadConfig(ConfigDataTable)
    self:Log("Begin loading pass config data")

    if self.bPassConfigLoaded then
        return
    end

    self.PassConfigDatas, self.TaskConfigDatas = {}, {}

    local ConfigDatas = UGCGameSystem.GetDataTableData(ConfigDataTable)
    for _, ConfigData in pairs(ConfigDatas) do
        local PassID = ConfigData.PassID

        self.PassConfigDatas[PassID] = {
            PassID                  = ConfigData.PassID,
            AdvancedPassProductID   = ConfigData.AdvancedPassProductID,
            UltraPassProductID      = ConfigData.UltraPassProductID,
            TaskLineName            = ConfigData.TaskLineName,
            LevelPurchaseItemID     = ConfigData.LevelPurchaseItemID,
            LevelPurchaseItemNum    = ConfigData.LevelPurchaseItemNum,
            SkipTaskProductID       = ConfigData.SkipTaskProductID,
            ThemeName               = ConfigData.ThemeName,
            ThemeIcon               = UGCObjectUtility.GetPathBySoftObjectPath(ConfigData.ThemeIcon),
            BasePassName            = ConfigData.BasePassName,
            BasePassIcon            = UGCObjectUtility.GetPathBySoftObjectPath(ConfigData.BasePassIcon),
            AdvancedPassName        = ConfigData.AdvancedPassName,
            AdvancedPassIcon        = UGCObjectUtility.GetPathBySoftObjectPath(ConfigData.AdvancedPassIcon),
            StartTime               = 0,
            EndTime                 = 0,
            PointItemID             = 0,
        }

        local AwardData = {}
        if ConfigData.Awards == nil then
            self:LogWarning(string.format("PassID=%d award is not configured", PassID), "PassManager:LoadConfig")
        else
            local AwardConfigs = UGCGameSystem.GetDataTableData(ConfigData.Awards)

            for _, Config in pairs(AwardConfigs) do
                local Data = 
                {
                    Point           = Config.Point,
                    NormalItem      = {
                        ItemID      = Config.NormalItemID,
                        Num         = Config.NormalNum
                    },
                    AdvancedItem    = {
                        ItemID      = Config.AdvancedItemID,
                        Num         = Config.AdvancedNum
                    }
                }

                table.insert(AwardData, Data)
            end
        end
        self.PassConfigDatas[PassID].Awards = AwardData

        local TaskManager = self:GetTaskManager()
        if TaskManager then
            local TaskLineConfig = TaskManager:GetTaskLineConfig(ConfigData.TaskLineName)
            
            if TaskLineConfig == nil then
                self:LogWarning(string.format("PassID=%d TaskLine is not configured", PassID), "PassManager:LoadConfig")
            else
                ---#TODO ToUnixTimestamp 改为标准接口
                self.PassConfigDatas[PassID].StartTime      = TaskLineConfig.BeginDate:ToUnixTimestamp()
                self.PassConfigDatas[PassID].EndTime        = TaskLineConfig.EndDate:ToUnixTimestamp()
                self.PassConfigDatas[PassID].PointItemID    = TaskLineConfig.ItemID

                self.TaskConfigDatas[PassID] = {}
                local WeeklyTaskIndexs, MaxWeek, PassTaskIndexs, Tasks = {}, 0, {}, {}
                if ConfigData.Tasks == nil then
                    self:LogError(string.format("PassID=%d Tasks is not configured"), "PassManager:LoadConfig")
                else
                    for _, Data in pairs(UGCGameSystem.GetDataTableData(ConfigData.Tasks)) do
                        local TaskIndex = Data.TaskIndex + 1    --C++ Index to Lua Index
                        
                        local TaskConfig = TaskLineConfig.PercentTaskLineConfig[TaskIndex]

                        if TaskConfig == nil then
                            self:LogWarning(string.format("TaskIndex %d not confirgured in TaskLine %s config list", TaskIndex-1, ConfigData.TaskLineName), "PassManager:LoadConfig")
                        elseif PassManager:GetTaskDetail(TaskConfig.PercentTaskID) == nil then
                            self:LogError(string.format("TaskID %d not confirgured in task config list", TaskConfig.PercentTaskID), "PassManager:LoadConfig")
                        else
                            local TaskID = TaskLineConfig.PercentTaskLineConfig[TaskIndex].PercentTaskID
                            local Task = {
                                TaskIndex   = TaskIndex, 
                                TaskID      = TaskID, 
                                SkipItemID  = Data.SkipItemID,
                                SkipItemNum = Data.SkipItemNum
                            }
                            
                            Tasks[TaskIndex] = Task

                            if Data.Week > 0 then
                                WeeklyTaskIndexs[Data.Week] = WeeklyTaskIndexs[Data.Week] or {}
                                table.insert(WeeklyTaskIndexs[Data.Week], TaskIndex)
                                MaxWeek = math.max(MaxWeek, Data.Week)
                            else
                                table.insert(PassTaskIndexs, TaskIndex)
                            end
                        end
                    end
                end

                self.TaskConfigDatas[PassID].Tasks              = Tasks
                self.TaskConfigDatas[PassID].WeeklyTaskIndexs   = WeeklyTaskIndexs
                self.TaskConfigDatas[PassID].PassTaskIndexs     = PassTaskIndexs
                self.TaskConfigDatas[PassID].MaxWeek            = MaxWeek
            end
        end
    end

    self:LogTree("PassConfigDatas=", "PassManager:LoadConfig", self.PassConfigDatas)
    self:LogTree("TaskConfigDatas=", "PassManager:LoadConfig", self.TaskConfigDatas)
    self:Log("Finish loading pass config data")

    self.bPassConfigLoaded = true
    self.OnPassConfigLoadedDelegate()

    UGCObjectUtility.MarkAsGarbage(ConfigDataTable)
end

function PassManager:OpenMainUI()
    self:Log("Open MainUI")

    PassManager:CheckIsAvailable()

    local Comp = self:GetPassComponent()
    if Comp ~= nil then
        Comp:OpenMainUI()
    else
        self:LogError("Cannot get PassComponent", "PassManager:OpenMainUI")
    end
end

function PassManager:CloseMainUI()
    self:Log("Close MainUI")

    PassManager:CheckIsAvailable()

    local Comp = self:GetPassComponent()
    if Comp ~= nil then
        Comp:CloseMainUI()
    else
        self:LogError("Cannot get PassComponent", "PassManager:CloseMainUI")
    end
end

function PassManager:ShowBuyAdvancedPassPanel(PassID)
    self:Log("Show advanced pass panel")

    PassManager:CheckIsAvailable()

    local Comp = self:GetPassComponent()
    if Comp then
        Comp:ShowBuyAdvancedPassPanel(PassID)
    end
end

function PassManager:ShowRechargeSkipTaskItemPanel(ProductID)
    PassManager:Log("Show RechargeSkipTaskItemPanel")

    PassManager:CheckIsAvailable()

    local Comp = self:GetPassComponent()
    if Comp then
        Comp:ShowRechargeSkipTaskItemPanel(ProductID)
    end
end

function PassManager:ShowTipPanel(Title, Description, ConfirmText)
    PassManager:Log("Show TipPanel")

    PassManager:CheckIsAvailable()

    local Comp = self:GetPassComponent()
    if Comp then
        Comp:ShowTipPanel(Title, Description, ConfirmText)
    end
end

function PassManager:SelectWeekTab(Week)
    self:Log("Select week " .. Week)

    local Comp = self:GetPassComponent()
    if Comp ~= nil then
        Comp:SelectWeekTab(Week)
    else
        self:LogError("Cannot get PassComponent", "PassManager:SelectWeekTab")
    end
end

function PassManager:SetImageFromIconPath(Image, IconPath)
    local Path = nil

    if type(IconPath) == "string" and IconPath ~= "" then
        Path = UGCObjectUtility.MakeSoftObjectPath(IconPath)
        Image:SetBrushImageReference(Path)
    elseif type(IconPath) == "userdata" and UGCObjectUtility.GetPathBySoftObjectPath(IconPath) ~= "" then
        Image:SetBrushImageReference(IconPath)
    else
        self:LogWarning("IconPath is invalid", "PassManager:SetImageFromPath")
    end
end

function PassManager:SetImageFromItemID(Image, ItemID)
    local ItemData = self:GetVirtualItemManager():GetItemData(ItemID)

    if ItemData == nil then
        self:LogWarning(string.format("Cannot get ItemID %d data, please check UGCObject DataTable", ItemID), "PassManager:SetImageFromItemID")
        return
    end

    self:SetImageFromIconPath(Image, ItemData.ItemIcon)
end

local function Log(Verbose, Message, FuncName)
    local Format = ""

    if FuncName and FuncName ~= "" then
        print(string.format("[Pass][%s][%s] %s", Verbose, FuncName, Message))
    else
        print(string.format("[Pass][%s] %s", Verbose, Message))
    end
end

function PassManager:Log(Message, FuncName)
    Log("Log", Message, FuncName)
end

function PassManager:LogWarning(Message, FuncName)
    Log("Warning", Message, FuncName)
end

function PassManager:LogError(Message, FuncName)
    Log("Error", Message, FuncName)
end

function PassManager:LogFatal(Message, FuncName)
    Log("Fatal", Message, FuncName)
    self.bAvailable = false

    assert(false, "Message")
end

function PassManager:LogTree(Message, FuncName, Table)
    if FuncName and FuncName ~= "" then
        log_tree(string.format("[Pass][Log] %s", Message), Table)
    else
        log_tree(string.format("[Pass][Log][%s] %s", FuncName, Message), Table)
    end
end

---注册获取物品品质UI材质路径的函数
--- *注册函数传入参数为 ItemID
--- *注册函数需要返回两个参数：QuailtiyBackgroundPath 和 QualityBarPath
--- *如果同时注册了GetItemQuailityRankFunc，仍优先执行GetItemQuailityPathFunc
---@param Func function @要注册的函数
---@param FuncSelf table @函数所属的table，冒号调用注册函数需传该参数
function PassManager:RegisterGetItemQuailityPathFunc(Func, FuncSelf)
    self.GetItemQuailityPath = Func
    self.GetItemQuailityPathSelf = FuncSelf
end

---注册获取物品品质等级的函数
--- *将使用预设的物品等级对应的品质颜色
--- *注册函数传入参数为 ItemID
--- *注册函数返回的品质等级需在[0, 6]
--- *如果同时注册了GetItemQuailityPathFunc，则优先执行GetItemQuailityPathFunc
---@param Func function @要注册的函数
---@param FuncSelf table @函数所属的table，冒号调用注册函数需传该参数
function PassManager:RegisterGetItemQuailityRankFunc(Func, FuncSelf)
    self.GetItemQuailityRank = Func
    self.GetItemQuailityRankSelf = FuncSelf
end

function PassManager:GetItemQualityPath(ItemID)
    local BackgroundPath = ""
    local BarPath = ""

    if type(self.GetItemQuailityPath) == "function" then
        if self.GetItemQuailityPathSelf ~= nil then
            BackgroundPath, BarPath = self.GetItemQuailityPath(self.GetItemQuailityPathSelf, ItemID)
        else
            BackgroundPath, BarPath = self.GetItemQuailityPath(ItemID)
        end
    elseif type(self.GetItemQuailityRank) == "function" then
        local Rank = 0
        if self.GetItemQuailityRankSelf ~= nil then
            Rank = self.GetItemQuailityRank(self.GetItemQuailityRankSelf, ItemID)
        else
            Rank = self.GetItemQuailityRank(ItemID)
        end

        BackgroundPath = UGCItemSystem.GetQualityTexturePath(Rank)
        BarPath        = UGCItemSystem.GetQualityBarTexturePath(Rank)
    end

    return BackgroundPath, BarPath
end