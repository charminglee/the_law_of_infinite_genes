---@class ReinfMain_C:UAEUserWidget
---@field After UUTRichTextBlock
---@field AfterBox UCanvasPanel
---@field Appraisal UButton
---@field arrow UImage
---@field BackpackList UGC_ReuseList2_C
---@field Button_0 UButton
---@field Button_1 UButton
---@field Compose UButton
---@field Front UUTRichTextBlock
---@field Image_6 UImage
---@field Image_7 UImage
---@field Image_9 UImage
---@field Image_12 UImage
---@field Image_13 UImage
---@field Image_14 UImage
---@field Image_17 UImage
---@field M1 ReinfPreviewItem_C
---@field M2 ReinfPreviewItem_C
---@field M3 ReinfPreviewItem_C
---@field Reinf UButton
---@field ReinfPreviewItem ReinfPreviewItem_C
---@field TabList UGC_ReuseList2_C
---@field UseCount UUTRichTextBlock
---@field UTRichTextBlock_0 UUTRichTextBlock
--Edit Below--
local Unpack = table.unpack or unpack

local function CopyReinfData(Dat, LockSource)
    local result = Lib.Table.DeepCopy(Dat or {});
    result.entries = result.entries or {};

    local sourceEntries = LockSource and LockSource.entries or {};
    for index, entry in ipairs(result.entries) do
        entry.isLocked = sourceEntries[index] ~= nil and sourceEntries[index].isLocked == true;
    end

    return result;
end

local function IsSameDefineId(Left, Right)
    if Left == Right then
        return true;
    end
    if type(Left) ~= type(Right) or type(Left) ~= 'table' then
        return false;
    end

    for key, value in pairs(Left) do
        if not IsSameDefineId(value, Right[key]) then
            return false;
        end
    end
    for key, _ in pairs(Right) do
        if Left[key] == nil then
            return false;
        end
    end

    return true;
end

local ReinfMain = {
    bInitDoOnce = false,
    Filter = {},
    attrBuff = {},
    LockCount = 0,
    ReinfDat = {
        DefineId = nil,
        current = { entries = {} },
        previous = { entries = {} }
    }
}

function ReinfMain:Construct()
    self:LuaInit();
end

function ReinfMain:Tick(MyGeometry, InDeltaTime)
    if ReinfManager.RefreshUI then
        ReinfManager.RefreshUI = false;
        self:Reload(ReinfManager.DefineId, ReinfManager.FilterType);
    end
end

function ReinfMain:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self:Listen();
    ReinfManager:RegisterMainUI(self);
end

function ReinfMain:Open(DefineID, FilterType)
    self:ResetReinfDat();
    self:SetVisibility(ESlateVisibility.Visible);
    self:Reload(DefineID, FilterType);
    BroadcastManager:SendTip('洗练会重新生成核心属性，可锁定需要保留的属性');
end

function ReinfMain:ResetReinfDat()
    self.LockCount = 0;
    self.ReinfDat = {
        DefineId = nil,
        current = { entries = {} },
        previous = { entries = {} }
    };
end

