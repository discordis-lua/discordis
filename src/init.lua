--[[lit-meta
	name = "MrEntrasil/Discordis"
	version = "0.0.5"
	homepage = "https://github.com/discordis-lua/discordis"
	description = "A simple discord wrapper written in lua"
	license = "MIT"
]]

return {
	cache = require("./utils/cache"),
	client = require("./class/client")
}
