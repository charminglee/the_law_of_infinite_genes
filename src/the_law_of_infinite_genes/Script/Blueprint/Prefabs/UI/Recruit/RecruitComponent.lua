---@class RecruitComponent_C:ActorComponent
---@field RecruitPath FSoftClassPath
--Edit Below--

UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Recruit.RecruitManager");
local RecruitComponent = {}


function RecruitComponent:ReceiveBeginPlay()
    RecruitComponent.SuperClass.ReceiveBeginPlay(self);
    if self:GetOwner():HasAuthority() == false then
        self:InitUI();
        RecruitManager:RegisterComponentClass(self);
    end
end


function RecruitComponent:InitUI()
    Common.LoadObjectWithSoftPathAsync(self.RecruitPath,
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

return RecruitComponent