function ReinfMain:Reload(DefineID, FilterType)
    local AllItem = UGCBackpackSystemV2.GetAllItemDefineIDsV2(LocalPlayerController);
    if FilterType == nil then
        FilterType = ReinfManager.KenlType[1].Type;
    end
    ReinfManager.FilterType = FilterType;
    local NewDefineId = DefineID;
    if not IsSameDefineId(self.ReinfDat.DefineId, NewDefineId) then
        self:ResetReinfDat();
        self.ReinfDat.DefineId = Lib.Table.DeepCopy(NewDefineId);
    end
    ReinfManager.DefineId = NewDefineId;
    self.Filter = self:FilterKenl(AllItem, FilterType)
    self.BackpackList:Reload(#self.Filter);
    self.TabList:Reload(#ReinfManager.KenlType);
    self:SetPreview(DefineID);
end

function ReinfMain:FilterKenl(ItemList, FilterType)
    local result = {};
    for key, item in ipairs(ItemList) do
        local itemId = item.TypeSpecificID;
        local itemType = UGCItemSystemV2.GetItemCustomizedTypeV2(itemId);
        local has_all = false
        if FilterType == ReinfManager.KenlType[1].Type then
            has_all = true;
        end
        local has_Kenl = self:HasLegalKenl(item);
        if has_all and has_Kenl then
            table.insert(result, item);
        else
            if itemType == FilterType then
                table.insert(result, item)
            end
        end
    end
    return result;
end

--- @param DefineId ItemDefineID
function ReinfMain:HasLegalKenl(DefineId)
    if UGCItemSystemV2.GetItemCustomizedTypeV2(DefineId.TypeSpecificID) == ItemCfg.ItemType.Kenl then
        local dat = LocalPlayerState.ItemDataManager:GetCustomData(DefineId);
        if dat.isIdentified then
            return true
        end
    end
    return false;
end

--- @param DefineID ItemDefineID
function ReinfMain:SetPreview(DefineID)
    local Dat = LocalPlayerState.ItemDataManager:GetCustomData(DefineID);
    local OldCurrent = self.ReinfDat.current;
    if OldCurrent.refineNum ~= nil and Dat.refineNum > OldCurrent.refineNum then
        self.ReinfDat.previous = Lib.Table.DeepCopy(OldCurrent);
    end
    self.ReinfDat.current = CopyReinfData(Dat, OldCurrent);

    self.LockCount = 0;
    for _, entry in ipairs(self.ReinfDat.current.entries) do
        if entry.isLocked then
            self.LockCount = self.LockCount + 1;
        end
    end

    self.ReinfPreviewItem:SetDefineID(DefineID);
    self.attrBuff = self:GetReinfText(self.ReinfDat.current);
    self.UTRichTextBlock_0:SetText(table.concat(self.attrBuff, '\n'));
    
    self.UseCount:SetText(self:GetUseCount(Dat));
    if #self.ReinfDat.previous.entries == 0 then
        self.Front:SetText(self:GetFrontText(self.ReinfDat.current));
        self.arrow:SetVisibility(ESlateVisibility.Collapsed);
        self.AfterBox:SetVisibility(ESlateVisibility.Collapsed);
    else
        self.Front:SetText(self:GetFrontText(self.ReinfDat.previous));
        self.After:SetText(self:GetAfterText(self.ReinfDat.current));
        self.arrow:SetVisibility(ESlateVisibility.Visible);
        self.AfterBox:SetVisibility(ESlateVisibility.Visible);
    end
end

function ReinfMain:GetReinfText(Dat)
    local result = {}
    local flag = 1;
    for k, v in ipairs(Dat.entries) do
        local attrName = AttributeMate[v.property].anno;
        local lockText = v.isLocked and '  解除  ' or '  锁定  ';
        local lockColor = v.isLocked and 'FFFF00FF' or '88FFFFFF';
        local lockValue = v.isLocked and 1 or 0;
        table.insert(result, RichText.Inline(
                RichText.Font(string.format('-- 属性%s\t\t', tostring(flag)), {size=18, color='FFFFFFFF'}),
                RichText.Font(string.format('%s +%s\t\t', attrName, tostring(v.value)), {size=18, color='B8FFA1FF'}),
                RichText.Link(lockText, {size=18, color=lockColor, flag=flag, lock=lockValue}))
        )
        flag = flag + 1;
    end
    return result
end

function ReinfMain:Listen()
    self.Button_0.OnClicked:Add(self.Exit, self);
    self.Appraisal.OnClicked:Add(self.AppraisalClick, self);
    self.Compose.OnClicked:Add(self.ComposeClick, self);
    self.TabList.OnUpdateItem:Add(self.TabListUpdate, self);
    self.BackpackList.OnUpdateItem:Add(self.BackpackListUpdate, self);
    self.UTRichTextBlock_0.OnHyperlinkClicked:Add(self.OnHyperlinkClicked, self)
    self.Button_1.OnClicked:Add(self.Request, self);
end

function ReinfMain:Request()
    local LockedIndexes = {};
    for index, entry in ipairs(self.ReinfDat.current.entries) do
        if entry.isLocked then
            table.insert(LockedIndexes, index);
        end
    end

    UnrealNetwork.CallUnrealRPC(
            LocalPlayerController,
            ReinfManager.ComponentClass,
            "ReinfSubmit",
            LocalPlayerController.PlayerKey,
            ReinfManager.DefineId,
            Unpack(LockedIndexes)
    );
end

function ReinfMain:Exit()
    self:SetVisibility(ESlateVisibility.Collapsed);
end

function ReinfMain:AppraisalClick()
    self:Exit()
    AppraisalManager:OpenMainUI(ReinfManager.DefineId);
end

function ReinfMain:ComposeClick()
    self:Exit();
    KenlComposeManager:OpenMainUI(ReinfManager.DefineId);
end

function ReinfMain:TabListUpdate(Item, Index)
    Item.Index = Index;
    Item:SetDAT(Index, ReinfManager.KenlType[Index+1].Text);
    if ReinfManager.FilterType == ReinfManager.KenlType[Index+1].Type then
        Item:SetSelected(true);
    else
        Item:SetSelected(false);
    end
end

function ReinfMain:BackpackListUpdate(Item, Index)
    local DefineID = self.Filter[Index+1];
    Item:SetDefineID(DefineID);
    Item:SetSelected(ReinfManager.DefineId);
end

function ReinfMain:OnHyperlinkClicked(meta)
    self:LockAttribute(meta);
    self.UTRichTextBlock_0:SetText(table.concat(self.attrBuff, '\n'));
end

function ReinfMain:LockAttribute(meta)
    local flag = tonumber(meta.Metadata.flag);
    local Dat = self.ReinfDat.current.entries;

    if flag == nil or Dat[flag] == nil then
        return;
    end

    if not Dat[flag].isLocked then
        if self.LockCount >= #Dat-1 then
            return;
        end
        self.LockCount = self.LockCount + 1;
        Dat[flag].isLocked = true;
    else
        self.LockCount = math.max(0, self.LockCount - 1);
        Dat[flag].isLocked = false;
    end

    self.attrBuff = self:GetReinfText(self.ReinfDat.current);
end

function ReinfMain:GetFrontText(Dat)
    local result = {};
    local flag = 1;
    for k, v in ipairs(Dat.entries) do
        local attrName = AttributeMate[v.property].anno;
        table.insert(result, RichText.Inline(
                RichText.Font(string.format('-- 属性%s\t\t', tostring(flag)), {size=18, color='FFFFFFFF'}),
                RichText.Font(string.format('%s +%s', attrName, tostring(v.value)), {size=18, color='B8FFA1FF'})
        ))
        flag = flag+1;
    end
    return table.concat(result, '\n');
end

function ReinfMain:GetAfterText(Dat)
    if Dat == nil or Dat.entries == nil then
        return RichText.Font('暂无', {size=18, color='FFFFFFFF'})
    end
    if #Dat.entries == 0 then
        return RichText.Font('暂无', {size=18, color='FFFFFFFF'})
    end
    local result = {};
    local flag = 1;
    for k, v in ipairs(Dat.entries) do
        local attrName = AttributeMate[v.property].anno;
        table.insert(result, RichText.Inline(
                RichText.Font(string.format('-- 属性%s\t\t', tostring(flag)), {size=18, color='FFFFFFFF'}),
                RichText.Font(string.format('%s +%s', attrName, tostring(v.value)), {size=18, color='B8FFA1FF'})
        ))
        flag = flag + 1;
    end
    return table.concat(result, '\n');
end

function ReinfMain:GetUseCount(Dat)
    local result = {
        RichText.Font('洗练次数 ',{size=18, color='FFFFFFFF'})
    }
    for i, v in ipairs({5, 4, 3, 2, 1}) do
        if Dat.refineNum >= v then
            table.insert(result, RichText.Image(
                    {src='/the_law_of_infinite_genes/Asset/Texture/UI/White.White', width=60, height=20, inline=0, color='656B6BFF'}
            ))
        else
            table.insert(result, RichText.Image(
                    {src='/the_law_of_infinite_genes/Asset/Texture/UI/White.White', width=60, height=20, inline=0, color='FFFF00FF'}
            ))
        end
    end
    return table.concat(result, ' ');
end

return ReinfMain
