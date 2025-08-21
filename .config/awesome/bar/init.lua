local awful = require("awful")
local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi

-- WIDGETS --
local battery = require("bar.battery")
local tags = require("bar.tags")
local power = require("bar.power")
local bluetooth = require("bar.bluetooth")
local dnd = require("bar.dnd")
-- local spotify = require("bar.spotify")
local clock = require("bar.clock") {}


screen.connect_signal("request::desktop_decoration", function(s)
    awful.wibar {
        position = "top",
        screen = s,
        height = 30,
        widget = {
            layout = wibox.layout.align.horizontal,
            expand = "none",
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(5),
                tags({ screen = s }),
                -- spotify{},
            },
            {
                clock,
                halign = "center",
                layout = wibox.container.place,
                content_fill_vertical = true,
            },
            {
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(10),
                dnd{},
                bluetooth{},
                battery{},
                power{},
            }
        }
    }
end)

