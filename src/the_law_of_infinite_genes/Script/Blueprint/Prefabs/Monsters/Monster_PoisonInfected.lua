---@class Monster_PoisonInfected_C:BaseMonster_C
--Edit Below--
local Monster_PoisonInfected = {}

-- function Monster_PoisonInfected:ReceiveBeginPlay()
--     Monster_PoisonInfected.SuperClass.ReceiveBeginPlay(self)
-- end

-- function Monster_PoisonInfected:ReceiveTick(DeltaTime)
--     Monster_PoisonInfected.SuperClass.ReceiveTick(self, DeltaTime)
-- end

-- function Monster_PoisonInfected:ReceiveEndPlay()
--     Monster_PoisonInfected.SuperClass.ReceiveEndPlay(self) 
-- end

-- function Monster_PoisonInfected:GetReplicatedProperties()
--     return
-- end

-- ---受击前置事件
-- ---生效范围：服务器
-- ---@param Damage float 伤害值
-- ---@param EventInstigator AController 伤害来源的Controller
-- ---@param DamageCauser AActor 伤害来源
-- ---@param DamageContext FGameMagnitudeContext  伤害上下文
-- function Monster_PoisonInfected:PreTakeDamageEvent(Damage, EventInstigator, DamageCauser, DamageContext)
     
-- end

-- ---受击后置事件
-- ---生效范围：服务器
-- ---@param Damage float 伤害值
-- ---@param EventInstigator AController 伤害来源的Controller
-- ---@param DamageCauser AActor 伤害来源
-- ---@param DamageContext FGameMagnitudeContext  伤害上下文
-- function Monster_PoisonInfected:PostTakeDamageEvent(Damage, EventInstigator, DamageCauser, DamageContext)
    
-- end

-- ---受击前置伤害修改
-- ---生效范围：服务器
-- ---@param Damage float 伤害值
-- ---@param EventInstigator AController 伤害来源的Controller
-- ---@param DamageCauser AActor 伤害来源
-- ---@param DamageContext FGameMagnitudeContext  伤害上下文
-- ---@return float 修改后的伤害值
-- function Monster_PoisonInfected:PreOverrideDamage(Damage, EventInstigator, DamageCauser, DamageContext)
--     return Damage
-- end

-- ---受击后置伤害修改
-- ---生效范围：服务器
-- ---@param Damage float 伤害值
-- ---@param EventInstigator AController 伤害来源的Controller
-- ---@param DamageCauser AActor 伤害来源
-- ---@param DamageContext FGameMagnitudeContext  伤害上下文
-- ---@return float 修改后的伤害值
-- function Monster_PoisonInfected:PostOverrideDamage(Damage, EventInstigator, DamageCauser, DamageContext)
--     return Damage
-- end

---角色死亡事件
---生效范围：服务器&客户端
---@param KillingDamage float 伤害值
---@param EventInstigator AController 伤害来源的Controller
---@param DamageCauser AActor 伤害来源
---@param DamageEvent DamageEvent 伤害事件
---@param DamageTypeID int32 伤害类型
function Monster_PoisonInfected:BPDie(KillingDamage, EventInstigator, DamageCauser, DamageEvent, DamageTypeID)
    Monster_PoisonInfected.SuperClass.BPDie(self, KillingDamage, EventInstigator, DamageCauser, DamageEvent, DamageTypeID)
end

-- ---状态进入事件
-- ---生效范围：服务器&客户端
-- ---@param DynamicState FGameplayTag 进入的状态
-- function Monster_PoisonInfected:OnEnterTagState_BP(DynamicState)
--     local Tag = BlueprintGameplayTagLibrary.GetTagName(DynamicState)
--     ugcprint('OnEnterTagState_BP: ' .. Tag)
-- end

-- ---状态退出事件
-- ---生效范围：服务器&客户端
-- ---@param DynamicState FGameplayTag 退出的状态
-- function Monster_PoisonInfected:OnLeaveTagState_BP(DynamicState)
--     local Tag = BlueprintGameplayTagLibrary.GetTagName(DynamicState)
--     ugcprint('OnLeaveTagState_BP: ' .. Tag)
-- end

-- ---状态打断事件
-- ---生效范围：服务器&客户端
-- ---@param DynamicState FGameplayTag 打断的状态
-- function Monster_PoisonInfected:OnInterruptTagState_BP(DynamicState)
--     local Tag = BlueprintGameplayTagLibrary.GetTagName(DynamicState)
--     ugcprint('OnInterruptTagState_BP' .. Tag)
-- end

-- ---行为树消息
-- ---生效范围：服务器
-- ---@param NotifyMsg string 消息
-- function Monster_PoisonInfected:OnBehaviorNotify_BP(NotifyMsg)
--     ugcprint('OnBehaviorNotify_BP: ' .. NotifyMsg)
-- end

-- ---怪物的目标发生变化事件
-- ---生效范围：服务器&客户端
-- ---@param NewTarget AActor 新目标
-- ---@param OldTarget AActor 旧目标
-- function Monster_PoisonInfected:OnTargetChange_BP(NewTarget, OldTarget)
    
-- end

return Monster_PoisonInfected