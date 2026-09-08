local GM = {}

-- 全局玩家列表UI实例（已打开时忽略重复点击）
local global_player_list_instance = nil

-- 队伍玩家列表UI实例（已打开时忽略重复点击）
local teammate_list_instance = nil

-- 邮箱UI实例（防重复打开）
local _gm_mail_ui = nil

function GM:Register(DebugUI)
    local UGCGMUI = require("client.ingame.ugc.ugc_gmui")

    local CurFuncList = {}
    CurFuncList["调试"] = {
        ["SubTab1"] = {
            {UGCGMUI.ItemTypeEnum.Button, {{"客户端服务端都调用"},{"Tips"}}, "CS_Func"},
            {UGCGMUI.ItemTypeEnum.TextInput, {{"添加物品","id count"},{"Tips"}}, "C_AddItem"},
            {UGCGMUI.ItemTypeEnum.Slider, {{"Slider", {0,100,40}},{"Tips"}}, "CS_SliderbarFunc"},
            {UGCGMUI.ItemTypeEnum.SwitchButton, {{"开关",function () return "close" end},{"Tips"}}, "CS_Switch"},
            {UGCGMUI.ItemTypeEnum.Button, {{"测试邮件系统"},{"在DS端运行邮件系统全量单元测试"}}, "S_TestMailSystem"},
            {UGCGMUI.ItemTypeEnum.Button, {{"打开邮箱UI"},{"在客户端打开邮箱界面"}}, "C_OpenMailUI"},
            {UGCGMUI.ItemTypeEnum.Button, {{"打开组队大厅UI"},{"在客户端打开组队大厅界面"}}, "C_OpenPartyUI"},
            {UGCGMUI.ItemTypeEnum.Button, {{"打开全局玩家列表示例"},{"在客户端打开全局玩家列表示例UI（含属性上报示例）"}}, "C_OpenGlobalPlayerList"},
            {UGCGMUI.ItemTypeEnum.Button, {{"模拟上报玩家数据"},{"服务端：给所有玩家上报测试排序/展示值"}}, "S_MockUpdatePlayerListData"},
            {UGCGMUI.ItemTypeEnum.Button, {{"打开玩家列表示例UI"},{"在客户端打开队伍玩家列表示例（含属性覆写示例）"}}, "C_OpenTeammateList"},
        },
    }
    return CurFuncList
end

function GM:CS_Func(param, PC)
    local isServer = UGCGameSystem.IsServer()
    if isServer then
        print_dev("[GM] CS_Func 服务端执行: " .. tostring(param))
    else
        print_dev("[GM] CS_Func 客户端执行: " .. tostring(param))
    end
end

function GM:C_AddItem(param, PC)
    print_dev("[GM] C_AddItem: " .. tostring(param))
end

function GM:CS_SliderbarFunc(param, PC)
    print_dev("[GM] CS_SliderbarFunc: " .. tostring(param))
end

function GM:CS_Switch(param, PC)
    print_dev("[GM] CS_Switch: " .. tostring(param))
end

--- 客户端打开邮箱UI
function GM:C_OpenMailUI(param)
    local is_server = UGCGameSystem.IsServer()
    if is_server then
        print_dev("[GM] 打开邮箱UI只能在客户端执行")
        return
    end

    -- 获取 UGCMailboxComponent（挂在 PlayerController 上）
    local PC = UGCGameSystem.GetLocalPlayerController()
    if not PC then
        print_dev("[GM] 无法获取 PlayerController")
        return
    end

    local compPath = UGCGameSystem.GetUGCResourcesFullPath("ExtendResource/GlobalPlayerList/OfficialPackage/" .. "Asset/Mail/CMPT/UGCMailboxComponent.UGCMailboxComponent_C")
    local compClass = compPath and UE.LoadClass(compPath) or nil
    local component = compClass and PC:GetComponentByClass(compClass) or nil
    if not component then
        -- 尝试通过 _ClientInstance 获取（组件自己维护的全局引用）
        component = UGCMailboxComponent and UGCMailboxComponent._ClientInstance
    end
    if not component then
        print_dev("[GM] 无法获取 UGCMailboxComponent，请确认组件已挂载")
        return
    end
    component:OpenMailUI()
end


--- 客户端打开组队大厅UI
function GM:C_OpenPartyUI(param)
    local is_server = UGCGameSystem.IsServer()
    if is_server then
        print_dev("[GM] 打开组队大厅UI只能在客户端执行")
        return
    end

    -- 获取 UGCPartyComponent（挂在 PlayerController 上）
    local PC = UGCGameSystem.GetLocalPlayerController()
    if not PC then
        print_dev("[GM] 无法获取 PlayerController")
        return
    end

    local compPath = UGCGameSystem.GetUGCResourcesFullPath("ExtendResource/GlobalPlayerList/OfficialPackage/" .. "Asset/PartyTemplate/Cmpt/UGCPartyComponent.UGCPartyComponent_C")
    local compClass = compPath and UE.LoadClass(compPath) or nil
    local component = compClass and PC:GetComponentByClass(compClass) or nil
    if not component then
        print_dev("[GM] 无法获取 UGCPartyComponent，请确认组件已挂载")
        return
    end
    component:Open()
end

