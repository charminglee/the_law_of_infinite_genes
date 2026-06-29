---@class Lib
---@field EventSystem EventSystem
Lib = {
    EventSystem = UGCGameSystem.UGCRequire("Script.Lib.EventSystem"),
}


---判断当前环境是否是服务端。
---@return boolean 是否是服务端
function Lib.IsServer()
    if GameState then 
        return GameState:HasAuthority()
    end
    return GameState ~= nil
end


return Lib