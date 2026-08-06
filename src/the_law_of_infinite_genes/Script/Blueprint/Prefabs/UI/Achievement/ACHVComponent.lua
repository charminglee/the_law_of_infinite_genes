---@class ACHVComponent_C:ActorComponent
---@field MainUIClassPath FSoftClassPath
--Edit Below--
local ACHVComponent = {}

-- 监听事件名
local _Event = {
    ServerRPC = {
        UnlockTitle = 'ServerRPC_UnlockTitle',
        EquippedTitle = 'ServerRPC_EquippedTitle',
        UnequippedTitle = 'ServerRPC_UnequippedTitle',
    },
    MulticastRPC = {
        EquippedTitle = 'MulticastRPC_EquippedTitle',
    }
}

UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Achievement.ACHVManager");

function ACHVComponent:ReceiveBeginPlay()
    ACHVComponent.SuperClass.ReceiveBeginPlay(self);
    ACHVManager:RegisterComponentClass(self);
    self._Event = _Event;
    if Lib.IsServer() == false then
        self:InitHomeUI();
    end
end

-- 注册界面
function ACHVComponent:InitHomeUI()
        local MainUI = UE.LoadClass(UGCMapInfoLib.GetRootLongPackagePath() .. "Asset/Blueprint/Prefabs/UI/Achievement/ACHVMain.ACHVMain_C");
        local MainUI_BP = UserWidget.NewWidgetObjectBP(self:GetOwner(), MainUI);
        MainUI_BP:AddToViewport(10000);
        MainUI_BP:SetVisibility(ESlateVisibility.Collapsed);
end

-- 注册服务端事件
function ACHVComponent:GetAvailableServerRPCs()
    local list = {}
    for _, name in pairs(_Event.ServerRPC) do
        table.insert(list, name)
    end
    return table.unpack(list);
end

--【服务端】申请解锁称号
function ACHVComponent:ServerRPC_UnlockTitle(uid, id)
    UGCGameSystem.GetPlayerStateByUID(uid).PlayerDataManager:UnlockTitle(id);
end

--【服务端】申请佩戴称号
function ACHVComponent:ServerRPC_EquippedTitle(uid, id)
    UGCGameSystem.GetPlayerStateByUID(uid).PlayerDataManager:EquipTitle(id);
    UnrealNetwork.CallUnrealRPC_Multicast(GameState,_Event.MulticastRPC.EquippedTitle, uid, id);
    ACHVManager.TitleTopUIByPlayerUID[uid] = UGCWidgetManagerSystem.AddObjectPositionUI(
        UGCGameSystem.GetPlayerPawnByUID(uid), 
        UGCGameSystem.GetUGCResourcesFullPath(ACHVManager.Config.TitleClassPath),
        { X = 0, Y = 0, Z = 100 }, 
        true, 
        true, 
        false, 
        true
    );
end

--【服务端】申请卸下称号
function ACHVComponent:ServerRPC_UnequippedTitle(uid)
    UGCGameSystem.GetPlayerStateByUID(uid).PlayerDataManager:EquipTitle(nil);
    UGCWidgetManagerSystem.RemoveObjectPositionUI(
        UGCGameSystem.GetPlayerPawnByUID(uid), 
        ACHVManager.TitleTopUIByPlayerUID[uid]
    );
    ACHVManager.TitleTopUIByPlayerUID[uid] = nil;
end

return ACHVComponent