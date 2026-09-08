---@class WBP_SocialChat_GlobalPlayerItem_C:UUserWidget
---@field AddFriendBox USizeBox
---@field AddFriendBut UButton
---@field Image_0 UImage
---@field PlayerName UTextBlock
---@field ShowAttributeBox USizeBox
---@field ShowAttributeValue UTextBlock
---@field SortAttributeBox USizeBox
---@field SortAttributeValue UTextBlock
--Edit Below--
local WBP_SocialChat_GlobalPlayerItem = { bInitDoOnce = false }

--- 显示浮动提示文字
local function ShowTip(text, widget)
    local PC = nil
    if widget and type(widget.GetOwningPlayer) == "function" then
        PC = widget:GetOwningPlayer()
    end
    if not PC then
        PC = GameplayStatics.GetPlayerController(nil, 0)
    end
    if PC then
        UGCWidgetManagerSystem.ShowTipsUIWithPC(tostring(text), PC)
    end
end

--- 安全检查：是否已是好友
local function CheckIsFriend(uid)
    if not uid or uid <= 0 then
        return false
    end
    if UGCGameSystem and type(UGCGameSystem.IsMyFriend) == "function" then
        return UGCGameSystem.IsMyFriend(uid)
    end
    return false
end

function WBP_SocialChat_GlobalPlayerItem:Construct()
    -- 读取父级传入的初始化数据
    local data = self._initData
    if not data then
        return
    end

    -- 缓存 uid
    self._uid = data.uid

    -- 设置玩家名称
    if self.PlayerName and data.playerName then
        self.PlayerName:SetText(tostring(data.playerName))
    end

    -- 设置排序属性值 & 可见性
    if self.SortAttributeBox then
        self.SortAttributeBox:SetVisibility(data.bHideSortAttr and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible)
    end
    if self.SortAttributeValue and not data.bHideSortAttr then
        self.SortAttributeValue:SetText(tostring(math.floor(data.sortValue or 0)))
    end

    -- 设置展示属性值 & 可见性
    if self.ShowAttributeBox then
        self.ShowAttributeBox:SetVisibility(data.bHideShowAttr and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible)
    end
    if self.ShowAttributeValue and not data.bHideShowAttr then
        self.ShowAttributeValue:SetText(tostring(math.floor(data.displayValue or 0)))
    end

    -- 添加好友按钮：固定显示，自己或已是好友时隐藏（用 Hidden 保持布局一致）
    local localPlayerKey = UGCGameSystem.GetLocalPlayerKey()
    local localUID = localPlayerKey and UGCGameSystem.GetUIDByPlayerKey(localPlayerKey) or 0
    local bIsSelf = (localUID > 0 and localUID == data.uid)
    local bAlreadyFriend = data.uid and data.uid > 0 and CheckIsFriend(data.uid)
    local bShowAddFriendFinal = not bIsSelf and not bAlreadyFriend
    if self.AddFriendBox then
        if bShowAddFriendFinal then
            self.AddFriendBox:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        else
            self.AddFriendBox:SetVisibility(ESlateVisibility.Hidden)
        end
    end
    if self.AddFriendBut and bShowAddFriendFinal then
        self.AddFriendBut.OnClicked:Add(self.OnAddFriendClicked, self)
    end
end

--- 添加好友按钮点击处理
function WBP_SocialChat_GlobalPlayerItem:OnAddFriendClicked()
    -- 使用缓存的 uid
    local uid = self._uid
    if not uid or uid <= 0 then
        ShowTip("无法获取玩家信息", self)
        return
    end

    -- 1. 检查是否已是好友
    if CheckIsFriend(uid) then
        ShowTip("该玩家已经是你的好友", self)
        return
    end

    -- 2. 检查是否已发送过申请（本地缓存，防止重复点击）
    if self._sentRequestSet and self._sentRequestSet[uid] then
        ShowTip("您已申请，请等待对方回应", self)
        return
    end

    -- 3. 发送好友申请
    local bSuccess = false
    if UGCGameSystem and type(UGCGameSystem.AddFriend) == "function" then
        local ok, err = pcall(function()
            UGCGameSystem.AddFriend(uid)
            bSuccess = true
        end)
    end

    if bSuccess then
        ShowTip("成功向对方发出好友申请", self)
    else
        ShowTip("当前环境不支持添加好友", self)
        return
    end

    -- 记录到本地已发送集合（防止重复点击）
    if not self._sentRequestSet then
        self._sentRequestSet = {}
    end
    self._sentRequestSet[uid] = true
end

function WBP_SocialChat_GlobalPlayerItem:Destruct()
    if self.AddFriendBut then
        self.AddFriendBut.OnClicked:Remove(self.OnAddFriendClicked, self)
    end
end

return WBP_SocialChat_GlobalPlayerItem
