if not _G.discordis then
	_G._discordis = {}
	_G._discordis.modules = {}
	_G._discordis.modules.request = require("modules.request")
	_G._discordis.api = require("api")
end

local api = _discordis.api.new(require("secrets").token)
print(api:get_message{
	channel_id = 1393290325631570031,
	message_id = 1393292075231088670
})
