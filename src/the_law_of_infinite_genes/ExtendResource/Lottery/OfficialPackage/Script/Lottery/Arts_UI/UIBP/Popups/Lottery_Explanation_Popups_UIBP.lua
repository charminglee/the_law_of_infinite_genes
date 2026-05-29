---@class Lottery_Explanation_Popups_UIBP_C:UUserWidget
---@field Button_0 UButton
---@field Button_CloseUI UButton
---@field Distance UImage
---@field MsgBox UCanvasPanel
---@field ScrollBox_0 UScrollBox
---@field TextBlock_WindowsTitle UTextBlock
---@field TY_PopupsBg_Text UTY_PopupsBg_Text_C
---@field UGC_Common_UIPopupBG UUGC_Common_UIPopupBG_C
---@field UTRichTextBlock_TipsContent UUTRichTextBlock
---@field WidgetSwitcher_Size UWidgetSwitcher
--Edit Below--
local Lottery_Explanation_Popups_UIBP = { bInitDoOnce = false } 

function Lottery_Explanation_Popups_UIBP:Construct()
    self:InitBindEvent();
end


-- function Lottery_Explanation_Popups_UIBP:Tick(MyGeometry, InDeltaTime)

-- end

-- function Lottery_Explanation_Popups_UIBP:Destruct()

-- end

function Lottery_Explanation_Popups_UIBP:InitBindEvent()
    self.Button_CloseUI.OnClicked:Add(self.Close, self)
end

function Lottery_Explanation_Popups_UIBP:Close()
    self:SetVisibility(ESlateVisibility.Collapsed);
end

function Lottery_Explanation_Popups_UIBP:InitUI(Desc)
    local Str = string.gsub(Desc, "\\n", "\n");
    -- local retStr = LotteryManager:GetLegalStr(Desc, 200);
    self.UTRichTextBlock_TipsContent:SetText(Str);
end

return Lottery_Explanation_Popups_UIBP