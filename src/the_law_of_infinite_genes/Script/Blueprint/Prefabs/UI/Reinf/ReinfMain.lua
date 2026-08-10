---@class ReinfMain_C:UAEUserWidget
---@field After UUTRichTextBlock
---@field BackpackList UGC_ReuseList2_C
---@field Button_0 UButton
---@field Button_1 UButton
---@field Front UUTRichTextBlock
---@field Image_14 UImage
---@field M1 ReinfPreviewItem_C
---@field M2 ReinfPreviewItem_C
---@field M3 ReinfPreviewItem_C
---@field ReinfItem ReinfItem_C
---@field TabList UGC_ReuseList2_C
---@field UTRichTextBlock_0 UUTRichTextBlock
--Edit Below--
local ReinfMain = { bInitDoOnce = false } 

function ReinfMain:Construct()
	self:LuaInit();
end

function ReinfMain:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self:Listen();
    ReinfManager:RegisterMainUI(self);
end

function ReinfMain:Open(DefineId)
    self:SetVisibility(ESlateVisibility.Visible);
end
function ReinfMain:Listen()
    self.Button_0.OnClicked:Add(self.Exit, self);
end

function ReinfMain:Exit()
    self:SetVisibility(ESlateVisibility.Collapsed);
end


return ReinfMain