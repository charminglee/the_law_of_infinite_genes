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
    local categoryListUISelected = ACHVManager.CategoryListUI.selectedTabID;
    local titleListUISelected = ACHVManager.TitleListUI.selectedTabID;
    self.Name:SetText(ACHVManager.Config.TitleNameLabel[categoryListUISelected + 1][titleListUISelected + 1]);
    local path = LoadObject(string.format(
        ACHVManager.Config.IconPath[categoryListUISelected + 1], titleListUISelected, titleListUISelected
    ))
    self.Icon:SetBrushFromTexture(path)
end

return ACHVPreview