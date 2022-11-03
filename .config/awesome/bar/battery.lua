local wibox = require("wibox")
local gears = require("gears")
local upower = require("lgi").require("UPowerGlib")

local M = {}
local meta = {}

M.instances = {}

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

M.device = upower.Client():get_display_device()
M.device.on_notify = function(device)
    for _, instance in pairs(M.instances) do
        instance.text = format_battery(device.percentage)
    end
end

function M.new()
    local textbox = wibox.widget {
        widget = wibox.widget.textbox,
        halign = "center",
        font = "SF Pro Display Semibold 10",
        text = format_battery(M.device.percentage)
    }

    local widget = wibox.widget {
        widget = wibox.container.background,
        shape = gears.shape.rounded_rect,
        {
            widget = wibox.container.margin,
            textbox
        }
    }

    table.insert(M.instances, textbox)
    return widget
end


function meta.__call(_, ...)
    return M.new(...)
end

return setmetatable(M, meta)
