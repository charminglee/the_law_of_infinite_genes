---@class FCombinedModeConfig
---@field ModeID int32
---@field DetailID int32
---@field ModeName FText
---@field ModeDesc FText
---@field ModeBanner UTexture2D
---@field ModePost UTexture2D
---@field Difficulty FText
---@field UnlockDesc FText
---@field Hide boolean

---大厅领域模型。
---负责模式配置、选择状态和匹配请求；不直接操作具体 Widget。
---@class LobbyModel
LobbyModel = LobbyModel or {
    MultiModeConfigTableList = {},
    GameModeConfigList = {},
    GameModeDetailList = {},
    CombinedModeConfigList = {},
    CurrentSelectedModeID = -1,
    bIsMatching = false,
}

local GAME_MODE_CONFIG_PATH = "Asset/Data/Table/UGCGameModeConfig.UGCGameModeConfig"
local GAME_MODE_DETAIL_PATH = "Asset/Data/Table/UGCGameModeDetail.UGCGameModeDetail"
local LOBBY_MODE_ID = 1001

---获取本地玩家控制器，集中隔离引擎全局访问。
---@return UGCPlayerController_C|nil
local function GetLocalPlayerController()
    return UGCGameSystem.GetLocalPlayerController()
end

---复制顺序数组，防止调用方直接修改模型内部集合。
---@param Source table|nil
---@return table
local function CopyArray(Source)
    local Result = {}
    for _, Value in ipairs(Source or {}) do
        table.insert(Result, Value)
    end
    return Result
end

---清空模式配置及查询索引，保证重复初始化不会叠加旧数据。
function LobbyModel:ResetConfigCache()
    self.MultiModeConfigTableList = {}
    self.GameModeConfigList = {}
    self.GameModeDetailList = {}
    self.CombinedModeConfigList = {}
    self.ModeConfigByID = {}
    self.ModeIDsByDetailID = {}
    self.MultiModeIDSet = {}
end

---@return boolean
function LobbyModel:LoadMultiModeConfig()
    local ConfigList = GameFrontendHUD and GameFrontendHUD:UGCGetMultiModeConfig()
    if not ConfigList then
        ugcprint("[LobbyModel] multi-mode config is unavailable")
        return false
    end

    for Index = 1, ConfigList:Num() do
        local Config = json.decode(ConfigList:Get(Index))
        local ModeID = Config and tonumber(Config.ModeID)
        if ModeID and ModeID ~= LOBBY_MODE_ID then
            table.insert(self.MultiModeConfigTableList, Config)
            self.MultiModeIDSet[ModeID] = true
        end
    end
    return #self.MultiModeConfigTableList > 0
end

---读取模式基础表和模式详情表，暂存原始配置行。
function LobbyModel:LoadDataTables()
    local ModeTable = UGCGameSystem.GetTableData(UGCGameSystem.GetUGCResourcesFullPath(GAME_MODE_CONFIG_PATH)) or {}
    local DetailTable = UGCGameSystem.GetTableData(UGCGameSystem.GetUGCResourcesFullPath(GAME_MODE_DETAIL_PATH)) or {}

    for _, Row in pairs(ModeTable) do
        table.insert(self.GameModeConfigList, Row)
    end
    for _, Row in pairs(DetailTable) do
        table.insert(self.GameModeDetailList, Row)
    end
end

---初始化配置与匹配监听。重复调用不会叠加数据或委托。
---@return boolean
function LobbyModel:Init()
    self:ResetConfigCache()
    self.bIsMatching = false

    if not self:LoadMultiModeConfig() then
        return false
    end
    self:LoadDataTables()
    self:CombineModeConfigTable()

    local DefaultModeID = self:IsModeIDValid(self.CurrentSelectedModeID)
        and self.CurrentSelectedModeID
        or self:GetAllModeID()[1]
    if DefaultModeID then
        self:SelectMode(DefaultModeID, true)
    end

    if not self._bMatchDelegatesBound then
        UGCMultiMode.NotifyMatchResponseDelegate:Add(self.OnMatchStarted, self)
        UGCMultiMode.NotifyMatchSucceededDelegate:Add(self.OnMatchSuccess, self)
        self._bMatchDelegatesBound = true
    end
    self._bInitialized = true
    return DefaultModeID ~= nil
end

---@param DetailID int32|nil
---@return FCombinedModeConfig[]
function LobbyModel:GetAllModeConfig(DetailID)
    if DetailID == nil then
        return CopyArray(self.CombinedModeConfigList)
    end

    local Result = {}
    for _, ModeID in ipairs(self.ModeIDsByDetailID[DetailID] or {}) do
        table.insert(Result, self.ModeConfigByID[ModeID])
    end
    return Result
end

