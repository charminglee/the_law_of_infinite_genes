---@class Title_C:ObjectPositionWidget
---@field Icon UImage
---@field Name UTextBlock
--Edit Below--
local Title = { 
	bInitDoOnce = false,
}

-- 获取数据
function Title:GetData()
	for _, titles in pairs(ACHVManager.Config.TitleData) do
		for k, data in pairs(titles) do
			if data.Id == ACHVManager.CacheEquippedTitle then
				return data
			end		
		end
	end
	return
end

function Title:Construct()
	local data = self:GetData();
	local path = LoadObject(data.IconPath);
	self.Name:SetText(data.NameText);
    self.Icon:SetBrushFromTexture(path);
end

return Title