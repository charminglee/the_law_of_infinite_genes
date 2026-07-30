---@class MobSpawnerManager_C: AUGCMobSpawnerManager
local MobSpawnerManager = {
    waveIndex = 0,              -- 当前波数
    ---@type MobSpawner_C[]
    spawners = {},              -- 刷怪点列表
    spawnerCount = 0,           -- 刷怪点数量
    isInSpawnInterval = false,  -- 是否处于两个波次之间的间隔时间
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


function MobSpawnerManager:ReceiveBeginPlay()
    MobSpawnerManager.SuperClass.ReceiveBeginPlay(self)
    GameState.MobSpawnerManager = self

    self.spawnerCount = self:GetWaveSpawnerNum(0)
    for i = 0, self.spawnerCount - 1 do
        local spawner = self:GetSpawner(0, i)
        table.insert(self.spawners, spawner)
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
end


---【服务端】启动下一波刷怪。
function MobSpawnerManager:NextWave()
    if self.waveIndex > 0 then
        self:StopSpawnerManager()
        self:JumpToWave(0)
    end
    self.isInSpawnInterval = true
    UGCTimerUtility.CreateUETimer(
        function()
            self:_StartWave()
        end, 
        Config.Common.SpawnerDelay, 
        false
    )
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


--[[
function MobSpawnerManager:OnAllMobDie()
    
end
--]]


return MobSpawnerManager