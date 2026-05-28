---@class topBarBtn_C:UUserWidget
---@field Button_0 UButton
---@field TextBlock_0 UTextBlock
--Edit Below--
local topBarBtn = { bInitDoOnce = false, BtnText = 'text', is_clicked = false, paternal=nil, idx=nil} 


function topBarBtn:Construct()
	ugcprint('init topbar btn')
	self:LuaInit();
end

function topBarBtn:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	self.TextBlock_0:BindingProperty("Text", self.TextBlock_0_Text, self);
	self.Button_0.OnClicked:Add(self.Button_0_OnClicked, self);
end

function topBarBtn:TextBlock_0_Text(ReturnValue)
	return self.BtnText or "Loading";
end

function topBarBtn:Button_0_OnClicked()
	self:switchPanel(self.idx);
	self.is_clicked = true;
	self.paternal:changeSelected(self.idx);
	self:NotifyPropertyChanged('BtnText');
	return nil;
end

function topBarBtn:changeBackgroundColor(color)
	self.Button_0:SetBackgroundColor(color);
	return nil
end

function topBarBtn:changeLabel(text)
	self.BtnText = text
end

function topBarBtn:switchPanel(idx)
	self.paternal.IndexUIControl.LobbyUIControl:switchActiveWidget(1)
	self.paternal.IndexUIControl.LobbyUIControl.store.storeTab.ReuseList2:Reload(5);
end

return topBarBtn