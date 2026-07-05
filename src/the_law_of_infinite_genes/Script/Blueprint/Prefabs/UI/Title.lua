---@class Title_C:ObjectPositionWidget
---@field Icon UImage
---@field Name UTextBlock
--Edit Below--
local Title = { 
	bInitDoOnce = false,
}

function Title:Construct()
	local data = ACHVManager:GetData(ACHVManager.CacheEquippedTitle);
	self.Icon:SetBrushFromTexture(UGCObjectUtility.LoadObject(data.IconPath));
	self.Name:SetText(data.NameText);
	self.Name:SetColorAndOpacity({SpecifiedColor = data.TextParam.SpecifiedColor});
	self.Name:SetRenderShear(data.TextParam.RenderShear);
	self.Name:SetShadowOffset(data.TextParam.ShadowOffset);
	self.Name:SetShadowColorAndOpacity(data.TextParam.ShadowColorAndOpacity);
	local font = self.Name.Font;
	font.FontMaterial = UGCObjectUtility.LoadObject(data.TextParam.FontMaterial);
	local outline = font.OutlineSettings;
	outline.OutlineSize = data.TextParam.OutlineSize;
	outline.OutlineColor = data.TextParam.OutlineColor;
	font.OutlineSettings = outline;
	self.Name:SetFont(font);
end

return Title