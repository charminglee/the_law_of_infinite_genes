---随机算法库。
---@class Random
local Random = {}


---@type Table
local Table = UGCGameSystem.UGCRequire("Script.Lib.Utils.Table")


math.randomseed(os.time())


local _CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
local _CHARS_LEN = #_CHARS


---【双端】生成一个指定长度的随机字符串。
---@param length number @字符串长度，默认为 16
---@return string @随机字符串
function Random.GenString(length)
    length = length or 16
    local result = {}
    for i = 1, length do
        local index = math.random(_CHARS_LEN)
        result[i] = _CHARS:sub(index, index)
    end
    return table.concat(result)
end


---【双端】随机打乱列表元素。
---@param list any[] @列表
function Random.Shuffle(list)
    local len = #list
    for i = len, 2, -1 do
        local j = math.random(i)
        list[i], list[j] = list[j], list[i]
    end
end


---【双端】从列表中随机抽取 n 个元素。
---@generic T
---@param list T[] @列表
---@param n number? @要抽取的元素个数，默认为 1
---@return T[] @抽取结果列表
function Random.Pick(list, n)
    list = Table.Copy(list)
    n = n or 1
    n = math.min(n, #list)
    Random.Shuffle(list)
    local result = {}
    for i = 1, n do
        result[i] = list[i]
    end
    return result
end


return Random