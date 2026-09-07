---@class Lib
Lib = {
    ---@type EventSystem
    EventSystem = UGCGameSystem.UGCRequire("Script.Lib.Utils.EventSystem"),
    ---@type Table
    Table = UGCGameSystem.UGCRequire("Script.Lib.Utils.Table"),
    ---@type Math
    Math = UGCGameSystem.UGCRequire("Script.Lib.Math.Math"),
    ---@type Random
    Random = UGCGameSystem.UGCRequire("Script.Lib.Math.Random"),
}


local _UGCGameSystem = UGCGameSystem
UGCGameSystem = setmetatable({}, {
    __index = _UGCGameSystem,
    __newindex = function(t, k, v)
        if k == "GameMode" then
            GameMode = v ---@type UGCGameMode_C
        elseif k == "GameState" then
            GameState = v ---@type UGCGameState_C
        end
        _UGCGameSystem[k] = v
    end
})


---@alias SupportToTable ItemDefineID


---【双端】将 UE 对象转换为 Lua table 。
---目前仅支持以下类型的 UE 对象： `ItemDefineID`
---@param obj SupportToTable @对象
---@return table @表
function Lib.ToTable(obj)
    local t = {}
    t.Type           = obj.Type or nil
    t.TypeSpecificID = obj.TypeSpecificID or nil
    t.bValidItem     = obj.bValidItem or nil
    t.bValidInstance = obj.bValidInstance or nil
    t.InstanceID     = obj.InstanceID or nil
    return t
end

---将单个 ItemDefineID 或 ItemDefineID 数组转换为指定类型的 ItemDefineID table。
---@param obj ItemDefineID|ItemDefineID[]
---@param customizedType number
---@return table|nil
function Lib.ToItemDefineId(obj, customizedType)
    if obj.TypeSpecificID ~= nil then
        return Lib.ToTable(obj)
    end

    for _, item in pairs(obj) do
        local defineId = Lib.ToTable(item)
        if defineId.bValidItem
                and UGCItemSystemV2.GetItemCustomizedTypeV2(defineId.TypeSpecificID) == customizedType then
            return defineId
        end
    end
end


---【双端】创建一个定时器。
---@param time number @定时时间，单位秒
---@param isLoop boolean @是否循环
---@param callback function @定时器回调函数
---@param obj any @回调函数所在对象，静态函数传 `nil` 即可
---@param ... any @回调函数参数
---@return FTimerHandle @定时器句柄
function Lib.CreateTimer(time, isLoop, callback, obj, ...)
    local args = {...}
    local argCount = select("#", ...)
    local f
    if obj ~= nil then
        f = function()
            callback(obj, table.unpack(args, 1, argCount))
        end
    else
        f = function()
            callback(table.unpack(args, 1, argCount))
        end
    end
    return UGCTimerUtility.CreateUETimer(f, time, isLoop)[0]
end


---【双端】移除定时器。
---@param timer FTimerHandle @定时器句柄
function Lib.RemoveTimer(timer)
    UGCTimerUtility.RemoveUETimer(timer)
end


---【双端】判断当前是否处于服务端。
---@return boolean @是否处于服务端
function Lib.IsServer()
    if GameState then 
        return GameState:HasAuthority()
    end
    return GameMode ~= nil
end


---【双端】判断当前是否是 PIE 环境。
---@return boolean @是否是 PIE 环境
function Lib.IsPIE()
    return UGCGameSystem.IsUGCPIE()
end


---【双端】判断当前是否是调试环境。
---@return boolean @是否是调试环境
function Lib.IsDebug()
    return UGCGameSystem.IsDebug()
end


local _ROOT = UGCMapInfoLib.GetRootLongPackagePath()
local _PC_CLS_PATH = "Asset/Blueprint/UGCPlayerController.UGCPlayerController_C"
local _PS_CLS_PATH = "Asset/Blueprint/UGCPlayerState.UGCPlayerState_C"
local _PP_CLS_PATH = "Asset/Blueprint/UGCPlayerPawn.UGCPlayerPawn_C"


local _clsCache = {}


---【双端】获取一个类。
---@param clsPath string @类路径（由 `Asset/` 开始）
---@return UClass|nil @类
function Lib.GetClass(clsPath)
    if not _clsCache[clsPath] then
        _clsCache[clsPath] = LoadClass(_ROOT..clsPath)
    end
    return _clsCache[clsPath]
end


---【双端】获取 `PlayerController` 类。
---@return UClass|nil @`PlayerController` 类
function Lib.GetPlayerControllerClass()
    return Lib.GetClass(_PC_CLS_PATH)
end


---【双端】获取 `PlayerState` 类。
---@return UClass|nil @`PlayerState` 类
function Lib.GetPlayerStateClass()
    return Lib.GetClass(_PS_CLS_PATH)
end


---【双端】获取 `PlayerPawn` 类。
---@return UClass|nil @`PlayerPawn` 类
function Lib.GetPlayerPawnClass()
    return Lib.GetClass(_PP_CLS_PATH)
end


local function _IsPlayer(actor)
    return UE.IsA(actor, Lib.GetPlayerControllerClass()) 
        or UE.IsA(actor, Lib.GetPlayerStateClass()) 
        or UE.IsA(actor, Lib.GetPlayerPawnClass())
end


---【双端】判断一个 Actor 是否属于玩家。
---@param actor AActor @Actor
---@return boolean @是否是玩家
function Lib.IsPlayer(actor)
    if not actor then
        return false
    end
    if _IsPlayer(actor) then
        return true
    end
    local owner = actor:GetOwner()
    return owner and _IsPlayer(owner)
end


---根目录长路径（以 `/` 结尾）
---@type string
Lib.LONG_ROOT_PKG_PATH = _ROOT


return Lib
