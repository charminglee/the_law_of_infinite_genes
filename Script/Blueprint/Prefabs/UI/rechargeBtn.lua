---@class rechargeBtn_C:UUserWidget
---@field RechargeBtn UButton
---@field RechargeText UTextBlock
--Edit Below--
local rechargeBtn = { 
	bInitDoOnce = false;

	paternal=nil;

	TabInfo = nil;
} 

function rechargeBtn:Construct()
	self:LuaInit();
end

-- function rechargeBtn:Tick(MyGeometry, InDeltaTime)

-- end

-- function rechargeBtn:Destruct()

-- end

function rechargeBtn:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;

	self.RechargeBtn.OnClicked:Add(self.Button_OnClicked, self);
end

function rechargeBtn:SetupTabInfo(TabInfo)
    self.TabInfo = TabInfo;
    self.TabID = TabInfo.TabID;
    self.RechargeText:SetText(TabInfo.TabName);
end

function rechargeBtn:Select()
	self.RechargeBtn:SetBackgroundColor({R=0, G=0, B=0, a=1});
    -- self.SelectHighlight:SetVisibility(ESlateVisibility.SelfHitTestInvisible);
end

function rechargeBtn:Deselect()
	self.RechargeBtn:SetBackgroundColor({R=1, G=1, B=1, a=1});
    -- self.SelectHighlight:SetVisibility(ESlateVisibility.Collapsed);
end

function rechargeBtn:Button_OnClicked()	
	self.paternal:SelectRechargeTab(self.TabID);

end

return rechargeBtn