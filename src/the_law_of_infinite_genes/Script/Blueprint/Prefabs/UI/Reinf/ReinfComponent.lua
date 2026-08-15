---@class ReinfComponent_C:ActorComponent
---@field ReinfPath FSoftClassPath
--Edit Below--
UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Reinf.ReinfManager");
local ReinfComponent = {}
function ReinfComponent:ReceiveBeginPlay()
    ReinfComponent.SuperClass.ReceiveBeginPlay(self);
    if Lib.IsServer() == false then
        ReinfManager:RegisterComponentClass(self);
        self:InitUI();
        Lib.EventSystem.Listen(Event.OnItemCustomDataUpdateAfter, self.OnItemCustomDataUpdateAfter, self);
    end
end
function ReinfComponent:InitUI()
    Common.LoadObjectWithSoftPathAsync(self.ReinfPath,
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


function ReinfComponent:GetAvailableServerRPCs()
    return
    "ReinfSubmit"
end

function ReinfComponent:OnItemCustomDataUpdateAfter(uid, itemDefineId, oldData, newData)
    if  oldData.isIdentified == true then
        ReinfManager.RefreshUI = true;
    end
end

function ReinfComponent:ReinfSubmit(PlayerKey, DefineId, ...)
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey);
    local manager = PlayerState.ItemDataManager;
    manager:Refine(DefineId, ...);
end

return ReinfComponent