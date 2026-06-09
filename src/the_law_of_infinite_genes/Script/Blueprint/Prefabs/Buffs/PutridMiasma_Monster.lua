---@class PutridMiasma_Monster_C:PersistEffectBuff
--Edit Below--
local PutridMiasma_Monster = {}
 

function PutridMiasma_Monster:AllAttrBuffFormula_Speed()
	local mul = SpecialEventConfig[SpecialEvent.PutridMiasma].InfectedAllAttrBuff
	return mul
end


function PutridMiasma_Monster:AllAttrBuffFormula_MaxHealth()
	local mul = SpecialEventConfig[SpecialEvent.PutridMiasma].InfectedAllAttrBuff
	return 1 + mul
end


function PutridMiasma_Monster:AllAttrBuffFormula_Health()
	local owner = self:GetOwnerActor()
	local health = UGCAttributeSystem.GetGameAttributeValue(owner, UGCNativeGameAttributeType.Character_Health)
	local maxHealth = UGCAttributeSystem.GetGameAttributeValueMax(owner, UGCNativeGameAttributeType.Character_Health)
	local mul = SpecialEventConfig[SpecialEvent.PutridMiasma].InfectedAllAttrBuff
	return math.floor(health + maxHealth * mul)
end


-- buff启动条件
--[[
function PutridMiasma_Monster:CanApply_BP(OwnerActor)
-- return true
end
--]]

-- buff开始
--[[
function PutridMiasma_Monster:OnApply_BP(OwnerActor)

end
--]]

-- buff结束
--[[
function PutridMiasma_Monster:OnUnApply_BP(OwnerActor, Reason)

end
--]]

-- buff合并条件，A为当前身上已有buff，B为外来buff，当要挂载外来buff时会判断A.CanMerge(B)
--[[
function PutridMiasma_Monster:CanMerge_BP(PersistEffect)
-- return true
end
--]]

-- buff合并，A为当前身上已有buff，B为外来buff，调用A.OnMerge(B)
--[[
function PutridMiasma_Monster:OnMerge_BP(PersistEffect)

end
--]]

-- 开启Tick需要SetTickEnable(true)，或buff为间隔触发类型会自动开启
--[[
function PutridMiasma_Monster:Tick_BP(OwnerActor, DeltaTime)

end
--]]

--[[
function PutridMiasma_Monster:OnInterrupted_BP(OwnerActor)

end
--]]

-- buff总持续时长变化，如修改ApplyTime、修改StackNum
--[[
function PutridMiasma_Monster:OnTotalDurationChange_BP(PreTime, CurTime)

end
--]]

-- buff堆叠层数变化
--[[
function PutridMiasma_Monster:OnStackChange_BP(PreNum, CurNum)

end
--]]

-- buff触发前条件判断
--[[
function PutridMiasma_Monster:CanTrigger_BP()
	return true
end
--]]

-- buff触发效果
--[[
function PutridMiasma_Monster:OnTrigger_BP(Delta)

end
--]]

return PutridMiasma_Monster