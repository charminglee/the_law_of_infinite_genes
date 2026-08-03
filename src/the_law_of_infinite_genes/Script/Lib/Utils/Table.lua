---Table工具库。
---@class Table
local Table = {}


----【双端】判断表是否为空。
---@param t table @表
---@return boolean @是否为空
function Table.IsEmpty(t)
    return next(t) == nil
end


---【双端】浅拷贝一个表。
---@generic T
---@param t T @表
---@return T @浅拷贝后的表
function Table.Copy(t)
    if type(t) ~= "table" then
        return t
    end

    local copy = {}
    for k, v in pairs(t) do
        copy[k] = v
    end

    local meta = getmetatable(t)
    if meta then
        setmetatable(copy, meta)
    end

    return copy
end


---【双端】深拷贝一个表。
---@generic T
---@param t T @表
---@param lookup table? @查找表，用于处理循环引用，一般无需传入
---@return T @深拷贝后的表
function Table.DeepCopy(t, lookup)
    if type(t) ~= "table" then
        return t
    end

    lookup = lookup or {}
    if lookup[t] then
        return lookup[t]
    end

    local copy = {}
    lookup[t] = copy
    for k, v in pairs(t) do
        k = Table.DeepCopy(k, lookup)
        v = Table.DeepCopy(v, lookup)
        copy[k] = v
    end

    local meta = getmetatable(t)
    if meta then
        setmetatable(copy, Table.DeepCopy(meta, lookup))
    end

    return copy
end


return Table