---@class GeneComponent_C:ActorComponent
---@field MainUIClassPath FSoftClassPath
--Edit Below--
local GeneComponent = {}

UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.GeneTree.GeneManager");

function GeneComponent:ReceiveBeginPlay()
    GeneComponent.SuperClass.ReceiveBeginPlay(self);
    if self:GetOwner():HasAuthority() == false then
        self:InitHomeUI();
    end
end

-- 注册界面
function GeneComponent:InitHomeUI()
        local MainUI = UE.LoadClass(UGCMapInfoLib.GetRootLongPackagePath() .. "Asset/Blueprint/Prefabs/UI/GeneTree/GeneMain.GeneMain_C");
        local MainUI_BP = UserWidget.NewWidgetObjectBP(self:GetOwner(), MainUI);
        MainUI_BP:AddToViewport(10000);
        MainUI_BP:SetVisibility(ESlateVisibility.Collapsed);
end

return GeneComponent