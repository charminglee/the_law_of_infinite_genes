---@class TeamList_C:UAEUserWidget
---@field TextBlock_Name_1 UTextBlock
---@field TextBlock_Name_2 UTextBlock
---@field TextBlock_Name_3 UTextBlock
---@field TextBlock_Name_4 UTextBlock
---@field TextBlock_State_1 UTextBlock
---@field TextBlock_State_2 UTextBlock
---@field TextBlock_State_3 UTextBlock
---@field TextBlock_State_4 UTextBlock
--Edit Below--
local TeamList = {}

function TeamList:SetMembers(Members)
    local NameWidgets = {
        self.TextBlock_Name_1,
        self.TextBlock_Name_2,
        self.TextBlock_Name_3,
        self.TextBlock_Name_4,
    }
    local StateWidgets = {
        self.TextBlock_State_1,
        self.TextBlock_State_2,
        self.TextBlock_State_3,
        self.TextBlock_State_4,
    }
    for Index = 1, 4 do
        local Member = Members[Index]
        NameWidgets[Index]:SetText(Member and Member.Name or "等待加入")
        if Member then
            StateWidgets[Index]:SetText(Member.bLeader and "队长" or (Member.bReady and "已准备" or "未准备"))
        else
            StateWidgets[Index]:SetText("")
        end
    end
end

return TeamList
