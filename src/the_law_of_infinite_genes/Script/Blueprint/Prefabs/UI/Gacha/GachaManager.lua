
GachaManager = GachaManager or
{
    MainUI = nil;
    PrevPressedItem= nil;
    CurrentPressedItem = nil;
    ClickFlag = 0;
    ClickIndex = 0;
    GachaBuffer = {
        SlotTable = {
            [0] = nil,[1] = nil,[3] = nil,[4] = nil,[5] = nil,[6] = nil,[7] = nil,[8] = nil,[9] = nil,[10] = nil,[11] = nil,[12] = nil,
        },
        cacheTable = {
            [0] = nil,[1] = nil,[2] = nil,[3] = nil,[4] = nil,[5] = nil,[6] = nil,[7] = nil,[8] = nil,[9] = nil,[10] = nil,[11] = nil,[12] = nil,[13] = nil,[14] = nil,[15] = nil,[16] = nil,[17] = nil,[18] = nil,[19] = nil,[20] = nil,
        },
        shopTable = {
            [0] = {GachaItemId = 0},[1] = {GachaItemId = 0},[2] = {GachaItemId = 0},[3] = {GachaItemId = 0},[4] = {GachaItemId = 0},[5] = {GachaItemId = 0},
        },
    }
}

function GachaManager:RegisterComponentClass(CompClass)
    if CompClass ~= nil then
        self.ComponentClass = CompClass;
    end
end

function GachaManager:RegisterMainUI(MainUI)
    if self.MainUI == nil then
        self.MainUI = MainUI;
        ugcprint('卡牌界面加载完毕.'..tostring(self.MainUI));
    end
end

function GachaManager:UnregisterMainUI()
    self.MainUI = nil;
end

function GachaManager:OpenMainUI()
    if self.MainUI == nil then
        return;
    end
    self.MainUI:SetVisibility(ESlateVisibility.Visible);
    self.CurrentPressedItem = nil;
    self.PrevPressedItem = nil;
end

function GachaManager:CloseMainUI()
    if self.MainUI == nil then
        return;
    end
    self.MainUI:SetVisibility(ESlateVisibility.Collapsed);
    self.PrevPressedItem = nil;
    self.CurrentPressedItem = nil;
end

function GachaManager:SetCurrentClickedParam(Item)
    if self.CurrentPressedItem == Item then
        return nil;
    end
    self.PrevPressedItem = self.CurrentPressedItem;
    self.CurrentPressedItem = Item;
end

function GachaManager:InitBuffer()
    self.GachaBuffer = {
        SlotTable = {
            [0] = nil,[1] = nil,[3] = nil,[4] = nil,[5] = nil,[6] = nil,[7] = nil,[8] = nil,[9] = nil,[10] = nil,[11] = nil,[12] = nil,
        },
        cacheTable = {
            [0] = nil,[1] = nil,[2] = nil,[3] = nil,[4] = nil,[5] = nil,[6] = nil,[7] = nil,[8] = nil,[9] = nil,[10] = nil,[11] = nil,[12] = nil,[13] = nil,[14] = nil,[15] = nil,[16] = nil,[17] = nil,[18] = nil,[19] = nil,[20] = nil,
        },
        shopTable = {
            [0] = {GachaItemId = 0},[1] = {GachaItemId = 0},[2] = {GachaItemId = 0},[3] = {GachaItemId = 0},[4] = {GachaItemId = 0},[5] = {GachaItemId = 0},
        },
    }
end