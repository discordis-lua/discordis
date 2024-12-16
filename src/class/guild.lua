local http = require("coro-http")
local json = require("json")
local cache = require("./cache")
local endpoints = require("../endpoints")

local module = {}
local class = {}
class.__index = class

function module.new(object, id, token)
    local guild_cache = cache.new("guilds")
    local guild = guild_cache:fetch(tonumber(id or object.id))

    if not guild then
        if not object then
            local _, httpResponse = http.request("GET", endpoints.GUILD:format(id), {
                {"Authorization", ("Bot %s"):format(token)},
                {"Content-Type", "Application/json"}
            })
            httpResponse = json.parse(httpResponse)
            httpResponse.id = id
            guild_cache:add(tonumber(httpResponse.id), setmetatable(httpResponse, class))
            return setmetatable(httpResponse, class)
        else
            guild_cache:add(tonumber(object.id), setmetatable(object, class))
            return setmetatable(object, class)
        end
    else
        return guild
    end
end

return module