--- 客户端打开全局玩家列表示例UI（单例，已存在则显示）
function GM:C_OpenGlobalPlayerList(param)
    local is_server = UGCGameSystem.IsServer()
    if is_server then
        print_dev("[GM] 打开全局玩家列表示例UI只能在客户端执行")
        return
    end

    -- 如果实例已存在，检查是否只是隐藏了，如果是则重新显示
    if global_player_list_instance and UE.IsValid(global_player_list_instance) then
        local vis = global_player_list_instance:GetVisibility()
        if vis == ESlateVisibility.Collapsed or vis == ESlateVisibility.Hidden then
            print_dev("[GM] 全局玩家列表示例UI已存在，重新显示")
            global_player_list_instance:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            return
        else
            print_dev("[GM] 全局玩家列表示例UI已存在，忽略重复点击")
            return
        end
    end

    local FullPath = UGCGameSystem.GetUGCResourcesFullPath("ExtendResource/GlobalPlayerList/OfficialPackage/" .. 'Asset/SocialChat/Arts_UI/UIBP/WBP_SocialChat_GlobalPlayerList.WBP_SocialChat_GlobalPlayerList_C')
    local UIClass = UE.LoadClass(FullPath)
    if not UIClass then
        print_dev("[GM] 错误：无法加载全局玩家列表示例UI蓝图 " .. tostring(FullPath))
        return
    end

    local UI = UGCWidgetManagerSystem.CreateWidget(UIClass)
    if not UI then
        print_dev("[GM] 错误：创建全局玩家列表示例UI失败")
        return
    end

    global_player_list_instance = UI
    UGCWidgetManagerSystem.AddToSlot(UI, "UI.UISlot.MainUISlot_High")
    print_dev("[GM] 全局玩家列表示例UI已打开")
end

--- 服务端：给当前所有玩家上报真实属性数据（信号值和技能急速）
function GM:S_MockUpdatePlayerListData(param, PC)
    if not UGCGameSystem.IsServer() then
        print_dev("[GM] 上报玩家数据只能在服务端执行")
        return
    end

    local actor = UGCGamePartSystem and UGCGamePartSystem.PlayerListManager and UGCGamePartSystem.PlayerListManager.GetGlobalActor and UGCGamePartSystem.PlayerListManager.GetGlobalActor()
    if not actor then
        print_dev("[GM] PlayerListManager GlobalActor 为 nil，请确认 GamePart 已添加且已启用")
        return
    end

    local allPS = UGCGameSystem.GetAllPlayerState()
    if not allPS then
        print_dev("[GM] GetAllPlayerState 返回 nil")
        return
    end

    local count = 0
    for _, ps in pairs(allPS) do
        if ps and UE.IsValid(ps) then
            local uid = UGCGameSystem.GetUIDByPlayerKey(ps.PlayerKey)
            local playerPC = UGCGameSystem.GetPlayerControllerByPlayerKey(ps.PlayerKey)
            if uid and uid > 0 and playerPC then
                local pawn = UGCGameSystem.GetPlayerPawnByPlayerKey(ps.PlayerKey)
                if pawn and UE.IsValid(pawn) then
                    -- 使用真实属性：信号值作为排序属性，技能急速作为展示属性
                    local sortVal = UGCAttributeSystem.GetGameAttributeValue(pawn, 'SignalHP') or 0
                    local displayVal = UGCAttributeSystem.GetGameAttributeValue(pawn, 'SkillCDRecoverRate') or 0
                    
                    actor:UpdatePlayerSortValue(playerPC, uid, sortVal)
                    actor:UpdatePlayerDisplayValue(playerPC, uid, displayVal)
                    print_dev("[GM] 上报 PlayerKey=" .. tostring(ps.PlayerKey) .. " UID=" .. tostring(uid) .. " sort=" .. sortVal .. " display=" .. displayVal)
                    count = count + 1
                else
                    print_dev("[GM] PlayerKey=" .. tostring(ps.PlayerKey) .. " 的 Pawn 无效，跳过")
                end
            end
        end
    end
    print_dev("[GM] 共上报 " .. count .. " 名玩家数据")
end

--- 客户端打开玩家列表示例UI（单例，已存在则忽略）
function GM:C_OpenTeammateList(param)
    local is_server = UGCGameSystem.IsServer()
    if is_server then
        print_dev("[GM] 打开玩家列表示例UI只能在客户端执行")
        return
    end

    if teammate_list_instance and UE.IsValid(teammate_list_instance) then
        print_dev("[GM] 玩家列表示例UI已存在，忽略重复点击")
        return
    end

    local FullPath = UGCGameSystem.GetUGCResourcesFullPath("ExtendResource/GlobalPlayerList/OfficialPackage/" .. "Asset/SocialChat/Arts_UI/UIBP/WBP_TeammateExample.WBP_TeammateExample_C")
    local UIClass = UE.LoadClass(FullPath)
    if not UIClass then
        print_dev("[GM] 错误：无法加载玩家列表示例UI蓝图 " .. tostring(FullPath))
        return
    end

    local UI = UGCWidgetManagerSystem.CreateWidget(UIClass)
    if not UI then
        print_dev("[GM] 错误：创建队伍玩家列表UI失败")
        return
    end

    teammate_list_instance = UI
    UGCWidgetManagerSystem.AddToSlot(UI, "UI.UISlot.MainUISlot_High")
    print_dev("[GM] 队伍玩家列表UI已打开")
end

--- 服务端：邮件系统全量单元测试
function GM:S_TestMailSystem(param, PC)
    print_dev("[GM] S_TestMailSystem 服务端执行: " .. tostring(param))
end

return GM
