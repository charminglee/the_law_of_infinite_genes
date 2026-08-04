---Table工具库。
---@class Table
local Table = {}


---【双端】截取列表的前 n 个元素。
---@generic T
---@param list T[] @列表
---@param n number @要截取的元素个数
---@return T[] @截取后的列表
function Table.Cut(list, n)
    local result = {}
    for i = 1, n do
        table.insert(result, list[i])
    end
    return result
end


---【双端】连接两个列表。
---@generic T1
---@generic T2
---@param t1 T1[] @第一个列表
---@param t2 T2[] @第二个列表
---@return (T1|T2)[] @连接后的列表
function Table.Concat(t1, t2)
    local res = {}
    local i = 1
    for _, v in pairs(t1) do
        res[i] = v
        i = i + 1
    end
    for _, v in pairs(t2) do
        res[i] = v
        i = i + 1
    end
    return res
end


---【双端】合并两个表，第二个表的键值会覆盖第一个表。
---@generic T1
---@generic T2
---@param t1 T1 @第一个表
---@param t2 T2 @第二个表
---@return T1 & T2 @合并后的表
function Table.Merge(t1, t2)
    local res = {}
    for k, v in pairs(t1) do
        res[k] = v
    end
    for k, v in pairs(t2) do
        res[k] = v
    end
    return res
end


---【双端】判断表是否为空。
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