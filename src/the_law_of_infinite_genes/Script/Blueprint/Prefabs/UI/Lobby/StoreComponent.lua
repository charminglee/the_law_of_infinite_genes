---@class StoreComponent_C:ActorComponent
---@field MainUIClassPath FSoftClassPath
--Edit Below--
local StoreComponent = {}


UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Lobby.StoreManager");


function StoreComponent:ReceiveBeginPlay()
    StoreComponent.SuperClass.ReceiveBeginPlay(self);
    if self:GetOwner():HasAuthority() == false then
        self:InitStoreUI();
    end
end


function StoreComponent:InitStoreUI(MainUIClass)
    Common.LoadObjectWithSoftPathAsync(self.MainUIClassPath, 
        function (MainUIClass)
            if self == nil or MainUIClass == nil then
                return;
            end

            local MainUI = UserWidget.NewWidgetObjectBP(self:GetOwner(), MainUIClass);
            MainUI:AddToViewport(10050);
            MainUI:SetVisibility(ESlateVisibility.Collapsed);
        end
    );
end
return StoreComponent