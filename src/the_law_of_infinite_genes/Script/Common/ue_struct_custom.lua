-- auto exported UStruct while compiling 

-- sorted by struct name asc 

---@class LobbyTabs
---@field TabID int32
---@field TabName FString
---@field TabDesc FString

---@class RechargeTabs
---@field TabID int32
---@field TabName FString
---@field TabDesc FString

---@class LotteryDrawInfo
---@field LotteryID int32
---@field LotteryRecords LotteryRecord[]
---@field TotalDrawTimes int32

---@class LotteryDrawItemInfo
---@field ID int32
---@field Num int32
---@field DropType FString
---@field IsDrawTenth bool

---@class LotteryExchangeInfo
---@field ProductID int32
---@field ExchangeInfo LotteryExchangeItemInfo[]

---@class LotteryExchangeItemInfo
---@field ExchangeNum int32
---@field ExchangeTime int32

---@class LotteryGiftProgressInfo
---@field LotteryID int32
---@field ProgressInfo LotteryGiftProgressReciveState[]

---@class LotteryGiftProgressReciveState
---@field Progress int32
---@field State bool

---@class LotteryInfo
---@field LotteryGroup bool
---@field Lottery bool
---@field LotteryExchangeInfo bool
---@field LotteryGiftProgress bool
---@field LotterySkipAnim bool

---@class LotteryRecord
---@field DrawItemInfo LotteryDrawItemInfo
---@field DrawTime int32

---@class LotteryData
---@field ID int32
---@field GiftProgressRewards ProgressReward[]
---@field LotteryRule FString
---@field DailyDrawLimit int32
---@field DailyDrawGroup int32
---@field OverrideDropID int32
---@field DropGroupID int32
---@field DrawCostID int32
---@field TenDrawCostNum int32
---@field OverrideGuarantDropID int32
---@field GuarantDropGroupID int32
---@field IsFirstDrawDiscountOpen bool
---@field FirstDrawDiscountCost int32
---@field FirstDrawDiscountResetType ELotteryResetType
---@field OverrideFirstDrawGuarantDropID int32
---@field FirstDrawGuarantDropGroupID int32
---@field FirstDrawGuarantResetType ELotteryResetType
---@field OneDrawCostNum int32
---@field Name FString
---@field Icon FSoftObjectPath

---@class ProgressItem
---@field ItemID int32
---@field ItemCount int32

---@class ProgressReward
---@field Progress int32
---@field ItemList ProgressItem[]
---@field Desc FString

---@class ShopV2_ItemQuality
---@field ItemID int32
---@field QualityRank int32

---@class ShopV2_TabInfo
---@field TabID int32
---@field TabName FString
---@field TabShopName FString
---@field TabShopDesc FString

