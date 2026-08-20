---@class BP_BackpackUIComponentV2_Custom_C:BP_BackpackUIComponentV2_C
--Edit Below--
local BP_BackpackUIComponentV2_Custom = {} 

---开始运行时执行
function BP_BackpackUIComponentV2_Custom:ReceiveBeginPlay()
    BP_BackpackUIComponentV2_Custom.SuperClass.ReceiveBeginPlay(self)
end

---结束运行时执行
function BP_BackpackUIComponentV2_Custom:ReceiveEndPlay()
    BP_BackpackUIComponentV2_Custom.SuperClass.ReceiveEndPlay(self)
end

---点击上锁格子后回调(ClickLockBackpackItem重写后不执行)
---@param Panel UUserWidget @弹窗面板，取自ClickLockBackpackItem返回值，可能为nil
-- function BP_BackpackUIComponentV2_Custom:OnClickLockBackpackItem(Panel)
-- end

---是否显示丢弃区域
---生效范围：客户端
---@return boolean @是否显示丢弃区域
-- function BP_BackpackUIComponentV2_Custom:IsDiscardAreaVisible()
-- end

---获取RPC列表 (注意不要使用GetAvailableServerRPCs)
---@return table @RPC函数名列表
-- function BP_BackpackUIComponentV2_Custom:GetUGCAvailableServerRPCs()
--     return {}
-- end

---默认排序函数, 组件上配置
---生效范围: 客户端
---@param Data1 table @物品数据1 {DefineID:物品DefineID, Idx:格子索引}
---@param Data2 table @物品数据2 {DefineID:物品DefineID, Idx:格子索引}
---@return boolean @true:物品1在前, false:物品2在前
-- function BP_BackpackUIComponentV2_Custom.CompareQuality(Data1,Data2)
-- end

---获取背包拖拽控件类
---生效范围：客户端
---@return FSoftClassPath|nil @拖拽控件类，未配置则返回nil
-- function BP_BackpackUIComponentV2_Custom:GetBackpackDragDropWidget()
-- end

---背包UI打开后执行
---@param Panel UUserWidget @背包主界面控件
-- function BP_BackpackUIComponentV2_Custom:OnOpenBattleMainPanel(Panel)
-- end

---背包UI关闭后执行
---@param Panel UUserWidget @背包主界面控件
-- function BP_BackpackUIComponentV2_Custom:OnCloseBattleMainPanel(Panel)
-- end

---打开大厅背包界面(已废弃)
---生效范围：客户端
---@param Mode number @1:背包+装备栏 2:背包+仓库 3:背包+装备栏+仓库
-- function BP_BackpackUIComponentV2_Custom:OpenLobbyBackpackMainUI(Mode)
-- end

---关闭大厅背包界面(已废弃)
---生效范围：客户端
-- function BP_BackpackUIComponentV2_Custom:CloseLobbyPanel()
-- end

---当打开删除弹窗时调用
---@param Panel UUserWidget @面板控件
-- function BP_BackpackUIComponentV2_Custom:OnOpenDeletePanel(Panel)
-- end

---当打开存入取出代币时调用
---@param Panel UUserWidget @面板控件
-- function BP_BackpackUIComponentV2_Custom:OnOpenSaveOrWithDrawPanel(Panel)
-- end

---当打开丢弃物品弹窗时调用
---@param Panel UUserWidget @面板控件
-- function BP_BackpackUIComponentV2_Custom:OnOpenDropItemPanel(Panel)
-- end

--- 点击强化界面按钮
function BP_BackpackUIComponentV2_Custom:EquipmentFortify(DefineID, DataType)
    --FortifyManager:OpenMainUI(DefineID);
    GunsManager:OpenMainUI();
end

function BP_BackpackUIComponentV2_Custom:EquipmentPure(DefineID, DataType)
    PureManager:OpenMainUI(DefineID);
end

--- 点击洗练界面按钮
function BP_BackpackUIComponentV2_Custom:KenlReinf(DefineID, DataType)
    ReinfManager:OpenMainUI(DefineID);
end

function BP_BackpackUIComponentV2_Custom:KenlAppraisal(DefineID, DataType)
    ugcprint_concat(DefineID)
    AppraisalManager:OpenMainUI(DefineID);
end

function BP_BackpackUIComponentV2_Custom:KenlFusion(DefineID, DataType)
    ReinfManager:OpenMainUI(DefineID);
end

--- 材料合成
function BP_BackpackUIComponentV2_Custom:OpenCompose(DefineID, DataType)
    ugcprint('点击洗练')
end

--- 装备按钮显示逻辑
function BP_BackpackUIComponentV2_Custom:CheckFortify(DefineID, DataType)
    --ugcprint('类型:'..UGCItemSystemV2.GetItemCustomizedTypeV2(DefineID.TypeSpecificID));
    if ItemCfg.CustomizeType[UGCItemSystemV2.GetItemCustomizedTypeV2(DefineID.TypeSpecificID)] then
        return true;
    else
        return false;
    end
end

function BP_BackpackUIComponentV2_Custom:CheckPure(DefineID, DataType)
    if ItemCfg.CustomizeType[UGCItemSystemV2.GetItemCustomizedTypeV2(DefineID.TypeSpecificID)] then
        return true;
    else
        return false;
    end
end

--- 核心按钮显示逻辑
function BP_BackpackUIComponentV2_Custom:CheckReinf(DefineID, DataType)
    if UGCItemSystemV2.GetItemCustomizedTypeV2(DefineID.TypeSpecificID) == ItemCfg.ItemType.Kenl then
        if not LocalPlayerState.ItemDataManager:GetCustomData(DefineID).isIdentified then
            return false;
        end
        return true;
    else
        return false;
    end
end

function BP_BackpackUIComponentV2_Custom:CheckAppraisal(DefineID, DataType)
    if UGCItemSystemV2.GetItemCustomizedTypeV2(DefineID.TypeSpecificID) == ItemCfg.ItemType.Kenl then
        if LocalPlayerState.ItemDataManager:GetCustomData(DefineID).isIdentified then
            return false;
        end
        return true;
    else
        return false;
    end
end

function BP_BackpackUIComponentV2_Custom:CheckFusion(DefineID, DataType)
    if UGCItemSystemV2.GetItemCustomizedTypeV2(DefineID.TypeSpecificID) == ItemCfg.ItemType.Kenl then
        if not LocalPlayerState.ItemDataManager:GetCustomData(DefineID).isIdentified then
            return false;
        end
        return true;
    else
        return false;
    end
end



function BP_BackpackUIComponentV2_Custom:CheckCompose(DefineID, DataType)
    if UGCItemSystemV2.GetItemCustomizedTypeV2(DefineID.TypeSpecificID) == ItemCfg.ItemType.Material then
        return true;
    else
        return false;
    end
end

return BP_BackpackUIComponentV2_Custom