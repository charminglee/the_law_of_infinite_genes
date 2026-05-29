---@class storeTabBtn_C:UUserWidget
---@field Button_72 UButton
---@field TextBlock_0 UTextBlock
--Edit Below--
local storeTabBtn = { bInitDoOnce = false, BtnText='',paternal=nil,idx=nil} 


function storeTabBtn:Construct()
	self:LuaInit();
end

function storeTabBtn:LuaInit()
    	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
    self.Button_72.OnClicked:Add(self.Button_Clicked, self);
	self.TextBlock_0:BindingProperty("Text", self.TextBlock_0_Text, self);
end

function storeTabBtn:TextBlock_0_Text(ReturnValue)
	return self.BtnText or "Loading";
end

-- function storeTabBtn:Tick(MyGeometry, InDeltaTime)

-- end

-- function storeTabBtn:Destruct()

-- end
function storeTabBtn:Button_Clicked()
	self:ButtonSelected()
	return nil;
end

function storeTabBtn:ButtonSelected()
	ugcprint('上级类为：'..tostring(self.paternal));
	ugcprint('clicked index is:'..tostring(self.idx));
	self.paternal:changeSelected(self.idx);
end

function storeTabBtn:changeBackgroundColor(color)
	self.Button_72:SetBackgroundColor(color);
	return nil
end

function storeTabBtn:SetTextColor(Hex)
	self.TextBlock_0:SetColorRGBStr(Hex)
end
return storeTabBtn