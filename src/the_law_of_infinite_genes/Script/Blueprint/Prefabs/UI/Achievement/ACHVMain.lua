---@class ACHVMain_C:UUserWidget
---@field ACHVCategoryList CHVCategoryList_C
---@field Bg UImage
---@field BgInner UImage
---@field Button_0 UButton
---@field CircularThrobber_0 UCircularThrobber
---@field Exit UButton
---@field Image_0 UImage
---@field Image_1 UImage
---@field Image_2 UImage
---@field ReuseList2 ReuseList2_C
--Edit Below--
local ACHVMain = { bInitDoOnce = false } 

function ACHVMain:Construct()
	self:LuaInit();
end

function ACHVMain:LuaInit()
    if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
    ACHVManager:RegisterMainUI(self);
	self.Exit.OnClicked:Add(self.ExitOnClicked, self);
	self.ReuseList2.OnUpdateItem:Add(self.ReuseList2Update, self);
	self.ReuseList2:Reload(6);
end

-- function ACHVMain:Tick(MyGeometry, InDeltaTime)

-- end

-- function ACHVMain:Destruct()

-- end

function ACHVMain:ExitOnClicked()
    ACHVManager:CloseMainUI();
end

function ACHVMain:ReuseList2Update(Item, Index)
	if Item.Parent == nil then
		Item.Parent = self;
		Item.Index = Index;
	end
	Item:Refresh();
end

return ACHVMain