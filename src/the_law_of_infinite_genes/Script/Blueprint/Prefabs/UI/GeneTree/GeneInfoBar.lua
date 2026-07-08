---@class GeneInfoBar_C:UAEUserWidget
---@field Add UButton
---@field Highest UButton
---@field Info_0 UTextBlock
---@field Info_1 UTextBlock
---@field InfoBg UImage
---@field InfoBg_0 UImage
---@field InfoBg_1 UImage
---@field InfoPanel UCanvasPanel
---@field Lowest UButton
---@field Reduce UButton
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