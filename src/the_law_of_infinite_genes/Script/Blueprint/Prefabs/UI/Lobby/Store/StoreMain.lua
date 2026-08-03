---@class StoreMain_C:UUserWidget
---@field BackpackList ReuseList2_C
---@field Button_0 UButton
---@field EquipSlotList ReuseList2_C
---@field PorpertyList ReuseList2_C
---@field StoreBackpackTabList ReuseList2_C
---@field StoreRefinedPanel StoreRefinedPanel_C
---@field StoreStrengthenPanel StoreStrengthenPanel_C
---@field StoreTabList ReuseList2_C
---@field WidgetSwitcher_0 UWidgetSwitcher
--Edit Below--
if UGCGameSystem ~= nil and UGCGameSystem.UGCRequire ~= nil then
end

local StoreMain = { 
    bInitDoOnce = false,
    TabSelectIndex = 0,
    BackpackSelectIndex = -1,
    TabLabelList = {'物品','强化', '洗练'},
    StoreBackpackTabLabel = {'装备', '消耗品', '材料', '其他'},
    StoreBackpackTabSelectIndex = 0,
    StoreChoseItemIndex = 0,
    } 

function StoreMain:GetBackpackUseList()
    if UGCItemManager ~= nil and UGCItemManager.UseList ~= nil and UGCItemManager.UseList.Backpack ~= nil then
        return UGCItemManager.UseList.Backpack;
    end
    return "BackpackList";
end

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
        self:SyncBackpackSelectIndex();
        self:ReloadBackpackList();
    end
    if self.StoreBackpackTabSelectIndex ~= StoreManager.StoreBackpackTabSelectIndex then
        self.StoreBackpackTabSelectIndex = StoreManager.StoreBackpackTabSelectIndex;
        self.StoreBackpackTabList:Reload(4);
        StoreManager.BackpackSelectIndex = -1;
        self.BackpackSelectIndex = -1;
        self:ClearBackpackSelectIndex();
        self:ReloadBackpackList();
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
    self:ReloadBackpackList();
    self.EquipSlotList:Reload(5);
    self.StoreBackpackTabList:Reload(#ItemCfg.ItemType);
end

function StoreMain:GetBackpackReloadCount()
    if StoreManager ~= nil and StoreManager.MaxStoreBackpackSize ~= nil then
        return StoreManager.MaxStoreBackpackSize;
    end
    return 100;
end

function StoreMain:GetBackpackTabIndex()
    if StoreManager == nil or StoreManager.StoreBackpackTabSelectIndex == nil then
        return 1;
    end
    return StoreManager.StoreBackpackTabSelectIndex + 1;
end

function StoreMain:GetBackpackDataList()
    if StoreManager == nil or StoreManager.BackpackList == nil then
        return {};
    end

    return StoreManager.BackpackList[self:GetBackpackTabIndex()] or {};
end

function StoreMain:GetBackpackItemData(Index)
    local DataList = self:GetBackpackDataList();
    if DataList == nil or Index == nil then
        return nil;
    end

    return DataList[Index + 1] or DataList[Index];
end

function StoreMain:SyncBackpackListData()
    if UGCItemManager == nil then
        return;
    end

    local UseList = self:GetBackpackUseList();
    UGCItemManager:RegisterList(UseList, self, self.BackpackList, self:GetBackpackReloadCount());
    UGCItemManager:SetListData(UseList, self:GetBackpackDataList());
end

function StoreMain:SyncBackpackSelectIndex()
    if UGCItemManager == nil then
        return;
    end

    local UseList = self:GetBackpackUseList();
    if StoreManager.BackpackSelectIndex == nil or StoreManager.BackpackSelectIndex < 0 then
        UGCItemManager:ClearSelectedIndex(UseList);
    else
        UGCItemManager:SetSelectedIndex(UseList, StoreManager.BackpackSelectIndex);
    end
end

function StoreMain:ClearBackpackSelectIndex()
    if UGCItemManager ~= nil then
        UGCItemManager:ClearSelectedIndex(self:GetBackpackUseList());
    end
end

function StoreMain:ReloadBackpackList()
    self:SyncBackpackListData();
    self:SyncBackpackSelectIndex();
    if self.BackpackList ~= nil then
        self.BackpackList:Reload(self:GetBackpackReloadCount());
    end
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
    local UseList = self:GetBackpackUseList();
    local ItemData = self:GetBackpackItemData(Index);

    self:SyncBackpackListData();

    if UGCItemManager ~= nil then
        UGCItemManager:BindItem(Item, self, UseList, Index, ItemData);
        return;
    end

    if Item.SetListContext ~= nil then
        Item:SetListContext(self, UseList, Index);
    else
        Item.OwnerWidget = self;
        Item.UseListFlag = UseList;
        Item.Index = Index;
        Item.index = Index;
    end
    if ItemData ~= nil and Item.SetItemData ~= nil then
        Item:SetItemData(ItemData);
    elseif Item.SetNoneItem ~= nil then
        Item:SetNoneItem();
    end
    if Item.SetSelectedVisible ~= nil then
        Item:SetSelectedVisible(StoreManager.BackpackSelectIndex == Index);
    end
end

function StoreMain:OnUGCItemClicked(UseListFlag, Index, ItemData, ItemWidget)
    if UseListFlag == self:GetBackpackUseList() then
        if ItemData == nil then
            StoreManager.BackpackSelectIndex = -1;
            self.BackpackSelectIndex = -1;
            self:ClearBackpackSelectIndex();
            return;
        end

        local bSameItem = StoreManager.BackpackSelectIndex == Index;
        StoreManager.BackpackSelectIndex = Index;
        self.BackpackSelectIndex = Index;

        if UGCItemManager ~= nil then
            UGCItemManager:SetSelectedIndex(UseListFlag, Index);
        end

        if bSameItem and StoreManager.OpenStoreItemInfoDialog ~= nil then
            StoreManager:OpenStoreItemInfoDialog();
        end
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
