---@class UGCPlayerController: ASTExtraPlayerController
local UGCPlayerController = {}


function UGCPlayerController:ReceiveBeginPlay()
    UGCPlayerController.SuperClass.ReceiveBeginPlay(self)
    if not UGCGameSystem.IsServer() then
        return
    end

    -- 初始武器
    local weaponId = 8310018
    local bulletId = 301001
    if not UGCBackPackSystem.IsAttachItemType(weaponId) then
        local delegate = ObjectExtend.CreateDelegate(
            self, 
            function()
                UGCPlayerControllerSystem.TeleportTo(self, 3634, 10340, 90)
                local spawnerManager = UGCActorComponentUtility.GetActorByActorInstancePath("UGCmap.MobSpawnerManager_10")
                spawnerManager:StartSpawnerManager()
                local pawn = self:GetPlayerCharacterSafety()
                UGCBackPackSystem.AddItem(pawn, weaponId, 1)
                UGCBackPackSystem.AddItem(pawn, bulletId, 100)
                UGCBackPackSystem.AddItem(pawn, bulletId, 100)
                UGCBackPackSystem.AddItem(pawn, bulletId, 100)
            end
        )
        KismetSystemLibrary.K2_SetTimerDelegateForLua(delegate, self, 2, false)
    end
end


--[[
function UGCPlayerController:ReceiveTick(DeltaTime)
    UGCPlayerController.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]


--[[
function UGCPlayerController:ReceiveEndPlay()
    UGCPlayerController.SuperClass.ReceiveEndPlay(self) 
end
--]]


--[[
function UGCPlayerController:GetReplicatedProperties()
    return
end
--]]


--[[
function UGCPlayerController:GetAvailableServerRPCs()
    return
end
--]]


return UGCPlayerController