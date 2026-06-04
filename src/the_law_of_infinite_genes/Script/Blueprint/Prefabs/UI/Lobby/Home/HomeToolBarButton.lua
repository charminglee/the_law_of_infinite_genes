---@class HomeToolBarButton_C:UUserWidget
---@field Button_0 UButton
---@field button_icon UImage
---@field Image_0 UImage
---@field Image_1 UImage
---@field TextBlock_0 UTextBlock
--Edit Below--
local HomeToolBarButton = { 
    bInitDoOnce = false,
    Parent = nil,
    Index = 0,    
} 

function HomeToolBarButton:Construct()
	self:LuaInit();
end

function HomeToolBarButton:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
    self:Listen();
end
function HomeToolBarButton:Listen()
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);
end

function HomeToolBarButton:Button_0_Clicked()
    if self.Index == 0 then
		ShopV2Manager:OpenMainUI();
        return nil;
	elseif self.Index  == 1 then
		LotteryManager:OpenLotteryPanel();
        return nil;
	elseif self.Index  == 2 then
		RankingListManager:OpenRankingList();
        return nil;
	elseif self.Index  == 3 then
        StoreManager:OpenMainUI();
        return nil;
	end
end

---@param text string
function HomeToolBarButton:SetText(text)
    self.TextBlock_0:SetText(text);
end

return HomeToolBarButton