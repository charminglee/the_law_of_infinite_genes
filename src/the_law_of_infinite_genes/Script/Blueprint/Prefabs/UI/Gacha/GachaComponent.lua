---@class GachaComponent_C:ActorComponent
---@field GachaMainPath FSoftClassPath
--Edit Below--
local GachaComponent = {}
UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Gacha.GachaManager");

function GachaComponent:ReceiveBeginPlay()
    GachaComponent.SuperClass.ReceiveBeginPlay(self);
    if self:GetOwner():HasAuthority() == false then
        self:InitUI();
    end

end


function GachaComponent:InitUI()
    Common.LoadObjectWithSoftPathAsync(self.GachaMainPath, 
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
return GachaComponent