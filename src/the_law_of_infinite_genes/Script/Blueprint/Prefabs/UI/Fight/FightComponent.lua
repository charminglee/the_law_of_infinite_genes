---@class FightComponent_C:ActorComponent
---@field FirearmPurchasePath FSoftClassPath
--Edit Below--
local FightComponent = {}
UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Fight.FightManager");

function FightComponent:ReceiveBeginPlay()
    FightComponent.SuperClass.ReceiveBeginPlay(self);
    if self:GetOwner():HasAuthority() == false then
        self:InitUI();
    end

end


function FightComponent:InitUI()
    Common.LoadObjectWithSoftPathAsync(self.FirearmPurchasePath, 
        function (UIClass)
            if self == nil or UIClass == nil then
                return;
            end

            local MainUI = UserWidget.NewWidgetObjectBP(self:GetOwner(), UIClass);
            MainUI:AddToViewport(10050);
            MainUI:SetVisibility(ESlateVisibility.Collapsed);
        end
    );
    
end
return FightComponent