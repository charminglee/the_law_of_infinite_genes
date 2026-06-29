---@class UGCPass_Record_UIBP_C:UUserWidget
---@field CloseButton UNewButton
---@field EmptyTip UCanvasPanel
---@field RecordList UHorizontalBox
---@field RecordItemUIClassPath FSoftClassPath
--Edit Below--
local UGCPass_Record_UIBP = { bInitDoOnce = false } 

function UGCPass_Record_UIBP:Construct()
    self.CloseButton.OnClicked:Add(self.OnCloseButtonClick, self)
end

function UGCPass_Record_UIBP:Destruct()
    self.CloseButton.OnClicked:Remove(self.OnCloseButtonClick, self)
end

function UGCPass_Record_UIBP:Refresh()
    PassManager:Log("", "UGCPass_Record_UIBP:Refresh")

    if self.RecordItemClass == nil then
        UGCObjectUtility.AsyncLoadClass(UGCObjectUtility.GetPathBySoftObjectPath(self.RecordItemUIClassPath), 
            function (Class)
                if Class == nil then
                    PassManager:LogError("Load RecordItemClass failed", "UGCPass_Record_UIBP:Refresh")
                    return
                end

                self.RecordItemClass = Class

                self:RefreshRecordItems()
            end
        )
    else
        self:RefreshRecordItems()
    end
end

function UGCPass_Record_UIBP:RefreshRecordItems()
    PassManager:Log("", "UGCPass_Record_UIBP:RefreshRecordItems")

    local PassConfigs = PassManager:GetAllPassConfigDatas()

    local ArchivedPassList = {}
    local ArchivedPassNum = 0
    local CurrentTime = UGCGameSystem.GetServerTimeSec()
    for PassID, PassConfigs in pairs(PassConfigs) do
        if CurrentTime > PassConfigs.StartTime then
            table.insert(ArchivedPassList, PassID)
            ArchivedPassNum = ArchivedPassNum + 1
        end
    end

    self.EmptyTip:SetVisibility(ArchivedPassNum > 0 and ESlateVisibility.Collapsed or ESlateVisibility.HitTestInvisible)
    
    local ChildrenCount = self.RecordList:GetChildrenCount()
    if ChildrenCount < ArchivedPassNum then
        local PC = UGCGameSystem.GetLocalPlayerController()

        if PC then
            for i = 1, ArchivedPassNum - ChildrenCount do
                ---#TODO 换成标准接口
                local Widget = UserWidget.NewWidgetObjectBP(PC, self.RecordItemClass)

                if UGCObjectUtility.IsObjectValid(Widget) then
                    self.RecordList:AddChildToHorizontalBox(Widget)
                else
                    PassManager:LogError("Create RecordItem failed", "UGCPass_Record_UIBP:RefreshRecordItems") 
                end
            end
        else
            PassManager:LogError("PlayerController is nil", "UGCPass_Record_UIBP:RefreshRecordItems")
        end
    end

    for Index=1, math.max(ChildrenCount, ArchivedPassNum) do
        local Widget = self.RecordList:GetChildAt(Index-1)

        if Index > ArchivedPassNum then
            Widget:SetVisibility(ESlateVisibility.Collapsed)
        else
            Widget:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            Widget:Refresh(ArchivedPassList[Index])
        end
    end
end

function UGCPass_Record_UIBP:OnCloseButtonClick()
    self:SetVisibility(ESlateVisibility.Collapsed)
end

return UGCPass_Record_UIBP