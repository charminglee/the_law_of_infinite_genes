---@class RaidInstanceMain_C:UAEUserWidget
---@field CardButton UButton
---@field ShopButton UButton
--Edit Below--
---@class RaidInstanceMain_C:UAEUserWidget
---@field CardButton UButton
---@field ShopButton UButton

local RaidInstanceMain = { bInitDoOnce = false } 

function RaidInstanceMain:Construct()
	self:LuaInit();
end

function RaidInstanceMain:LuaInit()
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true;
    self:Listen();
end


return RaidInstanceMain