---@class MobSpawnerManager_C:BP_UGCMobSpawnerManager_C
--Edit Below--
local MobSpawnerManager = {
    waveIndex = 0,              -- 当前波数
    ---@type MobSpawner_C[]
    spawners = {},              -- 刷怪点列表
    isInSpawnInterval = false,  -- 是否处于两个波次之间的间隔时间
    ---@type UClass[]
    spawnQueue = {},            -- 本波待刷新的怪物类队列
    spawnTimer = 0,             -- 距离下一只怪的刷怪计时
    ---@type table<string, table<number, {ItemId: number, Count: number}[]>>
    rewardsRecord = {},
}


local SPAWNER_LOC = {
    { X=13420, Y=13200, Z=0 },
    { X=3670, Y=2780, Z=0 },
    { X=3130, Y=10960, Z=190 },
    { X=13960, Y=5010, Z=0 },
}


local _maxMonsterGroupIndex = nil


local function _SpawnCountFormula(n)
    -- 每波刷怪数量 = (20 + 波次) * 存活玩家数
    local survivors = 0
    local playerKeys = UGCGameSystem.GetAllPlayerKey(false)
    for _, k in pairs(playerKeys) do
        if UGCPlayerStateSystem.IsAlive(k) then
            survivors = survivors + 1
        end
    end
    return (20 + n) * survivors
end


---将总刷怪数按权重分配到各怪物配置。
---使用最大余数法使各怪物数量尽量贴近权重比例，并尽可能保证每种怪至少出现一只，而不是对每只怪独立做完全随机的加权抽取。
---@param mobConfigList table @怪物配置列表
---@param totalCount number @总刷怪数
---@return table<number, number> @配置索引 -> 刷怪数量
local function _DistributeSpawnCount(mobConfigList, totalCount)
    local result = {}
    local typeCount = #mobConfigList
    if typeCount == 0 or totalCount <= 0 then
        return result
    end

    -- 收集有效权重（缺省或非正数按1处理，保证该种类仍有机会出现）
    local weights = {}
    local totalWeight = 0
    for i, mobConfig in ipairs(mobConfigList) do
        local weight = mobConfig.Weight
        if weight == nil or weight <= 0 then
            weight = 1
        end
        weights[i] = weight
        totalWeight = totalWeight + weight
    end
    if totalWeight <= 0 then
        for i = 1, typeCount do
            weights[i] = 1
        end
        totalWeight = typeCount
    end

    -- 名额少于种类数时无法让每种怪都出现，按权重不放回抽取，先保证种类不重复
    if totalCount < typeCount then
        local candidates = {}
        for i = 1, typeCount do
            candidates[i] = i
            result[i] = 0
        end
        for _ = 1, totalCount do
            local weightSum = 0
            for _, index in ipairs(candidates) do
                weightSum = weightSum + weights[index]
            end

            local pick = math.random(1, weightSum)
            local acc = 0
            local chosenSlot = #candidates
            for slot, index in ipairs(candidates) do
                acc = acc + weights[index]
                if pick <= acc then
                    chosenSlot = slot
                    break
                end
            end

            result[candidates[chosenSlot]] = 1
            table.remove(candidates, chosenSlot)
        end
        return result
    end

    -- 先按权重比例取整分配
    local remainders = {}
    local allocated = 0
    for i = 1, typeCount do
        local quota = totalCount * weights[i] / totalWeight
        result[i] = math.floor(quota)
        remainders[i] = quota - result[i]
        allocated = allocated + result[i]
    end

    -- 剩余名额按小数余量从大到小补齐（同余量时权重大的优先）
    local order = {}
    for i = 1, typeCount do
        order[i] = i
    end
    table.sort(order, function(a, b)
        if math.abs(remainders[a] - remainders[b]) > 0.000001 then
            return remainders[a] > remainders[b]
        end
        return weights[a] > weights[b]
    end)

    local slot = 1
    while allocated < totalCount do
        local index = order[slot]
        result[index] = result[index] + 1
        allocated = allocated + 1
        slot = slot + 1
        if slot > typeCount then
            slot = 1
        end
    end

    -- 尽可能保证每种怪至少一只：从占比超出权重最多的种类腾出名额
    for i = 1, typeCount do
        if result[i] == 0 then
            local lender = 0
            local lenderRatio = 0
            for j = 1, typeCount do
                if result[j] > 1 then
                    local ratio = result[j] / weights[j]
                    if ratio > lenderRatio then
                        lenderRatio = ratio
                        lender = j
                    end
                end
            end

            if lender > 0 then
                result[lender] = result[lender] - 1
                result[i] = 1
            else
                -- 没有可腾出的名额（理论上不会发生，因为 totalCount >= typeCount）
                break
            end
        end
    end

    return result
end


---生成本波怪物类列表，各类数量按权重分配，顺序随机。
local function _BuildWaveMobClassList(mobConfigList, totalCount)
    local distribution = _DistributeSpawnCount(mobConfigList, totalCount)
    local mobClassList = {}
    for i, mobConfig in ipairs(mobConfigList) do
        local spawnParam = mobConfig.SpawnParam
        local mobClass = Lib.GetClass(spawnParam.MobClass)
        local count = distribution[i] or 0
        if mobClass ~= nil then
            for _ = 1, count do
                table.insert(mobClassList, mobClass)
            end
        end
    end
    -- 打乱顺序，避免同种怪集中在一起刷新
    Lib.Random.Shuffle(mobClassList)
    return mobClassList
