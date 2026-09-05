---@class MobSpawnerManager_C:BP_UGCMobSpawnerManager_C
--Edit Below--
local MobSpawnerManager = {
    waveIndex = 0,              -- 当前波数
    ---@type MobSpawner_C[]
    spawners = {},              -- 刷怪点列表
    spawnerCount = 0,           -- 刷怪点数量
    isInSpawnInterval = false,  -- 是否处于两个波次之间的间隔时间
    ---@type table<string, table<number, {ItemId: number, Count: number}[]>>
    rewardsRecord = {},
}


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


function MobSpawnerManager:GetReplicatedProperties()
    return { "waveIndex", "Lazy" }
end


function MobSpawnerManager:ReceiveBeginPlay()
    MobSpawnerManager.SuperClass.ReceiveBeginPlay(self)
    GameState.MobSpawnerManager = self

    if Lib.IsServer() then
        self.spawnerCount = self:GetWaveSpawnerNum(0)
        for i = 0, self.spawnerCount - 1 do
            local spawner = self:GetSpawner(0, i)
            table.insert(self.spawners, spawner)
        end
    end
end


function MobSpawnerManager:ReceiveEndPlay()
    MobSpawnerManager.SuperClass.ReceiveEndPlay(self)
    GameState.MobSpawnerManager = nil
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

    for _, material in pairs(bossLoot.RewardPool) do
        if difficultyMultiplier >= material.MinDifficulty then
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

    -- 根据波次控制刷怪数量
    local count = math.floor(_SpawnCountFormula(self.waveIndex) / self.spawnerCount)
    for _, spawner in pairs(self.spawners) do
        spawner:ModifyMinMaxSpawnCount(count, count)
    end

    -- 设置刷怪表
    local mobConfig = {
        ConfigMode = EUGCMobSpawnerConfigMode.MobGroup,
        MobGroupID = self.waveIndex - 1,
    }
    self:SetMobConfigOverride(mobConfig)
    self:StartSpawnerManager()
    
    UnrealNetwork.RepLazyProperty(self, "waveIndex")
    Lib.EventSystem.Broadcast(Event.OnWaveStart, self.waveIndex)
end


---【服务端】启动下一波刷怪。
function MobSpawnerManager:NextWave()
    if not Lib.IsServer() then
        return
    end
    if self.waveIndex > 0 then
        self:StopSpawnerManager()
        self:JumpToWave(0)
    end
    self.isInSpawnInterval = true
    Lib.CreateTimer(GameFlowCfg.SpawnerDelay, false, self._StartWave, self)
end


-- function MobSpawnerManager:OnWaveStart(waveIndex)
    
-- end


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