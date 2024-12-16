local http = require("coro-http")
local json = require("json")
local logs = require("../utils/logs")
local endpoints = require("../endpoints")
local cache = require("./cache")

local module = {}
local class = {}
class.__index = class

function module.new(id, token)
    local channel_cache = cache.new("channels")
    local channel = channel_cache:fetch(tonumber(id))

    if not channel then
        print(token)
        local res, httpResponse = http.request("GET", endpoints.CHANNEL:format(id), {
            {"Authorization", ("Bot %s"):format(token)},
            {"Content-Type", "Application/json"}
        })

        if res.code ~= 200 then
            return print(logs.Error:format(res.code, res.reason))
        end

        httpResponse = json.parse(httpResponse)
        httpResponse.token = token
        httpResponse._headers = {
            {"Authorization", ("Bot %s"):format(token)},
            {"Content-Type", "Application/json"}
        }

        channel_cache:add(tonumber(id), setmetatable(httpResponse, class))

        return setmetatable(httpResponse, class)
    else
        return channel
    end
end

return module