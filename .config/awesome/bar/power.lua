local wibox = require("wibox")

local M = {}
local meta = {}

function M.new(args)
    local textbox = wibox.widget {
        text = "⏻",
        widget = wibox.widget.textbox
    }
    local widget = wibox.widget {
        widget = wibox.container.background,
        bg = args.bg, -- or ..
        fg = args.fg, -- or ...
        buttons = args.buttons,
        {
            widget = wibox.container.margin,
            margins = args.margins,
            textbox
        }
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
