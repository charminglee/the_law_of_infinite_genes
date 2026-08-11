---@class KenlComposeComponent_C:ActorComponent
---@field KenlComposePath FSoftClassPath
--Edit Below--
UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.KenlCompose.KenlComposeManager");
local KenlComposeComponent = {}
function KenlComposeComponent:ReceiveBeginPlay()
    KenlComposeComponent.SuperClass.ReceiveBeginPlay(self);
    if Lib.IsServer() == false then
        self:InitUI();
    end
end
function KenlComposeComponent:InitUI()
    Common.LoadObjectWithSoftPathAsync(self.KenlComposePath,
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
return KenlComposeComponent