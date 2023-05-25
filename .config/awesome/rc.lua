local awful = require("awful")
require("awful.autofocus")

-- require("autostart")
local gears = require("gears")
local wibox = require("wibox")

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

local dpi = require("beautiful").xresources.apply_dpi

naughty.connect_signal("request::display", function(n)
    naughty.layout.box {
        notification = n,
        -- widget_template = {
        --     widget = wibox.container.constraint,
        --     strategy = "max",
        --     width = 340,
        --     {
        --         id     = "background_role",
        --         widget = naughty.container.background,
        --         {
        --             margins = dpi(10),
        --             widget  = wibox.container.margin,
        --             {
        --                 widget = wibox.container.place,
        --                 valign = "center",
        --                 halign = "left",
        --                 {
        --                     {
        --                         widget = naughty.widget.icon,
        --                         valign = "center",
        --                         forced_height = 128
        --                     },
        --                     {
        --                         {
        --                             {
        --                                 widget = naughty.widget.title,
        --                                 font = "SF Pro Display Bold 20"
        --                             },
        --                             {
        --                                 widget = naughty.widget.message,
        --                                 font = "SF Pro Display 11"
        --                             },
        --                             spacing = 4,
        --                             layout  = wibox.layout.fixed.vertical,
        --                         },
        --                         widget = wibox.container.background,
        --                         bg = "red"
        --                     },
        --                     fill_space = true,
        --                     spacing    = 4,
        --                     layout     = wibox.layout.fixed.horizontal,
        --                 },
        --             }
        --         },
        --     },
        -- },
        -- shape = gears.shape.rounded_rect
    }
end)

-- }}}

require("signals")
