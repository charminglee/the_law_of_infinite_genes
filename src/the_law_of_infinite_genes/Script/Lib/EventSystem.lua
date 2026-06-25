---@class EventSystem_C
local EventSystem = {}


---事件触发方式枚举。
EventSystem.EmitType = {
    ---本地触发（服务端触发的事件，仅服务端可收到；客户端触发的事件，仅当前客户端可收到）。
    Local = 0,
    ---跨端触发（服务端触发的事件，所有客户端可收到；客户端触发的事件，仅服务端可收到）。
    Across = 1,
    ---双端触发（本端与对端同时收到：服务端发→服务端与所有客户端；客户端发→本客户端与服务端）。
    Both = 2,
}


local eventPools = {}


local function IsServer()
    return GameState ~= nil and GameState:HasAuthority()
end


---添加监听。
---@param eventName string 事件名
---@param func function 回调函数
---@param obj any 回调函数所在对象（通常为self，非实例方法可忽略该参数）
function EventSystem.Listen(eventName, func, obj)
    local data = { func = func, obj = obj }
    if eventPools[eventName] == nil then
        eventPools[eventName] = {}
    end
    table.insert(eventPools[eventName], data)
end


---移除监听。
---@param eventName string 事件名
---@param func function 回调函数
---@param obj any 回调函数所在对象（通常为self，非实例方法可忽略该参数）
function EventSystem.Unlisten(eventName, func, obj)
    local pool = eventPools[eventName]
    if pool == nil then
        return
    end
    for i, data in pairs(pool) do
        if data.func == func and data.obj == obj then
            pool[i] = nil
        end
    end
end


---移除所有事件监听。
function EventSystem.UnlistenAll()
    eventPools = {}
end


function EventSystem._EmitLocal(eventName, ...)
    local pool = eventPools[eventName]
    if pool == nil then
        return
    end
    for _, data in pairs(pool) do
        if data.obj ~= nil then
            data.func(data.obj, ...)
        else
            data.func(...)
        end
    end
end


function EventSystem._EmitAcross(eventName, ...)
    if IsServer() then
        UnrealNetwork.CallUnrealRPC_Multicast(GameState, "ServerRPC_OnEmitAcross", eventName, ...)
    else
        local comp = LocalPlayerController.GlobalEventComponent
        UnrealNetwork.CallUnrealRPC(comp, comp, "ServerRPC_OnEmitAcross", eventName, ...)
    end
end


---触发指定事件。
---@param eventName string 事件名
---@param emitType number 触发方式，请使用EventSystem.EmitType枚举值
---@param ... any 回调参数
function EventSystem.Emit(eventName, emitType, ...)
    if emitType == EventSystem.EmitType.Local then
        EventSystem._EmitLocal(eventName, ...)
    elseif emitType == EventSystem.EmitType.Across then
        EventSystem._EmitAcross(eventName, ...)
    elseif emitType == EventSystem.EmitType.Both then
        EventSystem._EmitLocal(eventName, ...)
        EventSystem._EmitAcross(eventName, ...)
    end
end


return EventSystem