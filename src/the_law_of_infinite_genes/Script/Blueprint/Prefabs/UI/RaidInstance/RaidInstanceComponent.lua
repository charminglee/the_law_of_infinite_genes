---@class RaidInstance_C:ActorComponent
---@field RaidInstancePath FSoftClassPath
--Edit Below--

UGCGameSystem.UGCRequire("Script.Blueprint.Prefabs.UI.RaidInstance.RaidInstanceManager");
local RaidInstanceComponent = {}


function RaidInstanceComponent:ReceiveBeginPlay()
    RaidInstanceComponent.SuperClass.ReceiveBeginPlay(self);
    if self:GetOwner():HasAuthority() == false then
        RaidInstanceManager:RegisterComponentClass(self);
    end
end

return RaidInstanceComponent