end


function MobSpawnerManager:GetReplicatedProperties()
    return { "waveIndex", "Lazy" }
end


function MobSpawnerManager:ReceiveBeginPlay()
    MobSpawnerManager.SuperClass.ReceiveBeginPlay(self)
    GameState.MobSpawnerManager = self

    if Lib.IsServer() then
        local spawnerCount = self:GetWaveSpawnerNum(0)
        for i = 0, spawnerCount - 1 do
            local spawner = self:GetSpawner(0, i)
            if spawner ~= nil then
                --table.insert(self.spawners, spawner)
                -- 关闭自动刷怪，需手动刷怪
                spawner:ModifyMinMaxSpawnCount(0, 0)
            end
        end
    end
end


function MobSpawnerManager:ReceiveEndPlay()
    MobSpawnerManager.SuperClass.ReceiveEndPlay(self)
    GameState.MobSpawnerManager = nil
    self.spawnQueue = {}
    self.spawnTimer = 0
end


function MobSpawnerManager:ReceiveTick(deltaTime)
    MobSpawnerManager.SuperClass.ReceiveTick(self, deltaTime)

    if not Lib.IsServer() or #self.spawnQueue == 0 then
        return
    end

    -- 按固定间隔逐只刷新；帧时间较长时补刷落后的只数
    self.spawnTimer = self.spawnTimer + deltaTime
    while #self.spawnQueue > 0 and self.spawnTimer >= GameFlowCfg.SpawnInterval do
        self.spawnTimer = self.spawnTimer - GameFlowCfg.SpawnInterval
        self:_SpawnNextMob()
    end

    if #self.spawnQueue == 0 then
        self.spawnTimer = 0
    end
end


function MobSpawnerManager:OnAllMobDie()
    if GameFlowCfg.Resource.BossLoot.WaveMultiplier[self.waveIndex] then
        self:_DropBossReward()
    end
    self:NextWave()
end


function MobSpawnerManager:_DropBossReward()
    local bossLoot = GameFlowCfg.Resource.BossLoot
    local difficulty = GameState.difficulty
    local difficultyMultiplier = bossLoot.DifficultyMultiplier[difficulty]
    local waveMultiplier = bossLoot.WaveMultiplier[self.waveIndex]
    local mul = difficultyMultiplier * waveMultiplier
    local allPlayers = UGCGameSystem.GetAllPlayerController(false)
    local difficultyIndex = {
        [Difficulty.Simple] = 0,
        [Difficulty.Normal] = 1,
        [Difficulty.Hard] = 2,
        [Difficulty.Nightmare] = 3,
    }

    for _, material in pairs(bossLoot.RewardPool) do
        if difficultyIndex[difficulty] >= difficultyIndex[material.MinDifficulty] then
            local baseCount = math.random(material.Min, material.Max)
            local count = math.ceil(baseCount * mul)

            for _, player in pairs(allPlayers) do
                UGCBackpackSystemV2.AddItemV2(player, material.ItemId, count)

                local record = Lib.Table.SetDefault(self.rewardsRecord, player.PlayerUID, {})
                local byWave = Lib.Table.SetDefault(record, self.waveIndex, {})
                table.insert(byWave, { ItemId = material.ItemId, Count = count })
            end
        end
    end
end


function MobSpawnerManager:_StartWave()
    self.waveIndex = self.waveIndex + 1
    self.isInSpawnInterval = false

    UnrealNetwork.RepLazyProperty(self, "waveIndex")
    Lib.EventSystem.Broadcast(Event.OnWaveStart, self.waveIndex)

    -- 丢弃上一波可能残留的待刷新队列
    self.spawnQueue = {}
    self.spawnTimer = 0

    local monsterGroup = GameFlowCfg.MonsterGroups[self.waveIndex]
    if monsterGroup == nil or monsterGroup.MobConfigList == nil or #SPAWNER_LOC == 0 then
        return
    end

    local totalCount = _SpawnCountFormula(self.waveIndex)
    self.spawnQueue = _BuildWaveMobClassList(monsterGroup.MobConfigList, totalCount)

    -- 第一只立即刷新，其余在 ReceiveTick 逐只刷新
    self:_SpawnNextMob()
end


---【服务端】从待刷新队列取出一只怪，随机挑选一个刷怪点刷新。
function MobSpawnerManager:_SpawnNextMob()
    local mobClass = table.remove(self.spawnQueue, 1)
    if mobClass == nil then
        return false
    end
    local loc = Lib.Random.Pick(SPAWNER_LOC)
    local rot = { Pitch=0, Yaw=0, Roll=0 }
    print("114514 "..tostring(loc).." "..tostring(rot))
    UGCMobPawnSystem.SpawnMob(self, mobClass, loc, rot)
    return true
end


---【服务端】启动下一波刷怪。
function MobSpawnerManager:NextWave()
    if not Lib.IsServer() then
        return
    end
    if GameFlowCfg.MonsterGroups[self.waveIndex + 1] == nil then
        return
    end
    self.isInSpawnInterval = true
    Lib.CreateTimer(GameFlowCfg.SpawnerDelay, false, self._StartWave, self)
end


--[[
function MobSpawnerManager:OnMobSpawn(mobPawn)

end
--]]


--[[
function MobSpawnerManager:OnWaveEnd(waveIndex)

end
--]]


--[[
function MobSpawnerManager:OnAllWaveEnd()

end
--]]


return MobSpawnerManager
