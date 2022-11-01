local awful = require("awful")
local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi

-- WIDGETS --
local battery = require("bar.battery")()
local tags = require("bar.tags")
local power = require("bar.power"){
    bg = "#ff8700",
    fg = "#121212",
    buttons = {
        awful.button({}, 1, function() awful.spawn("power-dmenu", false) end)
    },
    margins = { left = dpi(3), right = dpi(3) }
}
local bluetooth = require("bar.bluetooth") {}


screen.connect_signal("request::desktop_decoration", function(s)
    awful.wibar {
        position = "top",
        screen = s,
        height = 32,
        widget = {
            layout = wibox.layout.align.horizontal,
            expand = "none",
            { -- Left widgets
                tags({ screen = s }),
                layout = wibox.layout.fixed.horizontal,
            },
            {
                wibox.widget.textclock("%a, %b %d   %I:%M %p"),
                halign = "center",
                layout = wibox.container.place,
            },
            {
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(5),
                bluetooth,
                battery,
                power,
            }
        }
    }
end)

