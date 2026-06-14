EventSystem = EventSystem or 
{   
    -- 事件触发方式
    EmitType = {
        Local = 0,  -- 本地触发（服务端触发的事件，仅服务端可收到；客户端触发的事件，仅当前客户端可收到）
        Across = 1, -- 跨端触发（服务端触发的事件，所有客户端可收到；客户端触发的事件，仅服务端可收到）
        Both = 2,   -- 双端触发（服务端与所有客户端同时收到）
    },

    _eventPools = {},
}


---添加监听。
---@param eventName string 事件名
---@param func function 回调函数
---@param obj any 回调函数所在对象（通常为self，非实例方法可忽略该参数）
function EventSystem.Listen(eventName, func, obj)
    local data = {func, obj}
    if EventSystem._eventPools[eventName] == nil then
        EventSystem._eventPools[eventName] = {}
    end
    table.insert(EventSystem._eventPools[eventName], data)
end


---移除监听。
---@param eventName string 事件名
---@param func function 回调函数
---@param obj any 回调函数所在对象（通常为self，非实例方法可忽略该参数）
function EventSystem.Unlisten(eventName, func, obj)
    local pool = EventSystem._eventPools[eventName]
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
    EventSystem._eventPools = {}
end


---触发指定事件。
---@param eventName string 事件名
---@param emitType number 触发方式，请使用EventSystem.EmitType枚举值
---@param ... any 回调参数
function EventSystem.Emit(eventName, emitType, ...)
    local pool = EventSystem._eventPools[eventName]
    if pool == nil then
        return
    end
    for i, data in pairs(pool) do
        if data.obj ~= nil then
            data.func(data.obj, ...)
        else
            data.func(...)
        end
    end
end


return EventSystem