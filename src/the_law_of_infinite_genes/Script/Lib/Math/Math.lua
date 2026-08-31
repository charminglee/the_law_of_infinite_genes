---数学库。
---@class Math
local Math = {}


---【双端】将数值限制在 `[min, max]` 范围内。
---@param value number @数值
---@param min number @最小值
---@param max number @最大值
---@return number @限制值
function Math.Clamp(value, min, max)
    return math.min(math.max(value, min), max)
end


---【双端】以指定概率返回 `true` 。
---@param c number @概率值，范围 `[0, 1]`
---@return boolean @以 `c` 的概率返回 `true` ， `1-c` 的概率返回 `false`
function Math.Chance(c)
    return math.random() <= c
end


---【双端】四舍五入。
---@param value number @数值
---@param n number? @保留几位小数，默认不保留
---@return number @四舍五入后的数值
function Math.Round(value, n)
    n = n or 0
    local factor = 10 ^ n
    return math.floor(value * factor + 0.5) / factor
end


return Math