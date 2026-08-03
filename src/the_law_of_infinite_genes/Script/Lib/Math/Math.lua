---数学库。
---@class Math
local Math = {}


---将数值限制在 [min, max] 范围内。
---@param value number @数值
---@param min number @最小值
---@param max number @最大值
---@return number @限制值
function Math.Clamp(value, min, max)
    return math.min(math.max(value, min), max)
end


---以指定概率返回 true 。
---@param c number @概率值，范围 [0, 1]
---@return boolean @以 c 的概率返回 true ， 1-c 的概率返回 false
function Math.Chance(c)
    return math.random() <= c
end


return Math