---@class FirearmPurchaseLTabItem_C:UUserWidget
---@field Button_0 UButton
---@field Item UImage
---@field selected UCanvasPanel
--Edit Below--
local FirearmPurchaseLTabItem = {
    bInitDoOnce = false,
    Index = nil,
    RenderVersion = 0,
}

function FirearmPurchaseLTabItem:Construct()
    self:LuaInit();
end

function FirearmPurchaseLTabItem:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self.Button_0.OnClicked:Add(self.Button_0_Clicked, self);
end

function FirearmPurchaseLTabItem:Button_0_Clicked()
    if self.Index ~= nil then
        FightManager:SelectTab(self.Index);
    end
end

function FirearmPurchaseLTabItem:SetEmpty()
    self.Index = nil;
    self.RenderVersion = self.RenderVersion + 1;
    self:SetVisibility(ESlateVisibility.Collapsed);
end

function FirearmPurchaseLTabItem:SetSelected(IsSelected)
    self.selected:SetVisibility(IsSelected and ESlateVisibility.Visible or ESlateVisibility.Collapsed);
end

---@param Index number
---@param TabData table
function FirearmPurchaseLTabItem:SetData(Index, TabData)
    if TabData == nil or TabData.path == nil then
        self:SetEmpty();
        return;
    end
    self.Index = Index;
    self.RenderVersion = self.RenderVersion + 1;
    local renderVersion = self.RenderVersion;
    self:SetVisibility(ESlateVisibility.Visible);
    self:AsyncSetTexture(
            {AssetPathName = TabData.path, SubPathString = nil},
            self.Item,
            renderVersion
    );
end

function FirearmPurchaseLTabItem:AsyncSetTexture(Path, UI, RenderVersion)
    if Path == nil or UI == nil then
        return;
    end
    Common.LoadObjectWithSoftPathAsync(Path,
            function(Texture)
                if self == nil or Texture == nil or UI == nil
                        or self.RenderVersion ~= RenderVersion then
                    return;
                end
                UI:SetBrushFromTexture(Texture);
            end
    );
end

return FirearmPurchaseLTabItem
