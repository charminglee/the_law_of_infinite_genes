local UGCPlayerController = {}

function UGCPlayerController:ReceiveBeginPlay()
    UGCPlayerController.SuperClass.ReceiveBeginPlay(self)
    if not self:HasAuthority() then
        return
    end

    -- 初始武器
    local WeaponId = 8310018
    local BulletId = 301001
    if not UGCBackPackSystem.IsAttachItemType(WeaponId) then
        local delegate = ObjectExtend.CreateDelegate(
            self, 
            function()
                local pawn = self:GetPlayerCharacterSafety()
                UGCBackPackSystem.AddItem(pawn, WeaponId, 1)
                UGCBackPackSystem.AddItem(pawn, BulletId, 500)
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