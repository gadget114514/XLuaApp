--[==[
- Author:       ezhex1991@outlook.com
- CreateTime:   2017-12-21 12:34:25
- Organization: #ORGANIZATION#
- Description:  
    -- 用于延迟调用的计时器，使用invoke(delay, action)方法来添加延迟事件，使用tick(deltatime)方法来计时
    手动调用tick(deltaTime)是为了方便不同类型的计时：
    可在Update中传入Time.deltaTime计时，也可以直接传入1计帧，用法更灵活
    -- 一个有利有弊的地方是必须通过某个Update来调用tick，需要额外的代码来控制倒计时
    但是这也方便了与某个MonoBehaviour来同步周期，go:SetActive(false)就可以直接控制暂停
    -- 例：
    Start()
        propTimer:invoke(cd, enableprop)
        bulletTimer:invokerepeat(delay, cd, fire)
        flyTimer:invoke(duration, landing)
    end
    Update()
        propTimer:tick(CS.UnityEngine.Time.deltaTime)
        bulletTimer:tick(CS.UnityEngine.Time.deltaTime * scale)
    end
    FixedUpdate()
        flyTimer:tick(CS.UnityEngine.Time.fixedDeltaTime)
    end
    这样就实现了道具CD、自动武器、物理飞行三种计时器，还可以通过scale单独控制武器发射频率，scale = 0就实现了武器的单独暂停
--]==]
local M = require("ezlua.module"):module()
M.task = require("ezlua.module"):module() -- 类似于C#的嵌套类timer.task
----- CODE -----
function M.task:new(delay, loop, action)
    self = getmetatable(M.task).new(self)
    self.delay = delay
    self.loop = loop
    self.action = action
    self.dead = false
    self.countdown = delay
    return self
end
function M.task:reset()
    if self.dead then
        error("trying to reset a dead task.")
    end
    self.countdown = self.delay
end

function M:new()
    self = getmetatable(M).new(self)
    self._tasklist = {}
    return self
end
function M:invoke(delay, action)
    local task = M.task:new(delay, false, action)
    table.insert(self._tasklist, task)
    return task
end
function M:invokerepeat(delay, repeatRate, action)
    if repeatRate <= 0 then
        print("invalid repeat rate: " .. debug.traceback())
        return
    end
    local task = M.task:new(repeatRate, true, action)
    task.countdown = delay
    table.insert(self._tasklist, task)
    return task
end
function M:tick(deltatime)
    -- 此处先对现有task进行记录，然后再遍历调用，防止task执行中有新的task插入造成死循环
    local tasks = {}
    for key, task in pairs(self._tasklist) do
        tasks[key] = task
    end
    for key, task in pairs(tasks) do
        task.countdown = task.countdown - deltatime
        if task.countdown <= 0 then
            task.action()
            if task.loop then
                task.countdown = task.delay
            else
                task.dead = true
                self._tasklist[key] = nil
            end
        end
    end
end
----- CODE -----
return M
