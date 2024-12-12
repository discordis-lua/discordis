local json = require "json"
local http = require "coro-http"
local endp = require "../endpoints"
local cache = require "./cache"
local channel = require "./channel"
local logs = require "./utils/logs"

local module = {}
local class = {}
class.__index = class

function module.new(object, token, id, channel_id)
    assert(token, "Token not provided")
    local message_cache = cache.new("messages")

    object._headers = {
        {"Authorization", ("Bot %s"):format(token)},
        {"Content-Type", "Application/json"}
    }

    if object then
        object.channel = channel.new(object.channel_id)
        object.channel_id = nil
        object._token = token

        if not message_cache:fetch(tonumber(object.id)) then
            message_cache:add(tonumber(object.channel.id), setmetatable(object, class))
        end

        return setmetatable(object, class)
    else
        local message_fetch = message_cache:fetch(tonumber(id))
        if message_fetch then
            return message_fetch
        else
            object = {}
            local _, httpResult = http.request("GET", endp.MESSAGE:format(channel_id, id), object._headers)
            local response = setmetatable(json.parse(httpResult), class)
            
            message_cache:add(tonumber(id), response)

            return response
        end
    end
end

function class.reply(self, content)
    coroutine.wrap(function()
        local result = {
            content = content,
        }

        if type(content) == "table" then
            result = content
        end
        result["message_reference"] = {
            message_id = self.id,
            channel_id = self.channel.id,
            guild_id = self.guild.id
        }

        local response, _ = http.request("POST", endp.MESSAGES:format(self.channel.id), self._headers, json.stringify(result))

        if response.status ~= 200 then
            print(logs.Error:format(tostring(response.status)))
        end
    end)()
end

function class.delete(self)
    coroutine.wrap(function()
        http.request("DELETE", endp.MESSAGE:format(self.channel.id, self.id), self._headers)
    end)()
end

function class.edit(self, content)
    coroutine.wrap(function()
        local result = {
            content = content,
        }

        if type(content) == "table" then
            result = content
        end
        result["message_reference"] = {
            message_id = self.id,
            channel_id = self.channel.id,
            guild_id = self.guild.id
        }

        local response, _ = http.request("PATCH", endp.MESSAGES:format(self.channel.id), self._headers, json.stringify(result))

        if response.status ~= 200 then
            print(logs.Error:format(tostring(response.status), response.reason))
        end
    end)()
end

function class.AddReaction(self, emoji)
    coroutine.wrap(function()
        local response, _ = http.request("PUT", endp.REACTIONS:format(self.channel.id, self.id, emoji), self._headers)

        if response.status ~= 200 then
            print(logs.Error:format(tostring(response.status), response.reason))
        end
    end)()
end

function class.RemoveReaction(self, emoji)
    coroutine.wrap(function()
        local response, _ = http.request("DELETE", endp.REACTIONS:format(self.channel.id, self.id, emoji), self._headers)

        if response.status ~= 200 then
            print(logs.Error:format(tostring(response.status), response.reason))
        end
    end)()
end

return module