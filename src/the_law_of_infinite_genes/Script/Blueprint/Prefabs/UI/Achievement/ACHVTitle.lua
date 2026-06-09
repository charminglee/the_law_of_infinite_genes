---@class ACHVTitle_C:UUserWidget
---@field Frame UButton
---@field Icon UImage
---@field Name UTextBlock
--Edit Below--
local ACHVTitle = { 
    bInitDoOnce = false,
    Parent = nil,
    Index = 0
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
    self.Name:SetText('囊中羞涩');

end

return ACHVTitle