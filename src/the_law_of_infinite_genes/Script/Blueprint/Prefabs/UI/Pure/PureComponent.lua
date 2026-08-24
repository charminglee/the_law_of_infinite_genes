---@class PureComponent_C:ActorComponent
---@field PurePath FSoftClassPath
--Edit Below--
UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Pure.PureManager");
local PureComponent = {}
function PureComponent:ReceiveBeginPlay()
    PureComponent.SuperClass.ReceiveBeginPlay(self);
    if Lib.IsServer() == false then
        PureManager:RegisterComponentClass(self);
        self:InitUI();
        Lib.EventSystem.Listen(Event.OnItemCustomDataUpdateAfter, self.OnItemCustomDataUpdateAfter, self);
    end
end
function PureComponent:InitUI()
    Common.LoadObjectWithSoftPathAsync(self.PurePath,
            function (MainUIClass)
                if self == nil or MainUIClass == nil then
                    return;
                end
                local MainUI = UserWidget.NewWidgetObjectBP(self:GetOwner(), MainUIClass);
                MainUI:AddToViewport(11000);
                MainUI:SetVisibility(ESlateVisibility.Collapsed);
            end
    );
end

function PureComponent:GetAvailableServerRPCs()
    return 'ReforgeSubmit';
end

function PureComponent:OnItemCustomDataUpdateAfter(UID, ItemDefineId, OldData, NewData)
    PureManager:OnItemCustomDataUpdateAfter(ItemDefineId);
end

---@param PlayerKey number
---@param DefineID ItemDefineID
---@param UseAdvanced boolean
function PureComponent:ReforgeSubmit(PlayerKey, DefineID, UseAdvanced)
    local playerState = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey);
    if playerState == nil or playerState.ItemDataManager == nil or DefineID == nil then
        return;
    end
    playerState.ItemDataManager:Reforge(DefineID, UseAdvanced == true);
end
return PureComponent
