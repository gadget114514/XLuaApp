--[==[
- Author:       ezhex1991@outlook.com
- CreateTime:   2017-09-29 12:52:50
- Organization: #ORGANIZATION#
- Description:  
--]==]
local M = {}
----- CODE -----
-- bind(self.function, self)返回的就是 function(...) self:function(...) end，保存该值用于添加和移除delegate
function M.bind(func, param)
    return function(...)
        return func(param, ...)
    end
end

-- 对于 condition and vtrue or vfalse 这个语句，vture会参与布尔运算而不是直接作为结果，当vtrue布尔判定为false时，该语句只能返回vfalse
-- 该方法并不等同于三目运算符，当vtrue或vfalse为表达式时，lua会先计算表达式然后传过来，所以该方法做不到“短路求值”，不能代替if...else...
function M.ifsetor(condition, vtrue, vfalse)
    if condition then
        return vtrue
    else
        return vfalse
    end
end

-- 字符串分割
function M.split(str, delimiter)
    if str == nil or delimiter == nil or str == "" then
        return nil
    end
    local result = {}
    for match in string.gmatch(str .. delimiter, "(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

-- 数值clamp
function M.clamp(value, min, max)
    if value < min then
        return min
    elseif value > max then
        return max
    else
        return value
    end
end

local seed = 0
local function setseed()
    seed = math.random(1e4, 1e6) + tostring(os.time()):reverse():sub(1, 6)
    math.randomseed(seed)
end
-- 整数random，max inclusive
function M.randomint(min, max)
    setseed()
    return math.random(min, max)
end
-- 浮点数random, max exclusive
function M.randomfloat(min, max)
    setseed()
    return math.random() * (max - min) + min
end
----- CODE -----
return M
