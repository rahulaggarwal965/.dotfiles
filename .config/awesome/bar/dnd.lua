local wibox = require("wibox")
local naughty = require("naughty")
local dpi = require("beautiful").xresources.apply_dpi

local M = {}
local meta = {}

M.instances = {}

function M.new()
    local textbox = wibox.widget {
        widget = wibox.widget.textbox,
        font = "SF Pro Display Semibold 9",
        halign = "center",
        text = "󰂛 ",
        visible = naughty.suspended,
    }

    local widget = wibox.widget {
            widget = wibox.container.margin,
            margins = { left = dpi(1), right = dpi(1) },
            textbox
    }

    table.insert(M.instances, textbox)
    return widget
end

awesome.connect_signal("sysinfo::dnd", function(suspended)
    for _, instance in pairs(M.instances) do
        instance.visible = suspended
    end
end)

function meta.__call(_, ...)
    return M.new(...)
end

return setmetatable(M, meta)
