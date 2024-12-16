--[[ // Class \\ ]]--
local message = require("../class/message")

--[[ // Require \\ ]]--
local timer = require("timer")
local json = require("json")
local ws = require("coro-websocket")
local emitter = require("../utils/emitter")
local logs = require("../utils/logs")

--[[ // Methods \\ ]]--
local module = {}
module.__index = module

function module.new(token)
    local self = setmetatable({}, module)
    self.token = token
    self.payload = {
        op = 2,
        d = {
            token = self.token,
            intents = 513,
            properties = {
                os = "linux",
                browser = "discordis",
                device = "discordis"
            },
            presence = {
                activities = {},
                since = 91879201,
                afk = false
            }
        }
    }
    return self
end

--[[ // Functions \\ ]]--
function module:ManageEvents(pd)
    local t = pd.t
    local d = pd.d

    if t == "READY" then
        self.session_id = d.session_id
        self.seq = d.seq
        print(logs.Received:format("READY"))
        emitter:emit("ready")
    elseif t == "MESSAGE_CREATE" then
        emitter:emit("messageCreate", message.new(d, self.token, d.id, d.channel_id))
    elseif t == "RESUMED" then
        self.write{
            opcode = 6,
            d = json.stringify{
                token = self.token,
                session_id = self.session_id,
                seq = self.seq
            }
        }
    end
end

function module:ManageOP(pd, op)
    local t = pd.t

    if op == 10 then
        print(logs.Received:format("HELLO"))
        local heartbeat_interval = pd.d.heartbeat_interval
        timer.setInterval(heartbeat_interval, function()
            self.write({
                opcode = 1,
                payload = json.stringify({
                    op = 1,
                    d = nil
                })
            })
        end)

        self.write({
            opcode = 2,
            payload = json.stringify(self.payload)
        })
    elseif op == 0 then
        self.seq = pd.s
    end

    if t then
        self:ManageEvents(pd)
    end
end

function module:run(status)
    self.payload.d.presence.status = status
    local _, read, write = ws.connect{
        port = 443,
        host = "gateway.discord.gg",
        path = "/?v=9&encoding=json",
        tls = true
    }
    self.write = write

    for message in read do
        if not message then break end
        local pd = json.parse(message.payload)
        if not pd then break end

        self:ManageOP(pd, pd.op)
    end
end

return module