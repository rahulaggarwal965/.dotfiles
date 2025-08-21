local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local M = {}
local meta = {}

M.instances = {}

-- Helper function for rounded rectangles
local function rrect(radius)
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, radius)
    end
end

function M.new()
    local battery_progress = wibox.widget{
        color				= beautiful.fg_normal,
        background_color	= "#00000000",
        forced_width        = dpi(22),
        border_width        = 1,
        border_color        = beautiful.fg_normal .. "A6",
        paddings             = dpi(1),
        bar_shape           = rrect(dpi(1)),
        shape				= rrect(dpi(3)),
        value               = 70,
        max_value 			= 100,
        widget              = wibox.widget.progressbar,
    }

    local battery_cap = wibox.widget{
        {
            widget = wibox.container.background,
            bg = beautiful.fg_normal .. "A6",
            forced_width = dpi(2),
            forced_height = 5,
            shape = function(cr, width, height)
                gears.shape.pie(cr, width, height, 0, math.pi)
            end
        },
        direction = "east",
        widget = wibox.container.rotate()
    }

    local widget = wibox.widget {
        {
            battery_progress,
            battery_cap,
            layout = wibox.layout.fixed.horizontal,
            spacing = dpi(-2)  -- Slight overlap to connect cap to body
        },
        widget = wibox.container.margin,
        margins = { top = dpi(8), bottom = dpi(8)},
    }

    -- Connect to battery signal
    awesome.connect_signal("signal::battery", function(value, state)
        battery_progress.value = value
        
        -- Only color when battery is below 20%
        if value <= 20 then
            battery_progress.color = "#F44336"  -- Red when low
            battery_cap.bg = "#F44336"
        else
            -- Normal foreground color for everything else
            battery_progress.color = beautiful.fg_normal or "#cccccc"
            battery_cap.bg = beautiful.fg_normal or "#cccccc"
        end
    end)

    -- Store instance for cleanup if needed
    table.insert(M.instances, {widget = widget, progress = battery_progress, cap = battery_cap})
    
    return widget
end

function meta.__call(_, ...)
    return M.new(...)
end

return setmetatable(M, meta)