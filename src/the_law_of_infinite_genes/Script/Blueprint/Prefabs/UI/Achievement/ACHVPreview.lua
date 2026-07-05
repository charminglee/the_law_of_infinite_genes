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
	local data = ACHVManager:SelectedTitleData();
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

return ACHVPreview