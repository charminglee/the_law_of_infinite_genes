---@class ComposeComponent_C:ActorComponent
---@field ComposeMainPath FSoftClassPath
--Edit Below--
local ComposeComponent = {}
UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Compose.ComposeManager");

function ComposeComponent:ReceiveBeginPlay()
    ComposeComponent.SuperClass.ReceiveBeginPlay(self);
    if self:GetOwner():HasAuthority() == false then
        self:InitUI();
    end

end


function ComposeComponent:InitUI()
    Common.LoadObjectWithSoftPathAsync(self.ComposeMainPath,
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
return ComposeComponent