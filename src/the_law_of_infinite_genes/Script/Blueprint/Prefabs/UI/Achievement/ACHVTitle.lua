---@class ACHVTitle_C:UUserWidget
---@field Frame UButton
---@field Icon UImage
---@field Name UTextBlock
---@field PressedImg UImage
--Edit Below--
local ACHVTitle = { 
    bInitDoOnce = false,
    parent = nil,
    index = 0,
    nameLabel = {},
} 

function ACHVTitle:Construct()
	self:LuaInit();
end

-- function ACHVTitle:Tick(MyGeometry, InDeltaTime)

-- end

-- function ACHVTitle:Destruct()

-- end
function ACHVTitle:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	self.Frame.OnClicked:Add(self.FrameClicked, self);
end

function ACHVTitle:Refresh()
    self.Name:SetText(self.nameLabel[self.index + 1]);
    local path = LoadObject(string.format(
        '/the_law_of_infinite_genes/Asset/Texture/Titles/WealthTitle_%d.WealthTitle_%d',
        self.index, self.index
    ))
    self.Icon:SetBrushFromTexture(path)
end

function ACHVTitle:Select()
    self.PressedImg:SetVisibility(ESlateVisibility.Visible);
end

function ACHVTitle:Deselect()
	self.PressedImg:SetVisibility(ESlateVisibility.Collapsed);
end

function ACHVTitle:FrameClicked()
    self.parent:SelectTab(self.index);
end

return ACHVTitle