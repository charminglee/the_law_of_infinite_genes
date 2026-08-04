---@class PureComponent_C:ActorComponent
---@field PurePath FSoftClassPath
--Edit Below--
UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Pure.PureManager");
local PureComponent = {}
function PureComponent:ReceiveBeginPlay()
    PureComponent.SuperClass.ReceiveBeginPlay(self);
    if self:GetOwner():HasAuthority() == false then
        self:InitUI();
    end
end
function PureComponent:InitUI()
    Common.LoadObjectWithSoftPathAsync(self.PurePath,
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
return PureComponent