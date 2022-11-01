local awful = require("awful")
local wibox = require("wibox")

local M = {}
local meta = {}

function M.new()
    local widget = wibox.widget {
        widget = wibox.widget.textbox,
        valign = "center",
        font = "SF Pro Display Semibold 10",
        buttons = {
            awful.button({}, 1, function() awful.spawn("rofi -show bluetooth -theme menu", false) end),
            awful.button({}, 3, function() awful.spawn("bluetooth toggle", false) end)
        }
    }

    widget.bluetooth_status = awful.spawn.with_line_callback("bluetoothstatus", {
        stdout = function (line)
            widget.text = line
        end
    })

    return widget
end

function meta.__call(_, ...)
    return M.new(...)
end

return setmetatable(M, meta)
