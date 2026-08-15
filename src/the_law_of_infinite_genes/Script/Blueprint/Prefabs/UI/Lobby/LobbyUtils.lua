---@class LobbyWidgetType
LobbyWidgetType = LobbyWidgetType or {
    LWT_MainLobby = {
        Name = "MainLobby",
        Path = "Asset/Blueprint/Prefabs/UI/Lobby/Home/HomeMain.HomeMain_C",
        Instance = nil,
    },
    LWT_ModeSelect = {
        Name = "ModeSelect",
        Path = "Asset/Blueprint/Prefabs/UI/Lobby/Mode/UGC_ModeSelection_UIBP.UGC_ModeSelection_UIBP_C",
        Instance = nil,
    },
    LWT_ClosePopupsTips = {
        Name = "ClosePopupsTips",
        Path = "Asset/Blueprint/Prefabs/UI/Lobby/UGC_ClosePopupsTips_UIBP.UGC_ClosePopupsTips_UIBP_C",
        Instance = nil,
    },
    LWT_ModeDifficultyTip = {
        Name = "ModeDifficultyTip",
        Path = "Asset/Blueprint/Prefabs/UI/Lobby/Mode/UGC_DifficultyTips_UIBP.UGC_DifficultyTips_UIBP_C",
        Instance = nil,
    },
    LWT_RaidInstance = {
        Name = "RaidInstance",
        Path = "Asset/Blueprint/Prefabs/UI/RaidInstance/RaidInstanceMain.RaidInstanceMain_C",
        Instance = nil,
    },
}

---大厅 Widget 生命周期工具。
---@class LobbyUtils
LobbyUtils = LobbyUtils or {}

---检查 WidgetType 是否为大厅注册表中的合法配置项。
---@param WidgetType table|nil
---@return boolean
local function IsRegisteredWidgetType(WidgetType)
    if type(WidgetType) ~= "table" or not WidgetType.Name or not WidgetType.Path then
        return false
    end
    for _, RegisteredType in pairs(LobbyWidgetType) do
        if RegisteredType == WidgetType then
            return true
        end
    end
    return false
end

---把可变参数转换为 Widget 生命周期函数使用的数据参数。
---@return any
local function NormalizeData(...)
    if select("#", ...) == 0 then
        return {}
    end
    return ...
end

---@param WidgetType table
---@return UUserWidget|nil
function LobbyUtils.GetWidget(WidgetType)
    if not IsRegisteredWidgetType(WidgetType) then
        ugcprint("[LobbyUtils] unregistered widget type")
        return nil
    end
    if WidgetType.Instance then
        return WidgetType.Instance
    end
    if not UGCGameSystem.GameState then
        return nil
    end

    local WidgetClass = UGCObjectUtility.LoadClass(UGCGameSystem.GetUGCResourcesFullPath(WidgetType.Path))
    local PlayerController = UGCGameSystem.GetLocalPlayerController()
    if not WidgetClass or not PlayerController then
        ugcprint("[LobbyUtils] failed to create widget: " .. WidgetType.Name)
        return nil
    end

    local Widget = UserWidget.NewWidgetObjectBP(PlayerController, WidgetClass)
    if not Widget then
        return nil
    end
    Widget:AddToViewport()
    Widget:SetVisibility(ESlateVisibility.Collapsed)
    Widget.bIsOpened = false
    WidgetType.Instance = Widget
    return Widget
end

---@return boolean
function LobbyUtils.OpenWidget(WidgetType, ...)
    local Widget = LobbyUtils.GetWidget(WidgetType)
    if not Widget then
        return false
    end
    if Widget.bIsOpened then
        return true
    end

    Widget:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    Widget.bIsOpened = true
    if Widget.OnOpen then
        Widget:OnOpen(NormalizeData(...))
    end
    return true
end

---@return boolean
function LobbyUtils.CloseWidget(WidgetType)
    if not IsRegisteredWidgetType(WidgetType) or not WidgetType.Instance then
        return false
    end
    local Widget = WidgetType.Instance
    if not Widget.bIsOpened then
        return true
    end

    if Widget.OnClose then
        Widget:OnClose()
    end
    Widget.bIsOpened = false
    Widget:SetVisibility(ESlateVisibility.Collapsed)
    return true
end

---@return boolean
function LobbyUtils.UpdateWidget(WidgetType, ...)
    if not IsRegisteredWidgetType(WidgetType) or not WidgetType.Instance then
        return false
    end
    local Widget = WidgetType.Instance
    if not Widget.bIsOpened then
        return false
    end
    if Widget.OnUpdate then
        Widget:OnUpdate(NormalizeData(...))
    end
    return true
end

---@return boolean
function LobbyUtils.OpenAndUpdateWidget(WidgetType, ...)
    if not LobbyUtils.OpenWidget(WidgetType, ...) then
        return false
    end
    return LobbyUtils.UpdateWidget(WidgetType, ...)
end

---预留的其他界面显隐控制入口。
---@param bHidden boolean
function LobbyUtils.SetOtherWidgetHidden(bHidden)
end

---按字符长度截断文本，超长时追加省略号。
---@param InStr string|FText|nil
---@param Max number
---@return string|FText
function LobbyUtils.GetTrimmedString(InStr, Max)
    if InStr == nil then
        return ""
    end
    local OutStr = InStr
    local MaxLength = tonumber(Max) or 0
    if MaxLength > 0 and FuncUtil.GetStringLength(OutStr) > MaxLength then
        OutStr = FuncUtil.SubString(OutStr, 1, MaxLength) .. "..."
    end
    return OutStr
end

return LobbyUtils
