---@class FortifyComponent_C:ActorComponent
---@field FortifyPath FSoftClassPath
--Edit Below--
UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Fortify.FortifyManager");

local FortifyComponent = {}
local FortifyResultEvent = 'OnFortifyResult';

local function IsEquipment(DefineID)
    if DefineID == nil or DefineID.TypeSpecificID == nil then
        return false;
    end
    local itemType = UGCItemSystemV2.GetItemCustomizedTypeV2(DefineID.TypeSpecificID);
    return ItemCfg.CustomizeType[itemType] == true;
end

local function IsSameDefineId(Left, Right)
    return Left ~= nil and Right ~= nil
            and Left.InstanceID ~= nil and Left.InstanceID == Right.InstanceID;
end

function FortifyComponent:ReceiveBeginPlay()
    FortifyComponent.SuperClass.ReceiveBeginPlay(self);
    if not Lib.IsServer() then
        FortifyManager:RegisterComponentClass(self);
        self:InitUI();
        Lib.EventSystem.Listen(Event.OnItemCustomDataUpdateAfter, self.OnItemCustomDataUpdateAfter, self);
        Lib.EventSystem.Listen(FortifyResultEvent, self.OnFortifyResult, self);
    end
end

function FortifyComponent:InitUI()
    Common.LoadObjectWithSoftPathAsync(self.FortifyPath,
            function(MainUIClass)
                if self == nil or MainUIClass == nil then
                    return;
                end
                local MainUI = UserWidget.NewWidgetObjectBP(self:GetOwner(), MainUIClass);
                MainUI:AddToViewport(11000);
                MainUI:SetVisibility(ESlateVisibility.Collapsed);
            end
    );
end

function FortifyComponent:GetAvailableServerRPCs()
    return "FortifySubmit";
end

function FortifyComponent:OnItemCustomDataUpdateAfter(UID, ItemDefineId, OldData, NewData)
    if not IsSameDefineId(ItemDefineId, FortifyManager.DefineId) then
        return;
    end
    local oldLevel = OldData and OldData.strengthenLevel or 0;
    local newLevel = NewData and NewData.strengthenLevel or 0;
    if newLevel ~= oldLevel then
        FortifyManager.RefreshUI = true;
    end
end

---@param Success boolean
---@param ItemDefineId ItemDefineID
function FortifyComponent:OnFortifyResult(Success, ItemDefineId)
    if not IsSameDefineId(ItemDefineId, FortifyManager.DefineId) then
        return;
    end
    FortifyManager.RefreshUI = true;
    BroadcastManager:SendTip(Success == true and '强化成功' or '强化失败');
end

---@param PlayerKey number
---@param DefineID ItemDefineID
function FortifyComponent:FortifySubmit(PlayerKey, DefineID)
    local playerState = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey);
    if playerState == nil or playerState.ItemDataManager == nil then
        return;
    end
    local success = playerState.ItemDataManager:Strengthen(DefineID) == true;
    Lib.EventSystem.Broadcast_SinglePlayer(
            playerState,
            FortifyResultEvent,
            success,
            totable(DefineID)
    );
end
return FortifyComponent
