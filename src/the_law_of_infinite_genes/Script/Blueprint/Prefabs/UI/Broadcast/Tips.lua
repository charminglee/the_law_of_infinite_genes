local Tips = {
    Timer = nil
}

function Tips:BPDoActionsWhenNewTipBegin(data)
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

function Tips:BPDoActionsWhenNewTipEnd()
    if self.Timer then
        UGCGameSystem.ClearTimer(self, self.Timer)
        self.Timer = nil
    end
end


return Tips