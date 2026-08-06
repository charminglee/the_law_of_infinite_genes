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


---【双端】创建一个定时器。
---@param time number @定时时间，单位秒
---@param isLoop boolean @是否循环
---@param callback function @定时器回调函数
---@param obj any @回调函数所在对象，静态函数传 nil 即可
---@param ... any @回调函数参数
---@return UGCLuaTimerInstance @定时器实例
function Lib.CreateTimer(time, isLoop, callback, obj, ...)
    local name = Lib.Random.GenString()
    local args = {...}
    local argCount = select("#", ...)
    local f = function()
        if obj then
            callback(obj, table.unpack(args, 1, argCount))
        else
            callback(table.unpack(args, 1, argCount))
        end
    end
    return UGCTimerUtility.CreateLuaTimer(time, f, isLoop, name, 0, false, false)
end


---【双端】移除定时器。
---@param timer UGCLuaTimerInstance @定时器实例
function Lib.RemoveTimer(timer)
    UGCTimerUtility.RemoveLuaTimer(timer)
end


---判断当前环境是否是服务端。
---@return boolean @是否是服务端
function Lib.IsServer()
    if GameState then 
        return GameState:HasAuthority()
    end
    return GameMode ~= nil
end


local _ROOT = UGCMapInfoLib.GetRootLongPackagePath()
local _PC_CLS_PATH = "Asset/Blueprint/UGCPlayerController.UGCPlayerController_C"
local _PS_CLS_PATH = "Asset/Blueprint/UGCPlayerState.UGCPlayerState_C"
local _PP_CLS_PATH = "Asset/Blueprint/UGCPlayerPawn.UGCPlayerPawn_C"


local _clsCache = {}


---获取一个类。
---@param clsPath string @类路径（由 "Asset/" 开始）
---@return UClass|nil @类
function Lib.GetClass(clsPath)
    if not _clsCache[clsPath] then
        _clsCache[clsPath] = LoadClass(_ROOT..clsPath)
    end
    return _clsCache[clsPath]
end


---获取 PlayerController 类。
---@return UClass|nil @PlayerController 类
function Lib.GetPlayerControllerClass()
    return Lib.GetClass(_PC_CLS_PATH)
end


---获取 PlayerState 类。
---@return UClass|nil @PlayerState 类
function Lib.GetPlayerStateClass()
    return Lib.GetClass(_PS_CLS_PATH)
end


---获取 PlayerPawn 类。
---@return UClass|nil @PlayerPawn 类
function Lib.GetPlayerPawnClass()
    return Lib.GetClass(_PP_CLS_PATH)
end


return Lib