---@return int32[]
function LobbyModel:GetAllDisplayModeID()
    local Result = {}
    for _, Detail in ipairs(self.GameModeDetailList) do
        if not Detail.Hide then
            local ModeIDs = self.ModeIDsByDetailID[Detail.ID] or {}
            for _, ModeID in ipairs(ModeIDs) do
                if self.MultiModeIDSet[ModeID] then
                    table.insert(Result, ModeID)
                    break
                end
            end
        end
    end
    table.sort(Result, function(A, B)
        return self.ModeConfigByID[A].DetailID < self.ModeConfigByID[B].DetailID
    end)
    return Result
end

---@param ModeID int32
---@return FCombinedModeConfig|nil
function LobbyModel:GetModeConfig(ModeID)
    return self.ModeConfigByID and self.ModeConfigByID[tonumber(ModeID)] or nil
end

---@return int32
function LobbyModel:GetCurrentSelectedModeID()
    return self.CurrentSelectedModeID
end

---@return FCombinedModeConfig|nil
function LobbyModel:GetCurrentSelectedMode()
    return self:GetModeConfig(self.CurrentSelectedModeID)
end

---@return int32[]
function LobbyModel:GetAllModeID()
    local Result = {}
    local Seen = {}
    for _, Config in ipairs(self.CombinedModeConfigList) do
        if Config.ModeID ~= LOBBY_MODE_ID and self.MultiModeIDSet[Config.ModeID] and not Seen[Config.ModeID] then
            Seen[Config.ModeID] = true
            table.insert(Result, Config.ModeID)
        end
    end
    return Result
end

---@param ModeID int32|nil
---@return FCombinedModeConfig[]
function LobbyModel:GetModeListWithSameDetailID(ModeID)
    local Config = self:GetModeConfig(ModeID or self.CurrentSelectedModeID)
    if not Config then
        return {}
    end
    return self:GetAllModeConfig(Config.DetailID)
end

---@return string
function LobbyModel:GetCurrentSelectedDifficulty()
    local Config = self:GetCurrentSelectedMode()
    return Config and Config.Difficulty or ""
end

---@param ModeID int32|nil
---@return boolean
function LobbyModel:IsModeLocked(ModeID)
    local TargetModeID = tonumber(ModeID or self.CurrentSelectedModeID)
    local PlayerState = UGCGameSystem.GetLocalPlayerState()
    if not TargetModeID or not PlayerState then
        return true
    end
    for _, UnlockedModeID in ipairs(PlayerState.GameCompletionRecord or {}) do
        if tonumber(UnlockedModeID) == TargetModeID then
            return false
        end
    end
    return true
end

---@param ModeID number
---@return boolean
function LobbyModel:IsModeIDValid(ModeID)
    ModeID = tonumber(ModeID)
    return ModeID ~= nil and self.MultiModeIDSet[ModeID] == true and self:GetModeConfig(ModeID) ~= nil
end

---@param ModeID number
---@param bClientInit boolean|nil
---@return boolean
function LobbyModel:SelectMode(ModeID, bClientInit)
    ModeID = tonumber(ModeID)
    if self.bIsMatching and not bClientInit then
        UGCWidgetManagerSystem.ShowTipsUI("匹配中无法选择模式")
        return false
    end
    if not self:IsModeIDValid(ModeID) then
        ugcprint("[LobbyModel] invalid ModeID: " .. tostring(ModeID))
        return false
    end
    if not bClientInit and self:IsModeLocked(ModeID) then
        UGCWidgetManagerSystem.ShowTipsUI("该模式尚未解锁")
        return false
    end

    local PreviousConfig = self:GetCurrentSelectedMode()
    self.CurrentSelectedModeID = ModeID
    local CurrentConfig = self:GetModeConfig(ModeID)

    LobbyEvent.OnModeSelected(ModeID)
    if not PreviousConfig or PreviousConfig.Difficulty ~= CurrentConfig.Difficulty then
        LobbyEvent.OnDifficultySelected(CurrentConfig.Difficulty)
    end

    local PC = GetLocalPlayerController()
    if PC and PC.bIsTeamLeader and UGCGameSystem.GameState and not bClientInit then
        UnrealNetwork.CallUnrealRPC(PC, PC, "RPC_Server_SetLobbySelectedModeID", ModeID)
    end
    return true
end

---@param Difficulty string
---@return boolean
function LobbyModel:SelectDifficulty(Difficulty)
    local CurrentConfig = self:GetCurrentSelectedMode()
    if not CurrentConfig then
        return false
    end
    for _, Config in ipairs(self:GetAllModeConfig(CurrentConfig.DetailID)) do
        if Config.Difficulty == Difficulty then
            return self:SelectMode(Config.ModeID)
        end
    end
    return false
end

