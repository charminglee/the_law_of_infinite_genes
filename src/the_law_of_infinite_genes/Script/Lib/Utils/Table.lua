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
---@return T @深拷贝后的表
function Table.DeepCopy(t, _lookup)
    if type(t) ~= "table" then
        return t
    end

    _lookup = _lookup or {}
    if _lookup[t] then
        return _lookup[t]
    end

    local copy = {}
    _lookup[t] = copy
    for k, v in pairs(t) do
        k = Table.DeepCopy(k, _lookup)
        v = Table.DeepCopy(v, _lookup)
        copy[k] = v
    end

    local meta = getmetatable(t)
    if meta then
        setmetatable(copy, Table.DeepCopy(meta, _lookup))
    end

    return copy
end


return Table