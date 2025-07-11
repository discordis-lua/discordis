local json = require("lunajson")
local mod = {}

function mod.request(url, options)
	assert(options, "'options' not provided")
	assert(url, "'url' not provided")
	options.method = options.method or "GET"
	options.body = options.body or {}
	options.headers = options.headers or {}
	local body = options.body
	local headers = options.headers

	if options.is_json and type(body) == "table" then
		body = json.encode(body)
		table.insert(headers, "Content-Type: application/json")
		table.insert(headers, "User-Agent: Discordis/0.1")
	end

	local hflags = ""
	for _, v in ipairs(headers) do
		hflags = hflags..string.format("-H '%s' ", v)
	end
	local command = string.format(
		"curl -s -X %s %s-d '%s' '%s'",
		options.method,
		hflags,
		body,
		url
	)
	local f = io.popen(command)
	local res = f:read("*a")
	f:close()

	return res
end

function mod.api_request(self, options)
	assert(options.token, "'token' not provided in function request:api_request(HERE)")
	assert(options.endpoint, "'endpoint' not provided in function request:api_request(HERE)")
	assert(options.method, "'method' not provided in function request:api_request(HERE)")
	local base_url = "https://discord.com/api/v10/"
	local as_json = false
	if options.body then
		as_json = true
	else
		options.body = ""
	end

	return self.request(base_url..options.endpoint, {
		headers = {
			"Authorization: Bot "..options.token
		},
		method = options.method,
		body = options.body,
		is_json = as_json
	})
end

return mod
