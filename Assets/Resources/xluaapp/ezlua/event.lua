--[==[
- Author:       ezhex1991@outlook.com
- CreateTime:   2017-04-19 14:20:04
- Organization: #ORGANIZATION#
- Description:  
    -- 用一个key去对应一个func是为了方便在移除时直接通过key去置空，而不是遍历_functionlist判断存在时移除：
    这意味着你必须用一个很特殊的值来保证key不冲突，好在lua里function本身就是一个不会冲突的key，
    所以你可以这样：event:addlistener(func, func)
    -- 使用"+","-"会直接以func本身为key添加监听，调用亦可直接用event(params)，例：
        event = require("ezlua.event"):new()
        event = event + func
        event(a)
        event = event - func
    -- 对于需要用到'self'语法糖的闭包，使用event = event + require("ezlua.util").bind(self.func, self)是一个不错的方法
    你还可以这样：添加时使用event:addlistener(self, self.func)，调用时使用event:keycall(params)
    这样key会作为func的第一个参数，也就实现了调用self.func(self, ...)，缺点就是一个table(key)只能对应一个listener(func)
--]==]
local M = require("ezlua.module"):module()
----- CODE -----
function M:new()
    self = getmetatable(M).new(self)
    self._functionlist = {}
    return self
end

function M:addlistener(key, func)
    self._functionlist[key] = func
end

function M:removelistener(key)
    self._functionlist[key] = nil
end

function M:clear()
    self._functionlist = {}
end

function M:call(...)
    for key, func in pairs(self._functionlist) do
        func(...)
    end
end

function M:keycall(...)
    for key, func in pairs(self._functionlist) do
        func(key, ...)
    end
end

M.__add = function(event, func)
    event:addlistener(func, func)
    return event
end
M.__sub = function(event, func)
    event:removelistener(func)
    return event
end
M.__call = function(event, ...)
    event:call(...)
end
----- CODE -----
return M
