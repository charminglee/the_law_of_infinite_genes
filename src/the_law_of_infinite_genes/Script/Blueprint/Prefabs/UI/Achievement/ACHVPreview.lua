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
    local path = LoadObject(string.format(
        ACHVManager:SelectedTitleData().IconPath, 
        ACHVManager.TitleListUI.selectedTabID, 
        ACHVManager.TitleListUI.selectedTabID
    ));
    self.Icon:SetBrushFromTexture(path);
end

return ACHVPreview