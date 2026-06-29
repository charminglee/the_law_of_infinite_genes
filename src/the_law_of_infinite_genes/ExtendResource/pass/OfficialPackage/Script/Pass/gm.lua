local ProjGM = {}
local FreezeExpSwitch = false

function ProjGM:Register(DebugUI)
    local UGCGMUI = require("client.ingame.ugc.ugc_gmui")

    local CurFuncList = {}
    CurFuncList["调试"] = {
        ["VirtualItem"] = {
            {UGCGMUI.ItemTypeEnum.TextInput, {{"添加虚拟物品"}, {"格式 [虚拟物品ID 虚拟物品数量]"}}, "S_AddVirtualItem"},
            {UGCGMUI.ItemTypeEnum.TextInput, {{"获取虚拟物品数量"}, {"格式 [虚拟物品ID]"}}, "C_GetVirtualItemNum"}
        },

        ["Pass"] = {
            {UGCGMUI.ItemTypeEnum.Button, {{"打开主界面"}, {"打开主界面"}}, "C_OpenPassMainUI"},
        },
    }

    return CurFuncList
end

function ProjGM:C_OpenPassMainUI() 
    PassManager:OpenMainUI()
end

function ProjGM:S_AddVirtualItem(Param, PC)
    local Table = {}
    local Sep = string.format("([^ ]+)")
    for Str in string.gmatch(Param, Sep) do
        table.insert(Table, tonumber(Str))
    end

    UGCGamePartSystem.VirtualItemManager.GetGlobalActor():AddVirtualItem(PC, Table[1], Table[2])
end

function ProjGM:C_GetVirtualItemNum(Param, PC)
    local ItemID = tonumber(Param)

    local Num = UGCGamePartSystem.VirtualItemManager.GetGlobalActor():GetItemNum(ItemID)
    UGCWidgetManagerSystem.ShowTipsUI(string.format("%d %d", ItemID, Num))
end

return ProjGM