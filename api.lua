local request = _discordis.modules.request
local api = {}

function api.send_message(options)
	assert(options.token, "Missing 'token' in api.send_message(HERE)")
	assert(options.channel_id, "Missing 'channel_id' in api.send_message(HERE)")
	assert(options.content, "Missing 'content' in api.send_message(HERE)")

	return request:api_request({
		token = options.token,
		body = {
			content = options.content
		},
		is_json = true,
		endpoint = string.format("channels/%d/messages", options.channel_id),
		method = "POST"
	})
end

return api
