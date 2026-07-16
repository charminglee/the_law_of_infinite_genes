---@class GeneReset_C:UAEUserWidget
---@field Icon UImage
---@field LimitText UTextBlock
---@field OwnText UTextBlock
---@field Reset UButton
--Edit Below--
local GeneReset = { 
    bInitDoOnce = false,
    tipUI = nil,
    own = 20,
    limit = 20
} 

function GeneReset:Construct()
	self:LuaInit();
end

function GeneReset:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
    GeneManager.Reset = self;
	self.Reset.OnClicked:Add(self.ResetClicked, self);
    self:SetOwnSkill(self.own);
    self:SetLimitSkill(self.limit);
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

function GeneReset:AddOwnSkill(value)
    local own = self.own + value;
    if own > self.limit then
        return nil
    end
    self:SetOwnSkill(own);
    return own
end

function GeneReset:ReduceOwnSkill(value)
    local own = self.own - value;
    if own < 0 then
        return nil
    end
    self:SetOwnSkill(own);
    return own
end

function GeneReset:SetOwnSkill(value)
    self.own = value;
    self.OwnText:SetText(tostring(value));
end

function GeneReset:SetLimitSkill(value)
    self.limit = value;
    self.LimitText:SetText(tostring(value));
end

return GeneReset