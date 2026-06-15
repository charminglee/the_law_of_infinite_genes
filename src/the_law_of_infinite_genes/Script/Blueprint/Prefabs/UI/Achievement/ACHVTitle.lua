---@class ACHVTitle_C:UUserWidget
---@field Frame UButton
---@field Icon UImage
---@field Name UTextBlock
---@field PressedImg UImage
--Edit Below--
local ACHVTitle = { 
    bInitDoOnce = false,
    Parent = nil,
    Index = 0,
    NameLabel = {'囊中羞涩', '略有盈余', '小富即安', '盆满钵满', '腰缠万贯', '富甲一方'},
} 

--[==[ Construct
function ACHVTitle:Construct()
	
end
-- Construct ]==]

-- function ACHVTitle:Tick(MyGeometry, InDeltaTime)

-- end

-- function ACHVTitle:Destruct()

-- end

function ACHVTitle:Refresh()
    UGCLog.Log(self.Index)
    self.Name:SetText(self.NameLabel[self.Index + 1]);
    local path = LoadObject(string.format(
        '/the_law_of_infinite_genes/Asset/Texture/Titles/WealthTitle_%d.WealthTitle_%d',
        self.Index, self.Index
    ))
    UGCLog.Log(path)
    self.Icon:SetBrushFromTexture(path)

end

return ACHVTitle