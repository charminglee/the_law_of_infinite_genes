---@class index_C:UUserWidget
---@field playerItem playerItem_C
---@field topBar topBar_C
--Edit Below--
local index = { bInitDoOnce = false, LobbyUIControl=nil} 

function index:Construct()
	ugcprint('index init!')
	self.LuaInit();
end

function index:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.topBar.IndexUIControl = self
	self.bInitDoOnce = true;
end
return index