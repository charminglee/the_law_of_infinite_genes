---@class DropItem_C:UUserWidget
---@field CanvasPanel_Icon UCanvasPanel
---@field Image_Icon UImage
---@field Image_QualityBar UImage
---@field Image_QualityBarBg UImage
---@field Size FVector2D
---@field DurabilityPercent float
--Edit Below--
local DropItem = {
    CutomeUISoftClassPath = {},
    CustomUIList = {},

    ItemDefineID = nil,
    ItemID = 0,

    QualityList = {},
    ColNum = 3,
}


---初始化控件
---设置控件可见性，并绑定配件品质列表更新回调。
function DropItem:Construct()
    self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)

    -- 配件更新
	self.WrapGroupBox_QualityPoint.OnUpdateItem:Add(self.AttachUpdateItem, self);
end

---析构控件
---解绑配件品质列表更新回调，防止内存泄漏。
function DropItem:Destruct()
    self.WrapGroupBox_QualityPoint.OnUpdateItem:Remove(self.AttachUpdateItem, self);

    self:Clear();
end

-- 清空控件显示状态
-- 隐藏数量文本、耐久遮罩、配件品质列表，清理叠加UI，并重置物品ID。
function DropItem:Clear()
    self.TextBlock_Num:SetVisibility(ESlateVisibility.Collapsed)
    self.Durable_Mask:SetVisibility(ESlateVisibility.Collapsed)
    -- 配件列表
	self.UGC_FittingSlot_UIBP:SetVisibility(ESlateVisibility.Collapsed)

    -- 清理叠加UI
    self.CanvasPanel_0:ClearChildren()
    self.CustomUIList = {}

    self.Image_Null:SetVisibility(ESlateVisibility.SelfHitTestInvisible)

    self.CanvasPanel_Icon:SetVisibility(ESlateVisibility.Collapsed)
    self.Image_Icon:SetVisibility(ESlateVisibility.Collapsed)

    self.Image_QualityBar:SetVisibility(ESlateVisibility.Collapsed)
    self.Image_QualityBarBg:SetVisibility(ESlateVisibility.Collapsed)

    self.ItemDefineID = nil
    self.ItemID = 0
end

---设置物品信息
---根据物品ID或DefineID设置物品的图标、品质、数量等显示信息。
---传入nil时显示空状态（空图标），传入DefineID时会额外显示实例的配件信息和耐久信息。
---Count大于1时显示数量文本。
---@param ItemData {Item: number|ItemDefineID, Count: number} @物品信息表，Item为物品ID或DefineID（nil则显示空状态），Count为物品数量
function DropItem:SetItemInfo(ItemData)
    self:Clear();

    if ItemData == nil then
        return
    end

    local Item = ItemData.Item
    if Item == nil then
        Item = ItemData.ItemDefineID or ItemData.ItemID

        if Item == nil then
            return
        end
    end

    local Count = ItemData.Count or 0

    if type(Item) == "number" then
        self.ItemID = Item
    else
        self.ItemDefineID = totable(Item)
        self.ItemID = Item.TypeSpecificID
    end

    -- 防御：无效 ItemID 直接保持空状态，避免异步加载空路径
    if not self.ItemID or self.ItemID <= 0 then
        return
    end

    self.Image_Null:SetVisibility(ESlateVisibility.Collapsed)
    self.CanvasPanel_Icon:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Image_Icon:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    
    -- 异步加载物品图标（使用带皮肤的接口，优先显示玩家商业化皮肤图标）
    local weakSelf = WeakObjectPtr(self)
    local LocalPC = UGCGameSystem.GetLocalPlayerController()
    
-- 根据传入参数类型选择不同的接口
    local IconPath, Quality
    if self.ItemDefineID then
        IconPath = UGCItemSystemV2.GetItemIconWithPlayerSkinV2ByDefineID(self.ItemDefineID, LocalPC)
        Quality = UGCItemSystemV2.GetItemQualityV2ByDefineID(self.ItemDefineID)
    else
        IconPath = UGCItemSystemV2.GetItemIconWithPlayerSkinV2(self.ItemID, LocalPC)
        Quality = UGCItemSystemV2.GetItemQualityV2(self.ItemID)
    end
    
    UGCObjectUtility.AsyncLoadObjectBySoftPath(IconPath, function(LoadedTexture)
        if weakSelf:IsValid() then
            weakSelf:Get().Image_Icon:SetBrushFromTexture(LoadedTexture, false)
        end
    end)
    self:SetQuality(Quality)

    if Count and Count > 1 then
        self.TextBlock_Num:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
    self.TextBlock_Num:SetText(tostring(Count))

    -- 如果是实例物品
    if self.ItemDefineID then
        -- 耐久遮罩
        self:UpdateDurabilityMask();

        -- 右上角 配件信息
	    self:UpdateAttachInfo();
    end
end

---更新耐久度遮罩
---根据物品自定义数据中的耐久值，计算耐久百分比并设置遮罩显示。
---耐久值越低，遮罩覆盖面积越大。
function DropItem:UpdateDurabilityMask()
    -- 耐久遮罩
    local CustomData = UGCItemSystemV2.LoadItemCustomData(self.ItemDefineID);
    if CustomData then
        local EquipHandle = UGCItemSystemV2.GetConfigItemHandle(self.ItemID);
        local CurDurability = CustomData["Durability"];
        if CurDurability and type(CurDurability) == "number" then
            local MaxDurability = EquipHandle.durability;
            if MaxDurability > 0 then
                local Percent = CurDurability / MaxDurability
                Percent = KismetMathLibrary.FClamp(Percent, 0, 1)

                self.Durable_Mask:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                self.Durable_Mask:SetPercent(1 - Percent);
            else
            end
        end
    end
end

