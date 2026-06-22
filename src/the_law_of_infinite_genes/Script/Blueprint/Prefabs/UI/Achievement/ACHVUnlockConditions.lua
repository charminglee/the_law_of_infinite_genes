---@class ACHVUnlockConditions_C:UUserWidget
---@field Info UTextBlock
---@field Limit UTextBlock
---@field UnlockProgressBar UProgressBar
---@field Value UTextBlock
--Edit Below--
local ACHVUnlockConditions = { 
    bInitDoOnce = false,
    parent = nil,
    index = 0,
} 

function ACHVUnlockConditions:Construct()
	self:LuaInit();
end

function ACHVUnlockConditions:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
end

function ACHVUnlockConditions:Refresh()
    local value, limit;
    -- value = PlayerController.PlayerDataManager:GetStat(Statistics.BossKillCount);
    value = 1;
    limit = ACHVManager:SelectedTitleData().UnlockType[self.index].Value;
    self.Info:SetText(ACHVManager:SelectedTitleData().UnlockType[self.index].Text);
    self.Value:SetText(tostring(value));
    self.Limit:SetText(tostring(limit));
    if value > limit then
        value = limit
    end
    TweenManager.FloatAnim(function(v)
        self.UnlockProgressBar:SetPercent(v)
    end, 0, value / limit, 0.5)
end

return ACHVUnlockConditions