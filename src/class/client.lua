local ws = require"../client/ws"
local emitter = require"../utils/emitter"
local class = {}
class.__index = class

function class.new(token)
    assert(token, debug.traceback("token needed!"))

    return setmetatable({
        onReceive = emitter.on,
        token = token,
        ws = ws.new(token)
    }, class)
end

function class:login(status)
    if not status then status = "online" end
    coroutine.wrap(function()
        self.ws:run(self.token, status)
    end)()
end

return class