---@class FirearmMain_C:UAEUserWidget
---@field ExitButton UButton
---@field FirearmList ReuseList2_C
---@field ItemDesc UTextBlock
---@field ItemName UTextBlock
---@field NeedCost UTextBlock
---@field Nils UCanvasPanel
---@field PurchaseButton UButton
---@field ResourceCoinIcon UImage
---@field Selected UCanvasPanel
---@field TabList ReuseList2_C
local FirearmMain = { 
    bInitDoOnce = false,
    TabSelectIndex = nil,
    PurchaseSelectIndex = nil,
} 


function FirearmMain:Construct()
    self:LuaInit();
end

function FirearmMain:Tick(MyGemetry,FGeometry)
    if self.TabSelectIndex ~= FightManager.TabSelectIndex then
        self.TabSelectIndex = FightManager.TabSelectIndex;
        self.TabList:Reload(#FightManager.LTabIconList);
        self.FirearmList:Reload(20);
    end
    if self.PurchaseSelectIndex == nil then
        self.Nils:SetVisibility(ESlateVisibility.Visible);
        self.Selected:SetVisibility(ESlateVisibility.Collapsed);
    else
        self.Nils:SetVisibility(ESlateVisibility.Collapsed);
        self.Selected:SetVisibility(ESlateVisibility.Visible);
    end
    if self.PurchaseSelectIndex ~= FightManager.PurchaseSelectIndex then
        self.PurchaseSelectIndex = FightManager.PurchaseSelectIndex;
        self.FirearmList:Reload(20);
        
    end
end


function FirearmMain:LuaInit()
    if self.bInitDoOnce then
        return nil;
    end
    self.bInitDoOnce = true;
    self:Listen();
    FightManager:RegisterMainUI(self);
    self.TabList:Reload(#FightManager.LTabIconList);
    self.FirearmList:Reload(20);
end

function FirearmMain:Listen()
    self.ExitButton.OnClicked:Add(self.Exit, self);
    self.PurchaseButton.OnClicked:Add(self.PurchaseButtonClick, self);
    self.TabList.OnUpdateItem:Add(self.TabListUpdate, self);
    self.FirearmList.OnUpdateItem:Add(self.FirearmListUpdate, self);
    
end

function FirearmMain:Exit()
    FightManager:CloseMainUI();
end

function FirearmMain:PurchaseButtonClick()
end

function FirearmMain:TabListUpdate(Item, Index)
    Item.Index = Index;
    Item:SetIcon()
    if self.TabSelectIndex == Index then
        Item:SetSelected(ESlateVisibility.Visible);
    else
        Item:SetSelected(ESlateVisibility.Collapsed);
    end

end

function FirearmMain:FirearmListUpdate(Item, Index)
    Item.Index = Index; 
    if self.PurchaseSelectIndex == Index then
        Item:SetSelected(ESlateVisibility.Visible);
    else        
        Item:SetSelected(ESlateVisibility.Collapsed);
    end
end


return FirearmMain