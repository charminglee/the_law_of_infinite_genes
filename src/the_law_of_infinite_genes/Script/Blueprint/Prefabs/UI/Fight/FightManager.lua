FightManager = FightManager or {
    MainUI = nil,
    ComponentClass = nil,
    TabSelectIndex = 0,
    PurchaseSelectIndex = nil,
    LTabIconList = {
        {name = '子弹', path = '/Game/Arts/UI/TableIcons/ItemIcon/Ammo/Icon_Ammo_50BMG_UG.Icon_Ammo_50BMG_UG', Key = 'Ammo'},
        {name = '步枪', path = '/Game/Arts/UI/TableIcons/ItemIcon/Weapon/Icon_WEP_M416.Icon_WEP_M416', Key = 'Rifle'},
        {name = '轻机枪', path = '/Game/Arts/UI/TableIcons/ItemIcon/Weapon/Icon_WEP_M249.Icon_WEP_M249', Key = 'LMG'},
        {name = '冲锋枪', path = '/Game/Arts/UI/TableIcons/ItemIcon/Weapon/Icon_WEP_UMP45.Icon_WEP_UMP45', Key = 'SMG'},
        {name = '狙击枪', path = '/Game/Arts/UI/TableIcons/ItemIcon/Weapon/Icon_WEP_AWM.Icon_WEP_AWM', Key = 'Snipe'},
        {name = '霰弹枪', path = '/Game/Arts/UI/TableIcons/ItemIcon/Weapon/Icon_WEP_S686.Icon_WEP_S686', Key = 'Shotgun'},
        {name = '手枪', path = '/Game/Arts/UI/TableIcons/ItemIcon/Weapon/Icon_WEP_P1911.Icon_WEP_P1911', Key = 'Pistol'},
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
    return self.LTabIconList[(Index or 0) + 1];
end

function FightManager:GetPurchaseList(Index)
    local tab = self:GetTabData(Index == nil and self.TabSelectIndex or Index);
    if tab == nil or ItemCfg.FirearmPurchase == nil then
        return {};
    end
    return ItemCfg.FirearmPurchase[tab.Key] or {};
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
    if Index == nil or self.LTabIconList[Index + 1] == nil then
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

---购买按钮预留接口。
---后续购买逻辑实现于此处；当前只提供已校验的商品数据。
---@param ItemData table @字段包括 ItemId、cost
---@param CategoryKey string
---@param Index number @从 0 开始
function FightManager:OnPurchaseRequested(ItemData, CategoryKey, Index)
end

return FightManager
