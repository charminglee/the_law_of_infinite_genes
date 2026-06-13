---@class FirearmPurchase_C:UUserWidget
---@field backgroundImage UImage
---@field borderImage UImage
---@field Button_0 UButton
---@field ExitButton UButton
---@field FirearnPurchaseDesc0 FirearnPurchaseDesc0_C
---@field FirearnPurchaseDesc0_215 FirearnPurchaseDesc0_C
---@field FirearnPurchaseDesc0_216 FirearnPurchaseDesc0_C
---@field FirearnPurchaseDesc0_217 FirearnPurchaseDesc0_C
---@field FirearnPurchaseDesc0_220 FirearnPurchaseDesc0_C
---@field Image_32 UImage
---@field Image_33 UImage
---@field Image_35 UImage
---@field Image_36 UImage
---@field Image_37 UImage
---@field Image_38 UImage
---@field Image_39 UImage
---@field Image_40 UImage
---@field Image_42 UImage
---@field LBPurchaseList ReuseList2_C
---@field LT_0 UImage
---@field LTabList ReuseList2_C
---@field OutSideExitButton UButton
---@field PurchaseItemImage UImage
---@field stripe0 UImage
---@field stripe1 UImage
---@field stripe2 UImage
---@field stripe3 UImage
---@field stripe4 UImage
---@field stripe5 UImage
---@field stripe6 UImage
---@field stripe7 UImage
---@field TH_0 UImage
---@field TH_1 UImage
---@field TH_2 UImage
---@field TH_3 UImage
---@field TH_4 UImage
---@field TH_5 UImage
--Edit Below--
local FirearmPurchase = { 
    bInitDoOnce = false, 
    LBPurchaseListSelectedIndex=nil, 
    LTabListSelectedIndex=nil,
    LTabListSource = nil,
}

function FirearmPurchase:Construct()
	self:LuaInit();
end

function FirearmPurchase:Tick(MyGeometry, InDeltaTime)
    if FightManager.LTabListSelectedIndex ~= self.LTabListSelectedIndex then
        self.LTabListSelectedIndex = FightManager.LTabListSelectedIndex;
        ugcprint('source length is:'..tostring(#self.LTabListSource))
        self.LTabList:Reload(5);
    end
end
function FirearmPurchase:LuaInit()
    if self.LTabListSource == nil then
        self.LTabListSource = UGCGameSystem.GetTableData("Data/Table/Customized/FightTabIcon");
        -- 'Asset/.../FightTabIcon.FightTabIcon'))
    end
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
    FightManager:RegisterMainUI(self);
    self:Listen();
    self.LBPurchaseList:Reload(10);
    self.LTabList:Reload(5);
    
end
function FirearmPurchase:Listen()
    self.ExitButton.OnClicked:Add(self.ExitButtonClicked, self);
    self.OutSideExitButton.OnClicked:Add(self.ExitButtonClicked, self);
    self.LBPurchaseList.OnUpdateItem:Add(self.LBPurchaseListUpdate, self);
    self.LTabList.OnUpdateItem:Add(self.LTabListUpdate, self);
end
function FirearmPurchase:ExitButtonClicked()
    FightManager:CloseMainUI();
end

function FirearmPurchase:LBPurchaseListUpdate(Item, Index)
    if self.LBPurchaseListSelectedIndex == Index then
    else
    end
end
function FirearmPurchase:LTabListUpdate(Item, Index)
    if Item.Index == nil then
        Item.Index = Index;
        Item:SetTabIcon(self.LTabListSource[Index].path);
    end

    if self.LTabListSelectedIndex == Index then
        Item:SetSelectedVisible(true);
    else
        Item:SetSelectedVisible(false);
    end
end
return FirearmPurchase