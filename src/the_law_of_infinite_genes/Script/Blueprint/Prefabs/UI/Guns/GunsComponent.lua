---@class GunsComponent_C:ActorComponent
---@field GunsMainPath FSoftClassPath
--Edit Below--
UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Guns.GunsManager");

local GunsComponent = {}

function GunsComponent:ReceiveBeginPlay()
    GunsComponent.SuperClass.ReceiveBeginPlay(self);
    if not Lib.IsServer() then
        GunsManager:RegisterComponentClass(self);
        self:InitUI();
        Lib.EventSystem.Listen(Event.OnItemCustomDataUpdateAfter, self.OnItemCustomDataUpdateAfter, self);
    end
end

function GunsComponent:InitUI()
    Common.LoadObjectWithSoftPathAsync(self.GunsMainPath,
            function(MainUIClass)
                if self == nil or MainUIClass == nil then
                    return;
                end
                local MainUI = UserWidget.NewWidgetObjectBP(self:GetOwner(), MainUIClass);
                MainUI:AddToViewport(11000);
                MainUI:SetVisibility(ESlateVisibility.Collapsed);
            end
    );
end

function GunsComponent:GetAvailableServerRPCs()
    return "GunsActivateSubmit";
end

function GunsComponent:OnItemCustomDataUpdateAfter(UID, ItemDefineId, OldData, NewData)

end

---@param PlayerKey number
---@param DefineID ItemDefineID
function GunsComponent:GunsActivateSubmit(PlayerKey, DefineID)
    ugcprint('接收消息')
end
return GunsComponent
