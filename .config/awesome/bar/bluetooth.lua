local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi

local M = {}
local meta = {}

M.instances = {}

function M.new()
    local textbox = wibox.widget {
        widget = wibox.widget.textbox,
        font = "SF Pro Display Semibold 12",
        halign = "center",
    }

    local widget = wibox.widget {
        widget = wibox.container.background,
        shape = gears.shape.rounded_rect,
        {
            widget = wibox.container.margin,
            margins = { left = dpi(10), right = dpi(10) },
            textbox
        }
    }

    widget.buttons = {
            awful.button({}, 1, function()
                widget.bg = "#222222"
                awful.spawn.with_line_callback("rofi -show bluetooth -theme menu", {
                    exit = function()
                        widget.bg = "#121212"
                    end
                })
            end),
            awful.button({}, 3, function() awful.spawn("bluetooth toggle", false) end)
    }
    table.insert(M.instances, textbox)
    return widget
end

M.bluetooth_status = awful.spawn.with_line_callback("bluetoothstatus", {
    stdout = function (line)
        for _, instance in pairs(M.instances) do
            instance.text = line
        end
    end
})

function meta.__call(_, ...)
    return M.new(...)
end

return setmetatable(M, meta)
