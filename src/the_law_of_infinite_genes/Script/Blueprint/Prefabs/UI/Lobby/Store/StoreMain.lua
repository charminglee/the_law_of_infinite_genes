---@class StoreMain_C:UUserWidget
---@field BackpackList ReuseList2_C
---@field bg_01 UImage
---@field bg_02 UImage
---@field EquipSlotList ReuseList2_C
---@field Image_1 UImage
---@field Image_2 UImage
---@field Image_3 UImage
---@field Image_4 UImage
---@field Image_5 UImage
---@field PorpertyList ReuseList2_C
---@field StoreBackpackTabList ReuseList2_C
---@field StoreRefinedPanel StoreRefinedPanel_C
---@field StoreResultantPanel StoreResultantPanel_C
---@field StoreStrengthenPanel StoreStrengthenPanel_C
---@field StoreTabList ReuseList2_C
---@field StoreToolBar StoreToolBar_C
---@field WidgetSwitcher_0 UWidgetSwitcher
--Edit Below--
local StoreMain = { 
    bInitDoOnce = false,
    TabSelectIndex = 0,
    BackpackSelectIndex = -1,
    TabLabelList = {'物品','强化', '洗练', '合成'},
    StoreBackpackTabLabel = {'装备', '消耗品', '材料', '其他'},
    StoreBackpackTabSelectIndex = 0,
    StoreChoseItemIndex = 0,
    } 

function StoreMain:Construct()
    self:LuaInit();
    
end

function StoreMain:Tick(MyGeometry, InDeltaTime)
    if self.TabSelectIndex ~= StoreManager.TabSelectIndex then
        self.TabSelectIndex = StoreManager.TabSelectIndex;
        self.StoreTabList:Reload(#self.TabLabelList);
        StoreManager.StoreChoseItemIndex = 0;
        self.WidgetSwitcher_0:SetActiveWidgetIndex(self.TabSelectIndex);
    end
    if self.BackpackSelectIndex ~= StoreManager.BackpackSelectIndex then
        self.BackpackSelectIndex = StoreManager.BackpackSelectIndex;
        self.BackpackList:Reload(100);
    end
    if self.StoreBackpackTabSelectIndex ~= StoreManager.StoreBackpackTabSelectIndex then
        self.StoreBackpackTabSelectIndex = StoreManager.StoreBackpackTabSelectIndex;
        self.StoreBackpackTabList:Reload(4);
    end
end

function StoreMain:LuaInit()
    ugcprint('store main 加载');
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
    StoreManager:RegisterMainUI(self);
    self:Listen();
    self:InitUI();
end

function StoreMain:Listen()
    self.StoreTabList.OnUpdateItem:Add(self.StoreTabListUpdate, self);
    self.BackpackList.OnUpdateItem:Add(self.BackpackListUpdate, self);
    self.PorpertyList.OnUpdateItem:Add(self.PorpertyListUpdate, self);
    self.EquipSlotList.OnUpdateItem:Add(self.EquipSlotListUpdate, self);
    self.StoreBackpackTabList.OnUpdateItem:Add(self.StoreBackpackTabListUpdate, self);
end


function StoreMain:InitUI()
    self.StoreTabList:Reload(#self.TabLabelList);
    self.BackpackList:Reload(100);
    self.EquipSlotList:Reload(5);
    self.StoreBackpackTabList:Reload(#self.StoreBackpackTabLabel);
end

function StoreMain:StoreTabListUpdate(Item, Index)
    if Item.Index == nil then
        Item.Index = Index;
    end
    if self.TabSelectIndex == Index then
        Item:SetSelectedVisible(ESlateVisibility.Visible);
    else
        Item:SetSelectedVisible(ESlateVisibility.Collapsed);
    
    end
    Item:SetText(self.TabLabelList[Index+1])
end

function StoreMain:BackpackListUpdate(Item, Index)
    Item.Index = Index
    if self.BackpackSelectIndex == Index then
        Item:SetSelectedVisible(ESlateVisibility.Visible);
    else
        Item:SetSelectedVisible(ESlateVisibility.Collapsed);
    
    end
end

function StoreMain:PorpertyListUpdate(Item, Index)
    
end

function StoreMain:EquipSlotListUpdate(Item, Index)

end

function StoreMain:StoreBackpackTabListUpdate(Item, Index)
    Item.Index = Index;
    Item:SetText(self.StoreBackpackTabLabel[Index + 1]);
    if self.StoreBackpackTabSelectIndex == Index then
        Item:SetSelectedVisible(ESlateVisibility.Visible);
    else
        Item:SetSelectedVisible(ESlateVisibility.Collapsed);
    end
end

return StoreMain