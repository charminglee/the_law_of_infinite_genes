-- auto exported UStruct while compiling 

-- sorted by struct name asc 

---@class F_PassConfig
---@field PassID int32
---@field TaskLineName FString
---@field AdvancedPassProductID int32
---@field UltraPassProductID int32
---@field LevelPurchaseItemID int32
---@field LevelPurchaseItemNum int32
---@field SkipTaskProductID int32
---@field ThemeName FString
---@field ThemeIcon FSoftObjectPath
---@field BasePassName FString
---@field BasePassIcon FSoftObjectPath
---@field AdvancedPassName FString
---@field AdvancedPassIcon FSoftObjectPath
---@field Awards UDataTable
---@field Tasks UDataTable

---@class FModeConfig
---@field ModeID int32
---@field ModeName FText
---@field Difficulty FText
---@field LevelCount int32
---@field UnlockDesc FText
---@field UnlockMode int32[]
---@field EnemyRefresh int32
---@field ItemRefresh int32
---@field ShopAfterLevel int32[]
---@field TrapRefresh int32
---@field SettlementExpCount int32
---@field SettlementTalentCount int32
---@field GameModeActorMgr FString
---@field FreeReviveCount int32
---@field PaidReviveCount  int32
---@field Price int32[]
---@field SkyBox FString

---@class F_PassAwardConfig
---@field Point int32
---@field NormalItemID int32
---@field NormalNum int32
---@field AdvancedItemID int32
---@field AdvancedNum int32

---@class F_PassTaskConfig
---@field TaskIndex int32
---@field Week int32
---@field SkipItemNum int32

---@class FModeDetail
---@field ID int32
---@field ModeName FText
---@field ModeDesc FText
---@field ModeBanner UTexture2D
---@field ModePost UTexture2D
---@field ModeIDs int32[]
---@field Hide bool

---@class GiftPackData
---@field ID int32
---@field ItemID int32
---@field GiftPackType EGiftPackType
---@field OpenWay EGiftPackOpenType
---@field DropID int32
---@field DropGroupID int32

---@class UGCTemplateRowStruct_itemTable
---@field name FString
---@field quality int32
---@field ItemType int32
---@field Desc FString
---@field path FString

---@class UGCTemplateRowStruct_lobbyBtnName
---@field label FString

---@class UGCTemplateRowStruct_FightTabIcon
---@field ItemName FString
---@field path FSoftObjectPath

---@class UGCTemplateRowStruct_skill
---@field branch FString
---@field skill FString
---@field level int32
---@field property FString
---@field value float
---@field cost int32

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

---@class F_AwardConfig
---@field ItemID int32
---@field Num int32

---@class F_GetAdvancedPassInfo
---@field Title FString
---@field Icon FSoftObjectPath

---@class F_PassBonusArrayConfig
---@field AdvancedBonus F_PassBonusConfig[]
---@field UltraBonus F_PassBonusConfig[]

---@class F_PassBonusConfig
---@field Icon FSoftObjectPath
---@field Description FString

---@class F_PassPrizeArrayConfig
---@field NormalPrizeItemIDs F_PassPrizeConfig[]
---@field AdvancedPrizeItemIDs F_PassPrizeConfig[]
---@field UltraPrizeItemIDs F_PassPrizeConfig[]

---@class F_PassPrizeConfig
---@field ItemID int32
---@field Num int32

---@class ShopV2_ItemQuality
---@field ItemID int32
---@field QualityRank int32

---@class ShopV2_TabInfo
---@field TabID int32
---@field TabName FString
---@field TabShopName FString
---@field TabShopDesc FString

