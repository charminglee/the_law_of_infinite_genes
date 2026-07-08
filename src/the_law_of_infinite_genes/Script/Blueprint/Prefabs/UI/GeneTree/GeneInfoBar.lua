---@class GeneInfoBar_C:UAEUserWidget
---@field InfoBg UImage
---@field InfoPanel UCanvasPanel
---@field SidebarBtn UButton
--Edit Below--
local GeneInfoBar = { bInitDoOnce = false } 

function GeneInfoBar:Construct()
	self:LuaInit();
end

function GeneInfoBar:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	self.SidebarBtn.OnClicked:Add(self.SidebarBtnClicked, self);
end

function GeneInfoBar:SidebarBtnClicked()
    GeneManager.Content:PlayAnim();
end

return GeneInfoBar