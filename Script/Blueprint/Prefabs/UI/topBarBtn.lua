---@class topBarBtn_C:UUserWidget
---@field Button_0 UButton
---@field TextBlock_0 UTextBlock
--Edit Below--
local topBarBtn = { bInitDoOnce = false, BtnText = 'text', is_clicked = false, paternal=nil, idx=nil} 


function topBarBtn:Construct()
	self:LuaInit();
	ugcprint('paternal is:'..tostring(self.paternal))
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
	ugcprint('paternal control is:'..tostring(self.paternal))
	ugcprint('IndexUIControl control is:'..tostring(self.paternal.IndexUIControl))
	ugcprint('LobbyUIControl control is:'..tostring(self.paternal.IndexUIControl.LobbyUIControl))
	self.paternal.IndexUIControl.LobbyUIControl:switchActiveWidget(1)
	ugcprint('1')
end

return topBarBtn