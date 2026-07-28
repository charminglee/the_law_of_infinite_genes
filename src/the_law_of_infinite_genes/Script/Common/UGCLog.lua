UGCLog = UGCLog or {}

local UGC_DEV_LOG = true

UGCLog.IsServerCached = nil;

function UGCLog.IsServer()
    if UGCLog.IsServerCached == nil then
        UGCLog.IsServerCached = UGCGameSystem.IsServer();
    end

    return UGCLog.IsServerCached;
end

-- 处理服务端换行符截断问题
local function line_break_handing(line_break_text, no_line_break_text)
    return tostring(UGCLog.IsServer() and no_line_break_text or line_break_text)
end

local function tostringex(v, len)
    if len == nil then len = 0 end
    local pre = string.rep('\t', len)
    local ret = ''
    local line_break_text = '\n'
    local no_line_break_text = ''
    if type(v) == "table" then
        if len > 5 then return "\t{ ... }" end
        local t = ""
        local keys = {}
        for k, v1 in pairs(v) do
            table.insert(keys, k)
        end
        
        for k, v1 in pairs(keys) do
            k = v1
            v1 = v[k]
            t = t .. line_break_handing(line_break_text, no_line_break_text) .. "\t" .. pre .. tostring(k) .. ":"
            t = t .. tostringex(v1, len + 1)
        end

        if t == "" then
            ret = ret .. pre .. line_break_handing(line_break_text, no_line_break_text) .. "{ }\t(" .. tostring(v) .. ")"
        else
            if len > 0 then
                ret = ret .. "\t(" .. tostring(v) .. ')' .. line_break_handing(line_break_text, no_line_break_text)
            else
                ret = ret .. line_break_handing(line_break_text, no_line_break_text) .. '(' .. tostring(v) .. ")"    
            end
            
            if len == 0 then
                ret = ret .. line_break_handing(line_break_text, no_line_break_text) .. pre .. "{" .. t .. line_break_handing(line_break_text, no_line_break_text) .. pre .. "}"  
            else
                ret = ret .. pre .. "{" .. t .. line_break_handing(line_break_text, no_line_break_text) .. pre .. "}"  
            end
        end
    elseif type(v) == "userdata" then
        if UE.IsValid(v) then
            local Nextpre = string.rep('\t', len+1)
            ret = ret .. pre .. tostring(UE.ToTable(v)) .. "\t(" .. type(v) .. ")"
            ret = ret .. line_break_handing(line_break_text, no_line_break_text) .. pre .. "{" .. line_break_handing(line_break_text, no_line_break_text) .. Nextpre .. "ClassAndPath:\t" .. UE.GetFullName(v) .. line_break_handing(line_break_text, no_line_break_text) .. pre .. "}"
        elseif v ~= nil then
            ret = ret .. pre .. tostring(UE.ToTable(v)) .. "\t(" .. type(v) .. ")"
        else
            ret = ret .. pre .. "[NullActor]"
        end
        
    else
        ret = ret .. pre .. tostring(v) .. "\t(" .. type(v) .. ")"
    end
    return ret
end

local function GetName(Actor)
    local line_break_text = '\n'
    local no_line_break_text = ''
    if UE.IsValid(Actor) then
        return string.format(tostring(v) .. ')' .. line_break_handing(line_break_text, no_line_break_text) .. "%s:" .. tostring(v) .. ')' .. line_break_handing(line_break_text, no_line_break_text) .. "{" .. tostring(v) .. ')' .. line_break_handing(line_break_text, no_line_break_text) .. " ClassAndPath:\t%s".. tostring(v) .. ')' .. line_break_handing(line_break_text, no_line_break_text) .. "}", tostring(UE.ToTable(Actor)), UE.GetFullName(Actor))
    elseif Actor ~= nil then
        return type(Actor)
    end

    return "[NullActor]";
end

local LogTag = function()
    local GameStr = "[UGC]";

    if UGCLog.IsServer() then
        GameStr = GameStr .. "[服务器]"
    else
        GameStr = GameStr .. "[客户端]"
    end

    return GameStr;
end

local GetLogStr = function(...)
    local data = {}
    local index = 1
    for k, v in pairs({...}) do
        if k > index + 1 then
            data[k - 1] = "nil"
        end

        local typev = type(v)
        if typev == "table" then
            data[k] = tostringex(v)
        elseif typev == "userdata" then
            data[k] = GetName(v)
        else
            data[k] = tostring(v)
        end

        index = k
    end

    local out = table.concat(data, "\t")
    if out:len() >= 10 * 1024 - 100 then
        out = out:sub(1, 10 * 1024 - 100) .. "..."
    end

    return out
end

local BaseLog = function(...)
    --优化，判断开关，开关状态打开才进行字符串序列化
    if UGC_DEV_LOG then
        if _G.bEnableUGCDebugLog == nil or _G.bEnableUGCDebugLog > 0 then
            ugcprint(LogTag() .. GetLogStr(...))
        end
    end
end

local BaseLogShipping = function(tag, ...)
    print(LogTag() .. tag .. GetLogStr(...))
end

function UGCLog.LogIf(Cond, ...)
    if Cond then
        BaseLog(...)
    end
end

function UGCLog.LogErrorIf(Cond, ...)
    if Cond then
        BaseLogShipping("[Error]", ...)
    end
end

function UGCLog.Log(...)
    BaseLog(...)
end

function UGCLog.LogError(...)
    BaseLogShipping("[Error]", ...)
end

function UGCLog.LogUEObj(Obj)
    UGCLog.Log("[UEObj]", UE.ToTable(Obj))
end

function UGCLog.LogUEObjList(Lst)
    print("[UGC][UEObj] UGCLog.LogUEObjList");
    for k, v in pairs(Lst) do
        UGCLog.Log("[UEObj]", GetName(v))
    end
end

function UGCLog.LogUEPawnList(Lst)
    local TableHelper = require("Script.Common.TableHelper");
    for k, v in pairs(Lst) do
        UGCLog.Log("[Pawn]", v.PlayerKey, GetName(v))
    end
end

function UGCLog.LogNetStatus(PlayerKey)    
    local PS = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey)

    if PS == nil then
        UGCLog.Log("[Net]还没有还没有PlayerState:", PlayerKey)
        return;
    end

    UGCLog.Log("[Net]PlayerKey:", PlayerKey, "是否断线：", PS.isLostConnection, "是否重连：", PS.isReconnected)
end

UGCLog.GameFlowStep = 1;
function UGCLog.LogGameFlow(...)
    BaseLogShipping("[GameFlow]", "["..UGCLog.GameFlowStep.."]", ...)
    UGCLog.GameFlowStep = UGCLog.GameFlowStep + 1;
end

return UGCLog;