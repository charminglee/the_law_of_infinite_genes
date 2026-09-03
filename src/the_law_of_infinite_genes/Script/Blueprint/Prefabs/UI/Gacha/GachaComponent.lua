---@class GachaComponent_C:ActorComponent
---@field GachaMainPath FSoftClassPath
--Edit Below--
local GachaComponent = {}


UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.Gacha.GachaManager");


function GachaComponent:GetAvailableServerRPCs()
    return
    "RefreshCardShop",
    "PurchaseCard",
    "EquipCard",
    "UnequipCard",
    "SellCardFromStore",
    "SellCardFromEquipped",
    "LevelUpCardSlot",
    "ResetCardData"
end


function GachaComponent:ReceiveBeginPlay()
    GachaComponent.SuperClass.ReceiveBeginPlay(self);
    if Lib.IsServer() == false then
        self:InitUI();
        GachaManager:RegisterComponentClass(self);
        Lib.EventSystem.Listen(Event.OnRepCardData, self.OnRepCardData, self);
        Lib.EventSystem.Listen(Event.OnCardAutoUpgradeAfter, self.OnCardAutoUpgradeAfter, self);
        Lib.EventSystem.Listen(Event.OnCoinChangeAfter, self.OnCoinChangeAfter, self);
    end
end


function GachaComponent:ReceiveEndPlay()
    Lib.EventSystem.UnlistenByOwner(self);
end


function GachaComponent:OnRepCardData()
    GachaManager.RefreshUI = true;
    GachaManager.PreviewDAT = nil;
    if GachaManager.MainUI ~= nil then
        GachaManager.MainUI:RefreshCountPreviewText();
    end
end

function GachaComponent:OnCardAutoUpgradeAfter(UID)
    self:OnRepCardData();
end

function GachaComponent:OnCoinChangeAfter(UID, CoinId, OldValue, NewValue)
    if CoinId == ItemId.Coin_3 and GachaManager.MainUI ~= nil then
        GachaManager.MainUI:SetResourceCoin(NewValue);
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
    ugcprint('接收商店刷新请求');
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey);
    local manager = PlayerState.PlayerDataManager;
    manager:RefreshCardShop();
end

function GachaComponent:PurchaseCard(PlayerKey, fromSlot, toSlot)
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey);
    local manager = PlayerState.PlayerDataManager;
    manager:PurchaseCard(fromSlot, toSlot);
end

function GachaComponent:EquipCard(PlayerKey, fromSlot, toSlot)
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey);
    local manager = PlayerState.PlayerDataManager;
    manager:EquipCard(fromSlot, toSlot);
end

function GachaComponent:UnequipCard(PlayerKey, fromSlot, toSlot)
    local PlayerState = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey);
    local manager = PlayerState.PlayerDataManager;
    manager:UnequipCard(fromSlot, toSlot);
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
