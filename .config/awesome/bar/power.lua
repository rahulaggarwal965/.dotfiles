local awful = require("awful")
local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi

local M = {}
local meta = {}

function M.new()
    local textbox = wibox.widget {
        text = "⏻",
        widget = wibox.widget.textbox
    }
    local widget = wibox.widget {
        widget = wibox.container.background,
        bg = "#ff8700",
        fg = "#121212",
        {
            widget = wibox.container.margin,
            margins = { left = dpi(3), right = dpi(3) },
            textbox
        }
    }
    widget.buttons = {
        awful.button({}, 1, function()
            awful.spawn.with_line_callback("power-dmenu", {
                exit = function() widget.bg = "#ff8700" end
            })
        end)

    }
    widget:connect_signal("mouse::enter", function()
        widget.bg = "#ff9900"
    end)

    widget:connect_signal("mouse::leave", function()
        widget.bg = "#ff8700"
    end)

    return widget
end

function meta.__call(_, ...)
    return M.new(...)
end

return setmetatable(M, meta)
