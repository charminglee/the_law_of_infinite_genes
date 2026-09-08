---@class BroadcastManager
BroadcastManager = BroadcastManager or {
    MainUI = nil,
    IsLoading = false,
    PendingData = nil,
    NoticeUI = nil,
    IsNoticeLoading = false,
    PendingNotice = nil,
}

local TipsPath = "Asset/Blueprint/Prefabs/UI/Broadcast/Tips.Tips_C"
local NoticePath = "Asset/Blueprint/Prefabs/UI/Broadcast/Notice.Notice_C"

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

---@param data string|table
---@param Image string|FSoftObjectPath
function BroadcastManager:Notice(data, Image)
    if type(data) == "string" then
        data = {
            FinalContext = data,
            PlayLength = 3,
        }
    end

    if self.NoticeUI == nil then
        self.PendingNotice = {
            Data = data,
            Image = Image,
        }
        self:AsyncLoadNotice()
        return
    end

    self.NoticeUI:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.NoticeUI:SetImage(Image)
    self.NoticeUI:BPDoActionsWhenNewTipBegin(data)
end

function BroadcastManager:AsyncLoadNotice()
    if self.NoticeUI ~= nil or self.IsNoticeLoading then
        return
    end

    self.IsNoticeLoading = true
    Common.LoadObjectAsync(
        UGCMapInfoLib.GetRootLongPackagePath() .. NoticePath,
        function(UIClass)
            self.IsNoticeLoading = false
            if UIClass == nil then
                return
            end

            self.NoticeUI = UserWidget.NewWidgetObjectBP(LocalPlayerController, UIClass)
            self.NoticeUI:AddToViewport(12000)
            self.NoticeUI:BPInitWhenSpawned()

            local pendingNotice = self.PendingNotice
            self.PendingNotice = nil
            if pendingNotice ~= nil then
                self:Notice(pendingNotice.Data, pendingNotice.Image)
            end
        end
    )
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
