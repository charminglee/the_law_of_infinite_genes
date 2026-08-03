---@class FortifyComponent_C:ActorComponent
---@field FortifyPath FSoftClassPath
--Edit Below--
UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Fortify.FortifyManager");
local FortifyComponent = {}
function FortifyComponent:ReceiveBeginPlay()
    FortifyComponent.SuperClass.ReceiveBeginPlay(self);
    if self:GetOwner():HasAuthority() == false then
        self:InitUI();
    end
end
function FortifyComponent:InitUI()
    Common.LoadObjectWithSoftPathAsync(self.FortifyPath,
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
return FortifyComponent