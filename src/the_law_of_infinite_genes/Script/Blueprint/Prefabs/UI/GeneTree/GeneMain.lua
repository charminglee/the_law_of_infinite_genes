---@class GeneMain_C:UAEUserWidget
---@field BgInner UImage
---@field Exit UButton
--Edit Below--
local GeneMain = { bInitDoOnce = false } 

function GeneMain:Construct()
	self:LuaInit();
end

function GeneMain:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
    GeneManager:RegisterMainUI(self);
end

function GeneMain:Open()
    UGCLog.Log('GeneMainAAAAAAAAAAAAAAAAAA')
	self:SetVisibility(ESlateVisibility.Visible);
end

function GeneMain:Close()
    self:SetVisibleAnim(ESlateVisibility.Collapsed);
end

return GeneMain