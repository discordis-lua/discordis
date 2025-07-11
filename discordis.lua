if not _G.discordis then
	_G._discordis = {}
	_G._discordis.modules = {}
	_G._discordis.modules.request = require("modules.request")
	_G._discordis.api = require("api")
end

print(_discordis.api.send_message({
	token = require("secrets").token,
	channel_id = 1384332720741683270,
	content = "test"
}))
