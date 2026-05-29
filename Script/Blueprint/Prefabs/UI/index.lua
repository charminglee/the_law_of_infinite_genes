---@class index_C:UUserWidget
---@field playerItem playerItem_C
---@field topBar topBar_C
--Edit Below--
local index = { bInitDoOnce = false, LobbyUIControl=nil} 

function index:Construct()
	self.LuaInit();
	ugcprint('init index')
end

function index:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.topBar.IndexUIControl = self
	self.bInitDoOnce = true;
end
return index