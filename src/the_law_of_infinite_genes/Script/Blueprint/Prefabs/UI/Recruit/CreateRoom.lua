---@class CreateRoom_C:UAEUserWidget
---@field Button_Cancel UButton
---@field Button_Create UButton
---@field Button_Left UButton
---@field Button_Right UButton
---@field DegreeChoice DegreeChoice_C
---@field DropList UGC_ReuseList2_C
---@field Image_Customs UImage
---@field TextBlock_Description UTextBlock
---@field TextBlock_MapName UTextBlock
--Edit Below--
local CreateRoom = { bInitDoOnce = false }
function CreateRoom:Init(OnCreate, OnCancel)
    self.OnCreate = OnCreate
    self.OnCancel = OnCancel
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true
    self.Button_Cancel.OnClicked:Add(self.OnCancelClicked, self)
    self.Button_Create.OnClicked:Add(self.OnCreateClicked, self)
    self.Button_Left.OnClicked:Add(self.OnPreviousMap, self)
    self.Button_Right.OnClicked:Add(self.OnNextMap, self)
    self.DropList.OnAfterNewItem:Add(self.OnDropItemReload, self)
end
function CreateRoom:OnOpen(Config)
    self.Config = Config
    self.Maps = RecruitManager:GetMapConfigs()
    self.MapIndex = 1
    for Index, Map in ipairs(self.Maps) do
        if Map.ModeID == Config.ModeID then
            self.MapIndex = Index
            break
        end
    end
    self:ApplyMap(self.MapIndex)
end
function CreateRoom:ApplyMap(Index)
    local Map = self.Maps[Index]
    if not Map then
        return
    end
    self.MapIndex = Index
    self:ApplyMode(Map)
    local Difficulties = RecruitManager:GetDifficultyConfigs()
    local bMapLocked = RecruitManager:IsModeLocked(Map.ModeID)
    self.Button_Create:SetIsEnabled(not bMapLocked)
    local SelectedDifficultyModeID = not bMapLocked and Difficulties[1].ModeID or nil
    if SelectedDifficultyModeID then
        self.Config.Difficulty = Difficulties[1].Difficulty
    end
    self.DegreeChoice:SetOptions(Difficulties, SelectedDifficultyModeID, function(NewConfig)
        self.Config.Difficulty = NewConfig.Difficulty
    end, function(ModeID)
        return bMapLocked or RecruitManager:IsModeLocked(ModeID)
    end)
end
function CreateRoom:ApplyMode(Mode)
    self.Config.ModeID = Mode.ModeID
    self.Config.MapName = Mode.ModeName
    self.Config.Description = Mode.ModeDesc
    self.Config.MapImage = Mode.ModePost
    self.Config.Difficulty = Mode.Difficulty
    self.TextBlock_MapName:SetText(Mode.ModeName or "")
    self.TextBlock_Description:SetText(Mode.ModeDesc or "")
    self.Image_Customs:SetVisibility(Mode.ModePost and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
    if Mode.ModePost then
        self.Image_Customs:SetBrushFromTexture(Mode.ModePost, false)
    end
    self.DropItems = self.Config.DropItems or {}
    self.DropList:Reload(#self.DropItems)
end
function CreateRoom:OnPreviousMap()
    self:ApplyMap((self.MapIndex - 2) % #self.Maps + 1)
end
function CreateRoom:OnNextMap()
    self:ApplyMap(self.MapIndex % #self.Maps + 1)
end
function CreateRoom:OnDropItemReload(Item, ZeroBasedIndex)
    Item:SetData(self.DropItems[ZeroBasedIndex + 1])
end
function CreateRoom:OnCreateClicked()
    self.OnCreate(self.Config)
end
function CreateRoom:OnCancelClicked()
    self.OnCancel()
end
return CreateRoom
