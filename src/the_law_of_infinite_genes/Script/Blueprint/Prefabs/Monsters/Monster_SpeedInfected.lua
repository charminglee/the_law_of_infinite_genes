---@class Monster_SpeedInfected_C:BaseMonster_C
--Edit Below--
local Monster_SpeedInfected = {}

-- function Monster_SpeedInfected:ReceiveBeginPlay()
--     Monster_SpeedInfected.SuperClass.ReceiveBeginPlay(self)
-- end

-- function Monster_SpeedInfected:ReceiveTick(DeltaTime)
--     Monster_SpeedInfected.SuperClass.ReceiveTick(self, DeltaTime)
-- end

-- function Monster_SpeedInfected:ReceiveEndPlay()
--     Monster_SpeedInfected.SuperClass.ReceiveEndPlay(self) 
-- end

-- function Monster_SpeedInfected:GetReplicatedProperties()
--     return
-- end

-- ---受击前置事件
-- ---生效范围：服务器
-- ---@param Damage float 伤害值
-- ---@param EventInstigator AController 伤害来源的Controller
-- ---@param DamageCauser AActor 伤害来源
-- ---@param DamageContext FGameMagnitudeContext  伤害上下文
-- function Monster_SpeedInfected:PreTakeDamageEvent(Damage, EventInstigator, DamageCauser, DamageContext)
     
-- end

-- ---受击后置事件
-- ---生效范围：服务器
-- ---@param Damage float 伤害值
-- ---@param EventInstigator AController 伤害来源的Controller
-- ---@param DamageCauser AActor 伤害来源
-- ---@param DamageContext FGameMagnitudeContext  伤害上下文
-- function Monster_SpeedInfected:PostTakeDamageEvent(Damage, EventInstigator, DamageCauser, DamageContext)
    
-- end

-- ---受击前置伤害修改
-- ---生效范围：服务器
-- ---@param Damage float 伤害值
-- ---@param EventInstigator AController 伤害来源的Controller
-- ---@param DamageCauser AActor 伤害来源
-- ---@param DamageContext FGameMagnitudeContext  伤害上下文
-- ---@return float 修改后的伤害值
-- function Monster_SpeedInfected:PreOverrideDamage(Damage, EventInstigator, DamageCauser, DamageContext)
--     return Damage
-- end

-- ---受击后置伤害修改
-- ---生效范围：服务器
-- ---@param Damage float 伤害值
-- ---@param EventInstigator AController 伤害来源的Controller
-- ---@param DamageCauser AActor 伤害来源
-- ---@param DamageContext FGameMagnitudeContext  伤害上下文
-- ---@return float 修改后的伤害值
-- function Monster_SpeedInfected:PostOverrideDamage(Damage, EventInstigator, DamageCauser, DamageContext)
--     return Damage
-- end

---角色死亡事件
---生效范围：服务器&客户端
---@param KillingDamage float 伤害值
---@param EventInstigator AController 伤害来源的Controller
---@param DamageCauser AActor 伤害来源
---@param DamageEvent DamageEvent 伤害事件
---@param DamageTypeID int32 伤害类型
function Monster_SpeedInfected:BPDie(KillingDamage, EventInstigator, DamageCauser, DamageEvent, DamageTypeID)
    Monster_SpeedInfected.SuperClass.BPDie(self, KillingDamage, EventInstigator, DamageCauser, DamageEvent, DamageTypeID)
end

-- ---状态进入事件
-- ---生效范围：服务器&客户端
-- ---@param DynamicState FGameplayTag 进入的状态
-- function Monster_SpeedInfected:OnEnterTagState_BP(DynamicState)
--     local Tag = BlueprintGameplayTagLibrary.GetTagName(DynamicState)
--     ugcprint('OnEnterTagState_BP: ' .. Tag)
-- end

-- ---状态退出事件
-- ---生效范围：服务器&客户端
-- ---@param DynamicState FGameplayTag 退出的状态
-- function Monster_SpeedInfected:OnLeaveTagState_BP(DynamicState)
--     local Tag = BlueprintGameplayTagLibrary.GetTagName(DynamicState)
--     ugcprint('OnLeaveTagState_BP: ' .. Tag)
-- end

-- ---状态打断事件
-- ---生效范围：服务器&客户端
-- ---@param DynamicState FGameplayTag 打断的状态
-- function Monster_SpeedInfected:OnInterruptTagState_BP(DynamicState)
--     local Tag = BlueprintGameplayTagLibrary.GetTagName(DynamicState)
--     ugcprint('OnInterruptTagState_BP' .. Tag)
-- end

-- ---行为树消息
-- ---生效范围：服务器
-- ---@param NotifyMsg string 消息
-- function Monster_SpeedInfected:OnBehaviorNotify_BP(NotifyMsg)
--     ugcprint('OnBehaviorNotify_BP: ' .. NotifyMsg)
-- end

-- ---怪物的目标发生变化事件
-- ---生效范围：服务器&客户端
-- ---@param NewTarget AActor 新目标
-- ---@param OldTarget AActor 旧目标
-- function Monster_SpeedInfected:OnTargetChange_BP(NewTarget, OldTarget)
    
-- end

return Monster_SpeedInfected