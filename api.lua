local request = _discordis.modules.request
local api = {}
api.__index = api

function api.new(token)
	assert(token, "Missing 'token'")
	
	return setmetatable({
		API_TOKEN = token
	}, api)
end

function api.send_message(self, options)
	assert(options.channel_id, "Missing 'channel_id'")
	assert(options.content, "Missing 'content'")

	return request:api_request({
		token = self.API_TOKEN,
		body = {
			content = options.content
		},
		is_json = true,
		endpoint = string.format("channels/%d/messages", options.channel_id),
		method = "POST"
	})
end

function api.get_message(self, options)
	assert(options.channel_id, "Missing 'channel_id'")
	assert(options.message_id, "Missing 'message_id'")

	print(options.channel_id, options.message_id, self.API_TOKEN)
	return request:api_request{
		endpoint = string.format("channels/%d/messages/%d", options.channel_id, options.message_id),
		method = "GET",
		token = self.API_TOKEN
	}
end

return api
