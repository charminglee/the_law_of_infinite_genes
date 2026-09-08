---@class WBP_SocialChat_GlobalPlayerList_C:UUserWidget
---@field CloseBut UButton
---@field Image_2 UImage
---@field ListScroll UScrollBox
---@field ShowAttributeBox USizeBox
---@field ShowAttributeText UTextBlock
---@field SortAttributeBox USizeBox
---@field SortAttributeText UTextBlock
---@field WBP_SocialChat_GlobalPlayerItem WBP_SocialChat_GlobalPlayerItem_C
---@field WBP_SocialChat_GlobalPlayerItem_0 WBP_SocialChat_GlobalPlayerItem_C
---@field WBP_SocialChat_GlobalPlayerItem_1 WBP_SocialChat_GlobalPlayerItem_C
---@field WBP_SocialChat_GlobalPlayerItem_2 WBP_SocialChat_GlobalPlayerItem_C
---@field WBP_SocialChat_GlobalPlayerItem_3 WBP_SocialChat_GlobalPlayerItem_C
--Edit Below--
local WBP_SocialChat_GlobalPlayerList = { bInitDoOnce = false }

--- 工具函数：截断 UTF-8 字符串到指定字数
local function TruncateUTF8(str, maxChars)
    if not str or str == "" then return "" end
    local count = 0
    local i = 1
    local len = #str
    while i <= len and count < maxChars do
        local byte = string.byte(str, i)
        if byte < 0x80 then
            i = i + 1
        elseif byte < 0xE0 then
            i = i + 2
        elseif byte < 0xF0 then
            i = i + 3
        else
            i = i + 4
        end
        count = count + 1
    end
    return string.sub(str, 1, i - 1)
end

function WBP_SocialChat_GlobalPlayerList:Construct()
    -- 绑定关闭按钮
    if self.CloseBut then
        print_dev("[GlobalPlayerList] Construct: CloseBut 存在，开始绑定 OnClicked")
        self.CloseBut.OnClicked:Add(self.OnCloseButClicked, self)
        print_dev("[GlobalPlayerList] Construct: OnClicked 绑定完成")
    else
        print_dev("[GlobalPlayerList] Construct: ERROR - CloseBut 为 nil，无法绑定")
    end

    -- 隐藏蓝图中预设的 Item 模板（含 _0 示例行，防止空数据时残留默认显示）
    if self.WBP_SocialChat_GlobalPlayerItem then
        self.WBP_SocialChat_GlobalPlayerItem:SetVisibility(ESlateVisibility.Collapsed)
    end
    if self.WBP_SocialChat_GlobalPlayerItem_0 then
        self.WBP_SocialChat_GlobalPlayerItem_0:SetVisibility(ESlateVisibility.Collapsed)
    end
    if self.WBP_SocialChat_GlobalPlayerItem_1 then
        self.WBP_SocialChat_GlobalPlayerItem_1:SetVisibility(ESlateVisibility.Collapsed)
    end
    if self.WBP_SocialChat_GlobalPlayerItem_2 then
        self.WBP_SocialChat_GlobalPlayerItem_2:SetVisibility(ESlateVisibility.Collapsed)
    end
    if self.WBP_SocialChat_GlobalPlayerItem_3 then
        self.WBP_SocialChat_GlobalPlayerItem_3:SetVisibility(ESlateVisibility.Collapsed)
    end

    -- Item 控件缓存: uid -> itemWidget
    self._itemWidgetMap = {}
    -- 已发送申请的 UID 集合（用于防重复点击）
    self._sentRequestSet = {}

    -- 缓存 Item 蓝图类
    local itemClassPath = UGCGameSystem.GetUGCResourcesFullPath(
        "ExtendResource/GlobalPlayerList/OfficialPackage/" .. "Asset/SocialChat/Arts_UI/UIBP/WBP_SocialChat_GlobalPlayerItem.WBP_SocialChat_GlobalPlayerItem_C"
    )
    self._itemClass = UE.LoadClass(itemClassPath)
    if not self._itemClass then
        print_dev("[GlobalPlayerList] 无法加载 Item 蓝图类: " .. tostring(itemClassPath))
    end

    -- 从 PlayerListManager 读取配置并监听数据更新
    self:_InitPlayerListManager()

    -- 请求已发送的好友申请列表（异步，稍后通过定时器读取结果）
    self:_RequestAddFriendList()
