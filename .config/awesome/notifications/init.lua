local naughty = require("naughty")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local dpi = beautiful.xresources.apply_dpi

-- Import our modules
local icon_resolver = require("notifications.icon_resolver")
local widgets = require("notifications.widgets")
require("notifications.rules")

-- Basic defaults; detailed behavior is defined by ruled in rc.lua
naughty.config.defaults.ontop = true
naughty.config.defaults.position = "top_right"

-- Custom display with rounded corners and clean typography
naughty.connect_signal("request::display", function(n)
	local bg = beautiful.bg_normal or "#121212"
	local fg = beautiful.fg_normal or "#dddddd"

	local app_icon_path = icon_resolver.resolve_app_icon(n.app_name)

	-- Create UI components
	local large_image = widgets.create_image(n.icon, 60, 8)
	local title = widgets.create_title(n.title)
	local message = widgets.create_message(n.message)
	local info_row = widgets.create_info_row(app_icon_path, n.app_name, fg)
	local actions = widgets.create_actions(n, bg)

	-- Build notification layout
	naughty.layout.box({
		notification = n,
		type = "notification",
		bg = bg,
		shape = function(cr, w, h)
			gears.shape.rounded_rect(cr, w, h, dpi(10))
		end,
		widget_template = {
			{
				{
					{
						info_row,
						{
							{
								title,
								message,
								layout = wibox.layout.fixed.vertical,
								spacing = dpi(4),
							},
							left = dpi(6),
							widget = wibox.container.margin,
						},
						layout = wibox.layout.fixed.vertical,
						spacing = dpi(14),
					},
					nil,
					large_image,
					layout = wibox.layout.align.horizontal,
					expand = "none",
				},
				{
					{ actions, layout = wibox.layout.fixed.vertical },
					top = dpi(10),
					visible = n.actions and #n.actions > 0,
					widget = wibox.container.margin,
				},
				layout = wibox.layout.fixed.vertical,
			},
			margins = dpi(12),
			widget = wibox.container.margin,
		},
		-- width constraint
		-- Use a background container to set width/shape/bg together
		widget = wibox.container.background,
		forced_width = dpi(340),
	})
end)

naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification({
		urgency = "critical",
		title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
		message = message,
	})
end)

