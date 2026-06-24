---@class GachaComponent_C:BaseManager_C
---@field GachaMainPath FSoftClassPath
--Edit Below--

UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Gacha.GachaManager");
local GachaComponent = {}


function GachaComponent:GetAvailableServerRPCs()
    return  
    "RefreshCardShop",
    "EquipCard",
    "UnequipCard",
    "PurchaseCard",
    "SellCardFromStore",
    "SellCardFromEquipped",
    "ResetCardData"
end

function GachaComponent:ReceiveBeginPlay()
    GachaComponent.SuperClass.ReceiveBeginPlay(self);
    if self:GetOwner():HasAuthority() == false then
        self:InitUI();
        GachaManager:RegisterComponentClass(self);
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

function GachaComponent:ResetCardData(PlayerKey)
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey);
    local manager = PlayerState.PlayerDataManager;
    manager:ResetCardData();
end

function GachaComponent:RefreshCardShop(PlayerKey)
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey);
    local manager = PlayerState.PlayerDataManager;
    manager:RefreshCardShop();
    UnrealNetwork.CallUnrealRPC(UGCGameSystem.GetPlayerControllerByPlayerKey(PlayerKey), self, "RefreshShopUI")
end

function GachaComponent:EquipCard(PlayerKey)
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey);
    local manager = PlayerState.PlayerDataManager;
    manager:EquipCard();
end

function GachaComponent:UnequipCard(PlayerKey)
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey);
    local manager = PlayerState.PlayerDataManager;
    manager:UnequipCard();
end

function GachaComponent:PurchaseCard(PlayerKey)
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey);
    local manager = PlayerState.PlayerDataManager;
    manager:PurchaseCard();
end

function GachaComponent:SellCardFromStore(PlayerKey)
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey);
    local manager = PlayerState.PlayerDataManager;
    manager:SellCardFromStore();
end

function GachaComponent:SellCardFromEquipped(PlayerKey)
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey);
    local manager = PlayerState.PlayerDataManager;
    manager:SellCardFromEquipped();
end

function GachaComponent:RefreshShopUI()
    ugcprint('刷新商店')
    GachaManager.RefreshShopUI = true;
end

return GachaComponent