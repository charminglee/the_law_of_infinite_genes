
GachaManager = GachaManager or
{
    MainUI = nil;
    ComponentClass = nil;
    SelectTag = nil;
    SelectIndex = nil;
    RefreshUI = false;
    PreviewDAT = nil;
}

function GachaManager:RegisterComponentClass(CompClass)
    if CompClass ~= nil then
        self.ComponentClass = CompClass;
    end
end

function GachaManager:RegisterMainUI(MainUI)
    if self.MainUI == nil then
        self.MainUI = MainUI;
    end
end

function GachaManager:UnregisterMainUI()
    self.MainUI = nil;
end

function GachaManager:OpenMainUI()
    if self.MainUI == nil then
        return;
    end
    self.MainUI:SetVisibility(ESlateVisibility.Visible);
    self.SelectIndex = nil;
    self.SelectTag = nil;
    self.PreviewDAT = nil;
    self.RefreshPreviewUI = false;
    self.RefreshUI = true;
    BroadcastManager:SendTip('购买并装备卡牌可激活对应套装效果');
end

function GachaManager:CloseMainUI()
    if self.MainUI == nil then
        return;
    end
    self.MainUI:SetVisibility(ESlateVisibility.Collapsed);
    self.SelectIndex = nil;
    self.SelectTag = nil;
    self.PreviewDAT = nil;
    self.RefreshPreviewUI = false;
    self.RefreshUI = false;
end



---@param star number <1,3>
function GachaManager:GetStarText(star)
    if star == 1 then
        return '1星';
    elseif star == 2 then
        return '2星';
    elseif star == 3 then
        return '3星';
    else
        return '1星';
    end
end

function GachaManager:SetPreviewDAT(DAT)
    self.PreviewDAT = DAT;
    self.RefreshPreviewUI = DAT ~= nil;
end
