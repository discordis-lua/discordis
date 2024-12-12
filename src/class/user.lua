local json = require "json"
local request = require "../utils/request"
local endp = require "../endpoints"
local cache = require "../utils/cache"
local class = {}
class.__index = class

function class.new(id, use_cache, object)
    local user_cache = cache.new("user"):get(id)
    if user_cache and use_cache then return user_cache end

    local self = setmetatable(object, class)

    if self.banner then
        self.banner = ("https://cdn.discordapp.com/banners/%s/%s.png"):format(id, self.banner)
    end
    if self.avatar then
        self.avatar = ("https://cdn.discordapp.com/avatars/%s/%s.png"):format(id, self.avatar)
    end

    return self
end

return class