---@class AppraisalComponent_C:ActorComponent
---@field AppraisalPath FSoftClassPath
--Edit Below--
UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Appraisal.AppraisalManager");
local AppraisalComponent = {}
function AppraisalComponent:ReceiveBeginPlay()
    AppraisalComponent.SuperClass.ReceiveBeginPlay(self);
    if Lib.IsServer() == false then
        AppraisalManager:RegisterComponentClass(self);
        self:InitUI();
        Lib.EventSystem.Listen(Event.OnItemCustomDataUpdateAfter, self.OnItemCustomDataUpdateAfter, self);
    end

end
function AppraisalComponent:InitUI()
    Common.LoadObjectWithSoftPathAsync(self.AppraisalPath,
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

function AppraisalComponent:GetAvailableServerRPCs()
    return
    "AppraisalSubmit"
end

function AppraisalComponent:OnItemCustomDataUpdateAfter(uid, itemDefineId, oldData, newData)
    AppraisalManager.RefreshUI = true;
end

function AppraisalComponent:AppraisalSubmit(PlayerKey, DefineId)
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey);
    local manager = PlayerState.ItemDataManager;
    manager:Identify(DefineId);
end

return AppraisalComponent