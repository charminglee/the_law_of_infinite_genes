---@class topBarBtn_C:UUserWidget
---@field BarBtn UButton
---@field BarText UTextBlock
--Edit Below--
local topBarBtn = { 
	bInitDoOnce = false;

	paternal=nil;

	TabInfo = nil;
} 


function topBarBtn:Construct()
	self:LuaInit();
end


-- function topBarBtn:Tick(MyGeometry, InDeltaTime)

-- end

-- function topBarBtn:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
function topBarBtn:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;

	self.BarBtn.OnClicked:Add(self.Button_OnClicked, self);
end

function topBarBtn:SetupTabInfo(TabInfo)
    self.TabInfo = TabInfo;
    self.TabID = TabInfo.TabID;
    self.BarText:SetText(TabInfo.TabName);
end

function topBarBtn:Select()
	self.BarBtn:SetBackgroundColor({R=0, G=0, B=0, a=1});
    -- self.SelectHighlight:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
end

function topBarBtn:Deselect()
	self.BarBtn:SetBackgroundColor({R=1, G=1, B=1, a=1});
    -- self.SelectHighlight:SetVisibility(ESlateVisibility.Collapsed);
end

function topBarBtn:Button_OnClicked()	
	self.paternal:SelectTab(self.TabID);

	if self.TabID == 0 then
		ShopV2Manager:OpenMainUI();
	elseif self.TabID == 1 then
		LotteryManager:OpenLotteryPanel();
	elseif self.TabID == 4 then
		RankingListManager:OpenRankingList();
	end


end

return topBarBtn