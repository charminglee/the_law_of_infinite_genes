---@class Notice_C:TopTipWidget
---@field FadeOut UWidgetAnimation
---@field FadeIn UWidgetAnimation
---@field Border_TopTips UBorder
---@field CanvasPanel_TopTips UCanvasPanel
---@field HorizontalBox_Content UHorizontalBox
---@field Image_BG1 UImage
---@field Image_Event UImage
---@field TopTips_Content UUTRichTextBlock
--Edit Below--
local Notice = {
    Timer = nil,
    ImageVersion = 0,
}

---@param Image string|FSoftObjectPath
function Notice:SetImage(Image)
    self.ImageVersion = self.ImageVersion + 1
    local imageVersion = self.ImageVersion
    local SelfWeakObjectPtr = WeakObjectPtr(self)
    local function SetTexture(Texture)
        local self = SelfWeakObjectPtr:Get()
        if self == nil or self.ImageVersion ~= imageVersion then
            return
        end
        self.Image_Event:SetBrushFromTexture(Texture)
    end

    if type(Image) == "string" then
        Common.LoadObjectAsync(Image, SetTexture)
    else
        Common.LoadObjectWithSoftPathAsync(Image, SetTexture)
    end
end

function Notice:BPDoActionsWhenNewTipBegin(data)
    self.TopTips_Content:SetText(tostring(data.FinalContext))
    if CheckObjectContainsField(self, 'FadeIn') then
        self:StopAnimation(self.FadeIn)
        self:PlayAnimation(self.FadeIn, 0, 1, EUMGSequencePlayMode.Forward, 1)
    end
    if self.Timer then
        UGCGameSystem.ClearTimer(self, self.Timer)
        self.Timer = nil
    end
    local SelfWeakObjectPtr = WeakObjectPtr(self)
    self.Timer = UGCGameSystem.SetTimer(self,
        function ()
            local self = SelfWeakObjectPtr:Get()
            if self == nil then return end
            if CheckObjectContainsField(self, 'FadeOut') then
                self:StopAnimation(self.FadeOut)
                self:PlayAnimation(self.FadeOut, 0, 1, EUMGSequencePlayMode.Forward, 1)
            end
        end,
    data.PlayLength - 0.5,
    false)
end
function Notice:BPDoActionsWhenNewTipEnd()
    if self.Timer then
        UGCGameSystem.ClearTimer(self, self.Timer)
        self.Timer = nil
    end
end
return Notice
