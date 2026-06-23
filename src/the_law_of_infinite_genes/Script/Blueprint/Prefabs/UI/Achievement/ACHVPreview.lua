---@class ACHVPreview_C:UUserWidget
---@field Icon UImage
---@field Name UTextBlock
--Edit Below--
local ACHVPreview = { 
    bInitDoOnce = false,
} 

function ACHVPreview:Construct()
	self:LuaInit();
end

function ACHVPreview:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	ACHVManager.Preview = self;
end

function ACHVPreview:Refresh()
    self.Name:SetText(ACHVManager:SelectedTitleData().NameText);
    local path = LoadObject(ACHVManager:SelectedTitleData().IconPath);
    self.Icon:SetBrushFromTexture(path);
end

return ACHVPreview