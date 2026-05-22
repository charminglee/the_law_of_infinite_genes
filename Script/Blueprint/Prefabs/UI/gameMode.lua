---@class gameMode_C:UUserWidget
---@field Button_0 UButton
---@field TextBlock_0 UTextBlock
--Edit Below--
local gameMode = { bInitDoOnce = false } 

function gameMode:Construct()
	self.TextBlock_0:SetText('游戏模式');
end

-- function gameMode:Tick(MyGeometry, InDeltaTime)

-- end

-- function gameMode:Destruct()

-- end

return gameMode