---事件系统，提供事件监听与触发功能。
---@class EventSystem
local EventSystem = {
    ---@type table<string, {func: function, obj: any, alive: boolean}[]>
    _pools = {}, 
}


---【双端】添加监听。
---@param eventName string @事件名
---@param func function @回调函数
---@param obj? any @回调函数所在对象（通常为 self ，非实例方法可忽略该参数）
function EventSystem.Listen(eventName, func, obj)
    local pool = EventSystem._pools[eventName]
    if pool == nil then
        pool = {}
        EventSystem._pools[eventName] = pool
    else
        for _, l in pairs(pool) do
            -- 去重
            if l.func == func and l.obj == obj then
                return
            end
        end
    end
    local listener = { 
        func = func,
        obj = obj, 
        alive = true,
    }
    table.insert(pool, listener)
end


---【双端】移除监听。
---@param eventName string @事件名
---@param func function @回调函数
---@param obj? any @回调函数所在对象（通常为 self ，非实例方法可忽略该参数）
function EventSystem.Unlisten(eventName, func, obj)
    local pool = EventSystem._pools[eventName]
    if pool == nil then
        return
    end
    for i = #pool, 1, -1 do
        local l = pool[i]
        if l.func == func and l.obj == obj then
            l.alive = false
            table.remove(pool, i)
        end
    end
end


---【双端】移除指定对象绑定的所有监听。
---@param obj any @回调函数所在对象（通常为 self ）
function EventSystem.UnlistenByOwner(obj)
    for _, pool in pairs(EventSystem._pools) do
        for i = #pool, 1, -1 do
            local l = pool[i]
            if l.obj == obj then
                l.alive = false
                table.remove(pool, i)
            end
        end
    end
end


---【双端】移除所有事件监听。
function EventSystem.UnlistenAll()
    EventSystem._pools = {}
end


---【双端】本地调用指定事件的所有回调函数。
---@param eventName string @事件名
---@param ... any @事件参数
function EventSystem.Dispatch(eventName, ...)
    local pool = EventSystem._pools[eventName]
    if pool == nil then
        return
    end

    -- 先做浅拷贝快照，派发期间增删监听不影响本次遍历，新加入者也不在本次触发
    local snapshot = {}
    for i = 1, #pool do
        snapshot[i] = pool[i]
    end

    for i = 1, #snapshot do
        local l = snapshot[i]
        if l.alive then
            local ok, err
            if l.obj ~= nil then
                ok, err = pcall(l.func, l.obj, ...)
            else
                ok, err = pcall(l.func, ...)
            end
            if not ok then
                print("[EventSystem] 执行事件 '"..eventName.."' 的回调函数时出现异常：\n"..tostring(err))
            end
        end
    end
end


---【服务端】发送事件到指定客户端。
---@param player UGCPlayerController|UGCPlayerState|UGCPlayerPawn @目标玩家的 PlayerController / PlayerState / PlayerPawn
---@param eventName string @事件名
---@param ... any @事件参数
function EventSystem.SendToClient(player, eventName, ...)
    if not Lib.IsServer() or not UE.IsValid(player) then
        return
    end

    local pc
    if UE.IsA(player, Lib.GetPlayerControllerClass()) then
        pc = player
    elseif UE.IsA(player, Lib.GetPlayerStateClass()) then
        pc = UGCGameSystem.GetPlayerControllerByPlayerState(player)
    elseif UE.IsA(player, Lib.GetPlayerPawnClass()) then
        pc = UGCGameSystem.GetPlayerControllerByPlayerPawn(player)
    end
    if not UE.IsValid(pc) then
        return
    end

    UnrealNetwork.CallUnrealRPC(
        pc, 
        pc.GlobalEventComponent, 
        "ClientRPC_FromEventSystem", 
        eventName, ...
    )
end


---【服务端】发送事件到所有客户端。
---@param eventName string @事件名
---@param ... any @事件参数
function EventSystem.SendToAllClients(eventName, ...)
    if not Lib.IsServer() then
        return
    end
    for _, pc in pairs(UGCGameSystem.GetAllPlayerController(false)) do
        if UE.IsValid(pc) then
            UnrealNetwork.CallUnrealRPC(
                pc, 
                pc.GlobalEventComponent, 
                "ClientRPC_FromEventSystem", 
                eventName, ...
            )
        end
    end
    -- UnrealNetwork.CallUnrealRPC_Multicast(
    --     UGCGameSystem.GetGameState(), 
    --     "Multicast_FromEventSystem", 
    --     eventName, ...
    -- )
end


---【客户端】发送事件到服务端。
---@param eventName string @事件名
---@param ... any @事件参数
function EventSystem.SendToServer(eventName, ...)
    if Lib.IsServer() then
        return
    end
    local pc = LocalPlayerController
    if not UE.IsValid(pc) then
        return
    end
    UnrealNetwork.CallUnrealRPC(
        pc, 
        pc.GlobalEventComponent, 
        "ServerRPC_FromEventSystem", 
        eventName, ...
    )
end


---【双端】广播事件到所有客户端和服务端。
---@param eventName string @事件名
---@param ... any @事件参数
function EventSystem.Broadcast(eventName, ...)
    EventSystem.Dispatch(eventName, ...)
    if Lib.IsServer() then
        EventSystem.SendToAllClients(eventName, ...)
    else
        EventSystem.SendToServer(eventName, ...)
    end
end


return EventSystem