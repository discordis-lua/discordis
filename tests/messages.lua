local discordis = require "../src/init"
local secrets = require "../secrets"
----------------------------------------------
local bot = discordis.client.new(secrets.token_key)
bot:onReceive("ready", function()
    print("client is on!")
end)
bot:onReceive("messageCreate", function(message)
    print(message.author.username..": "..message.content)
end)
bot:login()