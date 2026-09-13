---@class DegreeChoice_C:UAEUserWidget
---@field Button_1 UButton
---@field Button_2 UButton
---@field Button_3 UButton
---@field Button_4 UButton
---@field DegreeChoiceItem_1 DegreeChoiceItem_C
---@field DegreeChoiceItem_2 DegreeChoiceItem_C
---@field DegreeChoiceItem_3 DegreeChoiceItem_C
---@field DegreeChoiceItem_C_2 DegreeChoiceItem_C
--Edit Below--
local DegreeChoice = { bInitDoOnce = false }

function DegreeChoice:Construct()
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true
    self.Buttons = { self.Button_1, self.Button_2, self.Button_3, self.Button_4 }
    self.Items = { self.DegreeChoiceItem_1, self.DegreeChoiceItem_2, self.DegreeChoiceItem_3, self.DegreeChoiceItem_C_2 }
    self.Button_1.OnClicked:Add(self.OnChoice1, self)
    self.Button_2.OnClicked:Add(self.OnChoice2, self)
    self.Button_3.OnClicked:Add(self.OnChoice3, self)
    self.Button_4.OnClicked:Add(self.OnChoice4, self)
end

function DegreeChoice:SetOptions(Options, SelectedModeID, OnSelected, IsLocked)
    self.Options = Options
    self.SelectedModeID = SelectedModeID
    self.OnSelected = OnSelected
    self.IsLocked = IsLocked
    for Index, Item in ipairs(self.Items) do
        local Config = Options[Index]
        local bLocked = Config and self.IsLocked(Config.ModeID) or false
        Item:SetState(Config and Config.ModeID == SelectedModeID, bLocked, Config ~= nil)
        self.Buttons[Index]:SetIsEnabled(Config ~= nil and not bLocked)
    end
end

function DegreeChoice:Select(Index)
    local Config = self.Options[Index]
    if not Config or self.IsLocked(Config.ModeID) then
        return
    end
    self.SelectedModeID = Config.ModeID
    self:SetOptions(self.Options, self.SelectedModeID, self.OnSelected, self.IsLocked)
    self.OnSelected(Config)
end

function DegreeChoice:OnChoice1() self:Select(1) end
function DegreeChoice:OnChoice2() self:Select(2) end
function DegreeChoice:OnChoice3() self:Select(3) end
function DegreeChoice:OnChoice4() self:Select(4) end

return DegreeChoice
