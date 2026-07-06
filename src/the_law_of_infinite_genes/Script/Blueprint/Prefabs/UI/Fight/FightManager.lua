
FightManager = FightManager or
{
    MainUI = nil;
    LBPurchaseListSelectedIndex = nil;
    LTabListSelectedIndex = 0;
    LTabIconList = {
        {name='子弹', path='/Game/Arts/UI/TableIcons/ItemIcon/Ammo/Icon_Ammo_50BMG_UG.Icon_Ammo_50BMG_UG'},
        {name='步枪', path='/Game/Arts/UI/TableIcons/ItemIcon/Weapon/Icon_WEP_M416.Icon_WEP_M416'},
        {name='轻机枪', path='/Game/Arts/UI/TableIcons/ItemIcon/Weapon/Icon_WEP_M249.Icon_WEP_M249'},
        {name='冲锋枪', path='/Game/Arts/UI/TableIcons/ItemIcon/Weapon/Icon_WEP_UMP45.Icon_WEP_UMP45'},
        {name='狙击枪', path='/Game/Arts/UI/TableIcons/ItemIcon/Weapon/Icon_WEP_AWM.Icon_WEP_AWM'},
        {name='手枪', path='/Game/Arts/UI/TableIcons/ItemIcon/Weapon/Icon_WEP_P1911.Icon_WEP_P1911'}
    },
    TabSelectIndex = nil,
    PurchaseSelectIndex = nil,
}

function FightManager:RegisterComponentClass(CompClass)

    if CompClass ~= nil then
        self.ComponentClass = CompClass;
    end
end

function FightManager:RegisterMainUI(MainUI)
    
    if self.MainUI == nil then
        self.MainUI = MainUI;
    end
end

function FightManager:UnregisterMainUI()
    self.MainUI = nil;
end

function FightManager:OpenMainUI()
    if self.MainUI == nil then
        return;
    end
    self.TabSelectIndex = 0;
    self.PurchaseSelectIndex = nil;
    self.MainUI:SetVisibility(ESlateVisibility.Visible);
end

function FightManager:CloseMainUI()
    if self.MainUI == nil then
        return;
    end
    self.MainUI:SetVisibility(ESlateVisibility.Collapsed);
end

function FightManager:GetMainUI()
    return self.MainUI;
end
