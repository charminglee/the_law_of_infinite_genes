---随机算法库。
---@class Random
local Random = {}


---@type Table
local Table = UGCGameSystem.UGCRequire("Script.Lib.Utils.Table")


math.randomseed(os.time())


---随机打乱列表元素。
---@param list table @列表
function Random.Shuffle(list)
    local len = #list
    for i = len, 2, -1 do
        local j = math.random(i)
        list[i], list[j] = list[j], list[i]
    end
end


---从列表中随机抽取 n 个元素。
---@param list table @列表
---@param n number? @要抽取的元素个数，默认为 1
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