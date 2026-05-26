---@class storeTopBar_C:UUserWidget
---@field bg_01 UImage
---@field Button_1 UButton
---@field Image_34 UImage
--Edit Below--
local storeTopBar = { bInitDoOnce = false, paternal=nil} 


function storeTopBar:Construct()
	self:LuaInit();
	
end


function storeTopBar:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	self.Button_1.OnClicked:Add(self.Button_1_OnClicked, self);
end

function storeTopBar:Button_1_OnClicked()
	self.paternal.LobbyUIControl:switchActiveWidget(0)
    return nil;
end



return storeTopBar