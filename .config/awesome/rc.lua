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

require("keys")
require("theme")

-- local hide = function (o)
--     -- naughty.notify({ title = "hide triggered"})
--     -- print("launcher ==== " .. tostring(mylauncher))
--     -- print("object ===== " .. tostring(o.widget))
--     if o ~= mymainmenu.wibox then
--         mymainmenu:hide()
--     end
-- end

-- mymainmenu.wibox:connect_signal("property::visible", function (w)
--
--
--     if w.visible then
--         wibox.connect_signal("button::press", hide)
--         client.connect_signal("button::press", hide)
--         awful.mouse.append_global_mousebinding(awful.button({}, 1, hide))
--     else
--         wibox.disconnect_signal("button::press", hide)
--         client.disconnect_signal("button::press", hide)
--         awful.mouse.remove_global_mousebinding(awful.button({}, 1, hide))
--     end
-- end)

require("screens")
require("bar")
require("rules")

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

naughty.connect_signal("request::display", function(n)
    naughty.layout.box { notification = n }
end)

-- }}}

require("signals")
