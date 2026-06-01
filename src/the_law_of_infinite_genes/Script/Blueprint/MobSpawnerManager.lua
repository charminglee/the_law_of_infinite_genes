---@class MobSpawnerManager: AUGCMobSpawnerManager
local MobSpawnerManager = {}


local GameState = UGCGameSystem.GetGameState()


function MobSpawnerManager:ReceiveBeginPlay()
    MobSpawnerManager.SuperClass.ReceiveBeginPlay(self)
end


function MobSpawnerManager:OnWaveStart(waveIndex)
    GameState.waveIndex = waveIndex

    if not UGCGameSystem.IsServer() then
        return
    end

    -- 根据波次控制刷怪数量
    local spawnerCount = self:GetWaveSpawnerNum(waveIndex)
    local spawnCount = math.floor(self:SpawnCountFormula(waveIndex) / spawnerCount)
    for i = 0, spawnerCount - 1 do
        local spawner = self:GetSpawner(waveIndex, i)
        spawner:ModifyMinMaxSpawnCount(spawnCount, spawnCount)
    end
end


---每波刷怪数量 = (20 + 波次) * 存活玩家数
function MobSpawnerManager:SpawnCountFormula(n)
    local survivors = 0
    local playerKeys = UGCGameSystem.GetAllPlayerKey(false)
    for _, k in pairs(playerKeys) do
        if UGCPlayerStateSystem.IsAlive(k) then
            survivors = survivors + 1
        end
    end
    return (20 + n) * survivors
end


--[[
function MobSpawnerManager:OnMobSpawn(MobPawn)
    
end
--]]


--[[
function MobSpawnerManager:OnWaveEnd(WaveIndex)
    
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