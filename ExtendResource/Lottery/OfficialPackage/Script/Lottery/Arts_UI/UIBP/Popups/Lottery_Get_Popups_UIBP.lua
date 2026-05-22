---@class Lottery_Get_Popups_UIBP_C:UUserWidget
---@field Button_Cancel UButton
---@field Button_CloseUI UButton
---@field Button_OK UButton
---@field Image_1 UImage
---@field ScrollBox_0 UScrollBox
---@field Text_cancel UTextBlock
---@field Text_Content UUTRichTextBlock
---@field Text_ok UTextBlock
---@field TextBlock_Title UTextBlock
---@field UGC_Common_UIPopupBG UUGC_Common_UIPopupBG_C
--Edit Below--

local Lottery_Get_Popups_UIBP = { bInitDoOnce = false } 

function Lottery_Get_Popups_UIBP:Construct()
	self:InitBindEvent();
end

function Lottery_Get_Popups_UIBP:InitBindEvent()
    self.Button_Cancel.OnClicked:Add(self.Close, self);
    -- self.Button_CloseUI.OnClicked:Add(self.Close, self);
end

function Lottery_Get_Popups_UIBP:Close()
    self:SetVisibility(ESlateVisibility.Collapsed);
end

-- function Lottery_Get_Popups_UIBP:Tick(MyGeometry, InDeltaTime)

-- end 

-- function Lottery_Get_Popups_UIBP:Destruct()

-- end

function Lottery_Get_Popups_UIBP:Show(Text, ConfirmBtnText, ConfirmFunc, CancelFunc)
    self.Text_Content:SetText(Text);
    self.Text_ok:SetText(ConfirmBtnText);
    self.Button_OK.OnClicked:RemoveAll();
    self.Button_OK.OnClicked:Add(ConfirmFunc, self);
end

return Lottery_Get_Popups_UIBP