---@param LobbyInfo table
function LobbyModel:ApplyLobbyInfo(LobbyInfo)
    if type(LobbyInfo) ~= "table" then
        return
    end
    local ModeID = tonumber(LobbyInfo.SelectedModeID)
    if self:IsModeIDValid(ModeID) then
        local OldConfig = self:GetCurrentSelectedMode()
        self.CurrentSelectedModeID = ModeID
        LobbyEvent.OnModeSelected(ModeID)
        local NewConfig = self:GetModeConfig(ModeID)
        if not OldConfig or OldConfig.Difficulty ~= NewConfig.Difficulty then
            LobbyEvent.OnDifficultySelected(NewConfig.Difficulty)
        end
    end

    self:SetMatchingState(LobbyInfo.bIsMatching == true)
end

---@param bFillTeammate boolean
---@return boolean
function LobbyModel:RequestMatch(bFillTeammate)
    if self.bIsMatching then
        UGCWidgetManagerSystem.ShowTipsUI("已经在匹配了")
        return false
    end
    local PC = GetLocalPlayerController()
    if not PC or not PC.bIsTeamLeader then
        return false
    end

    bFillTeammate = bFillTeammate == true
    UnrealNetwork.CallUnrealRPC(PC, PC, "RPC_Server_SetFillTeammate", bFillTeammate)
    UGCMultiMode.RequestMatch(self.CurrentSelectedModeID, nil, nil, bFillTeammate)
    return true
end

---@return boolean
function LobbyModel:CancelMatch()
    if not self.bIsMatching then
        return false
    end
    if UGCMultiMode.RequestCancelMatch() then
        self:OnMatchCanceled()
        return true
    end
    UGCWidgetManagerSystem.ShowTipsUI("取消匹配失败")
    return false
end

---@return boolean
function LobbyModel:IsMatching()
    return self.bIsMatching
end

---@param bIsMatching boolean
function LobbyModel:SetMatchingState(bIsMatching)
    self.bIsMatching = bIsMatching == true
    LobbyEvent.OnMatchStarted(self.bIsMatching)
end

---广播大厅退出事件，并执行返回游戏大厅操作。
function LobbyModel:ExitLobby()
    LobbyEvent.OnLobbyExited()
    self:DoExitLobby()
end

---兼容旧调用；退出执行与退出事件分离。
function LobbyModel:DoExitLobby()
    UGCGameSystem.ReturnToLobby()
    if UGCGameSystem.GameState and UGCGameSystem.GameState.DestroyBattleWidget then
        UGCGameSystem.GameState:DestroyBattleWidget()
    end
end

---@private
function LobbyModel:OnMatchStarted(bSucceeded)
    local PC = GetLocalPlayerController()
    if not PC or not PC.bIsTeamLeader then
        return
    end

    self:SetMatchingState(bSucceeded)
    UGCWidgetManagerSystem.ShowTipsUI("匹配" .. (bSucceeded and "开始" or "失败"))
    UnrealNetwork.CallUnrealRPC(PC, PC, "RPC_Server_SetLobbybIsMatching", bSucceeded)
end

---@private
function LobbyModel:OnMatchCanceled()
    local PC = GetLocalPlayerController()
    if not PC or not PC.bIsTeamLeader then
        return
    end

    self.bIsMatching = false
    UnrealNetwork.CallUnrealRPC(PC, PC, "RPC_Server_SetLobbybIsMatching", false)
    UGCWidgetManagerSystem.ShowTipsUI("匹配取消")
    LobbyEvent.OnMatchCanceled()
end

---@private
function LobbyModel:OnMatchSuccess()
    LobbyEvent.OnMatchSuccess()
end

---@private
function LobbyModel:CombineModeConfigTable()
    local ModeRowsByID = {}
    for _, ModeRow in ipairs(self.GameModeConfigList) do
        ModeRowsByID[tonumber(ModeRow.ModeID)] = ModeRow
    end

    for _, Detail in ipairs(self.GameModeDetailList) do
        local DetailModeIDs = {}
        for _, RawModeID in ipairs(Detail.ModeIDs or {}) do
            local ModeID = tonumber(RawModeID)
            local ModeRow = ModeRowsByID[ModeID]
            if ModeRow then
                local Combined = {
                    ModeID = ModeID,
                    DetailID = Detail.ID,
                    ModeName = Detail.ModeName,
                    ModeDesc = Detail.ModeDesc,
                    ModeBanner = Detail.ModeBanner,
                    ModePost = Detail.ModePost,
                    Difficulty = ModeRow.Difficulty,
                    UnlockDesc = ModeRow.UnlockDesc,
                    Hide = Detail.Hide,
                }
                table.insert(self.CombinedModeConfigList, Combined)
                table.insert(DetailModeIDs, ModeID)
                self.ModeConfigByID[ModeID] = Combined
            end
        end
        self.ModeIDsByDetailID[Detail.ID] = DetailModeIDs
    end
end

return LobbyModel
