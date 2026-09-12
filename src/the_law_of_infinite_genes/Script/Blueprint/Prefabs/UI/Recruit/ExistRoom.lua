---@class ExistRoom_C:UAEUserWidget
---@field Button_Begin UButton
---@field Button_CancelParpare UButton
---@field Button_Invitation UButton
---@field Button_Join UButton
---@field Button_Prepare UButton
---@field Button_RoomConfig UButton
---@field CheckBox_AllowRestock UCheckBox
---@field CheckBox_AllowServe UCheckBox
---@field DropList UGC_ReuseList2_C
---@field Image_1 UImage
---@field Image_Customs UImage
---@field Image_NoRequired_1 UImage
---@field Image_NoRequired_2 UImage
---@field TeamList TeamList_C
---@field TextBlock_Degree UTextBlock
---@field TextBlock_Description UTextBlock
---@field UGC_ReuseList2 UGC_ReuseList2_C
--Edit Below--
local ExistRoom = { bInitDoOnce = false } 
--[==[ Construct
function ExistRoom:Construct()
	
end
-- Construct ]==]
-- function ExistRoom:Tick(MyGeometry, InDeltaTime)
-- end
-- function ExistRoom:Destruct()
-- end
return ExistRoom