---更新配件品质信息
---获取物品的所有配件槽位，按品质降序排列后刷新右上角配件品质点列表。
function DropItem:UpdateAttachInfo()
	-- 根据品质排序
	local TempQualityList = {}
	local Slots = UGCItemSystemV2.GetEquipTargetSlots(self.ItemID)
    if Slots and #Slots > 0 then
        self.UGC_FittingSlot_UIBP:SetVisibility(ESlateVisibility.SelfHitTestInvisible)

        for _, Slot in pairs(Slots) do
            local AttachItem = UGCItemSystemV2.GetAttachChildItem(self.ItemDefineID, Slot)
			local Quality = -1;
            if AttachItem and AttachItem.TypeSpecificID > 0 then
                Quality = UGCItemSystemV2.GetItemQualityV2ByDefineID(AttachItem)
            end

            table.insert(TempQualityList, Quality)
        end
    end
	table.sort(TempQualityList, function(a, b) return a > b end)

	self.QualityList = TempQualityList

	-- 配件最大行数(固定3列, 最少2行)
	self.QualityRow = math.max(math.floor((#self.QualityList - 1) / self.ColNum) + 1, 2);

	-- 最多槽位数
	local AllSlotNums = self.QualityRow * self.ColNum
	self.WrapGroupBox_QualityPoint:Reload(AllSlotNums);
end

---配件品质列表更新回调
---根据控件索引计算对应的品质数据索引（固定3列布局，左右对称），设置品质背景。
---@param widget userdata @品质点控件
---@param idx number @控件索引（从0开始）
function DropItem:AttachUpdateItem(widget, idx)
	if self.QualityList == nil then
		return;
	end

	-- 配件格子和数据对应关系(固定3列)
	-- 0->1 1->row+1 2-> 2*row + 1
	-- 3->2 4->row+2 5-> 2*row + 2
	-- 6->3 7->row+3 8-> 2*row + 3
	-- idx -> (idx % col) * row + (math.floor(idx / col) + 1)

	-- 左右对称处理
	idx = 2 * (1 + math.floor(idx / self.ColNum) * self.ColNum) - idx
	local _useidx = (idx % self.ColNum) * self.QualityRow + math.floor(idx / self.ColNum) + 1
	local Quality = self.QualityList[_useidx]
	widget:SetQualityBg(Quality, _useidx > #self.QualityList)
end

---叠加UI控件创建完成回调
---将创建的控件加入列表，并触发PostCallback通知外部。
---@param CustomUI userdata @创建完成的叠加UI控件实例
function DropItem:OnCustomUICreated(CustomUI)
    if UE.IsValid(CustomUI) then
		table.insert(self.CustomUIList, WeakObjectPtr(CustomUI))

        if self.PostCallback then
            self.PostCallback(self.CanvasPanel_0, CustomUI)
        end
    end
end

---设置叠加UI列表(需在SetItemData后调用!!!)
---清空现有叠加UI，根据传入的路径列表异步创建新的叠加UI控件，
---并挂接到CanvasPanel_0面板下。每个控件创建完成后会触发PostCallback回调。
---@param SoftWidgetPaths table @叠加UI路径列表，nil时清空所有叠加UI
---@param PostCallback function @叠加控件创建后回调函数，参数为(UISlot:挂点Slot, CustomUI:叠加控件)
function DropItem:SetCustomUISoftWidgetPath(SoftWidgetPaths, PostCallback)
    -- 清空自定义UI
    self.CanvasPanel_0:ClearChildren()

    self.PostCallback = PostCallback

    if SoftWidgetPaths == nil then
        SoftWidgetPaths = {}
    end
    self.CutomeUISoftClassPath = SoftWidgetPaths

    local weakSelf = WeakObjectPtr(self)
    
    -- 挂接叠加UI
    self.CustomUIList = {}
    for index, Path in ipairs(self.CutomeUISoftClassPath) do
        UGCWidgetManagerSystem.CreateWidgetAsync(Path, function(CustomUI)
            if weakSelf:IsValid() then
                weakSelf:Get():OnCustomUICreated(CustomUI)
            end
        end)
    end
end

---获取叠加UI路径列表
---返回当前设置的叠加UI软引用路径列表。
---@return table @叠加UI路径列表
function DropItem:GetCustomUISoftWidgetPath()
    return self.CutomeUISoftClassPath
end

-- 设置物品品质显示
-- 根据品质等级加载对应的品质背景和品质条纹理，nil时隐藏对应图片。
-- @param Quality number @物品品质等级
function DropItem:SetQuality(Quality)
    local QualityBgPath = UGCItemSystemV2.GetQualityTexturePath(Quality)
    local QualityBarPath = UGCItemSystemV2.GetQualityBarTexturePath(Quality)
    local weakSelf = WeakObjectPtr(self)

    if QualityBgPath then
        self.Image_QualityBarBg:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        UGCObjectUtility.AsyncLoadObject(QualityBgPath, function(LoadedTexture)
            if weakSelf:IsValid() then
                weakSelf:Get().Image_QualityBarBg:SetBrushFromTexture(LoadedTexture, false)
            end
        end)
    else
    end

    if QualityBarPath then
        self.Image_QualityBar:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        UGCObjectUtility.AsyncLoadObject(QualityBarPath, function(LoadedTexture)
            if weakSelf:IsValid() then
                weakSelf:Get().Image_QualityBar:SetBrushFromTexture(LoadedTexture, false)
            end
        end)
    else
    end
end

---设置选中状态
---控制选中描边图片的显示或隐藏。
---@param isSelect boolean @是否选中，true显示选中描边，false隐藏
function DropItem:SetIsSelect(isSelect)
    if isSelect then
        self.Image_Select:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Image_Select:SetVisibility(ESlateVisibility.Collapsed)
    end
end

return DropItem