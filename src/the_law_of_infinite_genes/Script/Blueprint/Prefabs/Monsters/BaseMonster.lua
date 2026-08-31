---@class BaseMonster_C:BP_UGC_GenericMobPawn_Base_C
---@field AttrManager AttrManager_C
---@field HitBox UCapsuleComponent
--Edit Below--
local BaseMonster = {
    tag = nil,
}


function BaseMonster:ReceiveBeginPlay()
    BaseMonster.SuperClass.ReceiveBeginPlay(self)
end


---角色死亡事件
---生效范围：服务器&客户端
---@param KillingDamage float 伤害值
---@param EventInstigator AController 伤害来源的Controller
---@param DamageCauser AActor 伤害来源
---@param DamageEvent DamageEvent 伤害事件
---@param DamageTypeID int32 伤害类型
function BaseMonster:BPDie(KillingDamage, EventInstigator, DamageCauser, DamageEvent, DamageTypeID)
    if not Lib.IsServer() or not Lib.IsPlayer(EventInstigator) then
        return
    end

    self.UGCPresetCommonDropItemComponent:StartDrop(self, EventInstigator, {})

    -- 资源点掉落/称号条件相关逻辑
    local pdm = UGCGameSystem.GetPlayerStateByPlayerController(EventInstigator).PlayerDataManager
    local pam = UGCGameSystem.GetPlayerPawnByPlayerController(EventInstigator).AttrManager
    local playerHealth = UGCAttributeSystem.GetGameAttributeValue(EventInstigator, UGCNativeGameAttributeType.Character_Health)
    local playerHealthMax = pam:GetAttr(Attribute.HealthMax)
    local playerHealthPct = playerHealth / playerHealthMax

    local loot = GameFlowCfg.Resource.OnKill.Loot[self.tag]
    pdm:AddCoin(loot.ItemId, loot.Count, false)

    local score = GameFlowCfg.Resource.OnKill.Score[self.tag]
    GameState:AddScore(score)

    if self.tag == Tag.Boss then
        pdm:AddStat(Statistics.BossKillCount, 1, false)
    elseif self.tag == Tag.Elite then
        pdm:AddStat(Statistics.EliteMonsterKillCount, 1, false)
        if playerHealthPct > 0.5 then
            pdm:AddStat(Statistics.EliteMonsterKillCountHealthAboveHalf, 1, false)
        end
    else
        pdm:AddStat(Statistics.NormalMonsterKillCount, 1, false)
        if playerHealthPct > 0.5 then
            pdm:AddStat(Statistics.NormalMonsterKillCountHealthAboveHalf, 1, false)
        end
    end

    pdm:SyncData()
end


-- function BaseMonster:ReceiveTick(DeltaTime)
--     BaseMonster.SuperClass.ReceiveTick(self, DeltaTime)
-- end


-- function BaseMonster:ReceiveEndPlay()
--     BaseMonster.SuperClass.ReceiveEndPlay(self) 
-- end


-- function BaseMonster:GetReplicatedProperties()
--     return
-- end


-- ---受击前置事件
-- ---生效范围：服务器
-- ---@param Damage float 伤害值
-- ---@param EventInstigator AController 伤害来源的Controller
-- ---@param DamageCauser AActor 伤害来源
-- ---@param DamageContext FGameMagnitudeContext  伤害上下文
-- function BaseMonster:PreTakeDamageEvent(Damage, EventInstigator, DamageCauser, DamageContext)

-- end


-- ---受击后置事件
-- ---生效范围：服务器
-- ---@param Damage float 伤害值
-- ---@param EventInstigator AController 伤害来源的Controller
-- ---@param DamageCauser AActor 伤害来源
-- ---@param DamageContext FGameMagnitudeContext  伤害上下文
-- function BaseMonster:PostTakeDamageEvent(Damage, EventInstigator, DamageCauser, DamageContext)

-- end


-- ---受击前置伤害修改
-- ---生效范围：服务器
-- ---@param Damage float 伤害值
-- ---@param EventInstigator AController 伤害来源的Controller
-- ---@param DamageCauser AActor 伤害来源
-- ---@param DamageContext FGameMagnitudeContext  伤害上下文
-- ---@return float 修改后的伤害值
-- function BaseMonster:PreOverrideDamage(Damage, EventInstigator, DamageCauser, DamageContext)
--     return Damage
-- end


-- ---受击后置伤害修改
-- ---生效范围：服务器
-- ---@param Damage float 伤害值
-- ---@param EventInstigator AController 伤害来源的Controller
-- ---@param DamageCauser AActor 伤害来源
-- ---@param DamageContext FGameMagnitudeContext  伤害上下文
-- ---@return float 修改后的伤害值
-- function BaseMonster:PostOverrideDamage(Damage, EventInstigator, DamageCauser, DamageContext)
--     return Damage
-- end


-- ---状态进入事件
-- ---生效范围：服务器&客户端
-- ---@param DynamicState FGameplayTag 进入的状态
-- function BaseMonster:OnEnterTagState_BP(DynamicState)
--     local Tag = BlueprintGameplayTagLibrary.GetTagName(DynamicState)
--     ugcprint('OnEnterTagState_BP: ' .. Tag)
-- end


-- ---状态退出事件
-- ---生效范围：服务器&客户端
-- ---@param DynamicState FGameplayTag 退出的状态
-- function BaseMonster:OnLeaveTagState_BP(DynamicState)
--     local Tag = BlueprintGameplayTagLibrary.GetTagName(DynamicState)
--     ugcprint('OnLeaveTagState_BP: ' .. Tag)
-- end


-- ---状态打断事件
-- ---生效范围：服务器&客户端
-- ---@param DynamicState FGameplayTag 打断的状态
-- function BaseMonster:OnInterruptTagState_BP(DynamicState)
--     local Tag = BlueprintGameplayTagLibrary.GetTagName(DynamicState)
--     ugcprint('OnInterruptTagState_BP' .. Tag)
-- end


-- ---行为树消息
-- ---生效范围：服务器
-- ---@param NotifyMsg string 消息
-- function BaseMonster:OnBehaviorNotify_BP(NotifyMsg)
--     ugcprint('OnBehaviorNotify_BP: ' .. NotifyMsg)
-- end


-- ---怪物的目标发生变化事件
-- ---生效范围：服务器&客户端
-- ---@param NewTarget AActor 新目标
-- ---@param OldTarget AActor 旧目标
-- function BaseMonster:OnTargetChange_BP(NewTarget, OldTarget)

-- end


-- [Editor Generated Lua] function define Begin:
function BaseMonster:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:
    -- self.UGCPresetCommonDropItemComponent.OnDropItem:Add(self.UGCPresetCommonDropItemComponent_OnDropItem, self);
    -- [Editor Generated Lua] BindingEvent End;
end


-- function BaseMonster:UGCPresetCommonDropItemComponent_OnDropItem(ItemActor)
-- 	return nil;
-- end
-- [Editor Generated Lua] function define End;


return BaseMonster