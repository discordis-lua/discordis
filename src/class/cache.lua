local module = {}
local class = {}
class.__index = class
local cache = {}
class.__index = class

function class.iter(self)
    return pairs(cache[self.id])
end

function class.fetch(self, name)
    return cache[self.id][name]
end

function class.add(self, name, value)
    assert(name, "Name not provided")
    assert(value, "Value not provided")

    cache[self.id][name] = value
end

function module.new(id)
    assert(id, "Id not provided")
    if not cache[id] then
        cache[id] = {}
    end

    return setmetatable({
        id = id
    }, class)
end

return module