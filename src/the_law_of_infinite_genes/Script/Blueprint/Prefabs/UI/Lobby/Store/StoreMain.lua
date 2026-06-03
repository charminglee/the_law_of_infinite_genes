---@class StoreMain_C:UUserWidget
---@field bg_01 UImage
---@field bg_02 UImage
---@field StoreList StoreList_C
---@field StoreToolBar StoreToolBar_C
--Edit Below--
local StoreMain = { 
    bInitDoOnce = false,
    parent = nil, 
    } 

function StoreMain:Construct()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
    self:InitUI();

end

function StoreMain:InitUI()
    self.StoreToolBar.parent = self;
    self.StoreList.parent = self;
    local DataList = {
        {ItemId=0, number=1},
        {ItemId=0, number=1},
        {ItemId=0, number=1},
        {ItemId=0, number=1},
        {ItemId=0, number=1},
        {ItemId=0, number=1},
        {ItemId=0, number=1},
        {ItemId=0, number=1},
        {ItemId=0, number=1},
        {ItemId=0, number=1}   
    }
    self.StoreList:ReloadList(DataList)
    UGCWidgetManagerSystem.GetUserWidgetByWidgetLayout()
end

function StoreMain:SwitchLobby()
    self.parent:switchActiveWidget(0);
end

return StoreMain