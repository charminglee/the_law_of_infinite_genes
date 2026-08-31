---Table 工具库。
---@class Table
local Table = {}


-- region: 表（通用） ==================================================


---【双端】获取表指定键的值，如果键不存在，则使用默认值，并同时设置 `t[key] = default` 。
---@generic K
---@generic V
---@generic T
---@param t table<K, V> @表
---@param key any @键
---@param default T @默认值，默认为 nil
---@return V|T @key 的值
function Table.SetDefault(t, key, default)
    local val = t[key]
    if val == nil then
        t[key] = default
        return default
    else
        return val
    end
end


---【双端】将表映射为新表。
---@generic K
---@generic V
---@generic U
---@param t table<K, V> @表
---@param mapper fun(k: K, v: V): U @映射函数，该函数接受两个参数：键和值，返回映射后的值
---@return table<K, U> @映射后的表
function Table.Map(t, mapper)
    local res = {}
    for k, v in pairs(t) do
        res[k] = mapper(k, v)
    end
    return res
end


---【双端】合并两个表。
---第二个表的键值会覆盖第一个表。
---@generic K1
---@generic V1
---@generic K2
---@generic V2
---@param t1 table<K1, V1> @第一个表
---@param t2 table<K2, V2> @第二个表
---@return table<K1|K2, V1|V2> @合并后的表
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
---@generic K
---@generic V
---@param t table<K, V> @表
---@return table<K, V> @浅拷贝后的表
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
---@generic K
---@generic V
---@param t table<K, V> @表
---@param lookup table? @查找表，仅内部使用，一般无需传入
---@return table<K, V> @深拷贝后的表
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


---【双端】按条件过滤表，返回新表。
---@generic K
---@generic V
---@param t table<K, V> @表
---@param filter fun(k: K, v: V): boolean @保留条件函数，该函数接受两个参数：键和值，返回 `true` 即表示保留该元素
---@return table<K, V> @过滤后的表
function Table.Filter(t, filter)
    local res = {}
    for k, v in pairs(t) do
        if filter(k, v) then
            res[k] = v
        end
    end
    return res
end


---【双端】根据值查找对应的键。
---@generic K
---@param t table<K, any> @表
---@param value any @要查找的值
---@return K[]? @键列表，找不到时返回 `nil`
function Table.FindKey(t, value)
    local keys = {}
    for k, v in pairs(t) do
        if v == value then
            table.insert(keys, k)
        end
    end
    if #keys > 0 then
        return keys
    else
        return nil
    end
end


---【双端】返回由表所有键组成的列表。
---@generic K
---@param t table<K, any> @表
---@return K[] @键列表
function Table.Keys(t)
    local keys = {}
    for k, _ in pairs(t) do
        table.insert(keys, k)
    end
    return keys
end


---【双端】返回由表所有值组成的列表。
---@generic V
---@param t table<any, V> @表
---@return V[] @值列表
function Table.Values(t)
    local values = {}
    for _, v in pairs(t) do
        table.insert(values, v)
    end
    return values
end


---【双端】统计表中某个值的数量。
---@param t table @表
---@param value any @值
---@return number @数量
function Table.Count(t, value)
    local n = 0
    for _, v in pairs(t) do
        if v == value then
            n = n + 1
        end
    end
    return n
end


---【双端】移除表中的某个值（只移除第一个匹配到的值），对应的键也会一并移除。
---@param t table @表
---@param value any @要移除的值
function Table.Remove(t, value)
    for k, v in pairs(t) do
        if v == value then
            t[k] = nil
            break
        end
    end
end


-- endregion


-- region: 列表 ==================================================


---【双端】根据传入的列表创建一个新表，列表的所有元素将被转换为新表的键，值均为 `0` 。
---@generic T
---@param list T[] @列表
---@return table<T, number> @以 `list` 的元素作为键的表
function Table.FromList(list)
    local res = {}
    for _, v in pairs(list) do
        res[v] = 0
    end
    return res
end


---【双端】截取列表指定范围的元素。
---当调用 `Table.Slice(list, n)` 时，视为省略 `from` 参数，即截取列表开头 `n` 个元素。
---@generic T
---@overload fun(list: T[], to: number): T[]
---@param list T[] @列表
---@param from number? @起始索引（包含），默认为 `1`
---@param to number? @终止索引（包含），默认为列表长度
---@return T[] @截取后的列表
function Table.Slice(list, from, to)
    if not from and not to then
        from = 1
        to = #list
    elseif from and not to then
        to = from
        from = 1
    elseif not from and to then
        from = 1
    end
    local result = {}
    for i = from, to do
        table.insert(result, list[i])
    end
    return result
end


---【双端】连接两个列表。
---连接后的列表带有 `n` 字段，表示连接后的元素数量。
---@generic T1
---@generic T2
---@param list1 T1[] @第一个列表
---@param list2 T2[] @第二个列表
---@return ntable<T1|T2> @连接后的列表
function Table.Concat(list1, list2)
    local res = {}
    local n = 0
    for i = 1, (list1.n or #list1) do
        table.insert(res, list1[i])
        n = n + 1
    end
    for i = 1, (list2.n or #list2) do
        table.insert(res, list2[i])
        n = n + 1
    end
    res.n = n
    return res
end


---【双端】返回列表中首个等于指定值的元素的索引。
---@param list any[] @列表
---@param value any @要查找的值
---@return number? @索引，找不到时返回 `nil`
function Table.Index(list, value)
    for i, v in ipairs(list) do
        if v == value then
            return i
        end
    end
    return nil
end


---【双端】判断列表中是否包含指定值。
---@param list any[] @列表
---@param value any @要查找的值
---@return boolean @是否包含
function Table.Contain(list, value)
    return Table.Index(list, value) ~= nil
end


---【双端】列表去重。
---@generic T
---@param list T[] @列表
---@return T[] @去重后的列表
function Table.Unique(list)
    local seen = {}
    local res = {}
    for _, v in pairs(list) do
        if not seen[v] then
            seen[v] = true
            table.insert(res, v)
        end
    end
    return res
end


-- endregion


return Table