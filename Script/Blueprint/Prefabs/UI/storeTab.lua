---@class storeTab_C:UUserWidget
---@field Image_46 UImage
---@field ReuseList2 ReuseList2_C
--Edit Below--
local storeTab = {
    bInitDoOnce = false, 
    selectedIndex = 0,
    tabLabel = {'装备','消耗品','材料','活动','其他'}     
} 


function storeTab:Construct()
	self:LuaInit();
    self:InitBindEvent();
	self:InitUI();
end

function storeTab:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
end

function storeTab:InitBindEvent()
    self.ReuseList2.OnUpdateItem:Add(self.UpdateReuseList2, self);
end

function storeTab:InitUI()
	self.selectedIdx = 0;
	self.ReuseList2:Reload(#self.tabLabel);
end

function storeTab:UpdateReuseList2(Widget, Idx)

	if Widget.paternal == nil then
	    Widget.idx=Idx;
		Widget.paternal=self;
		Widget.BtnText=self.tabLabel[Idx+1]
		Widget:NotifyPropertyChanged('BtnText');
	end
	if Idx == self.selectedIdx then
		Widget:changeBackgroundColor({R=1, G=1,B=1,a=1});
		Widget:SetTextColor('#000000')
	else
		Widget:changeBackgroundColor({R=0, G=0,B=0,a=0});
		Widget:SetTextColor('#FFFFFF');
	end
	return nil;
end

function storeTab:changeSelected(idx)
	self.selectedIdx = idx;
	self.ReuseList2:Reload(#self.tabLabel);
end

-- [Editor Generated Lua] function define End;

return storeTab