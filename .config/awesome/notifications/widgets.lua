local naughty = require("naughty")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local M = {}

-- XML escape helper
local function esc(text)
    return gears.string.xml_escape(text or "")
end

-- Create a rounded image widget with constraints
function M.create_image(image_path, size, corner_radius)
    return wibox.widget {
        {
            image      = image_path,
            resize     = true,
            clip_shape = function(cr, w, h)
                gears.shape.rounded_rect(cr, w, h, dpi(corner_radius or 8))
            end,
            halign     = "center",
            valign     = "center",
            widget     = naughty.widget.icon,
        },
        strategy = "exact",
        height   = image_path and dpi(size) or 0,
        width    = image_path and dpi(size) or 0,
        widget   = wibox.container.constraint,
    }
end

-- Create scrollable title widget
function M.create_title(title_text)
    return wibox.widget {
        {
            markup = esc(title_text),
            font   = "SF Pro Display Bold 11",
            align  = "left",
            valign = "center",
            widget = naughty.widget.title,
        },
        forced_width   = dpi(230),
        widget         = wibox.container.scroll.horizontal,
        step_function  = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
        speed          = 50,
    }
end

-- Create message widget
function M.create_message(message_text)
    return wibox.widget {
        {
            markup = esc(message_text),
            font   = "SF Pro Display 9",
            align  = "left",
            valign = "center",
            wrap   = "char",
            widget = naughty.widget.message,
        },
        forced_width = dpi(230),
        layout       = wibox.layout.fixed.horizontal,
    }
end

-- Create info row with app icon, name, and time
function M.create_info_row(app_icon_path, app_name, fg_color)
    local subtle_fg = (fg_color .. "BF") -- add alpha
    
    local app_icon = wibox.widget {
        {
            image      = app_icon_path,
            resize     = true,
            clip_shape = function(cr, w, h)
                gears.shape.rounded_rect(cr, w, h, dpi(3))
            end,
            halign     = "center",
            valign     = "center",
            widget     = wibox.widget.imagebox,
        },
        strategy = "exact",
        height   = app_icon_path and dpi(16) or 0,
        width    = app_icon_path and dpi(16) or 0,
        widget   = wibox.container.constraint,
    }
    
    local app_name_widget = wibox.widget {
        markup = string.format("<span foreground='%s'>%s</span>", subtle_fg, esc(app_name)),
        font   = "SF Pro Display 9",
        align  = "left",
        valign = "center",
        widget = wibox.widget.textbox,
    }
    
    local time_widget = wibox.widget {
        {
            markup = string.format("<span foreground='%s'>now</span>", subtle_fg),
            font   = "SF Pro Display 9",
            align  = "right",
            valign = "center",
            widget = wibox.widget.textbox,
        },
        right  = dpi(12),
        widget = wibox.container.margin,
    }
    
    local separator = wibox.widget {
        widget        = wibox.widget.separator,
        shape         = gears.shape.circle,
        forced_height = dpi(4),
        forced_width  = dpi(4),
        color         = subtle_fg,
    }
    
    return wibox.widget {
        app_icon,
        app_name_widget,
        separator,
        time_widget,
        spacing = dpi(6),
        layout  = wibox.layout.fixed.horizontal,
    }
end

-- Create actions widget
function M.create_actions(notification, bg_color)
    return wibox.widget {
        notification = notification,
        base_layout  = wibox.widget { 
            spacing = dpi(8), 
            layout = wibox.layout.flex.horizontal 
        },
        widget_template = {
            {
                {
                    id     = "text_role",
                    align  = "center",
                    valign = "center",
                    font   = "SF Pro Display 9",
                    widget = wibox.widget.textbox,
                },
                left   = dpi(6),
                right  = dpi(6),
                widget = wibox.container.margin,
            },
            bg      = bg_color,
            shape   = function(cr, w, h) 
                gears.shape.rounded_rect(cr, w, h, dpi(6)) 
            end,
            widget  = wibox.container.background,
        },
        style    = { underline_normal = false, underline_selected = true },
        widget   = require("naughty").list.actions,
    }
end

return M