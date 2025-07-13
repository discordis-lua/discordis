require("luacurl")
local json = require("lunajson")
local mod = {}

function mod.api_request(self, options)
	assert(options.token, "'token' not provided in function request:api_request(HERE)")
	assert(options.endpoint, "'endpoint' not provided in function request:api_request(HERE)")
	assert(options.method, "'method' not provided in function request:api_request(HERE)")
	local base_url = "https://discord.com/api/v10/"

	local res = luacurl_request(base_url..options.endpoint, options.method, options.body, {
		"Authorization: Bot "..options.token
	})

	return res
end

return mod
