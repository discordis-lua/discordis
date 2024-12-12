local color = require"pretty-print".colorize
return {
    Received = color("table", "[DISCORDIS]: ").." Received %s!",
    Error = color("table", "[DISCORDIS] | ").." %s: %s"
}