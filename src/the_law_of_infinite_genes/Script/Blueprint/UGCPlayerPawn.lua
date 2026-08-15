---@class UGCPlayerPawn_C:BP_UGCPlayerPawn_C
---@field AttrManager AttrManager_C
--Edit Below--
local UGCPlayerPawn = {}

local RESPAWN_INVINCIBLE_DURATION = 5

---Pawn 生命周期入口，按运行端初始化物品、状态监听或本地引用。
function UGCPlayerPawn:ReceiveBeginPlay()
    UGCPlayerPawn.SuperClass.ReceiveBeginPlay(self)
    self.bVaultIsOpen = true
    self.IsOpenShovelAbility = true
    self.LastState = nil

    if Lib.IsServer() then
        self:InitializeStarterItems()
        self:InitInServer()
        return
    end

    if self == UGCGameSystem.GetLocalPlayerPawn() then
        LocalPlayerPawn = self ---@type UGCPlayerPawn_C
    end
    self:OnRep_CoverAllAvatarMeshInfo()
end

---Pawn 销毁时清理无敌 Timer 和本地 Pawn 引用。
function UGCPlayerPawn:ReceiveEndPlay()
    UGCPlayerPawn.SuperClass.ReceiveEndPlay(self)
    if self.InvincibleTimer then
        UGCTimerUtility.RemoveLuaTimer(self.InvincibleTimer)
        self.InvincibleTimer = nil
    end
    if not Lib.IsServer() and self == UGCGameSystem.GetLocalPlayerPawn() then
        LocalPlayerPawn = nil
    end
end

---服务端一次性发放初始物品；存档标记归 PlayerDataManager 管理。
function UGCPlayerPawn:InitializeStarterItems()
    Lib.CreateTimer(4, false, function ()
        -- 初始武器
        local weaponId = Config.InitialWeapon.WeaponId
        local bulletId = Config.InitialWeapon.BulletId
        local pdm = UGCGameSystem.GetPlayerStateByPlayerPawn(self).PlayerDataManager
        local isNotFirstJoin = pdm:GetCustomData("isNotFirstJoin")
        if isNotFirstJoin ~= 1 then
            UGCBackpackSystemV2.AddItemV2(self, weaponId, 1)
            UGCBackpackSystemV2.AddItemV2(self, bulletId, 300)
            pdm:SaveCustomData("isNotFirstJoin", 1)
        end
    end)
end

---服务端关闭死亡盒、监听复活消息并绑定动态状态变化。
function UGCPlayerPawn:InitInServer()
    UGCPlayerPawnSystem.SkipSpawnDeadTombBox(self, true)
    UGCGenericMessageSystem.ListenGlobalMessage(
        self,
        UGCGenericMessageSystem.Messages.UGC.PlayerPawn.PawnRespawn,
        self,
        self.SetIsInvincible_Lua
    )
    self.DynamicStateEnterHandle:Add(self.ChangeState, self)
    if self.DynamicStateExitHandle then
        self.DynamicStateExitHandle:Add(self.ChangeState, self)
    end
end

---目标 Pawn 复活后获得一段限时无敌效果。
---@param MessageOrPlayerKey any
---@param PlayerKey number|nil
function UGCPlayerPawn:SetIsInvincible_Lua(MessageOrPlayerKey, PlayerKey)
    PlayerKey = PlayerKey or MessageOrPlayerKey
    local OwnPlayerKey = UGCGameSystem.GetPlayerKeyByPlayerPawn(self)
    if PlayerKey ~= OwnPlayerKey then
        return
    end
    if self.InvincibleTimer then
        UGCTimerUtility.RemoveLuaTimer(self.InvincibleTimer)
    end

    UGCPlayerPawnSystem.SetIsInvincible(self, true)
    self.InvincibleTimer = UGCTimerUtility.CreateLuaTimer(RESPAWN_INVINCIBLE_DURATION, function()
        self.InvincibleTimer = nil
        UGCPlayerPawnSystem.SetIsInvincible(self, false)
    end, false)
end

---Pawn 只解释 GameplayTag，并把生存状态上报给 Controller。
function UGCPlayerPawn:ChangeState(CurState)
    if not Lib.IsServer() then
        return
    end

    local DyingTag = UGCGameplayTagSystem.RequestGameplayTag("PawnState.Dying")
    local DeadTag = UGCGameplayTagSystem.RequestGameplayTag("PawnState.Dead")
    local bDying = UGCGameplayTagSystem.IsValidTag(DyingTag)
        and UGCPersistEffectSystem.HasDynamicState(self, DyingTag)
    local bDead = UGCGameplayTagSystem.IsValidTag(DeadTag)
        and UGCPersistEffectSystem.HasDynamicState(self, DeadTag)

    local NewState = UGCGameData.AliveState.Alive
    if bDead then
        NewState = UGCGameData.AliveState.Dead
    elseif bDying then
        NewState = UGCGameData.AliveState.Dying
    end

    if self.LastState ~= NewState then
        local PC = UGCGameSystem.GetPlayerControllerByPlayerPawn(self)
        if PC then
            PC:ChangeState(NewState)
            self.LastState = NewState
        end
    end
    self.CapsuleComponent:SetCollisionObjectType(16)
end

---声明 Pawn 需要复制的子对象列表。
function UGCPlayerPawn:GetReplicatedProperties()
    return { "__SubObjectRepList", "Lazy" }
end

return UGCPlayerPawn
