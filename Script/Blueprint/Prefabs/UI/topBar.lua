---@class topBar_C:UUserWidget
---@field CanvasPanel_0 UCanvasPanel
---@field ReuseList2 ReuseList2_C
--Edit Below--
local topBar = { 
	bInitDoOnce = false,
	btnLabel = {},
	backgroundColors = {true, false, false, false, false},
	selectedIdx = 0,
	IndexUIControl = nil,
	isVisible = true,
	}

function topBar:Construct()
	self.btnLabel = UGCGameSystem.GetTableData('/the_law_of_infinite_genes/Asset/Data/Table/Customized/lobbyBtnName.lobbyBtnName')
	self:LuaInit();
	self:InitBindEvent();
	self:InitUI();
end

function topBar:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
end

function topBar:PreLoadUI()
    Common.LoadObjectWithSoftPathAsync(self.ItemTipUIClassPath, 
        function (Object)
            if self ~= nil and Object ~= nil then
                local PlayerController = STExtraGameplayStatics.GetFirstPlayerController(self);
                self.ItemTip = UserWidget.NewWidgetObjectBP(PlayerController, Object);
                self.ItemTip:AddToViewport(25000);
                self.ItemTip:SetVisibility(ESlateVisibility.Visible);
            end
        end
    );
end

function topBar:InitBindEvent()
	self.ReuseList2.OnUpdateItem:Add(self.InitBtn, self);
end

function topBar:InitBtn(Item, Index)
	if Item.paternal == nil then
		Item.paternal = self;
		Item.idx = Index;
		Item.BtnText = tostring(self.btnLabel[Index].label);
		Item:NotifyPropertyChanged('BtnText');
	end
	if Index == self.selectedIdx then
		Item:changeBackgroundColor({R=0, G=0,B=0,a=1});
	else
		Item:changeBackgroundColor({R=1, G=1,B=1,a=1});
	end
end

function topBar:InitUI()
	self.selectedIdx = 0;
	self.ReuseList2:Reload(#self.btnLabel);
end

function topBar:changeSelected(idx)
	self.selectedIdx = idx;
	self.ReuseList2:Reload(#self.btnLabel);
end



return topBar
