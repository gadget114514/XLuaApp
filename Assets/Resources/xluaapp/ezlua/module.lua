--[==[
- Author:       ezhex1991@outlook.com
- CreateTime:   2018-02-12 17:13:35
- Organization: #ORGANIZATION#
- Description:  
--]==]
local M = {}
----- CODE -----
M.__index = M
function M:module(super)
    local instance = {}
    setmetatable(instance, super or M) -- 以super为meta，继承super的所有元素
    instance.__index = instance -- 以自身为__index，表示其可以直接被继承（可作为metatable）
    return instance -- 返回值即可作为实例，又可作为基类继续被扩展
end
function M:new()
    return self:module(self) -- 默认的无参new方法
end
----- CODE -----
return M -- 如果这里返回M:new()，那么require的结果就可以直接作为单例使用
