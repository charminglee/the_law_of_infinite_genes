---@class AppraisalComponent_C:ActorComponent
---@field AppraisalPath FSoftClassPath
--Edit Below--
UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Appraisal.AppraisalManager");
local AppraisalComponent = {}
function AppraisalComponent:ReceiveBeginPlay()
    AppraisalComponent.SuperClass.ReceiveBeginPlay(self);
    if Lib.IsServer() == false then
        self:InitUI();
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
return AppraisalComponent