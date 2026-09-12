---@class CreateRoom_C:UAEUserWidget
---@field Button_Cancel UButton
---@field Button_Create UButton
---@field Button_Left UButton
---@field Button_Right UButton
---@field DegreeChoice DegreeChoice_C
---@field DropList UGC_ReuseList2_C
---@field Image_Customs UImage
---@field TextBlock_Description UTextBlock
--Edit Below--
local CreateRoom = { bInitDoOnce = false } 
--[==[ Construct
function CreateRoom:Construct()
	
end
-- Construct ]==]
-- function CreateRoom:Tick(MyGeometry, InDeltaTime)
-- end
-- function CreateRoom:Destruct()
-- end
return CreateRoom