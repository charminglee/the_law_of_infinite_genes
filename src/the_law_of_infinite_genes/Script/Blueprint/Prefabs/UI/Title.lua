---@class Title_C:ObjectPositionWidget
---@field Icon UImage
---@field Name UTextBlock
--Edit Below--
local Title = { 
	bInitDoOnce = false,
}

function Title:Construct()
	self.Name:SetText(ACHVManager.Config.EquippedTitleData.NameText);
	local path = LoadObject(string.format(
        ACHVManager.Config.EquippedTitleData.IconPath, 
		ACHVManager.Config.EquippedTitleData.Index - 1, 
		ACHVManager.Config.EquippedTitleData.Index - 1
    ));
    self.Icon:SetBrushFromTexture(path);
end

return Title