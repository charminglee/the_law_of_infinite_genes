---@class RoomConfig_C:UAEUserWidget
---@field Button_Cancel UButton
---@field Button_Left UButton
---@field Button_Right UButton
---@field Button_Save UButton
---@field CheckBox_AllowRestock UCheckBox
---@field CheckBox_AllowServe UCheckBox
---@field DegreeChoice DegreeChoice_C
---@field DropList UGC_ReuseList2_C
---@field Image_Customs UImage
---@field TextBlock_Description UTextBlock
---@field TextBlock_MapName UTextBlock
--Edit Below--
local RoomConfig = { bInitDoOnce = false }

function RoomConfig:Construct()
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true
    self.Button_Cancel.OnClicked:Add(self.OnCancelClicked, self)
    self.Button_Save.OnClicked:Add(self.OnSaveClicked, self)
    self.Button_Left.OnClicked:Add(self.OnPreviousMap, self)
    self.Button_Right.OnClicked:Add(self.OnNextMap, self)
    self.DropList.OnAfterNewItem:Add(self.OnDropItemReload, self)
end

function RoomConfig:OnOpen(Data)
    self.Config = Data.Config
    self.OnSave = Data.OnSave
    self.OnCancel = Data.OnCancel
    self.Maps = RecruitManager:GetModeGroups()
    self.MapIndex = 1
    local CurrentMode = RecruitManager:GetModeConfig(self.Config.ModeID)
    for Index, Map in ipairs(self.Maps) do
        if CurrentMode and Map.DetailID == CurrentMode.DetailID then
            self.MapIndex = Index
            break
        end
    end
    self.CheckBox_AllowRestock:SetIsChecked(self.Config.AllowRestock == true)
    self.CheckBox_AllowServe:SetIsChecked(self.Config.AllowServe == true)
    self:ApplyMap(self.MapIndex, self.Config.ModeID)
end

function RoomConfig:ApplyMap(Index, SelectedModeID)
    local Map = self.Maps[Index]
    if not Map then
        return
    end
    self.MapIndex = Index
    local Difficulties = RecruitManager:GetDifficultyConfigs(Map.ModeID)
    local Selected = RecruitManager:GetModeConfig(SelectedModeID) and SelectedModeID or Difficulties[1].ModeID
    self:ApplyMode(RecruitManager:GetModeConfig(Selected))
    self.DegreeChoice:SetOptions(Difficulties, Selected, function(NewConfig)
        self:ApplyMode(NewConfig)
    end, function(ModeID)
        return RecruitManager:IsModeLocked(ModeID)
    end)
end

function RoomConfig:ApplyMode(Mode)
    self.Config.ModeID = Mode.ModeID
    self.Config.MapName = Mode.ModeName
    self.Config.Description = Mode.ModeDesc
    self.Config.MapImage = Mode.ModePost
    self.Config.Difficulty = Mode.Difficulty
    self.TextBlock_MapName:SetText(Mode.ModeName or "")
    self.TextBlock_Description:SetText(Mode.ModeDesc or "")
    self.Image_Customs:SetBrushFromTexture(Mode.ModePost, false)
    self.DropItems = self.Config.DropItems or {}
    self.DropList:Reload(#self.DropItems)
end

function RoomConfig:OnPreviousMap()
    self:ApplyMap((self.MapIndex - 2) % #self.Maps + 1)
end

function RoomConfig:OnNextMap()
    self:ApplyMap(self.MapIndex % #self.Maps + 1)
end

function RoomConfig:OnDropItemReload(Item, ZeroBasedIndex)
    Item:SetData(self.DropItems[ZeroBasedIndex + 1])
end

function RoomConfig:OnSaveClicked()
    self.Config.AllowRestock = self.CheckBox_AllowRestock:IsChecked()
    self.Config.AllowServe = self.CheckBox_AllowServe:IsChecked()
    self.OnSave(self.Config)
end

function RoomConfig:OnCancelClicked()
    self.OnCancel()
end

return RoomConfig
