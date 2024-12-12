local emitter = {}
local cache = {}

function emitter:on(event_name, event_cb)
    if not cache[event_name] then
        cache[event_name] = {}
    end

    table.insert(cache[event_name], event_cb)
end

function emitter:emit(event_name, ...)
    if not cache[event_name] then cache[event_name] = {} end

    for _, cb in pairs(cache[event_name]) do
       if type(cb) == "function" then
            cb(...)
       end
    end
end

return emitter