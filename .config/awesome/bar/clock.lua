local awful = require("awful")
local wibox = require("wibox")

local M = {}
local meta = {}

function M.new()
    local widget = wibox.widget.textclock("%a, %b %d   %I:%M %p")
    widget.state = 0
    widget.buttons = {
        awful.button({}, 1, function()
            if (widget.state == 0) then
                widget.state = 1
                widget.format = "%a, %b %d   %I:%M:%S %p"
                widget.refresh = 1
            else
                widget.state = 0
                widget.format = "%a, %b %d   %I:%M %p"
                widget.refresh = 60
            end
        end)
    }
    return widget
end

function meta.__call(_, ...)
    return M.new(...)
end

return setmetatable(M, meta)
