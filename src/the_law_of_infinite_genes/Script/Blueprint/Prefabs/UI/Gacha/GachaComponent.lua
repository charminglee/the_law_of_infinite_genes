---@class GachaComponent_C:ActorComponent
---@field GachaMainPath FSoftClassPath
--Edit Below--
local GachaComponent = {}


UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Gacha.GachaManager");


function GachaComponent:GetAvailableServerRPCs()
    return
    "RefreshCardShop",
    "APurchaseCard",
    "EquipCard",
    "UnequipCard",
    "SellCardFromStore",
    "SellCardFromEquipped",
    "LevelUpCardSlot",
    "ResetCardData"
end


function GachaComponent:ReceiveBeginPlay()
    GachaComponent.SuperClass.ReceiveBeginPlay(self);
    if self:GetOwner():HasAuthority() == false then
        self:InitUI();
        GachaManager:RegisterComponentClass(self);
        Lib.EventSystem.Listen(Event.OnRepCardData, self.OnRepCardData, self);
    end
end


function GachaComponent:ReceiveEndPlay()
    Lib.EventSystem.UnlistenByOwner(self);
end


function GachaComponent:OnRepCardData()
    GachaManager.RefreshUI = true;
    GachaManager.PreviewDAT = nil;
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

function GachaComponent:ResetCardData(PlayerKey)
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey);
    local manager = PlayerState.PlayerDataManager;
    manager:ResetCardData();
end

function GachaComponent:RefreshCardShop(PlayerKey)
    ugcprint('接收商店刷新请求');
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey);
    local manager = PlayerState.PlayerDataManager;
    manager:RefreshCardShop();
end

function GachaComponent:APurchaseCard(PlayerKey, fromSlot)
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey);
    local manager = PlayerState.PlayerDataManager;
    manager:PurchaseCard(fromSlot);
end

function GachaComponent:EquipCard(PlayerKey, fromSlot)
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey);
    local manager = PlayerState.PlayerDataManager;
    manager:EquipCard(fromSlot);
end

function GachaComponent:UnequipCard(PlayerKey, fromSlot)
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey);
    local manager = PlayerState.PlayerDataManager;
    manager:UnequipCard(fromSlot);
end

function GachaComponent:SellCardFromStore(PlayerKey, slot)
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey);
    local manager = PlayerState.PlayerDataManager;
    manager:SellCardFromStore(slot);
end

function GachaComponent:SellCardFromEquipped(PlayerKey, slot)
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey);
    local manager = PlayerState.PlayerDataManager;
    manager:SellCardFromEquipped(slot);
end

function GachaComponent:LevelUpCardSlot(PlayerKey)
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey);
    local manager = PlayerState.PlayerDataManager;
    manager:LevelUpCardSlot();
end

return GachaComponent
