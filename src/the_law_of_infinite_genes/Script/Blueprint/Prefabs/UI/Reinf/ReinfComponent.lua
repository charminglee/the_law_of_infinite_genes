---@class ReinfComponent_C:ActorComponent
---@field ReinfPath FSoftClassPath
--Edit Below--
UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Reinf.ReinfManager");
local ReinfComponent = {}
function ReinfComponent:ReceiveBeginPlay()
    ReinfComponent.SuperClass.ReceiveBeginPlay(self);
    if Lib.IsServer() == false then
        self:InitUI();
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
return ReinfComponent