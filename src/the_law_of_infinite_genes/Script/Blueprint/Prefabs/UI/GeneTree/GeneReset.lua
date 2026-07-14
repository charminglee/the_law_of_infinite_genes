---@class GeneReset_C:UAEUserWidget
---@field Icon UImage
---@field Reset UButton
--Edit Below--
local GeneReset = { 
    bInitDoOnce = false,
    tipUI = nil
} 

function GeneReset:Construct()
	self:LuaInit();
end

function GeneReset:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	self.Reset.OnClicked:Add(self.ResetClicked, self);
    self:Create();
end

function GeneReset:Create()
    local tipClass = UE.LoadClass(UGCGameSystem.GetUGCResourcesFullPath(GeneManager.Config.TipPath));
    self.tipUI = UGCWidgetManagerSystem.CreateWidget(tipClass);
    self.tipUI.parent = self;
    self.tipUI:AddToViewport(10010);
    self.tipUI:SetVisibility(ESlateVisibility.Collapsed);
end

function GeneReset:ResetClicked()
    self.tipUI:Open();
end

function GeneReset:Execute()
    GeneManager.Content:ResetAll();
end

return GeneReset