---@class RaidInstance_C:ActorComponent
---@field RaidInstancePath FSoftClassPath
--Edit Below--

UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.RaidInstance.RaidInstanceManager");
local RaidInstanceComponent = {}


function RaidInstanceComponent:ReceiveBeginPlay()
    RaidInstanceComponent.SuperClass.ReceiveBeginPlay(self);
    if self:GetOwner():HasAuthority() == false then
        self:InitUI();
        RaidInstanceManager:RegisterComponentClass(self);
    end
end


function RaidInstanceComponent:InitUI()
    Common.LoadObjectWithSoftPathAsync(self.RaidInstancePath, 
        function (UIClass)
            if self == nil or UIClass == nil then
                return;
            end

            local MainUI = UserWidget.NewWidgetObjectBP(self:GetOwner(), UIClass);
            MainUI:AddToViewport(10000);
            MainUI:SetVisibility(ESlateVisibility.Collapsed);
        end
    );
end

return RaidInstanceComponent
