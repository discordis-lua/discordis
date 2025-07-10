if not _G.discordis then
	_G._discordis = {}
	_G._discordis.request = require("modules.request")
end

print(_G._discordis.request.request("http://example.com", {}))
