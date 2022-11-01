local wibox = require("wibox")
local upower = require("lgi").require("UPowerGlib")

local M = {}
local meta = {}

local battery_icons = {
    [0] = "",
    [1] = "",
    [2] = "",
    [3] = "",
    [4] = ""
}

local function format_battery(percentage)
    local icon = battery_icons[math.floor(percentage / 21)]
    return string.format("%s  ", icon)
end

function M.new()
    local device = upower.Client():get_display_device()
    local widget = wibox.widget {
        widget = wibox.widget.textbox,
        valign = "center",
        font = "SF Pro Display Semibold 10",
        text = format_battery(device.percentage),
        device = device,
    }

    widget.device.on_notify = function(d)
        widget.text = format_battery(d.percentage)
    end

    return widget
end

function meta.__call(_, ...)
    return M.new(...)
end

return setmetatable(M, meta)
