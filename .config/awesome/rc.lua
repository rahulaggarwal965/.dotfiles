local awful = require("awful")
require("awful.autofocus")


-- Notification library
local naughty = require("naughty")
-- Declarative object management
local ruled = require("ruled")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)
-- }}}
require("theme")
require("screens")
require("rules")


require("sysinfo")
require("notifications")
require("signals")

require("keys")
require("bar")

-- {{{ Notifications

ruled.notification.connect_signal('request::rules', function()
    -- All notifications will match this rule.
    ruled.notification.append_rule {
        rule       = { },
        properties = {
            screen           = awful.screen.preferred,
            implicit_timeout = 5,
        }
    }
end)