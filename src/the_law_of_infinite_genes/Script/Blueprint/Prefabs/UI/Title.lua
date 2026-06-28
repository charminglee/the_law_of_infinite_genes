---@class Title_C:ObjectPositionWidget
---@field Icon UImage
---@field Name UTextBlock
--Edit Below--
local Title = { 
	bInitDoOnce = false,
}

function Title:Construct()
	local data = ACHVManager:GetData(ACHVManager.CacheEquippedTitle);
	local path = LoadObject(data.IconPath);
	self.Name:SetText(data.NameText);
    self.Icon:SetBrushFromTexture(path);
end

return Title