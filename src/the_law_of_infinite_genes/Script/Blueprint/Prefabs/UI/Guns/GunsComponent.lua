---@class GunsComponent_C:ActorComponent
---@field GunsMainPath FSoftClassPath
--Edit Below--
UGCGameSystem.UGCRequire('Script.Blueprint.Prefabs.UI.Guns.GunsManager');

local GunsComponent = {}

function GunsComponent:ReceiveBeginPlay()
    GunsComponent.SuperClass.ReceiveBeginPlay(self);
    if not Lib.IsServer() then
        GunsManager:RegisterComponentClass(self);
        self:InitUI();
        Lib.EventSystem.Listen(Event.OnGunUnlockAfter, self.OnGunUnlockAfter, self);
    end
end

function GunsComponent:ReceiveEndPlay()
    Lib.EventSystem.UnlistenByOwner(self);
    GunsComponent.SuperClass.ReceiveEndPlay(self);
end

function GunsComponent:InitUI()
    Common.LoadObjectWithSoftPathAsync(self.GunsMainPath,
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

function GunsComponent:GetAvailableServerRPCs()
    return 'GunsActivateSubmit';
end

function GunsComponent:OnGunUnlockAfter(UID, ItemId)
    GunsManager:OnGunUnlockAfter(ItemId);
end

---@param PlayerKey integer
---@param ItemId integer
function GunsComponent:GunsActivateSubmit(PlayerKey, ItemId)
    local playerState = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey);
    playerState.PlayerDataManager:UnlockGun(ItemId);
end

return GunsComponent
