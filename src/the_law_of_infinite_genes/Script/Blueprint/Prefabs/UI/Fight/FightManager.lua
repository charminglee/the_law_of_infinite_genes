FightManager = FightManager or {
    MainUI = nil,
    ComponentClass = nil,
    TabSelectIndex = 0,
    PurchaseSelectIndex = nil,
    TabIconMap = {
        Ammo = '/Game/Arts/UI/TableIcons/ItemIcon/Ammo/Icon_Ammo_50BMG_UG.Icon_Ammo_50BMG_UG',
        Rifle = '/Game/Arts/UI/TableIcons/ItemIcon/Weapon/Icon_WEP_M416.Icon_WEP_M416',
        LMG = '/Game/Arts/UI/TableIcons/ItemIcon/Weapon/Icon_WEP_M249.Icon_WEP_M249',
        SMG = '/Game/Arts/UI/TableIcons/ItemIcon/Weapon/Icon_WEP_UMP45.Icon_WEP_UMP45',
        Snipe = '/Game/Arts/UI/TableIcons/ItemIcon/Weapon/Icon_WEP_AWM.Icon_WEP_AWM',
        Shotgun = '/Game/Arts/UI/TableIcons/ItemIcon/Weapon/Icon_WEP_S686.Icon_WEP_S686',
        Pistol = '/Game/Arts/UI/TableIcons/ItemIcon/Weapon/Icon_WEP_P1911.Icon_WEP_P1911',
    },
}

function FightManager:RegisterComponentClass(CompClass)
    if CompClass ~= nil then
        self.ComponentClass = CompClass;
    end
end

function FightManager:RegisterMainUI(MainUI)
    if MainUI ~= nil then
        self.MainUI = MainUI;
    end
end

function FightManager:UnregisterMainUI(MainUI)
    if MainUI == nil or self.MainUI == MainUI then
        self.MainUI = nil;
    end
end

function FightManager:GetTabData(Index)
    local firearmType = ItemCfg.FirearmType[(Index or 0) + 1];
    if firearmType == nil then
        return nil;
    end
    return {
        Type = firearmType.Type,
        Text = firearmType.Text,
        path = self.TabIconMap[firearmType.Type],
    };
end

function FightManager:GetPurchaseList(Index)
    local tab = self:GetTabData(Index == nil and self.TabSelectIndex or Index);
    if tab == nil then
        return {};
    end

    local result = {};
    for _, itemId in ipairs(ItemCfg.TabItemsMap[tab.Type]) do
        if tab.Type == 'Ammo' or LocalPlayerState.PlayerDataManager:IsGunUnlock(itemId) then
            result[#result + 1] = {
                ItemId = itemId,
                Price = ItemCfg.GunPrice[itemId],
            };
        end
    end
    return result;
end

function FightManager:GetSelectedPurchaseData()
    if self.PurchaseSelectIndex == nil then
        return nil;
    end
    return self:GetPurchaseList()[self.PurchaseSelectIndex + 1];
end

function FightManager:OpenMainUI()
    if self.MainUI == nil then
        return;
    end
    self.TabSelectIndex = 0;
    self.PurchaseSelectIndex = nil;
    self.MainUI:Open();
end

function FightManager:CloseMainUI()
    if self.MainUI ~= nil then
        self.MainUI:Exit();
    end
end

function FightManager:GetMainUI()
    return self.MainUI;
end

function FightManager:SelectTab(Index)
    Index = tonumber(Index);
    if Index == nil or ItemCfg.FirearmType[Index + 1] == nil then
        return;
    end
    if self.TabSelectIndex == Index then
        return;
    end
    self.TabSelectIndex = Index;
    self.PurchaseSelectIndex = nil;
    if self.MainUI ~= nil then
        self.MainUI:RefreshAll();
    end
end

function FightManager:SelectPurchase(Index)
    Index = tonumber(Index);
    local purchaseList = self:GetPurchaseList();
    if Index == nil or purchaseList[Index + 1] == nil then
        return;
    end
    self.PurchaseSelectIndex = Index;
    if self.MainUI ~= nil then
        self.MainUI:RefreshPurchaseSelection();
    end
end

---@param ItemData table @字段包括 ItemId、Price
function FightManager:OnPurchaseRequested(ItemData)
    UnrealNetwork.CallUnrealRPC(
            LocalPlayerController,
            self.ComponentClass,
            'BuyGunSubmit',
            LocalPlayerController.PlayerKey,
            ItemData.ItemId
    );
end

return FightManager
