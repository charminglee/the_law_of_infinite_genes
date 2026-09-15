---@class SwitchMode_C:UAEUserWidget
---@field Button_3 UButton
---@field Button_4 UButton
---@field Button_5 UButton
---@field Button_Exit UButton
---@field Button_Left UButton
---@field Button_Right UButton
---@field DegreeChoice DegreeChoice_C
---@field DropList UGC_ReuseList2_C
---@field Image_Customs UImage
---@field TextBlock_Description UTextBlock
---@field TextBlock_Map UTextBlock
--Edit Below--
local SwitchMode = { bInitDoOnce = false }

function SwitchMode:Construct()
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true
    self.Button_Exit.OnClicked:Add(self.OnCancelClicked, self)
    self.Button_3.OnClicked:Add(self.OnCancelClicked, self)
    self.Button_4.OnClicked:Add(self.OnRecruitClicked, self)
    self.Button_5.OnClicked:Add(self.OnConfirmClicked, self)
    self.Button_Left.OnClicked:Add(self.OnPreviousMap, self)
    self.Button_Right.OnClicked:Add(self.OnNextMap, self)
    self.DropList.OnAfterNewItem:Add(self.OnDropItemReload, self)
end

function SwitchMode:OnOpen(Data)
    self.FocusedModeID = Data.ModeID
end

function SwitchMode:OnUpdate(Data)
    self.FocusedModeID = Data.ModeID or self.FocusedModeID
    local PlayerController = UGCGameSystem.GetLocalPlayerController()
    local bHasTeam = #(PlayerController.LobbyTeammatePlayerKeys or {}) > 1
    self.Button_4:SetVisibility(not bHasTeam and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    self.Maps = RecruitManager:GetMapConfigs()
    self.MapIndex = 1
    for Index, Map in ipairs(self.Maps) do
        if Map.ModeID == self.FocusedModeID then
            self.MapIndex = Index
            break
        end
    end
    self:ApplyMap(self.MapIndex)
end

function SwitchMode:ApplyMap(Index)
    local Map = self.Maps[Index]
    if not Map then
        return
    end
    self.MapIndex = Index
    self:ApplyMode(Map)
    local DifficultyOptions = RecruitManager:GetDifficultyConfigs()
    local bMapLocked = RecruitManager:IsModeLocked(Map.ModeID)
    self.Button_5:SetIsEnabled(not bMapLocked)
    self.SelectedDifficultyModeID = not bMapLocked and DifficultyOptions[1].ModeID or nil
    self.DegreeChoice:SetOptions(DifficultyOptions, self.SelectedDifficultyModeID, function(Config)
        self.SelectedDifficultyModeID = Config.ModeID
    end, function(ModeID)
        return bMapLocked or RecruitManager:IsModeLocked(ModeID)
    end)
end

function SwitchMode:ApplyMode(Config)
    self.FocusedModeID = Config.ModeID
    self.TextBlock_Map:SetText(Config.ModeName or "")
    self.TextBlock_Description:SetText(Config.ModeDesc or "")
    self.Image_Customs:SetVisibility(Config.ModePost and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
    if Config.ModePost then
        self.Image_Customs:SetBrushFromTexture(Config.ModePost, false)
    end
    self.DropItems = Config.DropItems or {}
    self.DropList:Reload(#self.DropItems)
end

function SwitchMode:OnPreviousMap()
    self:ApplyMap((self.MapIndex - 2) % #self.Maps + 1)
end

function SwitchMode:OnNextMap()
    self:ApplyMap(self.MapIndex % #self.Maps + 1)
end

function SwitchMode:OnDropItemReload(Item, ZeroBasedIndex)
    Item:SetData(self.DropItems[ZeroBasedIndex + 1])
end

function SwitchMode:OnConfirmClicked()
    if LobbyModel:SelectMode(self.FocusedModeID) then
        LobbyUtils.CloseWidget(LobbyWidgetType.LWT_SwitchMode)
    end
end

function SwitchMode:OnCancelClicked()
    LobbyUtils.CloseWidget(LobbyWidgetType.LWT_SwitchMode)
end

function SwitchMode:OnRecruitClicked()
    LobbyUtils.CloseWidget(LobbyWidgetType.LWT_SwitchMode)
    RecruitManager:OpenMainUI()
end

return SwitchMode
