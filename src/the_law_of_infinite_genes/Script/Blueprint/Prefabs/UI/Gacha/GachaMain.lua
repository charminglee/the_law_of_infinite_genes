---@class GachaMain_C:UUserWidget
---@field backgroundImage UImage
---@field borderImage UImage
---@field ExitButton UButton
---@field FirearnPurchaseDesc0_215 FirearnPurchaseDesc0_C
---@field FirearnPurchaseDesc0_220 FirearnPurchaseDesc0_C
---@field GachaAttributeBg UImage
---@field GachaAttributeList ReuseList2_C
---@field GachaCacheList ReuseList2_C
---@field GachaDescText UTextBlock
---@field GachaSelectedItem UImage
---@field GachaSlotList ReuseList2_C
---@field Image_1 UImage
---@field Image_2 UImage
---@field Image_3 UImage
---@field Image_4 UImage
---@field Image_6 UImage
---@field Image_7 UImage
---@field Image_35 UImage
---@field Image_36 UImage
---@field Image_37 UImage
---@field Image_38 UImage
---@field Image_39 UImage
---@field Image_40 UImage
---@field Image_42 UImage
---@field LBPurchaseList ReuseList2_C
---@field LevelUpButton UButton
---@field OutSideExitButton UButton
---@field PBG UImage
---@field RefreshBg UImage
---@field RefreshButton UButton
---@field RPurchaseButton UButton
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
local GachaMain = { 
    bInitDoOnce = false,
    ListFlag = nil,
    PrevPressedItem = nil,
    CurrentPressedItem = nil,
} 
function GachaMain:Construct()
    self:LuaInit();
end

function GachaMain:Tick(MyGemetry,FGeometry)
    if GachaManager.RefreshShopUI then
        GachaManager.RefreshShopUI = false;
        self.LBPurchaseList:Reload(6);
    end
    if GachaManager.CurrentPressedItem ~= self.CurrentPressedItem or GachaManager.CurrentPressedItem == nil then
        self.CurrentPressedItem = GachaManager.CurrentPressedItem;
        self.PrevPressedItem = GachaManager.PrevPressedItem;
        self.GachaCacheList:Reload(20);
        self.GachaSlotList:Reload(12);
        self.LBPurchaseList:Reload(6);
        if self.CurrentPressedItem ~= nil then
            self:SetSelectItem('测试', '/Game/UGC/Repository/Icon/Skill/Icon_Skill_14.Icon_Skill_14')
        end
    end
end
function GachaMain:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
    GachaManager:RegisterMainUI(self);
    self:Listen();
    self.GachaCacheList:Reload(20);
    self.GachaSlotList:Reload(12);
    self.LBPurchaseList:Reload(6);
end
function GachaMain:Listen()
    self.GachaCacheList.OnUpdateItem:Add(self.GachaCacheListUpdate, self);
    self.LBPurchaseList.OnUpdateItem:Add(self.LBPurchaseListUpdate, self);
    self.GachaSlotList.OnUpdateItem:Add(self.GachaSlotListUpdate, self);
    self.GachaAttributeList.OnUpdateItem:Add(self.GachaAttributeListUpdate, self);
    self.LevelUpButton.OnClicked:Add(self.LevelUpButtonClicked, self);
    self.OutSideExitButton.OnClicked:Add(self.Exit, self);
    self.ExitButton.OnClicked:Add(self.Exit, self);
    self.RPurchaseButton.OnClicked:Add(self.RPurchaseButtonClicked, self);
    self.RefreshButton.OnClicked:Add(self.RefreshButtonClicked, self);
end
function GachaMain:GachaCacheListUpdate(Item, Index)
    local tempItem = nil;
    if tempItem == nil then
        Item:SetSelectedVisibility(2);
        return nil;
    end
    if Item == self.CurrentPressedItem then
        Item:SetSelectedVisibility(0);
    elseif Item == self.PrevPressedItem then
        Item:SetSelectedVisibility(1);
    else
        Item:SetSelectedVisibility(2)
    end
end
function GachaMain:LBPurchaseListUpdate(Item, Index)
    local slot = LocalPlayerState.PlayerDataManager._card.shop[Index+1];
    if slot ~= nil then
        Item:SetItemTexture(slot);
    end
    if Item == self.CurrentPressedItem then
        Item:SetSelectedVisibility(0);
        return nil;
    elseif Item == self.PrevPressedItem then
        Item:SetSelectedVisibility(1);
        return nil;
    else
        Item:SetSelectedVisibility(1)
    end
end
function GachaMain:GachaSlotListUpdate(Item, Index)
    if LocalPlayerState.PlayerDataManager._card.slot == nil then
        Item:SetSelectedVisibility(2);
        return nil;
    end
    if LocalPlayerState.PlayerDataManager._card.slot[Index+1] == nil then
        Item:SetSelectedVisibility(2)
        return nil;
    end
    if Item == self.CurrentPressedItem then
        Item:SetSelectedVisibility(0);
    elseif Item == self.PrevPressedItem then
        Item:SetSelectedVisibility(1);
    else
        Item:SetSelectedVisibility(2)
    end
end
function GachaMain:GachaAttributeListUpdate(Item, Index)
end
function GachaMain:LevelUpButtonClicked()
end
function GachaMain:RPurchaseButtonClicked()

end
function GachaMain:RefreshButtonClicked()
    ugcprint('发送客户端消息');
    UnrealNetwork.CallUnrealRPC(LocalPlayerController, GachaManager.ComponentClass, "RefreshCardShop", LocalPlayerController.PlayerKey);
    ugcprint('发送完成')
end
function GachaMain:Exit()
    GachaManager:CloseMainUI()
end

---@param descripute string
---@param ImagePath string
function GachaMain:SetSelectItem(descripute, ImagePath)
    self.GachaDescText:SetText(descripute);
    local Texture = LoadObject(ImagePath);
    self.GachaSelectedItem:SetBrushFromTexture(Texture);
end

return GachaMain