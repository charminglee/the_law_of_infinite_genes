---@class UGCPass_Record_Item_UIBP_C:UUserWidget
---@field Button UNewButton
---@field Detail UCanvasPanel
---@field LevelRecordText UTextBlock
---@field LevelText UTextBlock
---@field PassIcon UImage
---@field PassNameText UTextBlock
---@field TaskCompletionRateText UTextBlock
---@field ThemeText UTextBlock
--Edit Below--
local UGCPass_Record_Item_UIBP = { bInitDoOnce = false } 

function UGCPass_Record_Item_UIBP:Construct()
	self.Button.OnClicked:Add(self.SwitchView, self)
    self.bShowDetail = false
end

function UGCPass_Record_Item_UIBP:Destruct()
	self.Button.OnClicked:Remove(self.SwitchView, self)
end

function UGCPass_Record_Item_UIBP:Refresh(PassID)
    local PassConfig = PassManager:GetPassConfigData(PassID)

    self.ThemeText:SetText(PassConfig.ThemeName)
    
    if PassManager:HasAdvancedPass(PassID) then
        PassManager:SetImageFromIconPath(self.PassIcon, PassConfig.AdvancedPassIcon)
        self.PassNameText:SetText(PassConfig.AdvancedPassName)
    else
        PassManager:SetImageFromIconPath(self.PassIcon, PassConfig.BasePassIcon)
        self.PassNameText:SetText(PassConfig.BasePassName)
    end

    local LevelData = PassManager:GetPassCurrentLevelData(PassID)
    self.LevelText:SetText(tostring(LevelData.Level))

    --详细数据
    self.LevelRecordText:SetText(tostring(LevelData.Level))

    local TotalTaskNum, CompletedTaskNum = 0, 0
    local Tasks = PassManager:GetTaskConfigDatas(PassID).Tasks
    for TaskIndex, TaskConfig in pairs(Tasks) do
        TotalTaskNum = TotalTaskNum + 1

        local TaskState = PassManager:GetTaskState(PassID, TaskIndex)
        if TaskState == EUGCTaskState.HasClaimed then
            CompletedTaskNum = CompletedTaskNum + 1
        end
    end

    self.TaskCompletionRateText:SetText(string.format("%d/%d", CompletedTaskNum, TotalTaskNum))
end

function UGCPass_Record_Item_UIBP:SwitchView()
    self.bShowDetail = not self.bShowDetail

    self.Detail:SetVisibility(self.bShowDetail and ESlateVisibility.HitTestInvisible or ESlateVisibility.Collapsed)
end

return UGCPass_Record_Item_UIBP