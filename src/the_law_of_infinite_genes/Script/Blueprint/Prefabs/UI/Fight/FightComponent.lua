---@class FightComponent_C:ActorComponent
---@field FirearmMainPath FSoftClassPath
--Edit Below--
UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Fight.FightManager");

local FightComponent = {}

function FightComponent:ReceiveBeginPlay()
    FightComponent.SuperClass.ReceiveBeginPlay(self);
    if not Lib.IsServer() then
        FightManager:RegisterComponentClass(self);
        self:InitUI();
    end
end

function FightComponent:InitUI()
    Common.LoadObjectWithSoftPathAsync(self.FirearmMainPath,
            function(UIClass)
                if self == nil or UIClass == nil then
                    return;
                end
                local mainUI = UserWidget.NewWidgetObjectBP(self:GetOwner(), UIClass);
                mainUI:AddToViewport(10050);
                mainUI:SetVisibility(ESlateVisibility.Collapsed);
            end
    );
end

return FightComponent
