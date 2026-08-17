---@class KenlComposeComponent_C:ActorComponent
---@field KenlComposePath FSoftClassPath
--Edit Below--
UGCGameSystem.UGCRequire('Script.Blueprint.Prefabs.UI.KenlCompose.KenlComposeManager');

local KenlComposeComponent = {}

function KenlComposeComponent:ReceiveBeginPlay()
    KenlComposeComponent.SuperClass.ReceiveBeginPlay(self);
    if not Lib.IsServer() then
        KenlComposeManager:RegisterComponentClass(self);
        self:InitUI();
        Lib.EventSystem.Listen(Event.OnItemCustomDataUpdateAfter, self.OnItemCustomDataUpdateAfter, self);
    end
end

function KenlComposeComponent:InitUI()
    Common.LoadObjectWithSoftPathAsync(self.KenlComposePath,
            function(MainUIClass)
                if self == nil or MainUIClass == nil then
                    return;
                end
                local mainUI = UserWidget.NewWidgetObjectBP(self:GetOwner(), MainUIClass);
                mainUI:AddToViewport(11000);
                mainUI:SetVisibility(ESlateVisibility.Collapsed);
            end
    );
end

function KenlComposeComponent:GetAvailableServerRPCs()
    return 'FusionSubmit';
end

function KenlComposeComponent:OnItemCustomDataUpdateAfter(UID, ItemDefineId, OldData, NewData)
    KenlComposeManager:OnFusionResult(ItemDefineId, OldData, NewData);
end

function KenlComposeComponent:FusionSubmit(PlayerKey, PrimaryDefineId, MaterialDefineId)
    local playerState = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey);
    if playerState == nil or playerState.ItemDataManager == nil then
        return;
    end

    if PrimaryDefineId == nil or MaterialDefineId == nil
            or PrimaryDefineId.InstanceID == MaterialDefineId.InstanceID then
        return;
    end

    local manager = playerState.ItemDataManager;
    local primaryData = manager:GetCustomData(PrimaryDefineId);
    local materialData = manager:GetCustomData(MaterialDefineId);
    if primaryData == nil or materialData == nil
            or not primaryData.isIdentified or not materialData.isIdentified then
        return;
    end

    manager:Fusion(PrimaryDefineId, MaterialDefineId);
end

return KenlComposeComponent