end

--- 初始化 PlayerListManager：读取配置 + 注册委托（支持重试，规避客户端时序问题）
function WBP_SocialChat_GlobalPlayerList:_InitPlayerListManager(retryCount)
    retryCount = retryCount or 0
    local MAX_RETRY = 10
    local RETRY_INTERVAL = 0.5

    -- 1. 检查 GlobalActor 是否就绪
    local ok, PlayerListGlobalActor = pcall(function()
        return UGCGamePartSystem.PlayerListManager.GetGlobalActor()
    end)
    if not ok or not PlayerListGlobalActor then
        if retryCount < MAX_RETRY then
            print_dev("[GlobalPlayerList] GlobalActor 未就绪，" .. RETRY_INTERVAL .. "秒后重试 (" .. (retryCount + 1) .. "/" .. MAX_RETRY .. ")")
            Timer.InsertTimer(RETRY_INTERVAL, function()
                if self and UE.IsValid(self) then
                    self:_InitPlayerListManager(retryCount + 1)
                end
            end, false)
        else
            print_dev("[GlobalPlayerList] GlobalActor 重试 " .. MAX_RETRY .. " 次仍失败，放弃初始化")
        end
        return
    end

    -- 2. 读取配置：优先用 GetConfig()（直接从 GamePartManager 读，不依赖 GlobalActor 的 BeginPlay）
    local config = nil
    pcall(function()
        config = UGCGamePartSystem.PlayerListManager.GetConfig()
    end)
    -- 兜底：GetConfig 不可用时尝试 GlobalActor 自身的接口
    if not config then
        pcall(function()
            config = PlayerListGlobalActor:GetPlayerListConfig()
        end)
    end

    if not config or (not config.SortPropertyName and not config.DisplayPropertyName) then
        if retryCount < MAX_RETRY then
            print_dev("[GlobalPlayerList] 配置未就绪，" .. RETRY_INTERVAL .. "秒后重试 (" .. (retryCount + 1) .. "/" .. MAX_RETRY .. ")")
            Timer.InsertTimer(RETRY_INTERVAL, function()
                if self and UE.IsValid(self) then
                    self:_InitPlayerListManager(retryCount + 1)
                end
            end, false)
        else
            print_dev("[GlobalPlayerList] 配置重试 " .. MAX_RETRY .. " 次仍为空，使用默认值")
            self._bHideSortAttr = true
            self._bHideShowAttr = true
        end
        return
    end

    -- 3. 配置读取成功
    -- 检查 bEnablePlayerList 开关（GP 配置，控制是否启用列表）
    local bEnable = true
    if config.bEnablePlayerList ~= nil then
        bEnable = config.bEnablePlayerList
    end
    if not bEnable then
        print_dev("[GlobalPlayerList] bEnablePlayerList=false，禁用列表UI")
        self:SetVisibility(ESlateVisibility.Collapsed) 
        return  -- 直接返回，不注册数据监听
    end

    local sortAttrName = TruncateUTF8(tostring(config.SortPropertyName or ""), 6)
    local displayAttrName = TruncateUTF8(tostring(config.DisplayPropertyName or ""), 6)
    self._bHideSortAttr = (sortAttrName == "")
    self._bHideShowAttr = (displayAttrName == "")
    self._sortDescending = (config.SortType == 1)

    -- 设置表头文本和可见性
    if self.SortAttributeText then
        self.SortAttributeText:SetText(sortAttrName)
    end
    if self.SortAttributeBox then
        self.SortAttributeBox:SetVisibility(self._bHideSortAttr and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible)
    end
    if self.ShowAttributeText then
        self.ShowAttributeText:SetText(displayAttrName)
    end
    if self.ShowAttributeBox then
        self.ShowAttributeBox:SetVisibility(self._bHideShowAttr and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible)
    end

    print_dev("[GlobalPlayerList] 配置读取成功(retry=" .. retryCount .. "): Sort=" .. sortAttrName .. " Display=" .. displayAttrName)
    
    -- 4. 注册数据更新委托
    local PlayerListGlobalActor = UGCGamePartSystem.PlayerListManager.GetGlobalActor()
    if PlayerListGlobalActor and PlayerListGlobalActor.PlayerListUpdateDelegate then
        self._updateDelegateHandle = PlayerListGlobalActor.PlayerListUpdateDelegate:Add(self._OnPlayerListUpdated, self)
        print_dev("[GlobalPlayerList] PlayerListUpdateDelegate 注册成功")
        
        -- 主动拉取一次；为空则周期补拉，直到拉到数据或达到上限
        self:_TryFetchPlayerList(PlayerListGlobalActor)
    else
        print_dev("[GlobalPlayerList] 警告：PlayerListUpdateDelegate 不存在，列表不会自动刷新")
    end
