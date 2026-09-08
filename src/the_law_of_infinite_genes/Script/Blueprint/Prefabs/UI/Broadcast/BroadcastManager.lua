---@class BroadcastManager
BroadcastManager = BroadcastManager or {
    MainUI = nil,
    IsLoading = false,
    PendingData = nil,
}

local TipsPath = "Asset/Blueprint/Prefabs/UI/Broadcast/Tips.Tips_C"

---@param data string|table
function BroadcastManager:SendTip(data)
    if type(data) == "string" then
        data = {
            FinalContext = data,
            PlayLength = 3,
        }
    end

    if self.MainUI == nil then
        self.PendingData = data
        self:AsyncLoad()
        return
    end

    self.MainUI:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.MainUI:BPDoActionsWhenNewTipBegin(data)
end

function BroadcastManager:AsyncLoad()
    if self.MainUI ~= nil or self.IsLoading then
        return
    end

    self.IsLoading = true
    Common.LoadObjectAsync(
        UGCMapInfoLib.GetRootLongPackagePath() .. TipsPath,
        function(UIClass)
            self.IsLoading = false
            if UIClass == nil then
                return
            end

            self.MainUI = UserWidget.NewWidgetObjectBP(LocalPlayerController, UIClass)
            self.MainUI:AddToViewport(12000)
            self.MainUI:BPInitWhenSpawned()

            local data = self.PendingData
            self.PendingData = nil
            if data ~= nil then
                self:SendTip(data)
            end
        end
    )
end

return BroadcastManager
