---@class ACHVComponent_C:ActorComponent
---@field MainUIClassPath FSoftClassPath
--Edit Below--
local ACHVComponent = {}
UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Achievement.ACHVManager");

function ACHVComponent:ReceiveBeginPlay()
    ACHVComponent.SuperClass.ReceiveBeginPlay(self);
    ACHVManager:Construct();
    if self:GetOwner():HasAuthority() == false then
        self:InitHomeUI(self.MainUIClassPath);
    end

end


function ACHVComponent:InitHomeUI(MainUIClass)
        local MainUI = UE.LoadClass( UGCMapInfoLib.GetRootLongPackagePath().. "Asset/Blueprint/Prefabs/UI/Achievement/ACHVMain.ACHVMain_C");
        local MainUI_BP = UserWidget.NewWidgetObjectBP(self:GetOwner(), MainUI);
        MainUI_BP:AddToViewport(10000);
        MainUI_BP:SetVisibility(ESlateVisibility.Collapsed);
end
return ACHVComponent