end

--- 主动拉取玩家列表；为空时按 SyncInterval 周期补拉，规避 PlayerListManager 数据同步与 UI 构造的竞态
---（SyncInterval=1s 时，补拉 10 次 = 约 10 秒仍无数据，说明客户端同步链路本身异常，Lua 层无法解决）
function WBP_SocialChat_GlobalPlayerList:_TryFetchPlayerList(PlayerListGlobalActor)
    if not PlayerListGlobalActor then return end

    -- 取消上一次补拉定时器，防止重复补拉
    if self._fetchTimerHandle then
        Timer.RemoveTimer(self._fetchTimerHandle)
        self._fetchTimerHandle = nil
    end

    local MAX_FETCH = 10     -- 最多补拉 10 次（约 10 秒）
    local FETCH_INTERVAL = 1 -- 与 PlayerListManager SyncInterval 对齐

    local function doFetch(count)
        if not self or not UE.IsValid(self) then
            self._fetchTimerHandle = nil
            return
        end

        local ok, data = pcall(function()
            return PlayerListGlobalActor:GetPlayerListData()
        end)
        if not ok then
            print_dev("[GlobalPlayerList] 补拉数据异常: " .. tostring(data))
            self._fetchTimerHandle = nil
            return
        end

        if data and #data > 0 then
            print_dev("[GlobalPlayerList] 补拉成功(第" .. count .. "次)，共 " .. #data .. " 条，停止补拉")
            self._fetchTimerHandle = nil
            self:_OnPlayerListUpdated(data)
            return
        end

        if count >= MAX_FETCH then
            print_dev("[GlobalPlayerList] 补拉 " .. MAX_FETCH .. " 次仍无数据，PlayerListManager 客户端同步链路可能异常（数据未下发/未同步）")
            self._fetchTimerHandle = nil
            return
        end

        print_dev("[GlobalPlayerList] 补拉第 " .. count .. " 次仍为空，等待数据同步后继续")
        self._fetchTimerHandle = Timer.InsertTimer(FETCH_INTERVAL, function()
            doFetch(count + 1)
        end, false)
    end

    -- 第一次立即拉取
    doFetch(1)
end

--- PlayerListUpdateDelegate 回调：数据已更新，直接渲染
function WBP_SocialChat_GlobalPlayerList:_OnPlayerListUpdated(PlayerListData)
    if not PlayerListData then
        print_dev("[GlobalPlayerList] 收到空数据，跳过刷新")
        return
    end
    print_dev("[GlobalPlayerList] 收到数据更新，共 " .. #PlayerListData .. " 条")
    -- 打印每个条目的详细数据
    for i, entry in ipairs(PlayerListData) do
        print_dev("[GlobalPlayerList]   条目" .. i .. ": UID=" .. tostring(entry.UID) .. " Name=" .. tostring(entry.PlayerName) .. " Sort=" .. tostring(entry.SortValue) .. " Display=" .. tostring(entry.DisplayValue))
    end
    self:_RebuildList(PlayerListData)
end

--- 内部：请求已发送的好友申请列表
function WBP_SocialChat_GlobalPlayerList:_RequestAddFriendList()
    if not FriendSystem.get_addfriend_reqlist_req then return end

    -- 发送请求获取已发申请列表
    FriendSystem.get_addfriend_reqlist_req()

    -- 延迟读取：等待网络回包后从全局数据中提取 UID
    Timer.InsertTimer(1.0, function()
        self:_ReadAddFriendListFromCache()
    end, false)
end

--- 内部：从 FriendSystem 缓存中读取已发申请的 UID 集合
function WBP_SocialChat_GlobalPlayerList:_ReadAddFriendListFromCache()
    self._sentRequestSet = {}
    
    -- 从 LobbyFriendUIV2 的申请列表缓存中读取（这是 FriendSystem 回调写入的数据源）
    if LobbyFriendUIV2_ARRAY_ApplyFriendProfile then
        for _, profile in ipairs(LobbyFriendUIV2_ARRAY_ApplyFriendProfile) do
            if profile and profile.gid then
                local uid = tonumber(profile.gid)
                if uid and uid > 0 then
                    self._sentRequestSet[uid] = true
                end
            end
        end
    end

    print_dev("[GlobalPlayerList] 已加载 " .. self:_GetTableSize(self._sentRequestSet) .. " 条好友申请记录")
end

--- 工具函数：获取表的大小
function WBP_SocialChat_GlobalPlayerList:_GetTableSize(tbl)
    local count = 0
    for _ in pairs(tbl or {}) do
        count = count + 1
    end
    return count
end

---------------------------------------------------------------------------
-- 内部实现
---------------------------------------------------------------------------

--- 根据 PlayerListManager 推送的数据重建整个列表
---@param PlayerListData FPlayerListEntry[] 已排序的玩家列表
function WBP_SocialChat_GlobalPlayerList:_RebuildList(PlayerListData)
    if not self.ListScroll then return end

    -- 清空滚动框
    self.ListScroll:ClearChildren()
    self._itemWidgetMap = {}

    local PC = UGCGameSystem.GetLocalPlayerController()
    if not PC or not self._itemClass then return end

    if not PlayerListData or #PlayerListData == 0 then
        print_dev("[GlobalPlayerList] 数据为空，列表清空")
        return
    end

    -- 直接使用传入的已排序列表
    for _, entry in ipairs(PlayerListData) do
        local itemWidget = UserWidget.NewWidgetObjectBP(PC, self._itemClass)
        if itemWidget then
            itemWidget._initData = {
                uid = entry.UID,
                playerName = entry.PlayerName,
                sortValue = entry.SortValue,
                displayValue = entry.DisplayValue,
                bHideShowAttr = self._bHideShowAttr,
                bHideSortAttr = self._bHideSortAttr,
                parentList = self,
            }

            self.ListScroll:AddChild(itemWidget)
            self._itemWidgetMap[entry.UID] = itemWidget

            -- 顶部填充5
            local slot = itemWidget.Slot
            if slot and slot.SetPadding then
                slot:SetPadding({ Left = 0, Top = 5, Right = 0, Bottom = 0 })
            end
        end
    end

    print_dev("[GlobalPlayerList] 列表刷新完成，共 " .. #PlayerListData .. " 名玩家")
end

--- 关闭按钮点击
function WBP_SocialChat_GlobalPlayerList:OnCloseButClicked()
    print_dev("[GlobalPlayerList] OnCloseButClicked 被调用！")
    print_dev("[GlobalPlayerList] 当前可见性：" .. tostring(self:GetVisibility()))
    self:SetVisibility(ESlateVisibility.Collapsed)
    print_dev("[GlobalPlayerList] SetVisibility(Collapsed) 已执行，新可见性：" .. tostring(self:GetVisibility()))
end

function WBP_SocialChat_GlobalPlayerList:Destruct()
    if self.CloseBut then
        self.CloseBut.OnClicked:Remove(self.OnCloseButClicked, self)
    end

    -- 取消补拉定时器
    if self._fetchTimerHandle then
        Timer.RemoveTimer(self._fetchTimerHandle)
        self._fetchTimerHandle = nil
    end

    -- 解绑 PlayerListUpdateDelegate
    if self._updateDelegateHandle then
        local PlayerListGlobalActor = UGCGamePartSystem.PlayerListManager.GetGlobalActor()
        if PlayerListGlobalActor and PlayerListGlobalActor.PlayerListUpdateDelegate then
            pcall(function()
                PlayerListGlobalActor.PlayerListUpdateDelegate:Remove(self._updateDelegateHandle)
            end)
        end
        self._updateDelegateHandle = nil
    end

    self._itemWidgetMap = nil
end

return WBP_SocialChat_GlobalPlayerList
